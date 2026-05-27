-- 1)
SELECT
    c.id,
    c.name,
    CASE
        WHEN (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.id) = 0 THEN 'new'
        WHEN (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.id) BETWEEN 1 AND 2 THEN 'returning'
        ELSE 'loyal'
    END AS client_type
FROM customers c;


-- 2)
SELECT
    o.id,
    o.created_at,
    o.status,
    CASE
        WHEN o.status = 'cancelled' THEN 'high'
        WHEN o.status = 'new' AND o.created_at < CURRENT_DATE - INTERVAL '3 days' THEN 'medium'
        ELSE 'low'
    END AS risk_label
FROM orders o;


-- 3)
SELECT
    p.id,
    p.title,
    p.price,
    p.category_id
FROM products p
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);


-- 4)
SELECT
    p.id,
    p.title,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM order_items oi
            WHERE oi.product_id = p.id
        ) THEN 'sold'
        ELSE 'not_sold'
    END AS sold_flag
FROM products p;


-- 5)
SELECT
    o.id,
    (
        SELECT COALESCE(SUM(p.amount), 0)
        FROM payments p
        WHERE p.order_id = o.id
    ) AS paid_amount,
    (
        SELECT COALESCE(SUM(oi.qty * oi.price), 0)
        FROM order_items oi
        WHERE oi.order_id = o.id
    ) AS items_total
FROM orders o
WHERE
    (
        SELECT COALESCE(SUM(p.amount), 0)
        FROM payments p
        WHERE p.order_id = o.id
    ) >
    (
        SELECT COALESCE(SUM(oi.qty * oi.price), 0)
        FROM order_items oi
        WHERE oi.order_id = o.id
    )
    AND EXISTS (
        SELECT 1
        FROM payments p
        WHERE p.order_id = o.id
    );


-- 6)
SELECT
    o.id,
    o.status
FROM orders o
WHERE EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.order_id = o.id
      AND oi.product_id IN (
          SELECT p.id
          FROM products p
          WHERE p.price > 20000
      )
);


-- 7)
SELECT
    o.id,
    CASE
        WHEN COALESCE((
            SELECT SUM(oi.qty * oi.price)
            FROM order_items oi
            WHERE oi.order_id = o.id
        ), 0) = 0 THEN 'zero'
        WHEN COALESCE((
            SELECT SUM(oi.qty * oi.price)
            FROM order_items oi
            WHERE oi.order_id = o.id
        ), 0) < 10000 THEN 'small'
        WHEN COALESCE((
            SELECT SUM(oi.qty * oi.price)
            FROM order_items oi
            WHERE oi.order_id = o.id
        ), 0) BETWEEN 10000 AND 50000 THEN 'medium'
        ELSE 'big'
    END AS check_class
FROM orders o;


-- 8)
SELECT
    c.id,
    c.name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
      AND EXISTS (
          SELECT 1
          FROM payments p
          WHERE p.order_id = o.id
      )
)
AND NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
      AND EXISTS (
          SELECT 1
          FROM shipments s
          WHERE s.order_id = o.id
      )
);


-- 9)
SELECT
    o.id,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM order_items oi
            WHERE oi.order_id = o.id
        ) THEN 'filled'
        ELSE 'empty'
    END AS items_state
FROM orders o;


-- 10)
SELECT
    o.id,
    CASE
        WHEN NOT EXISTS (
            SELECT 1
            FROM order_items oi
            WHERE oi.order_id = o.id
        ) THEN 'D'

        WHEN EXISTS (
            SELECT 1
            FROM payments p
            WHERE p.order_id = o.id
        )
        AND COALESCE((
            SELECT SUM(oi.qty * oi.price)
            FROM order_items oi
            WHERE oi.order_id = o.id
        ), 0) >= 50000 THEN 'A'

        WHEN EXISTS (
            SELECT 1
            FROM payments p
            WHERE p.order_id = o.id
        )
        AND COALESCE((
            SELECT SUM(oi.qty * oi.price)
            FROM order_items oi
            WHERE oi.order_id = o.id
        ), 0) < 50000 THEN 'B'

        ELSE 'C'
    END AS business_grade
FROM orders o;
