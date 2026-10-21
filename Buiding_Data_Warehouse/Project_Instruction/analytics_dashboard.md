---
video_url: "https://www.youtube.com/watch?v=BUlmVbdYfDs&feature=youtu.be"
prev_url: 09-marts.md
next_url: 11-orchestration.md
---

# Analytical Dashboard: Interactive Data Visualization with `dct`

> 📄 Official docs: [dbt Charts Documentation](https://github.com/dbt-charts/dbt-charts)

This module focuses on connecting our transformed **Marts Layer** to an interactive analytical dashboard using **dbt Charts (`dct`)**. By referencing our dbt models directly in YAML configuration files, we can generate real-time local previews and compile static dashboard artifacts for automated reporting.

---

## The Purpose of dbt Charts (`dct`)

- **Code-First BI:** Defines dashboards as code (YAML) right inside your dbt repository, keeping your visualizations version-controlled alongside your transformations.
- **Native dbt Model Integration:** Leverages dbt's `ref()` macro syntax within SQL queries to query transformed tables like `fct_sales` directly from DuckDB.
- **Dual Operating Modes:** Supports live local hot-reloading (`dct serve`) for rapid dashboard development and static HTML generation (`dct render`) for CI/CD deployments.

---

## 1. Environment Setup: Installing `dbt-charts`

We use **`uv`** to install and manage the `dbt-charts` tool globally on your system.

Run the following command in your PowerShell terminal:

```powershell
uv tool install dbt-charts
```

> **Note:** Installing via `uv tool` exposes the global CLI command **`dct`**. To verify that the CLI is installed correctly, run:
> ```powershell
> dct --help
> ```

---

## 2. Configuring the Data Source (`dbt_charts.yml`)

Create a file named **`dbt_charts.yml`** in your project root directory (`northwind_dw/`). This file establishes the connection between `dct` and your dbt profile.

```yaml:dbt_charts.yml
sources:
  analytics:
    type: dbt_profile
    profile: northwind_dw  # The profile name inside your profiles.yml
    target: dev           # The target pointing toward DuckDB
```

---

## 3. Creating the Dashboard Definition (`charts/analytics.yml`)

Create a folder named **`charts/`** in your project root directory and add a dashboard file called **`analytics.yml`**.

```yaml:charts/analytics.yml
title: "Northwind Business Executive Overview"
source: analytics
theme: paper

queries:
  # 1. High-level KPIs from Fact
  kpi_metrics:
    sql: |
      select 
        round(sum(quantity * unit_price * (1 - discount)), 2) as total_revenue,
        count(distinct order_id) as total_orders,
        round(sum(quantity * unit_price * (1 - discount)) / count(distinct order_id), 2) as avg_order_value
      from {{ ref('fct_sales') }}

  # 2. Revenue Trend over time
  monthly_revenue:
    sql: |
      select 
        date_trunc('month', order_date) as sales_month,
        round(sum(quantity * unit_price * (1 - discount)), 2) as total_revenue
      from {{ ref('fct_sales') }}
      group by 1
      order by 1

  # 3. Sales Breakdown by Product Category (Fact + Dim Product)
  sales_by_category:
    sql: |
      select 
        p.category,
        round(sum(f.quantity * f.unit_price * (1 - f.discount)), 2) as category_revenue
      from {{ ref('fct_sales') }} f
      join {{ ref('dim_products') }} p on f.product_id = p.product_id
      group by 1
      order by 2 desc
```

---

## 4. Local Development vs. Production Deployment

Understanding when and why to use **`dct serve`** versus **`dct render`** is essential for workspace workflow and automation.

| Command | Usage Context | How It Works |
| :--- | :--- | :--- |
| **`dct serve`** | **Local Development** | Launches a live WebSockets web server (`http://localhost:3000`). It connects directly to `dev.duckdb` and live-refreshes your browser as you edit your chart YAML files. |
| **`dct render`** | **Production & CI/CD** | Executes queries once against DuckDB and compiles the results into a **standalone, self-contained HTML file**. Perfect for hosting on GitHub Pages without requiring a running server. |

---

## 5. Running and Previewing Your Dashboard

### Step 1: Ensure Your dbt Models Are Built
`dct` queries your transformed tables directly. If your models aren't materialized in DuckDB, `dct` will throw a catalog error. Always build your models first:

```powershell
dbt run
```

### Step 2: Validate Your Dashboard YAML Syntax
Verify that your SQL queries and YAML layout are error-free:

```powershell
dct validate
```

### Step 3: Launch the Live Local Server
Start the development server to view your interactive dashboard in your browser:

```powershell
dct serve
```
Open your browser at `http://localhost:3000` (or the port specified in terminal output) to explore your live KPIs, trend lines, and category breakdowns.

### Step 4: Render a Static HTML Artifact for GitHub Pages
When you are ready to export a static version of your dashboard for deployment, run:

```powershell
dct render charts/analytics.yml --format html --output target/index.html
```

This generates a portable `index.html` file inside your `target/` directory, ready to be served via GitHub Pages!
<img width="1847" height="856" alt="image" src="https://github.com/user-attachments/assets/c482f515-74c7-4221-a01e-7c3b57d36694" />
<img width="1882" height="822" alt="image" src="https://github.com/user-attachments/assets/6ebbf47c-32c9-4bfe-911f-c57b3f8fe85c" />

