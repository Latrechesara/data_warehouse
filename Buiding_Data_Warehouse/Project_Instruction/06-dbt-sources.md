---
video_url: "https://www.youtube.com/watch?v=BUlmVbdYfDs&feature=youtu.be"
prev_url: 05-Ingestion.md
next_url: 06-dbt_schema.md
---
# dbt Sources

> 📄 Official docs: [Sources](https://docs.getdbt.com/docs/build/sources)

> 📄 Best practices: [How we structure our dbt projects — Staging](https://docs.getdbt.com/best-practices/how-we-structure/03-staging)

This module is about telling dbt where your raw data actually lives. Sources are how dbt knows which tables to pull from before any transformation happens. Everything in this section takes place inside the `models/staging/` folder that we set up earlier.

---

## Defining Sources

### `sources.yml`
- A **YAML file** inside `models/staging/` that tells dbt where your raw data resides.
- The **name** of the file is arbitrary — common choices are `sources.yml`, `_sources.yml` (with an underscore so it sorts to the top),
- or something descriptive like `northwind_sources.yml`.
- You give your source a **name** (label) — this is also arbitrary, such as `northwind_mysql` or `raw_northwind`.
- Then you provide three fields that are **not** arbitrary — they must exactly match your warehouse structure:
  - **database** — the database name (e.g., `northwind`)
  - **schema** — the schema inside that database where tables were loaded (e.g., `raw_northwind`)
  - **tables** — the individual tables you want to reference

```yaml
sources:
  - name: northwind_mysql
    database: northwind
    schema: raw_northwind

    tables:
      - name: customers
      - name: orders
      - name: order_details
      - name: products
      - name: categories
```
Using Sources in Your ModelsThe source() functionInstead of hard-coding the full path to your table
(e.g., FROM northwind.raw_northwind.customers), you use the source() function.   It's a Jinja macro written with double curly brackets {{ }}.
It takes two arguments:   The source name defined in your YAML (e.g., northwind_mysql)   The table name matching what is listed under tables
 in the YAML (e.g., customers)
 As long as there's a valid YAML configuration in your project, this resolves correctly at compile time
```powershell

select * from {{ source('northwind_mysql', 'customers') }}
```
Run a preview query, and you should see your raw table data returned successfully

     

Building a Proper Staging Model
Naming convention
Prefix your staging model files with stg_ to clarify their layer (e.g., customers.sql becomes stg_customers.sql).

Rename and reorder columns
List out every column explicitly and give them cleaner aliases.

Order them logically: identifiers first, followed by descriptive attributes,
dates/timestamps, and metrics/values last.

Cast data types explicitly
Do not rely solely on source type defaults; cast fields explicitly (IDs to text/varchar, timestamps to timestamp,
quantities to integer, monetary values to numeric).

A Note on Filtering
Staging models should generally be 1:1 copies of the source with minimal cleaning.

Filtering out clearly invalid rows (such as null primary keys) directly in staging is a practical approach to ensure downstream data quality[cite: 9].

Your Exercise
Apply this same pattern to the rest of the core operational tables (orders, products, employees, order_details, etc.). By the end of this exercise, you should have:

A completed sources.yml declaring all raw Northwind tables.

Corresponding stg_*.sql staging models for each operational table.
