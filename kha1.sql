-- 1. Tạo bảng products trong schema kha1
CREATE TABLE kha1.products (
                               product_id INT PRIMARY KEY, -- Để INSERT thủ công ID 1,2,3... thì dùng INT thay vì SERIAL
                               product_name VARCHAR(100) UNIQUE NOT NULL,
                               category VARCHAR(50)
);

-- 2. Chèn dữ liệu vào bảng products
INSERT INTO kha1.products(product_id, product_name, category)
VALUES
    (1, 'Laptop Dell', 'Electronics'),
    (2, 'IPhone 15', 'Electronics'),
    (3, 'Bàn học gỗ', 'Furniture'),
    (4, 'Ghế xoay', 'Furniture');

-- 3. Tạo bảng orders (Cần chỉ rõ tham chiếu tới kha1.products)
CREATE TABLE kha1.orders (
                             order_id INT PRIMARY KEY,
                             product_id INT REFERENCES kha1.products(product_id), -- QUAN TRỌNG: Phải có kha1.
                             quantity INT,
                             total_price DECIMAL(10, 2)
);

-- 4. Chèn dữ liệu vào bảng orders
INSERT INTO kha1.orders (order_id, product_id, quantity, total_price)
VALUES
    (101, 1, 2, 2200),
    (102, 2, 3, 3300),
    (103, 3, 5, 2500),
    (104, 4, 4, 1600),
    (105, 1, 1, 1100);

SELECT
    p.category,
    SUM(o.total_price) AS total_sales,
    SUM(o.quantity) AS total_quantity
FROM kha1.orders o
JOIN kha1.products p
ON o.product_id = p.product_id
GROUP BY p.category
HAVING SUM(o.total_price) > 2000
ORDER BY total_sales DESC;