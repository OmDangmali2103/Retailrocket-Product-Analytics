
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

product_views AS (
    SELECT itemid, COUNT(*) AS viewed_pairs
    FROM views
    GROUP BY itemid
),

product_carts AS (
    SELECT itemid, COUNT(*) AS cart_pairs
    FROM carts
    GROUP BY itemid
),

product_purchases AS (
    SELECT itemid, COUNT(*) AS purchased_pairs
    FROM purchases
    GROUP BY itemid
)

SELECT
    v.itemid,
    v.viewed_pairs,
    COALESCE(c.cart_pairs, 0) AS cart_pairs,
    COALESCE(p.purchased_pairs, 0) AS purchased_pairs,

    ROUND(
        100.0 * COALESCE(c.cart_pairs, 0)
        / NULLIF(v.viewed_pairs, 0), 2
    ) AS view_to_cart_pct,

    ROUND(
        100.0 * COALESCE(p.purchased_pairs, 0)
        / NULLIF(v.viewed_pairs, 0), 2
    ) AS view_to_purchase_pct

FROM product_views v
LEFT JOIN product_carts c
    ON v.itemid = c.itemid
LEFT JOIN product_purchases p
    ON v.itemid = p.itemid
ORDER BY v.viewed_pairs DESC;
