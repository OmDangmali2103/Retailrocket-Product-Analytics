

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
        MIN(e.timestamp) AS first_cart_timestamp
    FROM views v
    JOIN events e
        ON e.visitorid = v.visitorid
       AND e.itemid = v.itemid
       AND e.event = 'addtocart'
       AND e.timestamp > v.first_view_timestamp
    GROUP BY v.visitorid, v.itemid
),

purchases AS (
    SELECT
        c.visitorid,
        c.itemid
    FROM carts c
    JOIN events e
        ON e.visitorid = c.visitorid
       AND e.itemid = c.itemid
       AND e.event = 'transaction'
       AND e.timestamp > c.first_cart_timestamp
    GROUP BY c.visitorid, c.itemid
),

product_metrics AS (
    SELECT
        v.itemid,
        COUNT(*) AS viewed_pairs,
        COUNT(c.visitorid) AS cart_pairs,
        COUNT(p.visitorid) AS purchased_pairs
    FROM views v
    LEFT JOIN carts c
        ON v.visitorid = c.visitorid
       AND v.itemid = c.itemid
    LEFT JOIN purchases p
        ON c.visitorid = p.visitorid
       AND c.itemid = p.itemid
    GROUP BY v.itemid
)

SELECT
    itemid,
    viewed_pairs,
    cart_pairs,
    purchased_pairs,
    ROUND(
        100.0 * purchased_pairs / NULLIF(viewed_pairs, 0), 2
    ) AS view_to_purchase_pct
FROM product_metrics
WHERE viewed_pairs >= 100
ORDER BY view_to_purchase_pct DESC, viewed_pairs DESC
LIMIT 20;
