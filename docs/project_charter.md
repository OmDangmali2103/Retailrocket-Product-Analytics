# Project Charter
## Product Funnel, Conversion & Customer Retention Analytics

## 1. Project Purpose

The purpose of this project is to analyse e-commerce visitor behaviour and product interactions using the Retailrocket E-commerce Dataset.

The project investigates how visitors progress through product interactions, how long qualifying conversions take, how activity changes across monthly cohorts, and how product-level engagement and conversion vary.

The analysis translates raw event data into structured analytical outputs and an interactive Power BI dashboard to support evidence-based product and business investigations.

## 2. Business Context

E-commerce businesses need visibility into customer interactions throughout the purchasing journey.

Understanding where visitors stop progressing, how quickly qualifying conversions occur, whether visitors return over time, and which products demonstrate stronger observed conversion can help identify areas for further investigation.

This project uses anonymised event-level data to examine these behaviours.

## 3. Business Objectives

The project addresses the following objectives:

1. Analyse visitor interactions across product views, add-to-cart events, and transactions.
2. Identify the largest drop-off in the sequential product funnel.
3. Measure elapsed time between qualifying product funnel stages.
4. Evaluate monthly customer activity and cohort retention.
5. Compare product-level engagement and conversion performance.
6. Identify data-quality issues and methodological limitations that affect interpretation.
7. Present analytical findings through an interactive Power BI dashboard.

## 4. Project Scope

### Included

**Data inspection and quality investigation**
- Dataset structure and data-type inspection.
- Missing-value and exact duplicate analysis.
- Transaction-level integrity investigation.
- Item-property and category-hierarchy auditing.
- Removal of exact duplicate event records.

**Exploratory analysis**
- Event distribution and visitor activity.
- User-level event overlap.
- Chronological visitor behaviour.
- Sequential visitor–product conversion analysis.
- Conversion-window sensitivity investigation.

**SQL analysis**
- Sequential product funnel.
- Conversion-time distribution.
- Monthly cohort retention.
- Product-level funnel performance.
- Product opportunity ranking.

**Dashboard development**
- Executive Overview.
- Conversion Funnel.
- Customer Retention.
- Product Performance.

**Dashboard data preparation**
- SQL-generated analytical datasets.
- Python-based batch export of product-performance data.
- DAX-based monthly activity calculations.

### Excluded

The following are outside the scope of the completed analysis:

- Customer acquisition attribution.
- Customer demographics and segmentation based on unavailable attributes.
- Device-level conversion comparisons.
- Verified customer signup-date cohorts.
- Revenue, profit, and customer lifetime value modelling.
- Causal experimentation and A/B testing.
- Predictive customer behaviour or purchase forecasting.
- Production deployment or automated scheduled refresh infrastructure.

## 5. Technology and Tools

| Technology | Role |
|---|---|
| Python | Data inspection, quality investigation, cleaning, and export automation |
| Pandas and NumPy | Data manipulation and numerical analysis |
| PostgreSQL | Analytical data storage and query execution |
| SQL | Funnel, conversion-time, retention, and product analysis |
| SQLAlchemy | Database connectivity from Python |
| Power BI | Interactive dashboard and reporting |
| DAX | Monthly activity calculations |
| Jupyter Notebook | Exploratory and reproducible analysis |
| Git and GitHub | Version control and project publication |

## 6. Analytical Methodology

### Product funnel

The final funnel is evaluated using distinct visitor–product pairs.

A qualifying progression requires:

**Product View → Add to Cart → Transaction**

Each event must occur in chronological order for the same visitor and product.

The analysis reports both visitor–product pair counts and distinct visitor counts. Conversion percentages are calculated using visitor–product pairs.

### Conversion time

Elapsed time is measured between the first qualifying events at consecutive funnel stages.

The analysis includes average, median, P90, P95, and maximum elapsed time.

The final SQL analysis does not impose a maximum conversion window.

### Customer retention

Visitors are grouped by the month of their first observed activity.

Monthly retention is calculated by comparing active visitors in each subsequent activity month against the original cohort size.

Any recorded event qualifies as activity.

### Product performance

Products are compared using viewed, carted, and purchased visitor–product pairs and their associated conversion rates.

The opportunity analysis considers products with at least 100 viewed pairs before ranking them by observed purchase conversion.

## 7. Project Deliverables

| Deliverable | Location |
|---|---|
| Exploratory dataset inspection | `notebooks/01_dataset_inspection.ipynb` |
| Data cleaning and quality audit | `notebooks/02_data_cleaning.ipynb` |
| Dashboard export workflow | `notebooks/06_export_dashboard_data.ipynb` |
| Product funnel analysis | `sql/02_product_funnel.sql` |
| Conversion-time analysis | `sql/03_conversion_time.sql` |
| Customer retention analysis | `sql/04_customer_retention.sql` |
| Product performance analysis | `sql/05_product_performance.sql` |
| Product opportunity analysis | `sql/06_product_opportunity_analysis.sql` |
| Power BI report | `Dashboard/Product Analysis Dashboard.pbix` |
| Dashboard datasets | `Dashboard/Dashboard Data/` |
| Metric definitions | `docs/metric_dictionary.md` |
| Project documentation | `README.md` |

## 8. Success Criteria

The project is considered complete when:

- Dataset inspection and data-quality investigations are documented.
- Exact duplicate event records are removed and the cleaning result is validated.
- SQL queries implement the documented analytical definitions.
- Funnel calculations preserve chronological visitor–product relationships.
- Conversion-time and cohort-retention analyses are available.
- Product-level performance and opportunity outputs are generated.
- Dashboard datasets are available for reporting.
- The Power BI report presents the four intended analytical areas.
- Important assumptions and data limitations are disclosed.
- Large raw and processed datasets are excluded from the public repository.

## 9. Assumptions and Limitations

1. The first observed activity month is used as a proxy for cohort entry because registration dates are unavailable.
2. Retention measures any recorded activity, not necessarily repeat purchases.
3. Funnel conversion rates are based on visitor–product pairs rather than distinct visitors.
4. The final SQL funnel does not enforce a maximum time interval between events.
5. The final observed retention month may have incomplete future follow-up.
6. The event dataset does not provide a reliable order-value model for revenue or profitability analysis.
7. Observed behavioural patterns do not establish causal relationships.
8. The dataset's available attributes limit acquisition, device, demographic, and other contextual analysis.

## 10. Intended Audience

The project is intended for:

- Product analysts.
- Data analysts.
- E-commerce and growth analysts.
- Product managers.
- Business intelligence stakeholders.

The outputs are designed to support product-performance assessment, funnel investigation, and customer activity analysis.

## 11. Final Outcome

The project delivers an end-to-end analytical workflow combining Python-based data investigation, PostgreSQL and SQL analysis, DAX calculations, and Power BI reporting.

It demonstrates the use of event-level data to construct sequential product funnels, examine conversion timing, evaluate monthly retention, and compare product performance while explicitly documenting the assumptions and limitations of the available data.