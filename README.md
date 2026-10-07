# SQL-data-warehouse-project-1
My goal for this project was to build a modern data warehouse using MySQL Workbench, including ETL processes, data modeling, and analytics. 

## About This Project

This project demonstrates the design and implementation of an end-to-end data warehouse, transforming raw CRM and ERP source data into a structured, analytics-ready data model.

The project follows a layered data warehouse architecture consisting of **Bronze, Silver, and Gold layers**. Raw source data is ingested into the Bronze layer, cleaned and standardized in the Silver layer, and transformed into business-ready dimensional models in the Gold layer.

The warehouse is designed around a **star schema**, with fact and dimension tables supporting analytical queries across customers, products, and sales.

### Project Scope

The project covers the full data warehouse development lifecycle, including:

* Requirements analysis and project planning
* Data architecture and warehouse layer design
* Source system analysis and data exploration
* Database and schema creation
* Naming conventions and repository organization
* Raw data ingestion into the Bronze layer
* Data cleansing, standardization, and integration in the Silver layer
* SQL-based transformation and loading processes
* Dimensional modeling and business object analysis
* Customer and product dimensions
* Sales fact table
* Star schema design
* Data flow and architecture documentation
* Data catalog and metadata documentation
* Git-based version control and development workflow

### Architecture
<img width="1041" height="778" alt="data_architecture" src="https://github.com/user-attachments/assets/13357f83-ce26-4c8e-b3ed-9b7e91f68951" />


**Bronze → Silver → Gold**

✦ **Bronze:** Raw source data loaded with minimal transformation

✦ **Silver:** Cleaned, standardized, and integrated data

✦ **Gold:** Business-ready dimensional models optimized for analytics

The Gold layer uses a star schema consisting of customer and product dimensions and a sales fact table, providing a foundation for analytical queries and downstream reporting.

### Technologies & Practices

✦ **SQL** — DDL, DML, data transformation, analytical queries, and stored procedures\
✦ **Relational Database** — database and schema design\
✦ **Git/GitHub** — version control and source code management\
✦ **ETL Pipelines** - Extracting, transforming, and loading data from source systems into the warehouse.\
✦ **Data Modeling** — dimensional modeling, fact and dimension design, and star schemas\
✦ **Data Documentation** — architecture diagrams, data flows, and data cataloging

The repository documents the architecture, transformation logic, data flows, and development process used to build the warehouse from source data through the final analytical model.

### Future Updates

I would like to explore an alternative approach for automating the Bronze-layer ingestion through stored procedures or an external orchestration process. MySQL does not permit LOAD DATA INFILE to be executed within stored procedures, so the current implementation uses a standalone load_bronze_data.sql script for bulk CSV ingestion.

### About the Author

Hi! I'm Tracy. I bring a strong background in science, technology, digital media, and communications to my work with data. I like to focus on clear communication and problem-solving in my data work, with particular interests in analytics engineering and data modeling, especially building reliable data solutions that make data easier to understand and use.

This repository is part of my data portfolio and demonstrates my work in data warehousing, transformation, modeling, documentation, and analytics.

**Connect with me:** [LinkedIn](https://www.linkedin.com/in/tracy-mason-3602337/) <!-- ⚙ Portfolio--> ⚙ [Notion templates](https://payhip.com/AtomicTeaWorks) ⚙ CV

<!--
Maybe add something like this? Of course, put in actual steps.
###How to Install and Run the Project
* Save the files locally or clone the repository.
* Open a terminal or a SQL GUI, such as MySQL Workbench.

* Execute the files in the following order:
  * installation.sql
  * mock_data.sql
* Open analysis.sql and select a query to run.
--!>
