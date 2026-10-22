---
video_url: "https://www.youtube.com/watch?v=BUlmVbdYfDs&feature=youtu.be"
prev_url: 10-analytics-dashboard.md
next_url: null
---

# Pipeline Orchestration & CI/CD Deployment

This final module completes our **Lean Data Stack** project. We automate the end-to-end data pipeline—from MySQL data restoration and DuckDB ingestion, through dbt transformations and data tests, to static dashboard rendering and live deployment on GitHub Pages using **GitHub Actions**.

---

## Architecture Overview

Every time code is pushed to the `main` branch or a scheduled job is triggered, GitHub Actions executes an isolated containerized workflow:

1. **MySQL Service Container:** Spins up MySQL 8.0, configures root user permissions, and restores source schema and data (`.sql` dumps).
2. **Data Ingestion (`load_from_mysql.py`):** Connects to MySQL, extracts tables, and creates/replaces raw tables in `dev.duckdb`.
3. **dbt Transformations & Data Quality Tests:** Runs `dbt run` and `dbt test` against local DuckDB tables using a repository-contained `profiles.yml`.
4. **Dashboard Compilation (`dct`):** Validates and renders the static dashboard HTML using `dbt-charts`.
5. **Production Deployment:** Publishes the resulting `index.html` to the repository's `gh-pages` branch for free web hosting.

---

## 1. Repository Layout & Configuration Files

Ensure your repository includes `profiles.yml` inside the project root (`northwind_dw/`):

```yaml:northwind_dw/profiles.yml
northwind_dw:
  outputs:
    dev:
      type: duckdb
      path: dev.duckdb
  target: dev
```

---

## 2. Complete GitHub Actions Workflow (`.github/workflows/main.yml`)

Create or update the workflow file at `.github/workflows/main.yml`:

```yaml
name: Northwind Data Stack CI/CD & Dashboard Deployment

on:
  push:
    branches: [ "main" ]
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * *' # Automated daily refresh at midnight UTC

jobs:
  run-pipeline:
    runs-on: ubuntu-latest

    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: password123
          MYSQL_DATABASE: northwind
        ports:
          - 3306:3306
        options: --health-cmd="mysqladmin ping -h localhost" --health-interval=10s --health-timeout=5s --health-retries=3

    permissions:
      contents: write
      pages: write
      id-token: write

    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Install uv package manager
        uses: astral-sh/setup-uv@v5

      - name: Install dependencies & dbt-charts tool
        run: |
          uv pip install --system dbt-duckdb pymysql
          uv tool install dbt-charts

      - name: Configure MySQL Root Access
        run: |
          mysql -h 127.0.0.1 -P 3306 -u root -ppassword123 -e "ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password123'; FLUSH PRIVILEGES;" || true
          mysql -h 127.0.0.1 -P 3306 -u root -ppassword123 -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password123'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;"

      - name: Restore MySQL Schema and Data
        run: |
          mysql -h 127.0.0.1 -P 3306 -u root -ppassword123 northwind < northwind_dw/data/northwind.sql
          mysql -h 127.0.0.1 -P 3306 -u root -ppassword123 northwind < northwind_dw/data/northwind-data.sql

      - name: Run Data Ingestion Script
        env:
          DB_HOST: 127.0.0.1
          DB_USER: root
          DB_PASSWORD: password123
          DB_NAME: northwind
        run: cd northwind_dw && python scripts/load_from_mysql.py

      - name: Run dbt Transformations & Data Tests
        run: |
          cd northwind_dw
          dbt run --profiles-dir .
          dbt test --profiles-dir .

      - name: Validate & Render dbt Charts HTML
        run: |
          cd northwind_dw
          dct validate
          mkdir -p target
          dct render charts/analytics.yml --format html --output target/index.html

      - name: Deploy Dashboard to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./northwind_dw/target
```

---

## 3. Key Technical Considerations

| Component | Technical Implementation | Why It Matters |
| :--- | :--- | :--- |
| **MySQL Authentication** | `mysql_native_password` configuration step | Prevents root connection denial errors on Ubuntu GitHub runners. |
| **Idempotency** | `CREATE OR REPLACE TABLE` in ingestion | Ensures daily cron runs refresh raw data without creating duplicate rows. |
| **Local Profiles** | `--profiles-dir .` in dbt commands | Ensures dbt uses `northwind_dw/profiles.yml` inside the runner workspace. |
| **Static Artifacts** | `dct render ... --output target/index.html` | Generates a single-file static dashboard ready for zero-cost web hosting. |

---

## 4. Enabling GitHub Pages Deployment

1. Go to **Settings > Pages** in your GitHub repository.
2. Under **Build and deployment**, set **Source** to **Deploy from a branch**.
3. Select the **`gh-pages`** branch and root `/` directory, then click **Save**.
4. Access your live interactive dashboard at:  
   `https://<your-username>.github.io/<repository-name>/`
