

1. What is schema.yml in Staging?
While sources.yml points to your raw tables, schema.yml (placed inside models/staging/) is used to document and test your dbt models
(like stg_customers.sql, stg_orders.sql).

It allows you to add column descriptions and data tests (such as ensuring an ID is unique and not_null).

Example of what goes inside models/staging/schema.yml:
```yaml 
version: 2

models:
  - name: stg_customers
    description: "Cleaned and standardized customer records from the Northwind database."
    columns:
      - name: customer_id
        description: "Unique primary key for each customer."
        tests:
          - unique
          - not_null
      - name: company_name
        description: "The name of the customer's company."
      - name: country
        description: "Country where the customer is located."

  - name: stg_orders
    description: "Cleaned transactional order headers."
    columns:
      - name: order_id
        description: "Unique identifier for each order."
        tests:
          - unique
          - not_null
      - name: customer_id
        description: "Foreign key linking to stg_customers."
```

2. Understanding profiles.yml
As seen in your configuration, profiles.yml tells dbt how to connect to your database. For local DuckDB development, your setup looks like this:

```yaml
northwind_transformations:   # Matches the name in your dbt_project.yml
  target: dev
  outputs:
    dev:
      type: duckdb
      path: dev.duckdb       # Path to your local DuckDB database file
      schema: main           # Default schema where models will be written
```

type: duckdb: Directs dbt to use the local DuckDB adapter.

path: dev.duckdb: Creates or connects to a local file named dev.duckdb in your project workspace.

schema: main: The default schema where dbt compiles and materializes your models.

3. How to Execute Your Staging Models
Once your sources.yml, schema.yml, and individual stg_*.sql files are in place, you can execute them using the terminal.

Run all models in the project:

```powershell
dbt run
```

Run only the staging folder:
```powershell
dbt run --select staging
```

Run a single specific model:
```powershell
dbt run --select stg_customers
```

Verification: If the command finishes with green success logs (e.g., OK created view stg_customers), your SQL files executed successfully and populated the database.

4. How to Check Your Data in DuckDB
To inspect the tables and views created by dbt inside your DuckDB file:

Open the DuckDB CLI from your terminal:
```powershell
duckdb dev.duckdb
```

List all tables and views currently in the database:
```powershell
SHOW TABLES;
```

Query one of your staging models to inspect the cleaned data:
```powershell
SELECT * FROM stg_customers LIMIT 5;
```
Exit the DuckDB CLI when finished:
```powershell
.exit
```
to run test use 
```powershell
dbt test --select staging.*
```

