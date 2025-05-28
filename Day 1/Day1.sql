CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    department VARCHAR(100),
    salary NUMERIC(10,2),
    age INT
);

-- Insert single record
INSERT INTO employees (name, email, phone_number, department, salary, age)
VALUES ('Ravi Kumar', 'ravi@example.com', '9876543210', 'IT', 75000, 30);

-- Insert multiple records
INSERT INTO employees (name, email, phone_number, department, salary, age)
VALUES
('Neha Sharma', 'neha@example.com', '9123456789', 'HR', 60000, 28),
('Amit Mehta', 'amit@example.com', '9988776655', 'Finance', 70000, 35),
('Pooja Rani', 'pooja@example.com', '9112233445', 'IT', 80000, 29);

-- Select all
SELECT * FROM employees;

-- Select specific columns
SELECT name, email FROM employees;

-- Filter with WHERE
SELECT * FROM employees WHERE age > 30;

-- ORDER BY
SELECT * FROM employees ORDER BY salary DESC;

-- LIMIT
SELECT * FROM employees LIMIT 3;

-- LIKE
SELECT * FROM employees WHERE name LIKE 'N%';

-- Update record
UPDATE employees SET salary = 85000 WHERE name = 'Pooja Rani';

-- Delete record
DELETE FROM employees WHERE name = 'Amit Mehta';

-- Make column NOT NULL
ALTER TABLE employees ALTER COLUMN age SET NOT NULL;

-- Count
SELECT COUNT(*) FROM employees;

-- Average salary
SELECT AVG(salary) FROM employees;

-- Group by age
SELECT age, COUNT(*) FROM employees GROUP BY age;

-- Group by department with total salary
SELECT department, SUM(salary) FROM employees GROUP BY department;

CREATE TABLE employee_projects (
    project_id SERIAL PRIMARY KEY,
    employee_id INT,
    project_name VARCHAR(100),
    role VARCHAR(50),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

INSERT INTO employee_projects (employee_id, project_name, role, start_date, end_date)
VALUES
(1, 'Smart City', 'Developer', '2024-01-15', '2024-06-30'),
(2, 'AI Chatbot', 'Team Lead', '2023-11-01', '2024-05-01'),
(3, 'HR Management', 'Tester', '2024-03-01', '2024-09-30'),
(1, 'IoT Monitoring', 'Developer', '2024-07-01', '2024-12-31'),
(4, 'Payroll System', 'Project Manager', '2024-02-10', '2024-08-10');

SELECT e.id, e.name, p.project_name, p.role
FROM employees e
INNER JOIN employee_projects p ON e.id = p.employee_id;

SELECT e.id, e.name, p.project_name, p.role
FROM employees e
LEFT JOIN employee_projects p ON e.id = p.employee_id;

SELECT e.id, e.name, p.project_name, p.role
FROM employees e
RIGHT JOIN employee_projects p ON e.id = p.employee_id;

SELECT e.id, e.name, p.project_name, p.role
FROM employees e
FULL OUTER JOIN employee_projects p ON e.id = p.employee_id;

SELECT e.name, p.project_name
FROM employees e
CROSS JOIN employee_projects p;

