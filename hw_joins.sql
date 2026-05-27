-- 1)
SELECT 
    p.title AS product_title,
    p.price,
    c.title AS category_title
FROM products p
JOIN categories c ON p.category_id = c.id
ORDER BY c.title ASC, p.price DESC;


-- 2)
SELECT 
    o.id AS order_id,
    o.created_at
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE u.name = 'Platon'
ORDER BY o.created_at ASC;


-- 3)
SELECT 
    o.id AS order_id,
    u.name AS user_name,
    p.title AS product_title,
    oi.qty,
    oi.qty * p.price AS line_sum
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
ORDER BY o.id ASC, p.title ASC;


-- 4)
SELECT 
    o.id AS order_id,
    u.name AS user_name,
    SUM(oi.qty * p.price) AS order_total
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY o.id, u.name
ORDER BY order_total DESC;


-- 5)
SELECT 
    p.title AS product_title,
    c.title AS category_title
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE oi.product_id IS NULL;
