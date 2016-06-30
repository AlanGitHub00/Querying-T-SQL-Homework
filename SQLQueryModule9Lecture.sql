--Module 9 Demos:  Inserting Data, Generating Identifiers, Updating and Deleting Data

--Create a table for the demo
CREATE TABLE SalesLT.CallLog
(
	CallID int IDENTITY PRIMARY KEY NOT NULL,  --This is an identity column with defaults (seed=1, increment=1)
	CallTime DATETIME NOT NULL DEFAULT GETDATE(),  --If you don't specify the date and time, default of current date and time will be returned by SQL.
	SalesPerson nvarchar(256) NOT NULL,
	CustomerID int NOT NULL REFERENCES SalesLT.Customer(CustomerID),
	PhoneNumber nvarchar(25) NOT NULL,
	Notes nvarchar(max) NULL  --NULLs will be allowed only in this column!
);
GO

--Take a peek
SELECT * FROM SalesLT.CallLog;

--Insert a row
INSERT INTO SalesLT.CallLog
VALUES
('2015-01-01T12:30:00', 'adventure-works\pamela0', 1, 
'245-555-0173', 'Returning call re; enquiry about delivery');

--Take a peek
SELECT * FROM SalesLT.CallLog;

--Insert defaults and nulls
INSERT INTO SalesLT.CallLog
VALUES
(DEFAULT, 'adventure-works\david8', 2, '170-555-0127', NULL);

--Take a peek
SELECT * FROM SalesLT.CallLog;

--BEST PRACTICE:  Insert a row with explicit columns designated in the INSERT clause
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\jillian0', 3, '279-555-0130');

--Take a peek
SELECT * FROM SalesLT.CallLog;

--Insert multiple rows
INSERT INTO SalesLT.CallLog
VALUES
(DATEADD(mi, -2, GETDATE()), 'adventure-works\jillian0', 4, '710-555-0173', NULL),
(DEFAULT, 'adventure-works\shu0', 5, '828-555-0186', 'Called to arrange deliver of order 10987');

SELECT * FROM SalesLT.CallLog;

--Insert results from a query
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber, Notes)
SELECT SalesPerson, CustomerID, Phone, 'Sales promo call'
FROM SalesLT.Customer
WHERE CompanyName = 'Big-Time Bike Store';

SELECT * FROM SalesLT.CallLog;

--Retrieving inserted identity
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\jose1', 10, '150-555-0127');

SELECT SCOPE_IDENTITY();

SELECT * FROM SalesLT.CallLog;

--Overriding Identity

--Example:  You deleted a call from the table and want to reinsert the details you deleted.
--But you still want to  have the original number, so you want to override instead
--of generating a new identity.

SET IDENTITY_INSERT SalesLT.CallLog ON;

INSERT INTO SalesLT.CallLog (CallID, SalesPerson, CustomerID, PhoneNumber)
VALUES
(9, 'adventure-works\jose1', 11, '926-555-0159');

SET IDENTITY_INSERT SalesLT.CallLog OFF;

SELECT * FROM SalesLT.CallLog;

--Update a table
UPDATE SalesLT.CallLog
SET Notes = 'No notes'
WHERE NOTES IS NULL;

SELECT * FROM SalesLT.CallLog;

--Update multiple columns
UPDATE SalesLT.CallLog
SET SalesPerson = '', PhoneNumber = ''  --Since there is no WHERE clause, every row in both columns affected

SELECT * FROM SalesLT.CallLog;

--Correct the mistake by updating from results of a query
UPDATE SalesLT.CallLog
SET SalesPerson = c.SalesPerson, PhoneNumber = c.Phone
FROM SalesLT.Customer AS c
WHERE c.CustomerID = SalesLT.CallLog.CustomerID;

SELECT * FROM SalesLT.CallLog;

--Delete rows
DELETE FROM SalesLT.CallLog
WHERE CallTime < DATEADD(dd, -7, GETDATE()); --Will remove calls that happened more than 7 days ago

SELECT * FROM SalesLT.CallLog;

--Truncate the table
TRUNCATE TABLE SalesLT.CallLog;

SELECT * FROM SalesLT.CallLog;