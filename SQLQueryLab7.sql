--Module 7 Lab

--CHALLENGE 1:  Views, Table Variables, Table-Valued Functions

--1. Retrieve product model descriptions
--Retrieve the product ID, product name, product model name, and 
--product model summary for each product from the SalesLT.Product table 
--and the SalesLT.vProductModelCatalogDescription view.

SELECT p.ProductID, p.Name as Product, pm.Name AS ModelName, v.Summary
FROM SalesLT.Product AS p
JOIN SalesLT.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID
JOIN SalesLT.vProductModelCatalogDescription AS v
ON pm.ProductModelID  = v.ProductModelID;

--2. Create a table of distinct colors. Tip: Review the documentation for Variables in Transact-SQL Language Reference.
--Create a table variable and populate it with a list of distinct colors 
--from the SalesLT.Product table. Then use the table variable to filter a 
--query that returns the product ID, name, and color from the SalesLT.Product 
--table so that only products with a color listed in the table variable are returned.

DECLARE @Colors AS TABLE
(Color varchar(15))
INSERT INTO @Colors
SELECT DISTINCT Color
FROM SalesLT.Product;
SELECT ProductID, Name, Color
FROM SalesLT.Product
WHERE Color IN (SELECT Color FROM @Colors);

--3. Retrieve product parent categories.
--The AdventureWorksLT database includes a table-valued function named 
--dbo.ufnGetAllCategories, which returns a table of product categories 
--(for example ‘Road Bikes’) and parent categories (for example ‘Bikes’). 
--Write a query that uses this function to return a list of all products 
--including their parent category and category.

--First, view dbo.ufnGetAllCategories
SELECT * 
FROM dbo.ufnGetAllCategories();

--Next, build the query
SELECT ParentProductCategoryName AS ParentCategory, 
ProductCategoryName AS Category, p.Name
FROM SalesLT.Product AS p
JOIN dbo.ufnGetAllCategories() AS f
ON p.ProductCategoryID = f.ProductCategoryID
ORDER BY ParentProductCategoryName, ProductCategoryName, Name;

--CHALLENGE 2:  Derived Tables and Common Table Expressions

--1. Retrieve sales revenue by customer and contact.
--Retrieve a list of customers in the format Company (Contact Name) together 
--with the total revenue for that customer. Use a derived table or a common 
--table expression to retrieve the details for each sales order, and then query 
--the derived table or CTE to aggregate and group the data.
SELECT CompanyName + ' ' + '(' + FirstName + ' ' + LastName + ')' AS Company, soh.TotalDue AS Revenue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader as soh
ON c.CustomerID = soh.CustomerID
ORDER BY Company;

--Using a derived table
SELECT CompanyContact, SUM(TotalDue) AS Revenue
FROM 
	(SELECT CONCAT(c.CompanyName, CONCAT(' (' + c.FirstName + ' ' , c.LastName + ')'))
	AS CompanyContact, soh.TotalDue
	FROM SalesLT.Customer AS c
	JOIN SalesLT.SalesOrderHeader AS soh
	ON c.CustomerID = soh.CustomerID) 
	AS CustomerSales(CompanyContact, TotalDue)
GROUP BY CompanyContact
ORDER BY CompanyContact;

--Using a Common Table Expression
WITH CustomerSales(CompanyContact, TotalDue)
AS
(SELECT CONCAT(c.CompanyName, CONCAT(' (' + c.FirstName + ' ', c.LastName + ')')), SOH.TotalDue
 FROM SalesLT.SalesOrderHeader AS SOH
 JOIN SalesLT.Customer AS c
 ON SOH.CustomerID = c.CustomerID)
SELECT CompanyContact, SUM(TotalDue) AS Revenue
FROM CustomerSales
GROUP BY CompanyContact
ORDER BY CompanyContact;