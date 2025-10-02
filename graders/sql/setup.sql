-- Company Database Setup Script
-- Creates a realistic company database with employees, departments, and projects

-- Create departments table
CREATE TABLE departments (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    location TEXT NOT NULL,
    budget INTEGER NOT NULL
);

-- Create employees table
CREATE TABLE employees (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    salary INTEGER NOT NULL,
    hire_date DATE NOT NULL,
    department_id INTEGER,
    manager_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments (id),
    FOREIGN KEY (manager_id) REFERENCES employees (id)
);

-- Create projects table
CREATE TABLE projects (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    deadline DATE,
    budget INTEGER NOT NULL,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments (id)
);

-- Create junction table for many-to-many relationship
CREATE TABLE employee_projects (
    employee_id INTEGER,
    project_id INTEGER,
    role TEXT,
    hours_allocated INTEGER,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES employees (id),
    FOREIGN KEY (project_id) REFERENCES projects (id)
);

-- Insert departments
INSERT INTO departments (id, name, location, budget) VALUES
(1, 'Engineering', 'San Francisco', 500000),
(2, 'Marketing', 'New York', 200000),
(3, 'Sales', 'Chicago', 300000),
(4, 'Human Resources', 'Austin', 150000);

-- Insert employees
INSERT INTO employees (id, first_name, last_name, email, salary, hire_date, department_id, manager_id) VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@company.com', 95000, '2022-01-15', 1, NULL),
(2, 'Bob', 'Smith', 'bob.smith@company.com', 78000, '2022-03-20', 1, 1),
(3, 'Charlie', 'Brown', 'charlie.brown@company.com', 82000, '2021-11-10', 1, 1),
(4, 'Diana', 'Wilson', 'diana.wilson@company.com', 65000, '2023-02-14', 2, NULL),
(5, 'Eve', 'Davis', 'eve.davis@company.com', 58000, '2023-05-08', 2, 4),
(6, 'Frank', 'Miller', 'frank.miller@company.com', 72000, '2022-09-12', 3, NULL),
(7, 'Grace', 'Lee', 'grace.lee@company.com', 55000, '2023-06-18', 3, 6),
(8, 'Henry', 'Taylor', 'henry.taylor@company.com', 61000, '2023-01-25', 3, 6),
(9, 'Ivy', 'Anderson', 'ivy.anderson@company.com', 68000, '2022-07-03', 4, NULL),
(10, 'Jack', 'White', 'jack.white@company.com', 89000, '2021-08-17', 1, 1),
(11, 'Kate', 'Garcia', 'kate.garcia@company.com', 53000, '2023-09-11', 2, 4),
(12, 'Liam', 'Martinez', 'liam.martinez@company.com', 59000, '2023-04-22', 3, 6),
(13, 'Mia', 'Clark', 'mia.clark@company.com', 76000, '2022-12-05', 1, 1),
(14, 'Noah', 'Rodriguez', 'noah.rodriguez@company.com', 62000, '2023-03-30', 4, 9),
(15, 'Olivia', 'Lewis', 'olivia.lewis@company.com', 71000, '2022-10-14', 2, 4);

-- Insert projects
INSERT INTO projects (id, name, start_date, deadline, budget, department_id) VALUES
(101, 'Project Phoenix', '2024-01-15', '2025-12-31', 250000, 1),
(102, 'Project Titan', '2024-03-01', '2026-06-30', 180000, 1),
(103, 'Brand Refresh', '2024-02-10', '2024-11-15', 85000, 2),
(104, 'Customer Portal', '2024-04-01', '2025-03-31', 120000, 1),
(105, 'Sales Automation', '2024-05-15', '2025-01-15', 95000, 3),
(106, 'Employee Onboarding', '2024-01-01', '2024-08-31', 45000, 4),
(107, 'Market Research', '2024-06-01', '2024-12-31', 75000, 2),
(108, 'Data Migration', '2024-07-01', '2025-02-28', 110000, 1);

-- Insert employee-project assignments
INSERT INTO employee_projects (employee_id, project_id, role, hours_allocated) VALUES
-- Project Phoenix assignments
(1, 101, 'Tech Lead', 40),
(2, 101, 'Senior Developer', 35),
(3, 101, 'Developer', 30),
(10, 101, 'Database Specialist', 25),

-- Project Titan assignments
(1, 102, 'Architect', 20),
(13, 102, 'Lead Developer', 40),
(3, 102, 'Developer', 35),

-- Brand Refresh assignments
(4, 103, 'Project Manager', 35),
(5, 103, 'Marketing Specialist', 30),
(15, 103, 'Creative Director', 32),

-- Customer Portal assignments
(2, 104, 'Frontend Lead', 38),
(10, 104, 'Backend Developer', 35),
(13, 104, 'UI Developer', 25),

-- Sales Automation assignments
(6, 105, 'Sales Lead', 30),
(7, 105, 'Sales Analyst', 25),
(12, 105, 'Sales Coordinator', 20),

-- Employee Onboarding assignments
(9, 106, 'HR Manager', 25),
(14, 106, 'HR Specialist', 30),

-- Market Research assignments
(4, 107, 'Research Lead', 25),
(11, 107, 'Research Analyst', 35),

-- Data Migration assignments
(1, 108, 'Migration Lead', 15),
(10, 108, 'Database Engineer', 40),
(2, 108, 'Developer', 20);