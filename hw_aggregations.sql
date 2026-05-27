-- INSERT (что добавил)

INSERT INTO categories (name)
VALUES ('Accessories');

INSERT INTO products (name, price, category_id)
VALUES
('Mouse Pad', 2500, 1),
('Gaming Mouse', 15000, 1),
('USB-C Cable', 3000, 2),
('Power Bank', 22000, 2),
('Laptop Bag', 18000, 3);

INSERT INTO orders (customer, total)
VALUES
('Ali', 2500),
('Ali', 85000),
('Dana', 12000),
('Dana', 45000),
('Miras', 90000),
('Amina', 7000);


-- 1)
SELECT category_id, COUNT(*) AS total_products
FROM products
GROUP BY category_id
ORDER BY total_products DESC;


-- 2)
SELECT category_id, COUNT(*) AS total_products
FROM products
GROUP BY category_id
HAVING COUNT(*) >= 3;


-- 3)
SELECT 
    category_id,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category_id;


-- 4)
SELECT category_id, COUNT(*) AS expensive_count
FROM products
WHERE price > 10000
GROUP BY category_id
HAVING COUNT(*) >= 2;


-- 5)
SELECT customer, COUNT(*) AS orders_count
FROM orders
GROUP BY customer
ORDER BY orders_count DESC;


-- 6)
SELECT customer, COUNT(*) AS orders_count
FROM orders
GROUP BY customer
HAVING COUNT(*) >= 2;


-- 7)
SELECT 
    customer,
    SUM(total) AS spent_total,
    ROUND(AVG(total), 2) AS avg_check
FROM orders
GROUP BY customer
ORDER BY spent_total DESC;
