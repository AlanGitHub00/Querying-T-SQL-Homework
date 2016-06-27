-- CHALLENGE 1, SELECT STATEMENT
-- Familiarize yourself with the Customer table by writing a Transact-SQL query that retrieves all columns
for all customers.

SELECT * 
FROM SalesLT.Customer;

-- Create a list of all customer contact names that includes the title, first name, middle name (if any), last
name, and suffix (if any) of all customers.

SELECT Title, FirstName, ISNULL(MiddleName,'') AS MiddleName, Lastname, ISNULL(Suffix,'') AS Suffix
FROM SalesLT.Customer; 

-- Each customer has an assigned salesperson. You must write a query to create a call sheet that lists:
The salesperson
A column named CustomerName that displays how the customer contact should be greeted (for
example, “Mr Smith”)
The customer’s phone number.

SELECT Salesperson, Title + ' ' + LastName AS CustomerName, Phone
FROM SalesLT.Customer;

-- Trying to clean up the SalesPerson column

SELECT 
	CASE Salesperson
		WHEN 'adventure-works\' THEN ''
		ELSE ISNULL(SalesPerson,'')
	END AS SalesPerson,
Title + ' ' + LastName AS CustomerName, Phone
FROM SalesLT.Customer;

-- CHALLENGE 2, CONVERSION functions (CAST, TRY_CAST, CONVERT, TRY_CONVERT, PARSE, STR)
-- You have been asked to provide a list of all customer companies in the format <Customer ID> :
<Company Name> - for example, 78: Preferred Bikes. 

SELECT CAST(CustomerID AS varchar) + ':  ' + CompanyName AS CustomerCompany
FROM SalesLT.Customer;

--  The SalesLT.SalesOrderHeader table contains records of sales orders. You have been asked to retrieve
data for a report that shows:
The sales order number and revision number in the format <Order Number> (<Revision>) – for
example SO71774 (2).
The order date converted to ANSI standard format (yyyy.mm.dd – for example 2015.01.31). 

SELECT CAST(SalesOrderNumber AS varchar(5)) + '  ' + '(' + CAST(RevisionNumber AS varchar(2)) + ')' AS SalesOrderID, 
CONVERT(nvarchar(30),OrderDate, 102) AS ANSIFormatDate
FROM SalesLT.SalesOrderHeader;

SELECT CONVERT(varchar(5), SalesOrderNumber) + '  ' + '(' + CONVERT(varchar(2), RevisionNumber) + ')' AS SalesOrderID, OrderDate 
FROM SalesLT.SalesOrderHeader; 

-- CHALLENGE 3, Using NULL (ISNULL, Expressions, COALESCE, CASE)
-- You have been asked to write a query that returns a list of customer names. The list must consist of a
single field in the format <first name> <last name> (for example Keith Harris) if the middle name is
unknown, or <first name> <middle name> <last name> (for example Jane M. Gates) if a middle name is
stored in the database.

SELECT FirstName + ' ' + ISNULL(MiddleName,'') + ' ' + Lastname + ISNULL(Suffix,'') AS CustomerContactName
FROM SalesLT.Customer; 

--Customers may provide adventure Works with an email address, a phone number, or both. If an email
address is available, then it should be used as the primary contact method; if not, then the phone
number should be used. You must write a query that returns a list of customer IDs in one column, and a
second column named PrimaryContact that contains the email address if known, and otherwise the
phone number.

SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer;

--IMPORTANT: In the sample data provided in AdventureWorksLT, there are no customer records
without an email address. Therefore, to verify that your query works as expected, run the following
UPDATE statement to remove some existing email addresses before creating your query (don’t worry,
you’ll learn about UPDATE statements later in the course).

UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer; --You have been asked to create a query that returns a list of sales order IDs and order dates with a
column named ShippingStatus that contains the text “Shipped” for orders with a known ship date, and
“Awaiting Shipment” for orders with no ship date.

SELECT SalesOrderID, OrderDate, 
CASE WHEN ShipDate IS NULL
	THEN 'Awaiting Shipment' 
	ELSE 'Shipped'
	END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;

--IMPORTANT: In the sample data provided in AdventureWorksLT, there are no sales order header
records without a ship date. Therefore, to verify that your query works as expected, run the following
UPDATE statement to remove some existing ship dates before creating your query (don’t worry, you’ll
learn about UPDATE statements later in the course).

UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;SELECT SalesOrderID, OrderDate, 
CASE WHEN ShipDate IS NULL
	THEN 'Awaiting Shipment' 
	ELSE 'Shipped'
	END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;