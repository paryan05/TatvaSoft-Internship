# 🧑‍💼 Employee Management SQL Project

This project demonstrates a simple **Employee Management System** using **PostgreSQL**. It includes table creation, data insertion, data manipulation, and SQL join operations using two related tables: `employees` and `employee_projects`.

---

## 📂 Tables

### 1. `employees`

Stores details of employees.

| Column       | Type          | Description              |
|--------------|---------------|--------------------------|
| `id`         | SERIAL        | Primary Key              |
| `name`       | VARCHAR(100)  | Employee's full name     |
| `email`      | VARCHAR(100)  | Unique email address     |
| `phone_number` | VARCHAR(15) | Contact number           |
| `department` | VARCHAR(100)  | Department name          |
| `salary`     | NUMERIC(10,2) | Salary in INR            |
| `age`        | INT           | Age of the employee      |

---

### 2. `employee_projects`

Stores project assignments for employees.

| Column        | Type          | Description                                 |
|---------------|---------------|---------------------------------------------|
| `project_id`  | SERIAL        | Primary Key                                 |
| `employee_id` | INT           | Foreign Key referencing `employees(id)`     |
| `project_name`| VARCHAR(100)  | Project name                                |
| `role`        | VARCHAR(50)   | Role of the employee in the project         |
| `start_date`  | DATE          | Project start date                          |
| `end_date`    | DATE          | Project end date                            |

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

