-- Insert data into Clients Table
INSERT INTO Clients (client_id, client_name, contact_name, contact_email) VALUES
(1, 'Big Retail Inc.', 'Peter Parker', 'peter.parker@bigretail.com'),
(2, 'EduTech Solutions', 'Walter White', 'walter.white@edutech.com'),
(3, 'Trendsetters Inc.', 'Sandra Bullock', 'sandra.bullock@trendsetters.com'),
(4, 'Gearhead Supply Co.', 'Daniel Craig', 'daniel.craig@gearheadsupply.com'),
(5, 'Fine Dine Group', 'Olivia Rodriguez', 'olivia.rodriguez@finedine.com'),
(6, 'Green Thumb Gardens', 'Mark Robinson', 'mark.robinson@greenthumb.com'),
(7, 'Busy Bees Daycare', 'Emily Blunt', 'emily.blunt@busybees.com'),
(8, 'Acme Pharmaceuticals', 'David Kim', 'david.kim@acmepharma.com'),
(9, 'Knowledge Stream Inc.', 'Matthew McConaughey', 'matthew.mcconaughey@knowledge.com'),
(10, 'Software Craft LLC', 'Jennifer Lopez', 'jennifer.lopez@softwarecraft.com');

-- Insert data into Projects Table
INSERT INTO Projects (project_id, project_name, requirements, deadline, client_id) VALUES
(1, 'E-commerce Platform', 'Extensive documentation', '2024-12-01', 1),
(2, 'Mobile App for Learning', 'Gamified learning modules', '2024-08-15', 2),
(3, 'Social Media Management Tool', 'User-friendly interface with analytics', '2024-10-31', 3),
(4, 'Inventory Management System', 'Barcode integration and real-time stock tracking', '2024-11-01', 4),
(5, 'Restaurant Reservation System', 'Online booking with table management', '2024-09-01', 5),
(6, 'Content Management System (CMS)', 'Drag-and-drop interface for easy content updates', '2024-12-15', 6),
(7, 'Customer Relationship Management (CRM)', 'Secure parent portal and communication tools', '2024-10-01', 7),
(8, 'Data Analytics Dashboard', 'Real-time visualization of key performance indicators (KPIs)', '2024-11-30', 8),
(9, 'E-learning Platform Development', 'Interactive course creation and delivery tools', '2024-09-15', 9),
(10, 'Bug Tracking and Issue Management System', 'Prioritization and collaboration features for bug reporting', '2024-12-31', 10);

-- Insert data into Employees Table
INSERT INTO Employees (employee_id, employee_name) VALUES
(101, 'Alice Brown'),
(102, 'David Lee'),
(103, 'Jane Doe'),
(104, 'Michael Young'),
(105, 'Emily Chen'),
(106, 'William Green'),
(107, 'Sarah Jones');

-- Insert data into Team Members Table
INSERT INTO Team_Members (project_id, employee_id) VALUES
(1, 101), -- E-commerce Platform: Alice Brown
(1, 102), -- E-commerce Platform: David Lee
(1, 103), -- E-commerce Platform: Jane Doe
(2, 102), -- Mobile App for Learning: David Lee
(2, 104), -- Mobile App for Learning: Michael Young
(2, 105), -- Mobile App for Learning: Emily Chen
(3, 101), -- Social Media Management Tool: Alice Brown
(3, 103), -- Social Media Management Tool: Jane Doe
(3, 106), -- Social Media Management Tool: William Green
(4, 102), -- Inventory Management System: David Lee
(4, 104), -- Inventory Management System: Michael Young
(4, 105), -- Inventory Management System: Emily Chen
(5, 101), -- Restaurant Reservation System: Alice Brown
(5, 106), -- Restaurant Reservation System: William Green
(5, 107), -- Restaurant Reservation System: Sarah Jones
(6, 102), -- Content Management System (CMS): David Lee
(6, 103), -- Content Management System (CMS): Jane Doe
(6, 104), -- Content Management System (CMS): Michael Young
(7, 101), -- Customer Relationship Management (CRM): Alice Brown
(7, 106), -- Customer Relationship Management (CRM): William Green
(7, 107), -- Customer Relationship Management (CRM): Sarah Jones
(8, 102), -- Data Analytics Dashboard: David Lee
(8, 104), -- Data Analytics Dashboard: Michael Young
(8, 105), -- Data Analytics Dashboard: Emily Chen
(9, 101), -- E-learning Platform Development: Alice Brown
(9, 103), -- E-learning Platform Development: Jane Doe
(9, 106), -- E-learning Platform Development: William Green
(10, 102), -- Bug Tracking and Issue Management System: David Lee
(10, 104), -- Bug Tracking and Issue Management System: Michael Young
(10, 107); -- Bug Tracking and Issue Management System: Sarah Jones

-- Insert data into Project Team Table
INSERT INTO Project_Team (project_id, employee_id, team_lead) VALUES
(1, 101, 'Y'), -- Alice Brown is the team leader for project 1
(1, 102, 'N'), -- David Lee is not the team leader for project 1
(1, 103, 'N'), -- Jane Doe is not the team leader for project 1
(2, 102, 'Y'), -- David Lee is the team leader for project 2
(2, 104, 'N'), -- Michael Young is not the team leader for project 2
(2, 105, 'N'), -- Emily Chen is not the team leader for project 2
(3, 101, 'Y'), -- Alice Brown is the team leader for project 3
(3, 103, 'N'), -- Jane Doe is not the team leader for project 3
(3, 106, 'N'), -- William Green is not the team leader for project 3
(4, 102, 'Y'), -- David Lee is the team leader for project 4
(4, 104, 'N'), -- Michael Young is not the team leader for project 4
(4, 105, 'N'), -- Emily Chen is not the team leader for project 4
(5, 101, 'Y'), -- Alice Brown is the team leader for project 5
(5, 106, 'N'), -- William Green is not the team leader for project 5
(5, 107, 'N'), -- Sarah Jones is not the team leader for project 5
(6, 102, 'Y'), -- David Lee is the team leader for project 6
(6, 103, 'N'), -- Jane Doe is not the team leader for project 6
(6, 104, 'N'), -- Michael Young is not the team leader for project 6
(7, 101, 'Y'), -- Alice Brown is the team leader for project 7
(7, 106, 'N'), -- William Green is not the team leader for project 7
(7, 107, 'N'), -- Sarah Jones is not the team leader for project 7
(8, 102, 'Y'), -- David Lee is the team leader for project 8
(8, 104, 'N'), -- Michael Young is not the team leader for project 8
(8, 105, 'N'), -- Emily Chen is not the team leader for project 8
(9, 101, 'Y'), -- Alice Brown is the team leader for project 9
(9, 103, 'N'), -- Jane Doe is not the team leader for project 9
(9, 106, 'N'), -- William Green is not the team leader for project 9
(10, 102, 'Y'), -- David Lee is the team leader for project 10
(10, 104, 'N'), -- Michael Young is not the team leader for project 10
(10, 107, 'N'); -- Sarah Jones is not the team leader for project 10
