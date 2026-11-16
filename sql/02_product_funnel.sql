
WITH views AS (
    -- First view for each visitor-product pair
    SELECT
        visitorid,
        itemid,
        MIN(timestamp) AS first_view_timestamp
    FROM events
    WHERE event = 'view'
    GROUP BY visitorid, itemid
),

carts AS (
    -- First cart event after the first view
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
    -- First transaction after the qualifying cart event
    SELECT
        c.visitorid,
        c.itemid,
        MIN(e.timestamp) AS first_purchase_timestamp
    FROM carts c
    JOIN events e
        ON e.visitorid = c.visitorid
       AND e.itemid = c.itemid
       AND e.event = 'transaction'
       AND e.timestamp > c.first_cart_timestamp
    GROUP BY c.visitorid, c.itemid
),

funnel_counts AS (
    SELECT
        (SELECT COUNT(*) FROM views) AS viewed_pairs,
        (SELECT COUNT(*) FROM carts) AS cart_pairs,
        (SELECT COUNT(*) FROM purchases) AS purchased_pairs,

        (SELECT COUNT(DISTINCT visitorid) FROM views) AS viewed_visitors,
        (SELECT COUNT(DISTINCT visitorid) FROM carts) AS cart_visitors,
        (SELECT COUNT(DISTINCT visitorid) FROM purchases) AS purchasing_visitors
)

SELECT
    viewed_pairs,
    cart_pairs,
    purchased_pairs,

    viewed_visitors,
    cart_visitors,
    purchasing_visitors,

    ROUND(
        100.0 * cart_pairs / NULLIF(viewed_pairs, 0), 2
    ) AS view_to_cart_pct,

    ROUND(
        100.0 * purchased_pairs / NULLIF(cart_pairs, 0), 2
    ) AS cart_to_purchase_pct,

    ROUND(
        100.0 * purchased_pairs / NULLIF(viewed_pairs, 0), 2
    ) AS view_to_purchase_pct

FROM funnel_counts;
