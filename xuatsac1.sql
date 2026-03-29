-- 1. Tạo bảng Sinh viên
CREATE TABLE students (
                          student_id SERIAL PRIMARY KEY,
                          full_name VARCHAR(100),
                          major VARCHAR(50)
);

-- 2. Tạo bảng Khóa học
CREATE TABLE courses (
                         course_id SERIAL PRIMARY KEY,
                         course_name VARCHAR(100),
                         credit INT
);

-- 3. Tạo bảng Đăng ký học (Kết nối giữa Sinh viên và Khóa học)
CREATE TABLE enrollments (
                             student_id INT REFERENCES students(student_id),
                             course_id INT REFERENCES courses(course_id),
                             score NUMERIC(5,2)
);

INSERT INTO students (full_name, major) VALUES
                                            ('Nguyen Van A', 'Computer Science'),
                                            ('Tran Thi B', 'Computer Science'),
                                            ('Le Van C', 'Data Science'),
                                            ('Pham Minh D', 'Data Science'),
                                            ('Hoang Thi E', 'Business Administration'),
                                            ('Ngo Van F', 'Business Administration'),
                                            ('Vu Tuyet G', 'Graphic Design'),
                                            ('Dang Van H', 'Graphic Design'),
                                            ('Bui Minh I', 'Economics'),
                                            ('Do Hoang J', 'Computer Science'); -- Sinh viên này sẽ không đăng ký môn nào để test LEFT JOIN

INSERT INTO courses (course_name, credit) VALUES
                                              ('Database Systems', 3),
                                              ('Python Programming', 4),
                                              ('Machine Learning', 4),
                                              ('Macroeconomics', 3),
                                              ('UI/UX Design', 2),
                                              ('Marketing Basics', 3),
                                              ('Advanced Math', 4); -- Môn này sẽ không có sinh viên nào học để test RIGHT JOIN

INSERT INTO enrollments (student_id, course_id, score) VALUES
                                                           (1, 1, 8.5), (1, 2, 9.0), (1, 3, 7.5), -- Sinh viên 1 học giỏi, nhiều môn
                                                           (2, 1, 4.0), (2, 2, 5.5),             -- Sinh viên 2 điểm trung bình/thấp
                                                           (3, 1, 9.5), (3, 3, 10.0),            -- Sinh viên 3 xuất sắc
                                                           (4, 2, 6.0),                          -- Sinh viên 4 chỉ học 1 môn
                                                           (5, 4, 8.0), (5, 6, 7.0),             -- Sinh viên ngành Kinh tế
                                                           (6, 4, 3.5),                          -- Sinh viên 6 bị trượt môn
                                                           (7, 5, 8.8),                          -- Sinh viên ngành Thiết kế
                                                           (8, 5, 9.2), (8, 6, 6.5),
                                                           (9, 6, 7.5);                          -- Sinh viên 9 học 1 môn
-- Lưu ý: student_id = 10 và course_id = 7 không xuất hiện ở đây.

-- 1. ALIAS:
SELECT
    s.full_name AS Ho_va_ten,
    c.course_name AS Mon_hoc,
    e.score AS Diem
FROM enrollments e
JOIN courses c on e.course_id = c.course_id
JOIN students s on e.student_id = s.student_id;

-- 2. Aggregate Functions:
SELECT
    s.student_id AS MSSV,
    s.full_name AS ho_va_ten,
    AVG(e.score)::DECIMAL(10,2) AS diem_trung_binh,
    MAX(e.score) AS diem_cao_nhat,
    MIN(e.score) AS diem_thap_nhat
FROM enrollments e
JOIN students s on e.student_id = s.student_id
GROUP BY s.student_id, s.full_name;

-- 3. GROUP BY / HAVING:
SELECT
    s.major AS nganh_hoc ,
    AVG(e.score)::DECIMAL(10,2) AS diem_trung_binh
FROM enrollments e
JOIN students s on s.student_id = e.student_id
GROUP BY s.major
HAVING AVG(e.score) > 7.5;

-- 4. JOIN:
SELECT
    s.full_name AS Ho_va_ten,
    c.course_name AS Mon_hoc,
    c.credit AS tin_chi,
    e.score AS Diem
FROM enrollments e
         JOIN courses c on e.course_id = c.course_id
         JOIN students s on e.student_id = s.student_id;

-- 5. Subquery:
SELECT
    s.student_id AS MSSV,
    s.full_name AS ho_va_ten,
    AVG(e.score)::DECIMAL(10,2) AS diem_trung_binh
FROM enrollments e
         JOIN students s on e.student_id = s.student_id
GROUP BY s.student_id, s.full_name
HAVING AVG(e.score) > (
    SELECT AVG(e.score)::DECIMAL(10, 2) AS diem_trung_binh
    FROM enrollments e
);