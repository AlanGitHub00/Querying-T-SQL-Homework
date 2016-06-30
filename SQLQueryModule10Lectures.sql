--Module 10:  Programming in Transact-SQL

--Using comments, batches, and variables

/* Block text comments looks like this.  Wish I knew this before now.
*/

--Search by city using a variable
DECLARE @City VARCHAR(20) = 'Toronto'
--Set @City = 'Bellevue'

--GO  --If you insert a GO here, it creates 2 batches and the query below will fail

--Write a query to search for the city using a variable.  
SELECT FirstName + ' ' + LastName AS [Name], AddressLine1 AS Address, City
FROM SalesLT.Customer AS C
JOIN SalesLT.CustomerAddress AS CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address AS A
ON CA.AddressID = A.AddressID
WHERE City = @City;

--Run the whole thing to return Name, Address, City=Toronto
DECLARE @City VARCHAR(20) = 'Bellevue'  --Change the 'City' to another city
--Set @City = 'Bellevue'
SELECT FirstName + ' ' + LastName AS [Name], AddressLine1 AS Address, City
FROM SalesLT.Customer AS C
JOIN SalesLT.CustomerAddress AS CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address AS A
ON CA.AddressID = A.AddressID
WHERE City = @City;

--Use a variable as output
DECLARE @Result money   --MONEY is a data type.  Your output must fit.
SELECT @Result = MAX(TotalDue)
FROM SalesLT.SalesOrderHeader;  --When you execute, you will see 'Command completed successfully.'

PRINT @Result  --You must run the DECLARE, SELECT..FROM, and PRINT as one batch to see output.

--Conditonal branching:  IF...ELSE, wrapping blocks of logic in BEGIN...END

--Simple logical test
IF 'Yes' = 'Yes'  --For IF 'Yes' = 'No' SQL Server returns a message that command has been executed but will not print any output
PRINT 'True'

--Change code based on a condition.  Run the following code as one batch.
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 680;  --Change 680 to 1 to see different output.  (There is no ProductID of 1!)

IF @@ROWCOUNT < 1  --In other words, there were no updates
BEGIN
	PRINT 'Product was not found'
END
ELSE
BEGIN
	PRINT 'Product updated'
END

--Looping to run through code multiple times:  WHILE

/* Write a query to return the last names of customers with 
CustomerID 1 through 5 in the SalesLT.Customer table */

SELECT CustomerID, LastName
FROM SalesLT.Customer;  --To see the table contents

DECLARE @custid AS INT = 1, @lname AS NVARCHAR(20);
WHILE @custid <= 5
	BEGIN
		SELECT @lname = lastname FROM SalesLT.Customer
		WHERE CustomerID = @custid;
		PRINT @lname;
		SET @custid += 1;
	END

--Inserting values into a table one row at a time using a loop (not a great use of a loop)
CREATE TABLE SalesLT.DemoTable (Description VARCHAR(5));

DECLARE @Counter INT = 1
WHILE @Counter <= 5
BEGIN
	INSERT SalesLT.DemoTable(Description)
	VALUES ('ROW ' + CONVERT(VARCHAR(5), @Counter))
	SET @Counter = @Counter + 1
END

SELECT Description FROM SalesLT.DemoTable; --Returns a Description column populated with ROW 1, ROW 2,...ROW 5.

/* If you run the above code over again, it adds 5 more rows 
of the same 5 values! */

--Quiz

DECLARE @i INT = 1
WHILE @i < 10
BEGIN
PRINT @i;
END  --This runs infinitely!

--Creating a stored procedure and executing it
CREATE PROCEDURE SalesLT.GetProductsByCategory (@CategoryID INT = NULL)
AS
IF @CategoryID IS NULL
	SELECT ProductID, Name, Color, Size, ListPrice
	FROM SalesLT.Product  --If ProductCategoryID is unknown, return an empty table
ELSE
	SELECT ProductID, Name, Color, Size, ListPrice
	FROM SalesLT.Product
	WHERE ProductCategoryID = @CategoryID;

--Execute the procedure with a parameter
EXECUTE SalesLT.GetProductsByCategory 6;  --Change category from 6 to whatever!

--Execute without a parameter
EXECUTE SalesLT.GetProductsByCategory; --Returns all products