--Lab 5, Using Functions and Aggregating Data
--Retrieving, aggregating, and grouping data

--CHALLENGE ONE

1. Retrieve the name and approximate weight of each product
--Write a query to return the product ID of each product, together with the 
--product name formatted as upper case and a column named ApproxWeight with 
--the weight of each product rounded to the nearest whole unit.
SELECT ProductID, UPPER(Name), 
	CAST(Weight AS numeric) AS ApproxWeight  --Can also use ROUND
FROM SalesLT.Product;

SELECT ProductID, UPPER(Name), Weight AS ApproxWeight --Check rounding
FROM SalesLT.Product;

--2. Retrieve the year and month in which products were first sold
--Extend your query to include columns named SellStartYear and SellStartMonth 
--containing the year and month in which Adventure Works started selling 
--each product. The month should be displayed as the month name 
--(for example, ‘January’).
SELECT ProductID, UPPER(Name), 
	CAST(Weight AS numeric) AS ApproxWeight,
	YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth
FROM SalesLT.Product;

--3. Extract product types from product numbers
--Extend your query to include a column named ProductType that contains 
--the leftmost two characters from the product number.
SELECT ProductID, UPPER(Name), 
	CAST(Weight AS numeric) AS ApproxWeight,
	YEAR(SellStartDate) AS SellStartYear, 
	DATENAME(mm, SellStartDate) AS SellStartMonth,
	LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product;

--4. Retrieve only products with a numeric size
--Extend your query to filter the product returned so that only products 
--with a numeric size are included.
SELECT ProductID, UPPER(Name), 
	CAST(Weight AS numeric) AS ApproxWeight,
	YEAR(SellStartDate) AS SellStartYear, 
	DATENAME(mm, SellStartDate) AS SellStartMonth,
	LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product
WHERE ISNUMERIC(Size) = 1; --Here '1' means 'true'

--CHALLENGE TWO, Ranking

--1. Retrieve companies ranked by sales totals
--Write a query that returns a list of company names with a ranking of 
--their place in a list of highest TotalDue values from the SalesOrderHeader 
--table.

SELECT soh.CustomerID, c.CompanyName, soh.TotalDue,
	RANK()OVER(ORDER BY TotalDue DESC) AS RankByTotalDue
FROM SalesLT.SalesOrderHeader as soh
JOIN SalesLT.Customer AS c
ON soh.CustomerID = c.CustomerID;

--CHALLENGE 3, GROUP BY

--1. Retrieve total sales by product
--Write a query to retrieve a list of the product names and the total 
--revenue calculated as the sum of the LineTotal from the SalesLT.SalesOrderDetail 
--table, with the results sorted in descending order of total revenue.
SELECT p.Name, SUM(sod.LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS sod
JOIN SalesLT.Product as p
ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC;

--2. Filter the product sales list to include only products that cost over $1,000
--Modify the previous query to include sales totals for products that have 
--a list price of more than $1000.

SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;  --Expect about 86 rows for the desired query below

SELECT p.Name, SUM(sod.LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS sod
JOIN SalesLT.Product as p
ON sod.ProductID = p.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.Name
ORDER BY TotalRevenue DESC;

--3. Filter the product sales groups to include only total sales over $20,000
--Modify the previous query to only include only product groups with a total 
--sales value greater than $20,000.
SELECT p.Name, SUM(sod.LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS sod
JOIN SalesLT.Product as p
ON sod.ProductID = p.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.Name
HAVING SUM(LineTotal) > 20000
ORDER BY TotalRevenue DESC;