--Module 7 Lectures

--Demo - Using views

--First, create a view
CREATE VIEW SalesLT.vCustomerAddress
AS
SELECT c.CustomerID, c.FirstName, c.LastName, a.AddressLine1, a.City, a.StateProvince
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID =ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID;  --When you execute, SQL returns 
--'Command completed successfully.'  Check for the object created
--in the Views folder in Object Explorer

--Next, query the view
SELECT *
FROM SalesLT.vCustomerAddress;

SELECT CustomerID, City
FROM SalesLT.vCustomerAddress;

--Try joining the view to a table
SELECT vca.CustomerID, vca.City, soh.TotalDue
FROM SalesLT.vCustomerAddress AS vca
JOIN SalesLT.SalesOrderHeader AS soh
ON vca.CustomerID = soh.CustomerID
ORDER BY TotalDue DESC;

--Join to a table to get revenue by StateProvince and City
SELECT vca.StateProvince, vca.City, ISNULL(SUM(soh.TotalDue), 0.00) AS Revenue
FROM SalesLT.vCustomerAddress as vca
LEFT JOIN SalesLT.SalesOrderHeader as soh  --Use LEFT JOIN to include all the NULLs
ON vca.CustomerID = soh.CustomerID
GROUP BY vca.StateProvince, vca.City
ORDER BY StateProvince, Revenue DESC;

--Demo, Temporary Table

--First, create a temporary table
CREATE TABLE #Colors
(Color varchar(15));  --Execute this to create the temporary table

SELECT * FROM #Colors;  --See that you have a table with one column, Color, with no rows of data

--Next, insert some data into the table.
INSERT INTO #Colors
SELECT DISTINCT Color
FROM SalesLT.Product; --Execute this.  A message returned '10 rows affected'

SELECT * FROM #Colors;  --Produces a populated table with one column 'Color' 

--Demo, Table Variable

--First, specify a variable of type table
DECLARE @Colors AS TABLE
(Color varchar(15)); --Execute this to return 'Command completed successfully'

SELECT * FROM @Colors;  --Produces error message 'Must declare the table 
--variable "@Colors" ' because it is scoped to the batch of commands.  
--With table variables, you must do everything in one batch of commands.

DECLARE @Colors AS TABLE
(Color varchar(15))
SELECT * FROM @Colors;  --Produces a table of one column 'Color' with no rows of data.

--Another example
DECLARE @Colors AS TABLE
(Color varchar(15))
INSERT INTO @Colors
SELECT DISTINCT Color
FROM SalesLT.Product;
SELECT * FROM @Colors;  --Produces a populated table with one column 'Color'

--Try to start a new batch to see what happens

SELECT * FROM @Colors;  --Error, Must declare the table variable "@Colors" 
--Out of scope, doesn't work

SELECT * FROM #Colors
--This works because I have not terminated the session yet.
--If the session in which the temporary table was created was ended
--and you execute this code, you get an error message "Invalid object name '#Colors'"

--Demo, Table-Valued Functions

CREATE FUNCTION SalesLT.udfCustomersByCity
(@City AS varchar(20))
RETURNS TABLE
AS
RETURN
(SELECT C.CustomerID, FirstName, LastName, AddressLine1, City, StateProvince
FROM SalesLT.Customer AS C
JOIN SalesLT.CustomerAddress AS CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address AS A
ON CA.AddressID = A.AddressID
WHERE City = @City);  --Execute this.  'Command completed successfully.'
--This is stored in AdventureWorksLT > Programmability > Functions > Table-valued Functions

SELECT * 
FROM SalesLT.udfCustomersByCity;  --Returns an error message that parameters
--were not supplied for the function 'SalesLT.udfCustomersByCity.'

SELECT * 
FROM SalesLT.udfCustomersByCity('Bellevue');  --This returns desired table
--because you have supplied the parameter 'Bellevue.'

--Demo, Derived Table
--First note that both tables have columns with the same name, but different data
SELECT Name FROM SalesLT.ProductCategory; --Note that 'Name' column has category names (41 rows)
SELECT Name FROM SalesLT.Product; -- Note that 'Name' column has product names (295 rows)

SELECT Category, COUNT(ProductID) AS Products
FROM 
	(SELECT p.ProductID, p.Name AS Product, c.Name AS Category
	FROM SalesLT.Product AS p
	JOIN SalesLT.ProductCategory AS c
	ON p.ProductCategoryID = c.ProductCategoryID) AS ProdCats
GROUP BY Category
ORDER BY Category;

--Test the derived query and table:
(SELECT p.ProductID, p.Name AS Product, c.Name AS Category
	FROM SalesLT.Product AS p
	JOIN SalesLT.ProductCategory AS c
	ON p.ProductCategoryID = c.ProductCategoryID)

--Demo, Using Common Table Expression (CTE)
WITH ProductsByCategory (ProductID, ProductName, Category)  --Creates temporary thing called ProductsByCategory with 3 columns)
AS
(
	SELECT p.ProductID, p.Name, c.Name AS Category
	FROM SalesLT.Product AS p
	JOIN SalesLT.ProductCategory AS c
	ON p.ProductCategoryID = c.ProductCategoryID
)
SELECT Category, COUNT(ProductID) AS Products
FROM ProductsByCategory
GROUP BY Category
ORDER BY Category;

--Recursion with CTEs
--First, remind yourself of the contents of SalesLT.Employee we created using SELF JOIN
SELECT * FROM SalesLT.Employee;

--Now, manipulate the same table using recursion and a CTE
WITH OrgReport (ManagerID, EmployeeID, EmployeeName, Level)
AS
(
	--Anchor query
	SELECT e.ManagerID, e.EmployeeID, EmployeeName, 0
	FROM SalesLT.Employee AS e
	WHERE ManagerID IS NULL
	
	UNION ALL
	
	--Recursive query
	SELECT e.ManagerID, e.EmployeeID, e.EmployeeName, Level + 1
	FROM SalesLT.Employee AS e
	INNER JOIN OrgReport AS o
	ON e.ManagerID = o.EmployeeID
)

SELECT * FROM OrgReport
OPTION (MAXRECURSION 3);

