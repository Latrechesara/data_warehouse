---
video_url: "https://www.youtube.com/watch?v=LIEN_DE_TA_VIDEO_ICI"
prev_url: 01-intro.md
next_url: 03-staging.md
---

# Environment Setup

In this module, we'll set up our environment using modern tooling from scratch, step by step.

We use **uv** by Astral as our fast Python package and environment manager, **DuckDB** as our local analytical database, and **dbt** for transformations. 
I want you to see every piece configured correctly first, so you understand the underlying modern data stack stack before writing your models.

Before you start, make sure you have PowerShell ready on your Windows machine (or your standard terminal on macOS/Linux).

## Installing uv

First, we install `uv` locally on your machine using PowerShell. 

Run the official installation command in your terminal:

```powershell
powershell -ExecutionPolicy ByPass -c "irm [https://astral.sh/uv/install.ps1](https://astral.sh/uv/install.ps1) | iex"

```

After installation, restart your terminal and verify it works by checking uv --version.

The project structure
Next, we use uv to create an empty project structure. Instead of traditional python virtual environments, 
we initialize a clean application workspace:

```bash
uv init --app data-warehouse
cd data-warehouse
```

This generates your initial configuration files, including pyproject.toml.   
Next, we add the required packages for our data warehouse pipeline using uv add:

```bash
uv add dbt-duckdb duckdb mysql-connector-python pandas
```
To interact with our database directly from the command line, we also install the DuckDB CLI locally.

On Windows (PowerShell), you can install it directly by running:
```powershell
powershell -NoExit iex (iwr "[https://install.duckdb.org/install.ps1](https://install.duckdb.org/install.ps1)").Content
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
