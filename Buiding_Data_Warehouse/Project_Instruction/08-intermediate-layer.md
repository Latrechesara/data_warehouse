---
video_url: "https://www.youtube.com/watch?v=ko2DRqu-3OQ"
prev_url: 07-dbt-shemas-and-tests.md
next_url: 09-marts.md
---

# Intermediate Layer: Business Logic & Joins

> 📄 Official docs: [How we structure our dbt projects — Intermediate](https://docs.getdbt.com/best-practices/how-we-structure/04-intermediate)

This module focuses on creating our **Intermediate Layer**. While staging models are 1:1 clean copies of our raw data sources, intermediate models are where we apply **business logic, complex joins, and reusable aggregations**.

All models created in this section reside inside the `models/intermediate/` folder and are typically materialized as **views** to keep our storage lean.

---

## The Purpose of Intermediate Models

- **Modular Architecture:** Intermediate models serve as building blocks between staging and marts (for example, combining order items with product details or joining orders with customer metadata).
- **The `ref()` Function:** Rather than referencing raw source tables directly, intermediate models consume data from our cleaned staging models using the `ref()` function.
- **Internal Transformations:** These models are for internal processing. Business users and Power BI dashboards will not query them directly; they will consume the final Star Schema in the *Marts* layer.

---

## Files in This Layer

Inside your `models/intermediate/` directory, you will create and configure three core files:

1. **`int_orders__enriched.sql`**  
   Joins the staging orders table (`stg_orders`) with customer demographics (`stg_customers`) and employee details (`stg_employees`) into a single enriched view.

2. **`int_order_items.sql`**  
   Combines order line items (`stg_order_details`) with product information (`stg_products`) and calculates the net line item total including discounts.

3. **`schema.yml`**  
   Defines model-level descriptions and applies data quality tests (such as `unique` and `not_null`) for key identifier fields in this layer.

---

## Executing the Intermediate Layer

Run only the intermediate models:
```powershell
dbt run --select intermediate
```
Run data quality tests on the intermediate models:
```powershell
dbt test --select intermediate
```
Verify inside DuckDB:
Launch the DuckDB CLI to inspect the generated views under your intermediate schema:

```powershell
duckdb dev.duckdb
```
```powershell
SHOW TABLES;
SELECT * FROM int_orders__enriched LIMIT 5;
.exit
```
