-- 1. ALIAS:
SELECT c.customer_name, o.order_date, o.total_amount
FROM orders o
JOIN customers c on o.customer_id = c.customer_id
JOIN order_items oi on o.order_id = oi.order_id;

-- 2. Aggregate Functions:
SELECT
    SUM(total_amount) AS tong_doanh_thu,
    AVG(total_amount) AS trung_binh_gia_tri_don,
    MAX(total_amount) AS don_hang_lon_nhat,
    MIN(total_amount) AS don_hang_nho_nhat,
    COUNT(order_id) AS tong_so_don_hang
FROM orders;

-- 3. GROUP BY / HAVING:
SELECT
    c.city,
    SUM(total_amount) AS tong_doanh_thu
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING SUM(total_amount) > 10000;

-- 4. JOIN:
SELECT
    c.customer_name,
    o.order_date,
    oi.quantity,
    oi.price
FROM orders o
JOIN customers c on o.customer_id = c.customer_id
JOIN order_items oi on o.order_id = oi.order_id;

-- 5. Subquery:
SELECT
    o.customer_id,
    c.customer_name,
    SUM(total_amount) AS doanh_thu
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
HAVING SUM(total_amount) = (
    SELECT MAX(doanh_thu)
    FROM (
        SELECT SUM(total_amount) AS doanh_thu
        FROM orders
        GROUP BY customer_id
         )
);
