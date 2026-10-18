---
video_url: "https://www.youtube.com/watch?v=CTZXuz9EejY"
prev_url: 04-dbt-project-structure.md
next_url: 05-dbt-sources.md
---

# Ingesting Raw Data from MySQL into DuckDB

Now that we have restored the Northwind database in our local MySQL instance, we need to extract those raw operational tables 
and populate our analytical database file (`northwind.duckdb`).

In this module, we will write an automated Python script using `duckdb` and `mysql-connector-python` to perform this ingestion step.

---

## 💡 How DuckDB Interacts with MySQL

DuckDB provides powerful native integrations to query external databases directly. We have two primary ways to move our data:

1. **Native DuckDB MySQL Extension:** Using `ATTACH 'host=localhost user=root database=northwind' AS mysql_db (TYPE MYSQL);` directly inside SQL.
2. **Python Pipeline Script (Recommended):** Fetching tables using standard connectors and staging them directly into local DuckDB persistent tables.

We will write a python script (`ingest_northwind.py`) in our project root folder.

---

## 🐍Loading the data from mysql

Create a file named `ingest_northwind.py` in your project root (`data-warehouse/`):
create a folder named scripts 
inside of it try to put the 
load_from_mysql.py


```
Running the Ingestion
Execute the script using uv:

```powershell
uv run python scripts/load_from_mysql.py

```

Verifying the Ingested Tables in DuckDB CLI
Launch the DuckDB CLI to inspect the newly populated database file:

```powershell
duckdb northwind.duckdb
```

Inside the CLI shell, query the schema:

```powershell
SHOW TABLES FROM raw;
```







