-- Find all projects with a deadline before December 1st, 2024:
SELECT project_id, project_name, deadline
FROM Projects
WHERE deadline < '2024-12-01';

-- List all projects for "Big Retail Inc." ordered by deadline:
SELECT p.project_id, p.project_name, p.deadline
FROM Projects p
JOIN Clients c ON p.client_id = c.client_id
WHERE c.client_name = 'Big Retail Inc.'
ORDER BY p.deadline;

-- Find the team lead for the "Mobile App for Learning" project:
SELECT e.employee_name
FROM Project_Team pt
JOIN Projects p ON pt.project_id = p.project_id
JOIN Employees e ON pt.employee_id = e.employee_id
WHERE p.project_name = 'Mobile App for Learning' AND pt.team_lead = 'Y';

-- Find projects containing "Management" in the name:
SELECT project_id, project_name
FROM Projects
WHERE project_name LIKE '%Management%';

-- Count the number of projects assigned to David Lee:
SELECT COUNT(*)
FROM Project_Team pt
JOIN Employees e ON pt.employee_id = e.employee_id
WHERE e.employee_name = 'David Lee';

-- Find the total number of employees working on each project:
SELECT pt.project_id, COUNT(pt.employee_id) AS total_employees
FROM Project_Team pt
GROUP BY pt.project_id;

-- Find all clients with projects having a deadline after October 31st, 2024:
SELECT DISTINCT c.client_id, c.client_name
FROM Clients c
JOIN Projects p ON c.client_id = p.client_id
WHERE p.deadline > '2024-10-31';

-- List employees who are not currently team leads on any project:
SELECT e.employee_id, e.employee_name
FROM Employees e
WHERE e.employee_id NOT IN (
    SELECT pt.employee_id
    FROM Project_Team pt
    WHERE pt.team_lead = 'Y'
);

-- Combine a list of projects with deadlines before December 1st and another list with "Management" in the project name
SELECT p.project_id, p.project_name, p.deadline
FROM Projects p
WHERE p.deadline < '2024-12-01'
UNION
SELECT p.project_id, p.project_name, p.deadline
FROM Projects p
WHERE p.project_name LIKE '%Management%';

-- Display a message indicating if a project is overdue (deadline passed):
SELECT project_id, project_name, deadline,
       CASE 
           WHEN deadline < CURDATE() THEN 'Overdue'
           ELSE 'Not Overdue'
       END AS status
FROM Projects;

-- Create a view to simplify retrieving client contact:
CREATE VIEW Client_Contact_View AS
SELECT client_id, client_name, contact_name, contact_email
FROM Clients;

-- Create a view to show only ongoing projects (not yet completed):
CREATE VIEW Ongoing_Projects_View AS
SELECT project_id, project_name, deadline
FROM Projects
WHERE deadline >= CURDATE();

-- Create a view to display project information along with assigned team leads:
CREATE VIEW Project_Team_Leads_View AS
SELECT p.project_id, p.project_name, p.deadline, e.employee_name AS team_lead
FROM Projects p
JOIN Project_Team pt ON p.project_id = pt.project_id
JOIN Employees e ON pt.employee_id = e.employee_id
WHERE pt.team_lead = 'Y';

-- Create a view to show project names and client contact information for projects with a deadline in November 2024:
CREATE VIEW Projects_November_2024_View AS
SELECT p.project_id, p.project_name, p.deadline, c.client_name, c.contact_name, c.contact_email
FROM Projects p
JOIN Clients c ON p.client_id = c.client_id
WHERE p.deadline BETWEEN '2024-11-01' AND '2024-11-30';

-- Create a view to display the total number of projects assigned to each employee:
CREATE VIEW Employee_Project_Count_View AS
SELECT e.employee_id, e.employee_name, COUNT(pt.project_id) AS total_projects
FROM Employees e
JOIN Project_Team pt ON e.employee_id = pt.employee_id
GROUP BY e.employee_id, e.employee_name;

-- Function to calculate the number of days remaining until a project deadline:
CREATE FUNCTION Days_Until_Deadline (project_id INT)
RETURNS INT
BEGIN
    DECLARE days_remaining INT;
    SELECT DATEDIFF(deadline, CURDATE()) INTO days_remaining
    FROM Projects
    WHERE project_id = project_id;
    RETURN days_remaining;
END;

-- Function to calculate the number of days a project is overdue:
CREATE FUNCTION Days_Overdue (project_id INT)
RETURNS INT
BEGIN
    DECLARE days_overdue INT;
    SELECT DATEDIFF(CURDATE(), deadline) INTO days_overdue
    FROM Projects
    WHERE project_id = project_id AND deadline < CURDATE();
    RETURN days_overdue;
END;

-- Stored procedure to add a new client and their first project in one call:
CREATE PROCEDURE Add_Client_And_Project (
    IN client_name VARCHAR(255),
    IN contact_name VARCHAR(255),
    IN contact_email VARCHAR(255),
    IN project_name VARCHAR(255),
    IN requirements TEXT,
    IN deadline DATE
)
BEGIN
    DECLARE new_client_id INT;
    
    INSERT INTO Clients (client_name, contact_name, contact_email)
    VALUES (client_name, contact_name, contact_email);
    
    SET new_client_id = LAST_INSERT_ID();
    
    INSERT INTO Projects (project_name, requirements, deadline, client_id)
    VALUES (project_name, requirements, deadline, new_client_id);
END;

-- Stored procedure to move completed projects (past deadlines) to an archive table:
CREATE PROCEDURE Archive_Completed_Projects ()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE project_id INT;
    DECLARE project_cursor CURSOR FOR
        SELECT project_id FROM Projects WHERE deadline < CURDATE();
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN project_cursor;
    
    project_loop: LOOP
        FETCH project_cursor INTO project_id;
        IF done THEN
            LEAVE project_loop;
        END IF;
        
        INSERT INTO Archived_Projects
        SELECT * FROM Projects WHERE project_id = project_id;
        
        DELETE FROM Projects WHERE project_id = project_id;
    END LOOP;
    
    CLOSE project_cursor;
END;

-- Trigger to log any updates made to project records in a separate table for auditing purposes:
CREATE TRIGGER Project_Update_Log
AFTER UPDATE ON Projects
FOR EACH ROW
BEGIN
    INSERT INTO Project_Audit_Log (project_id, old_project_name, new_project_name, old_deadline, new_deadline, update_time)
    VALUES (OLD.project_id, OLD.project_name, NEW.project_name, OLD.deadline, NEW.deadline, NOW());
END;

-- Trigger to ensure a team lead assigned to a project is a valid employee:
CREATE TRIGGER Validate_Team_Lead
BEFORE INSERT ON Project_Team
FOR EACH ROW
BEGIN
    DECLARE valid_employee INT;
    SELECT COUNT(*) INTO valid_employee
    FROM Employees
    WHERE employee_id = NEW.employee_id;
    
    IF valid_employee = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Team lead must be a valid employee';
    END IF;
END;

-- View to display project details along with the total number of team members assigned:
CREATE VIEW Project_Details_With_Team_Count AS
SELECT p.project_id, p.project_name, p.deadline, COUNT(pt.employee_id) AS team_member_count
FROM Projects p
LEFT JOIN Project_Team pt ON p.project_id = pt.project_id
GROUP BY p.project_id, p.project_name, p.deadline;

-- View to show overdue projects with the number of days overdue:
CREATE VIEW Overdue_Projects_View AS
SELECT p.project_id, p.project_name, p.deadline, DATEDIFF(CURDATE(), p.deadline) AS days_overdue
FROM Projects p
WHERE p.deadline < CURDATE();

-- Stored procedure to update project team members (remove existing, add new ones):
CREATE PROCEDURE Update_Project_Team_Members (
    IN project_id INT,
    IN new_team_members JSON
)
BEGIN
    DECLARE employee_id INT;
    
    -- Remove existing team members
    DELETE FROM Project_Team WHERE project_id = project_id;
    
    -- Add new team members
    DECLARE team_member_cursor CURSOR FOR
        SELECT JSON_UNQUOTE(JSON_EXTRACT(value, '$.employee_id')) AS employee_id,
               JSON_UNQUOTE(JSON_EXTRACT(value, '$.team_lead')) AS team_lead
        FROM JSON_TABLE(new_team_members, '$[*]') AS jt;
    
    OPEN team_member_cursor;
    
    fetch_loop: LOOP
        FETCH team_member_cursor INTO employee_id, team_lead;
        IF done THEN
            LEAVE fetch_loop;
        END IF;
        
        INSERT INTO Project_Team (project_id, employee_id, team_lead)
        VALUES (project_id, employee_id, team_lead);
    END LOOP;
    
    CLOSE team_member_cursor;
END;

-- Trigger to prevent deleting a project that still has assigned team members:
CREATE TRIGGER Prevent_Project_Deletion
BEFORE DELETE ON Projects
FOR EACH ROW
BEGIN
    DECLARE team_member_count INT;
    SELECT COUNT(*) INTO team_member_count
    FROM Project_Team
    WHERE project_id = OLD.project_id;
    
    IF team_member_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete project with assigned team members';
    END IF;
END;