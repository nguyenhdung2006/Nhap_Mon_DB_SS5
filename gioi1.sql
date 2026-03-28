CREATE TABLE customers (
    customer_id serial primary key ,
    customer_name varchar(50) unique not null ,
    city varchar(50) not null
);

INSERT INTO customers (customer_name, city)
VALUES
    ('Nguyễn Văn A', 'Hà Nội'),
    ('Trần Thị B', 'Đà Nẵng'),
    ('Lê Văn C', 'Hồ Chí Minh'),
    ('Phạm Thị D', 'Hà Nội');

CREATE TABLE orders (
    order_id int primary key,
    customer_id int,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    order_date DATE not null ,
    total_price int not null
);

INSERT INTO orders (order_id, customer_id, order_date, total_price)
VALUES
    (101, 1, '2024-12-20', 3000),
    (102, 2, '2025-01-05', 1500),
    (103, 1, '2025-02-10', 2500),
    (104, 3, '2025-02-15', 4000),
    (105, 4, '2025-03-01', 800);

CREATE TABLE products (
                          product_id INT PRIMARY KEY,
                          product_name VARCHAR(255),
                          category VARCHAR(100)
);

INSERT INTO products VALUES (1, 'Laptop Dell', 'Điện tử');
INSERT INTO products VALUES (2, 'Bàn phím cơ', 'Phụ kiện');
INSERT INTO products VALUES (3, 'Chuột không dây', 'Phụ kiện');

CREATE TABLE order_items (
                             item_id INT PRIMARY KEY,
                             order_id INT,
                             product_id INT,
                             quantity INT,
                             price DECIMAL(10, 2),
                             FOREIGN KEY (order_id) REFERENCES orders(order_id),
                             FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items VALUES (1, 101, 1, 2, 1500);
INSERT INTO order_items VALUES (2, 102, 2, 1, 1500);
INSERT INTO order_items VALUES (3, 103, 3, 5, 500);
INSERT INTO order_items VALUES (4, 104, 2, 4, 1000);

-- ĐỀ SAI KHÁ NHIỀU!!!
SELECT
    customer_id,
    COUNT(order_id) as order_count, -- Tổng số đơn hàng
    SUM(total_price) as total_revenue-- Tổng doanh thu
FROM orders
GROUP BY customer_id
HAVING SUM(total_price) > 2000;

SELECT
    c.customer_name,
    o.customer_id,
    SUM(o.total_price) as tong_doanh_thu
From orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
HAVING SUM(o.total_price) > (
      SELECT AVG(tong_doanh_thu)
      From (
          SELECT customer_id, SUM(total_price) AS tong_doanh_thu
          FROM orders
          GROUP BY customer_id
           ) AS doanh_thu
);

SELECT city,tong_doanh_thu
From (
         SELECT
             c.city,
             SUM(o.total_price) AS tong_doanh_thu
         FROM orders o
                  JOIN customers c
                       ON o.customer_id = c.customer_id
         GROUP BY c.city
     ) AS doanh_thu_thanh_pho
ORDER BY tong_doanh_thu DESC
LIMIT 1;

SELECT
    c.customer_name,
    c.city,
    SUM(oi.quantity) as tong_so_luong,
    SUM(o.total_price) as tong_doanh_thu
FROM orders o
JOIN customers c on o.customer_id = c.customer_id
JOIN order_items oi on o.order_id = oi.order_id
GROUP BY c.city, c.customer_name;
