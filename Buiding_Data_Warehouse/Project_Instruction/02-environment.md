---
video_url: "https://www.youtube.com/watch?v=6dGpSBbXqdA"
prev_url: 01-intro.md
next_url: 03-data.md
---

## 🛠️ Built With

<p align="center">
  <!-- Languages & Environments -->
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python" />
  <img src="https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQL" />
  <img src="https://img.shields.io/badge/Shell-4E2A8E?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Shell" />
  <br>

  <!-- Data Warehouse & Transformations -->
  <img src="https://img.shields.io/badge/DuckDB-FFF000?style=for-the-badge&logo=duckdb&logoColor=black" alt="DuckDB" />
  <img src="https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white" alt="dbt" />
  <img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL" />
  <br>

  <!-- Package Management & Automation -->
  <img src="https://img.shields.io/badge/uv-Astral-261230?style=for-the-badge&logo=python&logoColor=white" alt="uv" />
  <img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white" alt="GitHub Actions" />
  <img src="https://img.shields.io/badge/VS_Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white" alt="VS Code" />
  <br>

  <!-- Business Intelligence -->
  <img src="https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" alt="Power BI" />
</p>



# Environment Setup




In this module, we'll set up our environment using modern tooling from scratch, step by step.

-First make sure you have vs code installed if not you can download it from here:

https://code.visualstudio.com/Download?_exp_download=d53503e735

choose the correct version for your operating system.

-Second we will use **uv** by Astral as our fast Python package and environment manager, **DuckDB** as our local analytical database, and **dbt** for transformations. 
I want you to see every piece configured correctly first, so you understand the underlying modern data stack stack before writing your models.

Before you start, make sure you have PowerShell ready on your Windows machine (or your standard terminal on macOS/Linux).

## Installing uv

First, we install `uv` locally on your machine using PowerShell. 

Run the official installation command in your terminal:

```powershell
irm https://astral.sh/uv/install.ps1 | iex
```

After installation, restart your terminal and verify it works by checking uv --version.

The project structure
Next, we use uv to create an empty project structure. Instead of traditional python virtual environments, 
we initialize a clean application workspace:

```bash
uv init --bare

```

This generates your initial configuration files, including pyproject.toml.   
Next, we add the required packages for our data warehouse pipeline using uv add:

```bash
uv add dbt-duckdb duckdb mysql-connector-python pandas
```
To interact with our database directly from the command line, we also install the DuckDB CLI locally.

On Windows (PowerShell), you can install it directly by running:
```powershell
winget install DuckDB.cli
```

[DuckDB Installation – DuckDB](https://duckdb.org/docs/installation/)
You can verify your DuckDB installation by running:

You can verify your DuckDB installation by running:

```bash
duckdb --version
```
This module has two parts.
In Part 1, we cover:
Installing and configuring uv and DuckDB
Setting up the pyproject.toml dependencies   
Preparing the database directoryIn Part 2, we connect everything 
to our dbt project configuration and build our first Staging models over the Northwind dataset.
The final code from this module is available in the code/ directory.
