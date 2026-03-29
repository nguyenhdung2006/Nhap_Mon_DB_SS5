CREATE TABLE departments (
                             dept_id SERIAL PRIMARY KEY,
                             dept_name VARCHAR(100)
);

CREATE TABLE employees (
                           emp_id SERIAL PRIMARY KEY,
                           emp_name VARCHAR(100),
                           dept_id INT REFERENCES departments(dept_id),
                           salary NUMERIC(10,2),
                           hire_date DATE
);

CREATE TABLE projects (
                          project_id SERIAL PRIMARY KEY,
                          project_name VARCHAR(100),
                          dept_id INT REFERENCES departments(dept_id)
);

INSERT INTO departments (dept_name) VALUES
                                        ('Phòng Kỹ thuật'),       -- Có nhân viên, có dự án
                                        ('Phòng Nhân sự'),        -- Có nhân viên, không có dự án
                                        ('Phòng Marketing'),       -- Không có nhân viên, có dự án
                                        ('Phòng Giám đốc');        -- Mới thành lập, chưa có gì cả

INSERT INTO employees (emp_name, dept_id, salary, hire_date) VALUES
                                                                 ('Nguyen Van A', 1, 1500.00, '2023-01-15'),
                                                                 ('Tran Thi B', 1, 1800.50, '2022-05-20'),
                                                                 ('Le Van C', 2, 1200.00, '2023-11-10'),
                                                                 ('Pham Minh D', 2, 900.00, '2024-02-01'), -- Lương thấp để test lọc
                                                                 ('Hoang Thi E', NULL, 2000.00, '2021-03-12'), -- NV tự do (dept_id NULL) để test LEFT JOIN
                                                                 ('Doan Van F', 1, 3000.00, '2020-01-01'); -- Lương cao nhất

INSERT INTO projects (project_name, dept_id) VALUES
                                                 ('Xây dựng App Mobile', 1),
                                                 ('Bảo trì Server', 1),
                                                 ('Chiến dịch Quảng cáo Tết', 3), -- Thuộc phòng Marketing (phòng này chưa có NV)
                                                 ('Tuyển dụng nhân tài', 2),
                                                 ('Dự án bí mật', NULL); -- Dự án chưa gán phòng ban

-- 1. Alias:
SELECT
    e.emp_name AS ten_nhan_vien ,
    d.dept_name AS ten_phong_ban ,
    e.salary AS luong
FROM employees e
JOIN departments d on e.dept_id = d.dept_id
JOIN projects p on d.dept_id = p.dept_id;

-- 2. Aggregate Functions:
SELECT
    SUM(e.salary) AS "tổng quỹ lương" ,
    AVG(e.salary)::DECIMAL(10, 2) AS "mức lương trung bình" ,
    MAX(e.salary) AS "Lương cao nhất" ,
    MIN(e.salary) AS "Lương thấp nhất" ,
    COUNT(DISTINCT emp_name) AS "Số nhân viên"
FROM employees e;

-- 3. GROUP BY / HAVING:
SELECT
    d.dept_name,
    AVG(e.salary)::DECIMAL(10, 2) AS luong_trung_binh
FROM employees e
JOIN departments d on e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 15000000;

-- 4. JOIN:
SELECT
    p.project_name AS ten_du_an ,
    d.dept_name AS ten_phong_ban ,
    e.emp_name AS ten_nhan_vien
FROM employees e
         JOIN departments d on e.dept_id = d.dept_id
         JOIN projects p on d.dept_id = p.dept_id;

-- 5. Subquery:
SELECT
    d.dept_name AS phong_ban ,
    MAX(e.salary) AS luong_cao_nhat
FROM employees e
JOIN departments d on d.dept_id = e.dept_id
GROUP BY d.dept_name;

