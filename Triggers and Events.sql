-- TRIGGERS AND EVENTS --
#About:
-- A trigger is a database object that is automatically executed (or "triggered") when a specified event occurs on a table. Events can be INSERT, UPDATE, or DELETE.

#Key Characterstics:
-- Triggers are tied to a table and activate when the specified event happens.
-- They can execute before or after the event.
-- Triggers are commonly used to enforce business rules, maintain audit logs, and automatically validate or transform data.

#Syntax:
-- CREATE TRIGGER trigger_name
--  {BEFORE | AFTER} {INSERT | UPDATE | DELETE}
-- ON table_name
-- FOR EACH ROW
-- BEGIN
     -- SQL statements
--  END;

#Example:
-- Example: Logging Changes
-- If you want to log any updates made to an employee_salary table. 

#Example Syntax:
-- CREATE TRIGGER log_salary_update
-- AFTER UPDATE ON employee_salary
-- FOR EACH ROW
-- BEGIN
--   INSERT INTO salary_changes_log (employee_id, old_salary, new_salary, change_date)
--   VALUES (OLD.id, OLD.salary, NEW.salary, NOW()); #Here you can also use NEW instead of OLD. 
-- END;

-- Explanation :
-- *OLD: Refers to the row's values before the update.
-- *NEW: Refers to the row's values after the update.
-- *Trigger ensures that changes are logged automatically.

#Uses of TRIGGERS:
-- Audit Logging: Track changes made to critical tables (e.g., changes in employee salaries).
-- Data Validation: Prevent invalid data from being inserted or updated.
-- Cascade Operations: Automatically update or delete related data in other tables.
-- Business Rule Enforcement: Ensure certain conditions or policies are met during data modification.

#When to Use
-- Triggers: Use when you need to respond immediately to changes in the database (e.g., log changes or validate data).


select *
from employee_demographics;

select *
from employee_salary;

-- TRIGGERS --

delimiter $$
create trigger employee_insert #Creating Trigger called employee_insert
	after insert on employee_salary #After a row is inserted in the employee_salary (Triggering Point or Trigger Event)
    for each row #For each rows to be affected
begin #Start the set of queries execution(Between Beging and End) or event codes after the trigger event occur(Rows inserted in employee_salary table).  
	insert into employee_demographics (employee_id , first_name , last_name)#Inserting into the employee_demographics only the given columns name.
    values(new.employee_id, new.first_name, new.last_name) ; #Values or rows to be inserted in the employee_demographics from the employee_salary table
														   -- should be new rows in (employee_id,first_name,last_name) column not the whole Rows of the employee_salary after Inserting Event(Trigger Event). 
-- Only the new rows which has been inserted in employee_salary table after triggering and affecting Whole Rows should be then added(inserted)in the employee_demographics table.
end $$
delimiter ;

#NOTE: 
-- *Triggers dont have there special section in the schemas. employee_demographics
-- *You can check it by going to the table you created triggers(Triggering Point) from and also you can't alter,change,update or drop it. You can only Refresh it. 

-- TESTING PART (TRIGGERING EVENT) --
insert into employee_salary (employee_id,first_name,last_name,occupation,salary,dept_id)
values(13,'Rishi','Raj','Quant in finance',20000000,null);

select *
from employee_salary;

select *
from employee_demographics;

#And thats how Triggers is created and Event Code or Query initiated in the Trigger Code is executed after Triggering Event occurs. 
#So, HERE:
-- 1. Trigger Name = employee_insert

-- 2. Trigger Code (code to be executed after trigger occur) : 
				--   begin
				--   insert into employee_demographics (employee_id , first_name , last_name)
                -- 	 values(new.employee_id, new.first_name, new.last_name) ;
				
-- 3. Triggering Point or Triggering Event= after insert on employee_salary
										--  for each row (affecting each row)
                     #That is:
                     -- insert into employee_salary (employee_id,first_name,last_name,occupation,salary,dept_id)
				 	 -- values(13,'Rishi','Raj','Quant in finance',20000000,null);



-- EVENTS --
#About:
-- In MySQL, an event is a task or action that runs automatically at a scheduled time or interval. It is kind of a Scheduled Automator.
-- It is a part of the MySQL Event Scheduler, which helps automate repetitive tasks, such as:
-- *Performing backups
-- *Archiving old data
-- *Cleaning up logs
-- *Generating reports

#Key Features:
-- *Events are similar to cron jobs in Unix/Linux.
-- *They are stored in the mysql database.
-- *Events can be single-time (executed once) or recurring (executed periodically).
-- *The Event Scheduler must be enabled for events to run.

#Syntax:
--   CREATE EVENT event_name
--   ON SCHEDULE schedule
--   DO
--   event_body;

-- where,
-- *event_name: Name of the event.
-- *schedule: Specifies when and how often the event runs.
-- *event_body: The SQL statements to execute.

#Uses of EVENTS:
-- 1.Data Maintenance:
-- *Deleting outdated data.
-- *Cleaning up temporary or unused records.

-- 2.Automated Backups:
-- *Taking regular backups of important tables or databases.

-- 3.Data Transformation:
-- *Aggregating or preprocessing data periodically for reports.

-- 4.Scheduling Tasks:
-- *Automating business logic tasks, such as updating prices or discounts.

-- 5.Performance Optimization:
-- *Purging old logs or data to optimize database performance.

#NOTE:
-- *Event Scheduler Status: Events only run when the Event Scheduler is enabled (SET GLOBAL event_scheduler = ON).
-- *Privileges: Ensure you have sufficient privileges to create events (EVENT privilege).
-- *Impact: Carefully design events to avoid performance issues due to heavy or frequent tasks.


select *
from employee_demographics;

delimiter $$
create event delete_retirees 
on schedule every 30 second
do
begin
	delete 
    from employee_demographics
    where age>=60;
end $$
delimiter ;

select *
from employee_demographics;

#Explanation of above Query
-- 1. Delimiter $$
--   *Purpose: In MySQL, the default delimiter is ;. 
--   *To define a block of SQL code (like a stored procedure, function, or event), we change the delimiter temporarily (e.g., to $$).
--   *After defining the block, the delimiter is reset to its original value (;).

-- 2. Event Part 
--   *create event delete_retirees: Defines a scheduled event named delete_retirees.
--   *on schedule every 30 second: Sets the event to run automatically every 30 seconds.
--   *do: Specifies the action to perform.
--   *begin ... end: Encapsulates the block of SQL commands. In this case, it contains a single DELETE statement.
--   *delete from employee_demographics where age >= 60: Deletes all rows in the employee_demographics table where the age is 60 or older.

-- 3. Resetting the Delimiter:
--   *Resets the delimiter back to ;, so normal SQL commands can be executed.

#Checking the settings. 
 show variables like 'event%' #(This should be ON).
 

