--Module 5, Functions and Aggregating Data

--Scalar Functions
SELECT * FROM SalesLT.Product;

SELECT YEAR(SellStartDate) SellStartYear, ProductID, Name
FROM SalesLT.Product
ORDER BY SellStartYear;

SELECT YEAR(SellStartDate) SellStartYear, DATENAME(mm,SellStartDate) SellStartMonth,
DAY(SellStartDate) SellStartDay, DATENAME(dw,SellStartDate) SellStartWeekday,
ProductID, Name
FROM SalesLT.Product
ORDER BY SellStartYear;

--Using DATEDIFF to compare dates, in this case the SellStartDate and today's date
SELECT DATEDIFF(yy,SellStartDate, GETDATE()) YearsSold, ProductID, Name
FROM SalesLT.Product
ORDER BY ProductID;

--Using UPPER to convert text to upper case
SELECT UPPER(Name) AS ProductName
FROM SalesLT.Product;

--Using CONCAT to concatenate
SELECT CONCAT(FirstName + ' ', LastName) AS FullName
From SalesLT.Customer;

--Using LEFT (or RIGHT) to return the left digits (or right digits)
SELECT Name, ProductNumber, LEFT(ProductNumber, 2) AS ProductType
From SalesLT.Product;

--Using SUBSTRING to return a portion of a string in a column, CHARINDEX to find dashes, RIGHT (or LEFT)
SELECT Name, ProductNumber, LEFT(ProductNumber, 2) AS ProductType,
			SUBSTRING(ProductNumber, CHARINDEX('-', ProductNumber) + 1, 4) AS ModelCode,
			SUBSTRING(ProductNumber, LEN(ProductNumber) - CHARINDEX('-', REVERSE(RIGHT(ProductNumber, 3))) + 2, 2) AS SizeCode
From SalesLT.Product;

--Logical functions (ISNUMERIC, IIS, CHOOSE)

--ISNUMERIC to filter through numeric sizes, alphanumeric sizes such as S,M,L stored
--within a text strng data field to return just the numeric sizes.  Here, "1" means true.
SELECT Name, Size AS NumericSize
FROM SalesLT.Product --Highlight and execute the first two lines to see what happens when you don't filter
WHERE ISNUMERIC(Size) = 1;

--IIF to filter product categories to pull out specific product types
SELECT Name, IIF(ProductCategoryID IN (5,6,7), 'Bike', 'Other') ProductType
FROM SalesLT.Product;

--Combining ISNUMERIC and IIF
SELECT Name, IIF(ISNUMERIC(Size) =1, 'Numeric', 'Non-Numeric') AS SizeType
FROM SalesLT.Product;

--CHOOSE and JOIN 
--First take a look at what's in the two tables being joined
Select * FROM SalesLT.Product;
SELECT * FROM SalesLT.ProductCategory;
--Note that the 'Name' columns are being used to store different information
--The following CHOOSE function returns the first 4 product categories in 
--the SalesLT.ProductCategory table and joins it with the SalesLT.Product names.

SELECT prd.Name AS ProductName, cat.Name as Category,
	CHOOSE (cat.ParentProductCategoryID, 'Bikes', 'Components', 'Clothing', 'Accessories') 
	AS ProductType
FROM SalesLT.Product as prd
JOIN SalesLT.ProductCategory AS cat
ON prd.ProductCategoryID = cat.ProductCategoryID;

--Window functions such as TOP, RANK()OVER

SELECT TOP(100) ProductID, Name, ListPrice,
	RANK()OVER(ORDER BY ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS p
ORDER BY RankByPrice;

SELECT c.Name AS Category, p.Name AS Product, ListPrice,
	RANK()OVER(PARTITION BY c.Name ORDER BY ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID
ORDER BY Category, RankByPrice;

--Aggregate Functions AVG, MAX, MIN, STDEV
SELECT COUNT(*) AS Products, COUNT(DISTINCT ProductCategoryID) AS Categories, 
	AVG(ListPrice) AS AveragePrice
FROM SalesLT.Product;

SELECT COUNT(*) AS Products, COUNT(DISTINCT ProductCategoryID) AS Categories, 
	MAX(ListPrice) AS MaxPrice
FROM SalesLT.Product;

SELECT COUNT(*) AS Products, COUNT(DISTINCT ProductCategoryID) AS Categories, 
	MIN(ListPrice) AS MinPrice
FROM SalesLT.Product;

SELECT COUNT(*) AS Products, COUNT(DISTINCT ProductCategoryID) AS Categories, 
	STDEV(ListPrice) AS StdDevPrice
FROM SalesLT.Product;

--Filtering aggregate functions
SELECT COUNT(p.ProductID) AS BikeModels,
	AVG(p.ListPrice) AS AveragePrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID
WHERE c.Name LIKE '%Bikes';

--GROUPING with GROUP BY
SELECT CustomerID, COUNT(*) AS Orders
FROM SalesLT.SalesOrderHeader
GROUP BY CustomerID;

--To see the records before grouping....
SELECT CustomerID, SalesOrderNumber FROM SalesLT.SalesOrderHeader
ORDER BY CustomerID;

--To return a list of salespersons with the grand total of their sales revenue
--(i.e. subtotals by salesperson)
SELECT c.SalesPerson, ISNULL(SUM(oh.SubTotal), 0.00) AS SalesRevenue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.Salesperson
ORDER BY SalesRevenue DESC; 

--Note what happens without GROUP BY clause.  You get an error message that the SalesPerson
--column you created in your virtual table is invalid because it is not contained
--in either an aggregate function or the GROUP BY clause.  SELECT SalesPerson needs
--to be in a function, either GROUP BY or aggregate.
SELECT c.SalesPerson, ISNULL(SUM(oh.SubTotal), 0.00) AS SalesRevenue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
ORDER BY SalesRevenue DESC; 

--To return SalesPerson subtotals of SalesRevenue by Customer
SELECT c.SalesPerson, CONCAT(c.FirstName + ' ', c.LastName) AS Customer,
	ISNULL(SUM(oh.SubTotal), 0.00) AS SalesRevenue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.SalesPerson, CONCAT(c.FirstName + ' ', c.LastName)  --Note that you can't use the alias because of SQL's order of processing
ORDER BY SalesRevenue DESC, Customer;

--Filtering Groups with HAVING and WHERE clauses

SELECT CustomerID, COUNT(*) AS Orders  --COUNT(*) sums the total rows in the table (Study the table!)
FROM SalesLT.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(*) > 0;

SELECT CustomerID, SalesOrderID FROM SalesLT.SalesOrderHeader
ORDER BY CustomerID;

--Using WHERE clause to filter inputs
SELECT ProductID, SUM(sod.OrderQty) AS Quantity
FROM SalesLT.SalesOrderDetail AS sod
JOIN SalesLT.SalesOrderHeader AS soh
On sod.SalesOrderID = soh.SalesOrderID
WHERE YEAR(soh.OrderDate) = 2008
GROUP BY ProductID;

--How to filter for products where > 50 were ordered?  This won't work. 
--An aggregate can't be in a WHERE clause
SELECT ProductID, SUM(sod.OrderQty) AS Quantity
FROM SalesLT.SalesOrderDetail AS sod
JOIN SalesLT.SalesOrderHeader AS soh
On sod.SalesOrderID = soh.SalesOrderID
WHERE YEAR(soh.OrderDate) = 2008 AND SUM(sod.OrderQty) > 50
GROUP BY ProductID;

--Filtering output using HAVING clause
SELECT ProductID, SUM(sod.OrderQty) AS Quantity
FROM SalesLT.SalesOrderDetail AS sod
JOIN SalesLT.SalesOrderHeader AS soh
On sod.SalesOrderID = soh.SalesOrderID
WHERE YEAR(soh.OrderDate) = 2008
GROUP BY ProductID
HAVING SUM(sod.OrderQty) > 50;
