# Metric Dictionary

This document defines the metrics used in the Retailrocket Product Analytics project. Definitions reflect the implemented SQL analyses and dashboard datasets.

## 1. Product Funnel Metrics

The product funnel is calculated at the **visitor–product pair** level.

A pair represents one combination of a visitor identifier and a product identifier.

| Metric | Definition |
|---|---|
| Viewed Pairs | Distinct visitor–product pairs with at least one recorded view |
| Carted Pairs | Distinct visitor–product pairs with an add-to-cart event occurring after the first recorded view |
| Purchased Pairs | Distinct visitor–product pairs with a transaction occurring after the qualifying add-to-cart event |
| Viewed Visitors | Distinct visitors who viewed at least one product |
| Cart Visitors | Distinct visitors with at least one qualifying carted product |
| Purchasing Visitors | Distinct visitors with at least one qualifying purchased product |

### Conversion rate formulas

**View-to-Cart Conversion**

\[
\frac{\text{Carted Pairs}}{\text{Viewed Pairs}}\times100
\]

**Cart-to-Purchase Conversion**

\[
\frac{\text{Purchased Pairs}}{\text{Carted Pairs}}\times100
\]

**View-to-Purchase Conversion**

\[
\frac{\text{Purchased Pairs}}{\text{Viewed Pairs}}\times100
\]

These percentages measure conversion across visitor–product pairs. They are not calculated using distinct visitor counts.

### Event sequence

The qualifying sequence is:

1. First recorded view for a visitor–product pair.
2. First add-to-cart event occurring after that view.
3. First transaction event occurring after that qualifying cart event.

Events must belong to the same visitor and product.

The final SQL funnel does not impose a maximum time interval between these events.

## 2. Conversion-Time Metrics

Conversion time measures elapsed time between qualifying events for a visitor–product pair.

| Metric | Definition |
|---|---|
| View-to-Cart Time | Time between the first recorded view and the first qualifying add-to-cart event |
| Cart-to-Purchase Time | Time between the first qualifying add-to-cart event and the first subsequent transaction |
| Average Hours | Arithmetic mean of qualifying elapsed times, expressed in hours |
| Median Hours | 50th percentile of qualifying elapsed times |
| P90 Hours | 90th percentile of qualifying elapsed times |
| P95 Hours | 95th percentile of qualifying elapsed times |
| Maximum Hours | Largest observed qualifying elapsed time |

Elapsed time is calculated as:

\[
\text{Elapsed Hours} =
\frac{\text{Later Event Timestamp}-\text{Earlier Event Timestamp}}
{3,600,000}
\]

The source timestamps are Unix milliseconds.

No maximum conversion window or session boundary is imposed in the final SQL analysis. Consequently, long intervals can influence average and maximum values.

## 3. Customer Retention Metrics

Retention is measured using monthly activity cohorts.

| Metric | Definition |
|---|---|
| Cohort Month | Calendar month of a visitor's first observed activity |
| Activity Month | Calendar month in which a visitor has at least one recorded event |
| Month Number | Number of calendar months between the cohort month and activity month |
| Cohort Size | Number of distinct visitors assigned to the cohort |
| Active Visitors | Number of distinct cohort visitors with at least one recorded event in the activity month |
| Retention Rate (%) | Active visitors divided by cohort size, multiplied by 100 |

### Retention formula

\[
\text{Retention Rate} =
\frac{\text{Active Visitors}}{\text{Cohort Size}}\times100
\]

Month 0 represents the cohort's initial activity month and is normally 100%.

**Interpretation:** A visitor is considered active if any recorded event occurs during the relevant month. This metric measures observed activity retention, not necessarily repeat purchasing or customer loyalty.

The first observed activity date is used because actual registration dates are unavailable. The final observed month may have incomplete follow-up.

## 4. Monthly Activity Metrics

The monthly activity dataset is prepared using Power BI DAX.

| Metric | Definition |
|---|---|
| Activity Month | Calendar month associated with the event timestamp |
| View Events | Number of recorded view events during the month |
| Add-to-Cart Events | Number of recorded add-to-cart events during the month |
| Transaction Events | Number of recorded transaction events during the month |
| Monthly Active Visitors | Number of distinct visitors with at least one recorded event during the month |

Event counts represent recorded events, not necessarily distinct visitors or completed orders.

Monthly active visitors are distinct within each month. A visitor may therefore be counted in multiple months.

## 5. Product Performance Metrics

Product performance is calculated for each product identifier.

| Metric | Definition |
|---|---|
| Item ID | Product identifier |
| Viewed Pairs | Number of distinct visitor–product pairs with a recorded view |
| Cart Pairs | Number of distinct visitor–product pairs with a qualifying cart event |
| Purchased Pairs | Number of distinct visitor–product pairs with a qualifying transaction |
| View-to-Cart (%) | Carted pairs divided by viewed pairs, multiplied by 100 |
| View-to-Purchase (%) | Purchased pairs divided by viewed pairs, multiplied by 100 |

Products with no qualifying cart or purchase pairs are assigned zero counts and zero conversion rates in the product-level output.

### Product opportunity analysis

The opportunity analysis applies a minimum threshold of **100 viewed visitor–product pairs**.

Products are ranked primarily by view-to-purchase conversion rate, with viewed-pair volume used as a secondary ordering criterion.

A high conversion rate alone does not establish high revenue, profitability, or commercial value.

## 6. Data and Interpretation Notes

- Exact duplicate event records are removed during the documented events-cleaning step.
- The original raw data is retained unchanged.
- Missing transaction identifiers are present in the source data; transaction analysis relies on qualifying transaction event records and their visitor–product relationships.
- Visitor-level event overlap is not equivalent to a sequential conversion funnel.
- Conversion percentages use visitor–product pairs, while unique visitor counts are separate metrics.
- First observed activity is a proxy for cohort entry, not a verified signup date.
- Retention measures any observed event activity, not necessarily repeat purchases.
- The final observation month may not provide complete future retention follow-up.
- The dataset does not provide sufficient order-value information for reliable revenue or profitability analysis.
- Observational results identify patterns and potential investigation areas; they do not establish causality.

---

**Source:** Retailrocket E-commerce Dataset. See the project README for dataset attribution and usage information.