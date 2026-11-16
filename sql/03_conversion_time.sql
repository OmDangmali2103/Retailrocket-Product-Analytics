

WITH views AS (
    SELECT
        visitorid,
        itemid,
        MIN(timestamp) AS first_view_timestamp
    FROM events
    WHERE event = 'view'
    GROUP BY visitorid, itemid
),

carts AS (
    SELECT
        v.visitorid,
        v.itemid,
        v.first_view_timestamp,
        MIN(e.timestamp) AS first_cart_timestamp
    FROM views v
    JOIN events e
        ON e.visitorid = v.visitorid
       AND e.itemid = v.itemid
       AND e.event = 'addtocart'
       AND e.timestamp > v.first_view_timestamp
    GROUP BY
        v.visitorid,
        v.itemid,
        v.first_view_timestamp
),

purchases AS (
    SELECT
        c.visitorid,
        c.itemid,
        c.first_cart_timestamp,
        MIN(e.timestamp) AS first_purchase_timestamp
    FROM carts c
    JOIN events e
        ON e.visitorid = c.visitorid
       AND e.itemid = c.itemid
       AND e.event = 'transaction'
       AND e.timestamp > c.first_cart_timestamp
    GROUP BY
        c.visitorid,
        c.itemid,
        c.first_cart_timestamp
),

conversion_gaps AS (
    SELECT
        'View to Cart' AS conversion_stage,
        (first_cart_timestamp - first_view_timestamp)
            / 3600000.0 AS time_hours
    FROM carts

    UNION ALL

    SELECT
        'Cart to Purchase' AS conversion_stage,
        (first_purchase_timestamp - first_cart_timestamp)
            / 3600000.0 AS time_hours
    FROM purchases
)

SELECT
    conversion_stage,
    COUNT(*) AS converted_product_pairs,
    ROUND(AVG(time_hours)::numeric, 2) AS avg_hours,
    ROUND(
        (PERCENTILE_CONT(0.50)
            WITHIN GROUP (ORDER BY time_hours))::numeric, 2
    ) AS median_hours,
    ROUND(
        (PERCENTILE_CONT(0.90)
            WITHIN GROUP (ORDER BY time_hours))::numeric, 2
    ) AS p90_hours,
    ROUND(
        (PERCENTILE_CONT(0.95)
            WITHIN GROUP (ORDER BY time_hours))::numeric, 2
    ) AS p95_hours,
    ROUND(MAX(time_hours)::numeric, 2) AS max_hours
FROM conversion_gaps
GROUP BY conversion_stage
ORDER BY CASE conversion_stage
    WHEN 'View to Cart' THEN 1
    WHEN 'Cart to Purchase' THEN 2
END;
