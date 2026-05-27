DROP TABLE IF EXISTS employees_hw;

CREATE TABLE employees_hw (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    age INT CHECK (age >= 0),
    department VARCHAR(60) NOT NULL,
    salary INT CHECK (salary >= 0),
    hired_at DATE DEFAULT CURRENT_DATE,
    fired_at DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO employees_hw 
(full_name, email, age, department, salary, hired_at, fired_at)
VALUES
('Alan Smith', 'alan.smith@corp.com', 25, 'IT', 650000, '2023-01-10', NULL),
('Dana Brown', 'dana.brown@gmail.com', 19, 'HR', 300000, '2024-02-15', NULL),
('Aruzhan Sadykova', 'aruzhan@corp.com', 17, 'Sales', 250000, '2024-03-01', NULL),
('Miras Khan', 'miras.khan@gmail.com', 30, 'Marketing', 700000, '2022-05-20', NULL),
('Anel Karimova', 'anel.karimova@corp.com', 22, 'IT', 800000, '2021-09-12', NULL),
('Roman Lee', 'roman.lee@gmail.com', 28, 'Sales', 550000, '2023-07-18', '2025-01-10'),
('Ayan Omarov', 'ayan.omarov@corp.com', 18, 'HR', 280000, '2024-01-11', NULL),
('Sanzhar Kim', 'sanzhar.kim@gmail.com', 16, 'IT', 400000, '2024-04-05', NULL),
('Anna Petrova', 'anna.petrova@corp.com', 21, 'Marketing', 620000, '2022-10-10', NULL),
('Dias Nur', 'dias.nur@gmail.com', 35, 'Sales', 750000, '2020-06-30', NULL),
('Madina Ali', 'madina.ali@corp.com', 27, 'HR', 480000, '2021-12-01', '2024-12-15'),
('Ivan Sokolov', 'ivan.sokolov@gmail.com', 23, 'IT', 900000, '2020-03-14', NULL),
('Kanat Ermek', 'kanat.ermek@corp.com', 19, 'Marketing', 350000, '2024-05-22', NULL),
('Nurlan Bek', 'nurlan.bek@gmail.com', 32, 'Sales', 150000, '2022-08-08', '2025-02-20'),
('Amina Toleu', 'amina.toleu@corp.com', 26, 'IT', 610000, '2023-11-11', NULL);

SELECT * FROM employees_hw;

SELECT * FROM employees_hw WHERE salary > 500000;
SELECT * FROM employees_hw WHERE age >= 18;
SELECT * FROM employees_hw WHERE department = 'IT';
SELECT * FROM employees_hw WHERE department != 'IT';
SELECT * FROM employees_hw WHERE id = 1;
SELECT * FROM employees_hw WHERE department = 'IT' AND salary >= 600000;
SELECT * FROM employees_hw WHERE department = 'HR' OR department = 'Marketing';
SELECT * FROM employees_hw WHERE age < 20 OR salary > 700000;
SELECT * FROM employees_hw WHERE department = 'Sales' AND (age < 25 OR salary > 500000);
SELECT * FROM employees_hw WHERE age BETWEEN 20 AND 30;
SELECT * FROM employees_hw WHERE salary BETWEEN 300000 AND 600000;
SELECT * FROM employees_hw WHERE fired_at IS NULL;
SELECT * FROM employees_hw WHERE fired_at IS NOT NULL;

SELECT * FROM employees_hw WHERE full_name ILIKE '%an%';
SELECT * FROM employees_hw WHERE full_name LIKE 'A%';
SELECT * FROM employees_hw WHERE email ILIKE '%corp%' OR email ILIKE '%gmail%';
SELECT * FROM employees_hw WHERE department ILIKE '%s%';

SELECT * FROM employees_hw ORDER BY salary DESC;
SELECT * FROM employees_hw ORDER BY salary DESC LIMIT 5;
SELECT * FROM employees_hw ORDER BY age ASC LIMIT 3;
SELECT * FROM employees_hw ORDER BY created_at DESC LIMIT 5;
SELECT * FROM employees_hw ORDER BY department ASC, full_name ASC;

UPDATE employees_hw
SET salary = salary * 1.10
WHERE department = 'IT';

SELECT * FROM employees_hw;

UPDATE employees_hw
SET salary = salary * 0.95
WHERE department = 'Sales';

SELECT * FROM employees_hw;

UPDATE employees_hw
SET department = 'Marketing'
WHERE email = 'ayan.omarov@corp.com';

SELECT * FROM employees_hw;

UPDATE employees_hw
SET full_name = 'Alan Johnson'
WHERE id = 1;

SELECT * FROM employees_hw;

UPDATE employees_hw
SET fired_at = CURRENT_DATE
WHERE id = 2;

SELECT * FROM employees_hw;

UPDATE employees_hw
SET salary = salary + 50000
WHERE age < 18;

SELECT * FROM employees_hw;

DELETE FROM employees_hw
WHERE id = 3;

SELECT * FROM employees_hw;

DELETE FROM employees_hw
WHERE salary < 200000;

SELECT * FROM employees_hw;

DELETE FROM employees_hw
WHERE fired_at IS NOT NULL;

SELECT * FROM employees_hw;

SELECT COUNT(*) FROM employees_hw;

SELECT MIN(salary), MAX(salary) FROM employees_hw;

SELECT * FROM employees_hw ORDER BY id;
