---
video_url: "https://www.youtube.com/watch?v=lRfXTTdGy8Q&feature=youtu.be"
prev_url: 03-data.md
next_url: 05-ingestion.md
---



# Initializing dbt and Understanding Data Warehouse Architecture

> 📄 Official docs: [About dbt projects](https://docs.getdbt.com/docs/build/projects)
> 📄 Best practices: [How we structure our dbt projects](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview)

When you run `dbt init`, dbt automatically generates a set of essential files and folders that form the core of your transformation workspace.
In this module, we'll initialize our dbt project and break down the modern analytics engineering architecture.

---

## 🚀 Initializing the dbt Project

Inside your working repository terminal, initialize your dbt project by running:

```powershell
dbt init northwind_dw
```

When prompted for your database adapter, select duckdb. 
This links your transformation framework directly to our local DuckDB database file.

📂 Understanding Project Top-Level Files & FoldersWhen you explore your initialized project, you'll notice several key components:

### dbt_project.yml
 The most important file in a dbt project.   
 Every time you run a dbt command, dbt looks for this 
 file first — if it's missing, the command fails. 
 Key configurations include the project name, profile name (which must match your profiles.yml), 
 default materializations, and global variables.
### models/The most important directory — 

this is where all your SQL transformation logic lives. 
dbt suggests breaking this folder down into three structured sublayers to maintain clean separation of concerns. 

### macros/Reusable SQL functions (similar to Python functions or UDFs).  
Use them when you find yourself repeating the same logic or want to encapsulate calculations like fiscal calendars or custom transformations. 

### seeds/A place to upload CSV or flat files and ingest them directly as dbt models.   
Useful for quick lookup tables, prototypes, or reference datasets.

### tests/A place for singular or generic SQL data assertions.  
If a test query returns more than zero rows, the dbt build fails, guaranteeing data quality.   

🏗️ The Three Core Architecture Layers (models/)

To build scalable and maintainable analytics pipelines, we organize our transformation models into three distinct layers:
1. staging/Contains source definitions (telling dbt where our raw data lives) and staging models.  
A staging model is a 1:1 copy of each raw source table with minimal cleaning applied. 

Minimal cleaning includes fixing data types, renaming columns to a consistent convention, 
filtering out empty rows, and standardizing values. It preserves the exact grain of the source. 

2. intermediate/A flexible layer for everything that is not raw and not yet ready to expose to end users.   
A catch-all for complex joins, heavy-duty data cleansing, business logic aggregation, and intermediate transformation steps.  

3. marts/Where all the final, consumption-ready tables live.
These models are fully modeled (often into star schemas) 
and ready for end users and BI tools.   
In a well-governed project, only marts tables should be exposed to 
stakeholders and visualization layers like Power BI.
This modular structure ensures that our data warehouse remains clean, traceable, and easy to debug.

### So Just create in the models three folders with this structure staging/ intermediate/ mart

Also you have to modify dbt_project.yml remove the exemple.

<img width="1846" height="927" alt="dbt_project" src="https://github.com/user-attachments/assets/61f834f2-9967-49d9-ab89-36314f55132a" />


```mermaid
graph TD
    %% --- Sources ---
    subgraph Sources ["Sources"]
        direction TB
        MySQL["MySQL Database<br/>(Northwind ERP)"]
        style MySQL fill:#f9f,stroke:#333,stroke-width:2px
    end

    %% --- Transformation Engine ---
    subgraph Transformation ["Modern Transformation Engine"]
        direction LR
        Engine["<b>dbt Core + dbt-duckdb</b><br/>• SQL Transformations<br/>• Automated Lineage & Testing<br/>• Runs locally on DuckDB"]
        style Engine fill:#d4edda,stroke:#28a745,stroke-width:2px
    end

    %% --- Data Warehouse (dbt Architecture) ---
    subgraph DWH ["Data Warehouse (DuckDB File)"]
        direction LR
        
        subgraph Staging ["Staging Layer"]
            S_Desc["<b>Raw & 1:1 Copies</b><br/>• Minimal cleaning<br/>• Type casting<br/>• Renaming columns"]
        end

        subgraph Intermediate ["Intermediate Layer"]
            I_Desc["<b>Business Logic & Joins</b><br/>• Complex joins<br/>• Reusable models"]
        end

        subgraph Marts ["Marts Layer"]
            M_Desc["<b>Consumption-Ready</b><br/>• Star Schema<br/>• Fact & Dimensions<br/>• KPIs & Aggregations"]
        end

        Staging ==> Intermediate ==> Marts
    end

    %% --- Consume ---
    subgraph Consume ["Consume Layers"]
        direction TB
        PBI["Power BI & Reporting"]
        SQL["Ad-Hoc SQL Queries"]
        ML["Machine Learning / Analytics"]
        style PBI fill:#ff9,stroke:#333,stroke-width:2px
    end

    %% --- Connections ---
    MySQL ==>|Python Script / Ingestion| Staging
    Staging -.-> Engine
    Intermediate -.-> Engine
    Marts -.-> Engine
    
    %% Clean single point output from Marts
    Marts ==>|Query / Connect| PBI
    Marts ==>|Query / Connect| SQL
    Marts ==>|Query / Connect| ML



