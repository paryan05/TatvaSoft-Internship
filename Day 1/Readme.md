# 🧑‍💼 Employee Management SQL Project

This project demonstrates a simple **Employee Management System** using **PostgreSQL**, including table creation, data insertion, querying, and different types of SQL joins. It consists of two tables:

- `employees`: Contains employee details
- `employee_projects`: Tracks which projects employees are assigned to

---

## 📁 Tables

### 📌 `employees`

| Column       | Type           | Description              |
|--------------|----------------|--------------------------|
| id           | SERIAL         | Primary Key              |
| name         | VARCHAR(100)   | Employee's name          |
| email        | VARCHAR(100)   | Unique email             |
| phone_number | VARCHAR(15)    | Contact number           |
| department   | VARCHAR(100)   | Department name          |
| salary       | NUMERIC(10,2)  | Monthly salary           |
| age          | INT            | Employee age             |

### 📌 `employee_projects`

| Column       | Type           | Description                            |
|--------------|----------------|----------------------------------------|
| project_id   | SERIAL         | Primary Key                            |
| employee_id  | INT            | Foreign key → employees(id)            |
| project_name | VARCHAR(100)   | Name of the project                    |
| role         | VARCHAR(50)    | Role in the project                    |
| start_date   | DATE           | Project start date                     |
| end_date     | DATE           | Project end date                       |

---

## 🔧 SQL Setup

### Create Tables

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    department VARCHAR(100),
    salary NUMERIC(10,2),
    age INT
);

CREATE TABLE employee_projects (
    project_id SERIAL PRIMARY KEY,
    employee_id INT,
    project_name VARCHAR(100),
    role VARCHAR(50),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);
```

---

## 📥 Sample Data

### Insert Employees

```sql
-- Single Record
INSERT INTO employees (name, email, phone_number, department, salary, age)
VALUES ('Ravi Kumar', 'ravi@example.com', '9876543210', 'IT', 75000, 30);

-- Multiple Records
INSERT INTO employees (name, email, phone_number, department, salary, age)
VALUES
('Neha Sharma', 'neha@example.com', '9123456789', 'HR', 60000, 28),
('Amit Mehta', 'amit@example.com', '9988776655', 'Finance', 70000, 35),
('Pooja Rani', 'pooja@example.com', '9112233445', 'IT', 80000, 29);
```

### Insert Projects

```sql
INSERT INTO employee_projects (employee_id, project_name, role, start_date, end_date)
VALUES
(1, 'Smart City', 'Developer', '2024-01-15', '2024-06-30'),
(2, 'AI Chatbot', 'Team Lead', '2023-11-01', '2024-05-01'),
(3, 'HR Management', 'Tester', '2024-03-01', '2024-09-30'),
(1, 'IoT Monitoring', 'Developer', '2024-07-01', '2024-12-31'),
(4, 'Payroll System', 'Project Manager', '2024-02-10', '2024-08-10');
```

---

## 🔍 Common Queries

### Select Operations

```sql
-- View all employees
SELECT * FROM employees;

-- View specific columns
SELECT name, email FROM employees;

-- Filter by condition
SELECT * FROM employees WHERE age > 30;

-- Sort by salary (descending)
SELECT * FROM employees ORDER BY salary DESC;

-- Limit result
SELECT * FROM employees LIMIT 3;

-- Pattern match
SELECT * FROM employees WHERE name LIKE 'N%';
```

### Update and Delete

```sql
-- Update salary
UPDATE employees SET salary = 85000 WHERE name = 'Pooja Rani';

-- Delete a record
DELETE FROM employees WHERE name = 'Amit Mehta';
```

### Modify Table

```sql
-- Set NOT NULL constraint
ALTER TABLE employees ALTER COLUMN age SET NOT NULL;
```

---

## 📊 Aggregation

```sql
-- Count all employees
SELECT COUNT(*) FROM employees;

-- Average salary
SELECT AVG(salary) FROM employees;

-- Group by age
SELECT age, COUNT(*) FROM employees GROUP BY age;

-- Group by department with total salary
SELECT department, SUM(salary) FROM employees GROUP BY department;
```

---

## 🔗 JOIN Operations

### INNER JOIN

```sql
SELECT e.id, e.name, p.project_name, p.role
FROM employees e
INNER JOIN employee_projects p ON e.id = p.employee_id;
```

### LEFT JOIN

```sql
SELECT e.id, e.name, p.project_name, p.role
FROM employees e
LEFT JOIN employee_projects p ON e.id = p.employee_id;
```

### RIGHT JOIN

```sql
SELECT e.id, e.name, p.project_name, p.role
FROM employees e
RIGHT JOIN employee_projects p ON e.id = p.employee_id;
```

### FULL OUTER JOIN

```sql
SELECT e.id, e.name, p.project_name, p.role
FROM employees e
FULL OUTER JOIN employee_projects p ON e.id = p.employee_id;
```

### CROSS JOIN

```sql
SELECT e.name, p.project_name
FROM employees e
CROSS JOIN employee_projects p;
```

---

## ✅ Requirements

- PostgreSQL installed locally
- SQL editor (e.g., pgAdmin, DBeaver, or psql CLI)
- Basic SQL knowledge

---

## 📌 Notes

- Ensure foreign key constraints match when inserting into `employee_projects`
- Use `ORDER BY`, `GROUP BY`, and filtering for more advanced insights
- This schema can be expanded to include project budgets, deadlines, performance metrics, etc.

---

## 📚 License

This project is open-source and free to use for learning or practice.
