"""Bulk-load CSV files into PostgreSQL using COPY (fast).

Tables must already exist with matching columns/types. This script only
inserts data; it does not create tables.

Usage:
    uv run load_data.py                 # load every CSV in LOAD_ORDER
    uv run load_data.py company_dim     # load a single table
"""

import sys
from pathlib import Path

import psycopg

# --- Connection settings -----------------------------------------------------
# Postgres.app uses "trust" auth for local connections, so no password is
# needed. Override any of these via the DB_CONFIG dict if your setup differs.
DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "dbname": "Job_Analysis_DB",
    "user": "job_analysis",
}

CSV_DIR = Path(__file__).parent / "csv_files"

# Map each table to its CSV file. Order matters: parents before children so
# foreign keys resolve (job_postings_fact references company_dim; skills_job_dim
# references job_postings_fact and skills_dim).
LOAD_ORDER = [
    ("company_dim", "company_dim.csv"),
    ("skills_dim", "skills_dim.csv"),
    ("job_postings_fact", "job_postings_fact.csv"),
    ("skills_job_dim", "skills_job_dim.csv"),
]


def load_csv_to_postgres(
    csv_path: str | Path,
    table_name: str,
    db_config: dict = DB_CONFIG,
    truncate: bool = False,
) -> int:
    """Load one CSV file into one Postgres table via COPY.

    The CSV's header row is used to map columns, so column order in the file
    does not need to match the table. Empty unquoted fields become NULL.

    Args:
        csv_path: Path to the CSV file.
        table_name: Target table (must already exist).
        db_config: psycopg connection kwargs.
        truncate: If True, empties the table before loading.

    Returns:
        Number of rows inserted.
    """
    csv_path = Path(csv_path)
    if not csv_path.exists():
        raise FileNotFoundError(f"CSV not found: {csv_path}")

    # Read the header to build an explicit, quoted column list.
    with open(csv_path, "r", encoding="utf-8", newline="") as f:
        header = f.readline().strip()
    columns = [c.strip() for c in header.split(",")]
    col_list = ", ".join(f'"{c}"' for c in columns)

    copy_sql = (
        f'COPY "{table_name}" ({col_list}) '
        f"FROM STDIN WITH (FORMAT CSV, HEADER TRUE, NULL '')"
    )

    with psycopg.connect(**db_config) as conn:
        with conn.cursor() as cur:
            if truncate:
                cur.execute(f'TRUNCATE "{table_name}" CASCADE;')
            # Stream the file to the server in chunks so large files (the
            # 123 MB job_postings_fact.csv) never load fully into memory.
            with open(csv_path, "rb") as f:
                with cur.copy(copy_sql) as copy:
                    while chunk := f.read(1 << 16):  # 64 KB chunks
                        copy.write(chunk)
            rows = cur.rowcount
        conn.commit()

    print(f"  ✓ {table_name}: loaded {rows:,} rows from {csv_path.name}")
    return rows


def load_all(truncate: bool = False) -> None:
    """Load every table in LOAD_ORDER (FK-safe order)."""
    print(f"Loading into database '{DB_CONFIG['dbname']}'...")
    total = 0
    for table_name, csv_file in LOAD_ORDER:
        total += load_csv_to_postgres(CSV_DIR / csv_file, table_name, truncate=truncate)
    print(f"Done. {total:,} rows loaded across {len(LOAD_ORDER)} tables.")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        # Load a single named table, e.g. `uv run load_data.py skills_dim`.
        name = sys.argv[1]
        match = dict(LOAD_ORDER).get(name)
        if not match:
            valid = ", ".join(t for t, _ in LOAD_ORDER)
            sys.exit(f"Unknown table '{name}'. Choose from: {valid}")
        load_csv_to_postgres(CSV_DIR / match, name, truncate=True)
    else:
        # Truncate + reload everything for a clean, repeatable import.
        load_all(truncate=True)
