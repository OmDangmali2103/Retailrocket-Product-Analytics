

WITH user_activity AS (
    SELECT DISTINCT
        visitorid,
        DATE_TRUNC(
            'month',
            TO_TIMESTAMP(timestamp / 1000.0) AT TIME ZONE 'UTC'
        ) AS activity_month
    FROM events
),

first_activity AS (
    SELECT
        visitorid,
        MIN(activity_month) AS cohort_month
    FROM user_activity
    GROUP BY visitorid
),

cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(*) AS cohort_size
    FROM first_activity
    GROUP BY cohort_month
),

cohort_activity AS (
    SELECT
        f.cohort_month,
        a.activity_month,
        (
            EXTRACT(YEAR FROM a.activity_month)
            - EXTRACT(YEAR FROM f.cohort_month)
        ) * 12
        +
        (
            EXTRACT(MONTH FROM a.activity_month)
            - EXTRACT(MONTH FROM f.cohort_month)
        ) AS month_number,
        COUNT(DISTINCT a.visitorid) AS active_visitors
    FROM first_activity f
    JOIN user_activity a
        ON f.visitorid = a.visitorid
    GROUP BY
        f.cohort_month,
        a.activity_month
)

SELECT
    ca.cohort_month::date AS cohort_month,
    ca.activity_month::date AS activity_month,
    ca.month_number,
    cs.cohort_size,
    ca.active_visitors,
    ROUND(
        100.0 * ca.active_visitors / cs.cohort_size,
        2
    ) AS retention_rate_pct
FROM cohort_activity ca
JOIN cohort_sizes cs
    ON ca.cohort_month = cs.cohort_month
ORDER BY
    ca.cohort_month,
    ca.month_number;
