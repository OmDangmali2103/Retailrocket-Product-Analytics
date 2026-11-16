# Product Funnel, Conversion & Customer Retention Analytics

An end-to-end e-commerce product analytics project using **Python, PostgreSQL, SQL, Power BI, and DAX** to investigate customer behaviour, product funnel progression, conversion time, customer retention, and product performance.

The project analyses the [Retailrocket E-commerce Dataset](https://www.kaggle.com/datasets/retailrocket/ecommerce-dataset) to identify behavioural patterns and translate event-level data into actionable product and business insights.

---

## 1. Project Overview

E-commerce businesses need to understand how customers interact with products, where potential customers drop out of the purchasing journey, how long conversions take, and whether customers return over time.

This project examines these questions through an analytical workflow covering:

- Exploratory data analysis and data-quality investigation using Python.
- Event-level duplicate identification and removal.
- Sequential product funnel analysis using PostgreSQL and SQL.
- Conversion-time distribution analysis.
- Monthly customer cohort and retention analysis.
- Product-level funnel performance and opportunity analysis.
- Dashboard data preparation using SQL, Python, and DAX.
- Interactive reporting and visualisation using Power BI.

**Primary objective:** Convert raw e-commerce interaction data into reliable analytical outputs that help evaluate customer behaviour, purchasing progression, and product performance.

## 2. Business Questions

The analysis addresses the following questions:

1. How do visitors progress from viewing a product to adding it to their cart and purchasing it?
2. At which stage does the largest product-level funnel drop-off occur?
3. How long does it take for a visitor to move from viewing a product to adding it to their cart, and from carting to purchasing?
4. How does customer activity and retention change across monthly cohorts?
5. Which products attract the most views, and which demonstrate stronger observed purchase conversion?
6. What data-quality limitations should be considered before making business decisions?

## 3. Dataset

**Source:** Retailrocket E-commerce Dataset, available on [Kaggle](https://www.kaggle.com/datasets/retailrocket/ecommerce-dataset).

The dataset contains anonymised e-commerce interaction events, item properties, and product category information.

### Dataset files

| File | Description |
|---|---|
| `events.csv` | Visitor interactions, including views, add-to-cart events, and transactions |
| `item_properties_part1.csv` | Product property records |
| `item_properties_part2.csv` | Additional product property records |
| `category_tree.csv` | Product category hierarchy |

### Events dataset columns

| Column | Description |
|---|---|
| `timestamp` | Event timestamp stored as Unix milliseconds |
| `visitorid` | Anonymised visitor identifier |
| `event` | Interaction type: `view`, `addtocart`, or `transaction` |
| `itemid` | Product identifier |
| `transactionid` | Transaction identifier, where available |

Raw dataset files are not included in this repository because of their size and dataset redistribution considerations. Refer to the original dataset source for access.

## 4. Technology Stack

| Technology | Application |
|---|---|
| Python | Exploratory analysis, data-quality investigation, duplicate removal, and export automation |
| Pandas | Data manipulation, aggregation, and analysis |
| NumPy | Numerical operations |
| PostgreSQL | Analytical data storage and SQL execution |
| SQL | Funnel, conversion-time, retention, and product-performance analysis |
| SQLAlchemy | Python-to-PostgreSQL connectivity |
| Power BI | Interactive dashboard development |
| DAX | Monthly activity calculations and dashboard metrics |
| Jupyter Notebook | Reproducible analytical workflow |
| Git & GitHub | Version control and project documentation |

## 5. Analytical Workflow

### Stage 1 — Dataset Inspection and Exploratory Analysis

Notebook: `notebooks/01_dataset_inspection.ipynb`

Activities:

- Inspected dataset structure, columns, data types, and sample records.
- Examined missing values and exact duplicate records.
- Analysed event distributions and visitor activity.
- Investigated transaction identifiers and transaction-level product relationships.
- Examined repeated product records within transactions.
- Compared user-level event overlap with sequential product-level conversion.
- Investigated chronological visitor journeys.
- Evaluated conversion-window sensitivity across 1-hour, 24-hour, and 7-day intervals.

This stage established the dataset's analytical structure and identified important limitations in interpreting event-level behaviour.

### Stage 2 — Data Quality and Cleaning

Notebook: `notebooks/02_data_cleaning.ipynb`

Activities:

- Loaded the events dataset with explicitly specified data types.
- Identified exact duplicate event records.
- Removed exact duplicate rows while retaining the first occurrence.
- Validated the resulting row count and remaining duplicate count.
- Audited missing values and event distributions.
- Processed large item-property files in chunks to examine row counts, missing values, timestamps, and property diversity.
- Investigated category hierarchy integrity, duplicate category identifiers, and invalid parent references.

The events cleaning operation specifically removes exact duplicate records. It does not imply that every missing value or potential data anomaly was removed.

The original raw files remain unchanged.

### Stage 3 — PostgreSQL and SQL Analysis

SQL scripts are maintained in the `sql/` directory.

| SQL file | Analysis |
|---|---|
| `02_product_funnel.sql` | Sequential visitor–product funnel |
| `03_conversion_time.sql` | Time between qualifying conversion stages |
| `04_customer_retention.sql` | Monthly cohort retention |
| `05_product_performance.sql` | Product-level funnel performance |
| `06_product_opportunity_analysis.sql` | Product opportunity ranking |

The SQL analysis uses common table expressions, joins, aggregation, conditional logic, date functions, and window-independent percentile calculations.

#### Product funnel methodology

The funnel is constructed at the **visitor–product pair** level:

1. Identify the first recorded product view for each visitor and product.
2. Identify the first add-to-cart event occurring after that view.
3. Identify the first transaction event occurring after the qualifying cart event.

This ensures that a cart or transaction is counted only when the required preceding event exists for the same visitor–product pair.

#### Conversion-time analysis

Measures elapsed time between:

- Product view and qualifying add-to-cart event.
- Qualifying add-to-cart event and subsequent transaction.

The analysis reports average, median, P90, P95, and maximum conversion times.

#### Customer retention methodology

- Cohort month is based on the visitor's first observed activity month.
- Any recorded event qualifies as activity.
- Monthly retention is calculated by comparing active visitors in each activity month with the original cohort size.

#### Product performance

Products are evaluated using:

- Viewed visitor–product pairs.
- Carted visitor–product pairs.
- Purchased visitor–product pairs.
- View-to-cart conversion rate.
- View-to-purchase conversion rate.

The opportunity analysis applies a minimum threshold of 100 viewed visitor–product pairs before ranking products.

### Stage 4 — Dashboard Data Preparation

The dashboard datasets are stored in `Dashboard/Dashboard Data/`.

| Export file | Source |
|---|---|
| `funnel_summary.csv` | PostgreSQL — `02_product_funnel.sql` |
| `conversion_time.csv` | PostgreSQL — `03_conversion_time.sql` |
| `cohort_retention.csv` | PostgreSQL — `04_customer_retention.sql` |
| `monthly_activity.csv` | Power BI DAX |
| `product_performance.csv` | PostgreSQL — `05_product_performance.sql`, exported through Python |

Notebook `notebooks/06_export_dashboard_data.ipynb` uses SQLAlchemy to connect to PostgreSQL and exports product-performance results in batches. It validates the expected row count before replacing the final CSV.

### Stage 5 — Power BI Dashboard

The Power BI report is available at:

`Dashboard/Product Analysis Dashboard.pbix`

The report contains four analytical pages:

1. **Executive Overview** — High-level view of product interactions and business performance.
2. **Conversion Funnel** — Visitor–product progression across views, carts, and purchases.
3. **Customer Retention** — Monthly cohort activity and retention patterns.
4. **Product Performance** — Product-level engagement and observed conversion performance.

The report combines SQL-generated analytical datasets with DAX-based dashboard calculations.

## 6. Key Analytical Findings

The following figures are based on the exported analytical datasets.

### Product funnel

| Metric | Result |
|---|---:|
| Viewed visitor–product pairs | 2,132,127 |
| Carted visitor–product pairs | 45,804 |
| Purchased visitor–product pairs | 16,695 |
| Unique visitors with views | 1,404,179 |
| Unique visitors with carts | 30,344 |
| Unique visitors with purchases | 9,641 |
| View-to-cart conversion | 2.15% |
| Cart-to-purchase conversion | 36.45% |
| View-to-purchase conversion | 0.78% |

**Interpretation:** The largest proportional drop-off occurs between product views and qualifying cart additions. This indicates an area worth investigating through product-page usability, product information, pricing, and add-to-cart experience analysis. These are potential investigation areas, not proven causes.

### Conversion time

| Conversion stage | Average | Median | P90 | P95 |
|---|---:|---:|---:|---:|
| View to Cart | 14.82 hours | 0.02 hours | 1.88 hours | 34.56 hours |
| Cart to Purchase | 5.83 hours | 0.07 hours | 0.84 hours | 4.45 hours |

The difference between average and median conversion time indicates a right-skewed distribution, with a smaller number of long conversion intervals increasing the average.

### Customer retention

The May 2015 first-observed activity cohort contains 307,574 visitors.

Its Month 1 retention rate is **4.76%**.

Retention should be interpreted as continued observed activity, not confirmed customer loyalty or repeat purchasing.

### Product performance

The product analysis evaluates product engagement and sequential purchase conversion. The opportunity analysis focuses on products with at least 100 viewed visitor–product pairs to reduce the influence of very small observation counts.

A high conversion rate does not necessarily indicate high revenue, profitability, or commercial value because the available event data does not provide a reliable order-value model.

## 7. Metric Definitions and Methodological Considerations

| Metric | Definition |
|---|---|
| Viewed pairs | Distinct visitor–product pairs with a recorded view |
| Carted pairs | Distinct visitor–product pairs with a cart event after a recorded view |
| Purchased pairs | Distinct visitor–product pairs with a transaction after the qualifying cart event |
| View-to-cart rate | Carted pairs divided by viewed pairs |
| Cart-to-purchase rate | Purchased pairs divided by carted pairs |
| View-to-purchase rate | Purchased pairs divided by viewed pairs |
| Monthly cohort retention | Active visitors in a cohort's activity month divided by the original cohort size |

### Important limitations

1. **Visitor–product pair versus visitor:** Funnel conversion rates use visitor–product pairs as their denominator and numerator. Distinct visitor counts are reported separately and should not be confused with pair-level conversion rates.
2. **Observed event sequence:** The funnel requires chronological view → add-to-cart → transaction events for the same visitor and product.
3. **Conversion window:** The final SQL funnel does not impose a maximum time interval between qualifying events. Long gaps can therefore be included.
4. **Cohort definition:** First observed activity is used as a proxy for cohort entry because actual registration dates are unavailable.
5. **Retention interpretation:** Any recorded event counts as activity. Retention does not necessarily represent repeat purchases.
6. **Incomplete observation period:** The final observed cohort activity month may not have complete future follow-up.
7. **Missing business context:** Acquisition channel, device, customer demographics, and reliable order-value information are not available in the event data.
8. **No causal inference:** Observed associations and conversion patterns do not establish why customers behave in a particular way.

## 8. Repository Structure

```text
Retailrocket-Product-Analytics/
│
├── Dashboard/
│   ├── Product Analysis Dashboard.pbix
│   └── Dashboard Data/
│       ├── cohort_retention.csv
│       ├── conversion_time.csv
│       ├── funnel_summary.csv
│       ├── monthly_activity.csv
│       └── product_performance.csv
│
├── data/
│   ├── raw/
│   │   └── README.md
│   └── processed/
│       └── README.md
│
├── docs/
│   ├── metric_dictionary.md
│   └── project_charter.md
│
├── notebooks/
│   ├── 01_dataset_inspection.ipynb
│   ├── 02_data_cleaning.ipynb
│   └── 06_export_dashboard_data.ipynb
│
├── reports/
│   └── README.md
│
├── sql/
│   ├── 02_product_funnel.sql
│   ├── 03_conversion_time.sql
│   ├── 04_customer_retention.sql
│   ├── 05_product_performance.sql
│   └── 06_product_opportunity_analysis.sql
│
├── .gitignore
└── README.md
```

Large raw and processed datasets are excluded from version control. Their directory-level README files explain where the data belongs.

## 9. Running the Project

### Prerequisites

- Python 3.10 or later.
- Jupyter Notebook or JupyterLab.
- PostgreSQL.
- Power BI Desktop.
- The Retailrocket dataset downloaded from its original source.

### Python environment

Create and activate a virtual environment, then install the required libraries:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install pandas numpy sqlalchemy psycopg2-binary jupyter
```

Additional dependencies may be needed depending on your local environment.

### Dataset placement

Place the downloaded source files in:

```text
data/raw/
```

Expected files:

```text
events.csv
item_properties_part1.csv
item_properties_part2.csv
category_tree.csv
```

### Notebook execution

Run the notebooks in this order:

1. `01_dataset_inspection.ipynb`
2. `02_data_cleaning.ipynb`
3. `06_export_dashboard_data.ipynb`

Notebook 06 requires a PostgreSQL database named `retailrocket_analytics` containing the relevant analytical tables and SQL-compatible structure.

Database setup and raw-data loading must be completed separately before executing the SQL analysis and export workflow.

### SQL analysis

Execute the SQL scripts against the PostgreSQL analytical database in the order required by the analysis.

### Power BI

Open `Dashboard/Product Analysis Dashboard.pbix`.

If prompted, configure the data source paths to the dashboard CSV files included in the repository.

## 10. Data Attribution and Usage

The project uses the Retailrocket E-commerce Dataset published on Kaggle:

https://www.kaggle.com/datasets/retailrocket/ecommerce-dataset

The dataset is associated with REES46. Refer to the original dataset page for its current licence, attribution requirements, and permitted use.

Raw dataset files are not redistributed in this repository.


*This project is intended for analytical and educational purposes. Findings represent patterns observed in the available dataset and should be interpreted in light of the stated methodological limitations.*
