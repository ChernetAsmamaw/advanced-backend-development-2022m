-- cretae database software_company;
CREATE DATABASE software_company;

-- Use te db
USE software_company;

/*
Normalized Tables:
Projects Table:
| Project ID | Project Name | Requirements| Deadline | Client ID (FK) |
Clients Table:
| Client ID | Client Name | Contact Name | Contact Email |
Employees Table:
| Employee ID | Employee Name |
Team Members Table:
| Project ID (FK) | Employee ID (FK) |
Project Team Table:
| Project ID (FK) | Employee ID (FK) | Team Lead (Yes/No) |   
*/

-- Create Projects Table
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255),
    requirements TEXT,
    deadline DATE,
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

-- Create Clients Table
CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(255),
    contact_name VARCHAR(255),
    contact_email VARCHAR(255)
);


-- Create Employees Table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(255)
);

-- Create Team Members Table
CREATE TABLE Team_Members (
    project_id INT,
    employee_id INT,
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Create Project Team Table
CREATE TABLE Project_Team (
    project_id INT,
    employee_id INT,
    team_lead CHAR(1),
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
