---
video_url: "https://www.youtube.com/watch?v=BUlmVbdYfDs&feature=youtu.be"
prev_url: 07-intermediate-layer.md
next_url: 09-orchestration.md
---

# Marts Layer: Star Schema & Analytics Readiness

> 📄 Official docs: [How we structure our dbt projects — Marts](https://docs.getdbt.com/best-practices/how-we-structure/05-marts)

This module focuses on building our final **Marts Layer**. While intermediate models organize internal business logic, marts structure the data into a clean **Star Schema** (Dimension and Fact tables) tailored for BI reporting and consumption in Power BI.


All models created in this section reside inside the `models/marts/` folder and are materialized as persistent **tables** for optimal query speed.

---

## The Purpose of Marts Models

- **Star Schema Design:** Reorganizes normalized data into intuitive Fact tables (`fct_*`) containing quantitative metrics, surrounded by Dimension tables (`dim_*`) containing contextual attributes.
- **Consumption Ready:** Serves as the single source of truth for end-user analytics, business analysts, and dashboards.
- **Relational Integrity:** Utilizes primary-key and foreign-key constraints (tested via `unique`, `not_null`, and `relationships`) to ensure referential integrity across the warehouse.

---

## Files in This Layer

Inside your `models/marts/` directory, you will create and configure five core files:

1. **`dim_customers.sql`**  
   Dimension table containing customer entities and geographical details referenced from staging.

2. **`dim_employees.sql`**  
   Dimension table containing employee metadata and staff roles referenced from staging.

3. **`dim_products.sql`**  
   Dimension table organizing product master data and categories referenced from staging.

4. **`fct_sales.sql`**  
   Central Fact table combining order item measurements (`int_order_items`) with order-level attributes (`int_orders__enriched`), capturing sales metrics, revenue calculations, and foreign keys.

5. **`schema.yml`**  
   Defines documentation and referential integrity tests (such as `unique`, `not_null`, and foreign key `relationships` linking facts to dimensions).

---

## Executing the Marts Layer

Follow these steps in your terminal to build, test, and validate your Star Schema tables:
Run only the marts models:
```powershell
dbt run --select marts
```
Run tests across the entire project (including referential integrity tests):
```powershell
dbt test --select marts
```
Verify the Star Schema in DuckDB:
Launch the DuckDB CLI to query your persistent fact and dimension tables:
```powershell
duckdb dev.duckdb
```

```powershell
SHOW TABLES;
SELECT * FROM fct_sales LIMIT 5;
.exit
```
