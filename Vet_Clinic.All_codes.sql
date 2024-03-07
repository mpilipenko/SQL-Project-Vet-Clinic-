USE Vet_Clinic

-- VIEWS

/* Creating a view with relevant info on owners and procedures to make reminder calls
about outstanding balances */

CREATE VIEW view_reminder_debt
	AS
SELECT
o.First_name, o.Last_name, o.Phone_number, a.Name AS 'Pet_name',
past.Appointment_Date, price.Procedure_name, past.Outstanding_balance
FROM Past_Appointments AS past
LEFT JOIN Animals AS a
ON past.Pet_ID = a.ID
LEFT JOIN Price_List as price
ON price.Procedure_ID = past.Procedure_ID
LEFT JOIN Owners AS o
ON a.Owner = o.ID
WHERE past.Outstanding_balance > 0.00;

-- Creating a view to make calls to remind customers about upcoming appointments in 2023

CREATE VIEW view_upcome_app
	AS
SELECT
o.First_name, o.Last_name, o.Phone_number, a.Name AS 'Pet_name',
upcome.Appointment_Date, price.Procedure_name
FROM Upcoming_Appointments AS upcome
LEFT JOIN Animals AS a
ON upcome.Pet_ID = a.ID
LEFT JOIN Price_List as price
ON price.Procedure_ID = upcome.Procedure_ID
LEFT JOIN Owners AS o
ON a.Owner = o.ID
WHERE YEAR(upcome.Appointment_date) = '2023'
ORDER BY upcome.Appointment_Date;

SELECT * FROM view_reminder_debt;
SELECT * FROM view_upcome_app;

-- Query with subquery. Find all the dentistry appointments in the Past_Appointments table for cats

SELECT ID, Appointment_Date
FROM Past_Appointments As past
WHERE Procedure_ID IN (
	SELECT Procedure_ID
    FROM Price_List
    WHERE Specialisation LIKE 'Dentistry')
AND
	Pet_ID IN (
    SELECT ID
    FROM Animals
    WHERE Species = 'Cat');
    
-- Creating a stored Function

DELIMITER //
CREATE FUNCTION Give_call(
    Vaccines VARCHAR(30)
) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE Calls VARCHAR(20);
    IF Vaccines LIKE 'V5' THEN
        SET Calls = 'Urgent Call';
	ELSEIF Vaccines LIKE 'V10' THEN
        SET Calls = 'Urgent Call';
    ELSE SET Calls = 'Call in a month';
    END IF;
    RETURN (Calls);
END//Vaccines
DELIMITER ;

SELECT
o.First_name,
o.Last_name,
o.Phone_number,
a.Name,
Give_call(a.Vaccines)
	FROM Owners AS o
LEFT JOIN Animals AS a
	ON o.ID = a.Owner;
    
/* Query with GROUP BY and HAVING
Want to extract info on how much have veterinarians earned on their previous procedures
(choose all the vets who earned more than 100.00 pounds) */

SELECT
past.Vet_ID, vet.First_name, vet.Last_name,
vet.Specialisation, SUM(price.Price) AS 'Money_earned'
FROM Past_Appointments AS past
LEFT JOIN Price_List AS price
ON price.Procedure_ID = past.Procedure_ID 
LEFT JOIN Veterinarians as vet
ON vet.Vet_ID = past.Vet_ID
GROUP BY Vet_ID
HAVING Money_earned > 100.00
ORDER BY Money_earned DESC;

-- Creating a Stored Procedure to insert new values

DELIMITER //
CREATE PROCEDURE InsertNewValue (
IN Vet_ID VARCHAR(5), 
IN First_name VARCHAR(20),
IN Last_name VARCHAR(20),
IN Specialisation VARCHAR(20),
IN Phone_number VARCHAR(20)
)

BEGIN

INSERT INTO Veterinarians
(Vet_ID, First_name, Last_name, Specialisation, Phone_number)
VALUES
(Vet_ID, First_name, Last_name, Specialisation, Phone_number);
END//
DELIMITER ;

CALL InsertNewValue (7, 'Bill', 'Stivenson', 'Surgery', '076590455145');

SELECT * FROM Veterinarians;

DELETE FROM Veterinarians
WHERE Vet_ID = 7;

-- Creating a Stored Procedure to count pets on Annuals Plans with different IDs

DELIMITER //
CREATE PROCEDURE CountPlans(IN Pet_ID VARCHAR(3), OUT num__of_plans INT)
	BEGIN 
      SELECT COUNT(*) INTO num__of_plans FROM Annual_Plans
      WHERE Plan_ID = Pet_ID;
	END//
    
CALL CountPlans('H1', @num__of_plans);

SELECT *
FROM Annual_Plans
WHERE Plan_ID = 'H1';

-- Creating a trigger for the table Veterinarians

SELECT *
FROM Veterinarians;

DELIMITER //
CREATE TRIGGER Vetfullname
BEFORE INSERT on Veterinarians
FOR EACH ROW
BEGIN
	SET NEW.First_name = CONCAT(UPPER(SUBSTRING(NEW.First_name,1,1)),
						LOWER(SUBSTRING(NEW.First_name FROM 2)));
	SET NEW.Last_name = CONCAT(UPPER(SUBSTRING(NEW.Last_name,1,1)),
						LOWER(SUBSTRING(NEW.Last_name FROM 2)));
END//

DELIMITER ;

INSERT INTO Veterinarians
(Vet_ID, First_name, Last_name, Specialisation, Phone_number)
VALUES
(8, 'FRANK', 'BRADY', 'General', '078901443520');

DELETE FROM Veterinarians
WHERE Vet_ID = 8;