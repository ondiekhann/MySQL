-- CREATING A COMPANY DATABASE AND QUERY IT

-- Create Tables
CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);
CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);
ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- Inserting Information for the Corporate branch
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Inserting information for the Scranton Branch
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Inserting information for the Stamford Branch
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

-- check out what we have now
select * from employee;
select * from works_with;

-- find all employees
select *
from employee;

-- find all clients
select * 
from client;

-- Find all employees ordered by salary
select *
from employee
order by salary desc;

-- Find all employees ordered by sex then name
select *
from employee
order by sex, first_name, last_name;

-- Find the first 5 employees in the table
select *
from employee
limit 5;

-- Find the first and last names of all employees
select first_name, last_name
from employee;

-- Find the forename and the surnames of all the employes
select first_name as forename, last_name as surname
from employee;

-- Find out all the different genders
select distinct sex
from employee;

-- FUNCTIONS

-- Find the number of employees
select count(emp_id)
from employee;

-- How many employees have supervisors?
select count(super_id)
from employee;

-- Find the number of female employees born after 1970
select count(emp_id)
from employee
where sex = 'F' and birth_day > '1970';

-- Find the average of all the employees' salaries
select avg(salary)
from employee;

-- Find the average salary of all male employees
select avg(salary)
from employee
where sex = 'M';

-- Find the sum of all employees salaries
select sum(salary)
from employee;

-- Find out how many males and females there are
select count(sex), sex
from employee
group by sex;

-- Find the total sales of each salesman
select sum(total_sales), emp_id
from works_with
group by emp_id;

-- How much money did each client spend with the branch?
select sum(total_sales), client_id
from works_with
group by client_id;

-- WILDCARDS
-- % = any # of characters, _ = one character

-- Find any clients who are in LLC
select *
from client
where client_name like '%LLC';

-- Find any branch suppliers who are in the label business
select *
from branch_supplier
where supplier_name like '%Label%';

-- Find any employee born in October
select *
from employee
where birth_day like '____-10%';

-- Find any clients who are schools
select *
from client
where client_name like '%school%';

-- UNION
--  Find a list of employees and branch names
select first_name as Company_Names
from employee
union
select branch_name
from branch
union 
select client_name
from client;

-- Find a list of all clients and supliers' names
select client_name, client.branch_id
from client
union
select supplier_name,branch_supplier.branch_id
from branch_supplier;

-- Find a list of all money spent or earned by the company
select salary
from employee
union
select total_sales
from works_with;

-- JOINS
-- Used to combine rows from two or more tables based on a related column between them

-- Add the extra branch
INSERT INTO branch VALUES(4, "Buffalo", NULL, NULL);

-- Find all branchess and the names of their mangers
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch    -- Inner join combines two tables whenever they have have a shared column value
ON employee.emp_id = branch.mgr_id;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch  -- Returns all the rows from the left table (table 'from') but only the rows in the right table that match are included
ON employee.emp_id = branch.mgr_id;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch  -- Returns all the rows from the right table no matter what but only the rows in the left table that match are included
ON employee.emp_id = branch.mgr_id;
-- A FULL OUTER JOIN returns all the the rows in both the right and left tables no matter what. 

-- NESTED QUERIES

-- Find names of all employees who have sold over 30,000 to a single client
select employee.first_name, employee.last_name
from employee
where employee.emp_id in (
	select works_with.emp_id
	from works_with
	where works_with.total_sales > 30000);

-- Find all clients who are handled by the branch that Michael Scott manages 
-- Assume you know Michael's ID

select client.client_name
from client
where client.branch_id = (
	select branch.branch_id
	from branch
	where branch.mgr_id = 102);

select client.client_name
from client
where client.branch_id = (
	select branch.branch_id
	from branch
	where branch.mgr_id = 102
    LIMIT 1);

 -- Find all clients who are handles by the branch that Michael Scott manages
 -- Assume you DONT'T know Michael's ID
 SELECT client.client_id, client.client_name
 FROM client
 WHERE client.branch_id = (SELECT branch.branch_id
                           FROM branch
                           WHERE branch.mgr_id = (SELECT employee.emp_id
                                                  FROM employee
                                                  WHERE employee.first_name = 'Michael' AND employee.last_name ='Scott'
                                                  LIMIT 1));

-- Find the names of employees who work with clients handled by the scranton branch
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
                         SELECT works_with.emp_id
                         FROM works_with
                         )
AND employee.branch_id = 2;

-- Find the names of all clients who have spent more than 100,000 dollars
SELECT client.client_name
FROM client
WHERE client.client_id IN (
                          SELECT client_id
                          FROM (
                                SELECT SUM(works_with.total_sales) AS totals, client_id
                                FROM works_with
                                GROUP BY client_id) AS total_client_sales
                          WHERE totals > 100000
);

-- ON DELETE
-- ON DELETE SET NULL
-- This sets the row value of the foreign key to null when the corresponding value in the primary key is deleted

delete from employee
where emp_id = 102;

select * from branch;

--- ON DELETE CASCADE
--- If a foreign key in the database is deleted, the entire rows associated with the value are deleted

delete from branch
where branch_id = 2;

select * from branch_supplier;
--- if you have a composite key, its advisable to use ON DELETE CASCADE because a primary key cannot be NULL

--- TRIGGERS
--- A trigger is a block of sql code which defines a certain action operation gets performed on a database. 

CREATE TABLE trigger_test (
     message VARCHAR(100)
);

DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee');
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

select * from trigger_test;


DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(NEW.first_name);
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

select * from trigger_test;

DELIMITER $$
CREATE
    TRIGGER my_trigger2 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
         IF NEW.sex = 'M' THEN
               INSERT INTO trigger_test VALUES('added male employee');
         ELSEIF NEW.sex = 'F' THEN
               INSERT INTO trigger_test VALUES('added female');
         ELSE
               INSERT INTO trigger_test VALUES('added other employee');
         END IF;
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

select * from trigger_test;

DROP TRIGGER my_trigger;

--- ER DIAGRAMS
--- ER = Entity Relationship
--- DB Schema = all the different tables and the different attributes that are to be in those tables
--- ER diagram is used to map out the different relationships, different entities and attributes. It's a diagram 
--- defining relationship model. 

--- COMPONENNTS OF ER DIAGRAM
--- Entity = An object we want to model and store information about
--- Attributes = specific pieces of information about an entity
--- Primary key = an attribute(s) that uniquely identifies an entity in the database table
--- Composite attribute = an attribute that can be broken up into sub-attributes
--- Multi-valued attribute = an attribute that can have more than one value
--- Derived attribute = an attribute that can be derived from the other attributes.
--- Multiple entities = you can define more than one entity in the diagram.
--- Relationships - defines a relationship between two entities
--- Total participation = all members must participate in the relationship
 -- Relationship attribute = attribute about a relationship
 -- Relationship Cardinality = the number of instances of an entity from a relation that can be associated with the relation
 -- Weak attribute = an attribute that cannot be uniquely identified by by its attributes alone
 -- Identifying relationship  = a relationship that serves to uniquely identigy the wea entity
 
-- DESIGNING AN ER DIAGRAM
-- Company Data Storage Requirements

-- The company is organized into branches. Each branch has a unique number, a name, and a particular employee who manages it.
-- The company makes it’s money by selling to clients. Each client has a name and a unique number to identify it.
-- The foundation of the company is it’s employees. Each employee has a name, birthday, sex, salary and a unique number.
-- An employee can work for one branch at a time, and each branch will be managed by one of the employees that work there. We’ll also want to keep track of when the current manager started as manager.
-- An employee can act as a supervisor for other employees at the branch, an employee may also act as the supervisor for employees at other branches. An employee can have at most one supervisor.
-- A branch may handle a number of clients, with each client having a name and a unique number to identify it. A single client may only be handled by one branch at a time.
-- Employees can work with clients controlled by their branch to sell them stuff. If nescessary multiple employees can work with the same client. We’ll want to keep track of how many dollars worth of stuff each employee sells to each client they work with.
-- Many branches will need to work with suppliers to buy inventory. For each supplier we’ll keep track of their name and the type of product they’re selling the branch. A single supplier may supply products to multiple branches.

-- ER DIAGRAM MAPPING

-- Step1: Mappig of Reglar Enity Types
-- For each regular entity type. Create a relation (table) that inclds all the simple attributes of that table

-- Step 2: Mapping of weak entity type.
--  Create a relation (table) that inclds all the simple attributes of the weak entity.
-- The primary key of the new relation should be the patial key of the weak entity plus the primary keyof its owner. 

-- Step 3: Mapping of Binary 1:1 Relationship Types
-- Include one side of the relationship as a foreign key in the other. Favor total participation

-- Step 4: Mapping of Binary 1:N Relationship Types
-- Include the 1 side's primary key as a foreign key on the N side relation (table)

-- Step 5: Mapping of Binary M:N Relationship Types
-- Create a new reltion (table) whose primary key is a combination of of both entities' primary keys. 
-- Also include any relationship attributes




