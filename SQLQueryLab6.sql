--Module 6 Lab

--CHALLENGE 1
--1. Retrieve products whose list price is higher than the average unit price
--Retrieve the product ID, name, and list price for each product where 
--the list price is higher than the average unit price for all products that 
--have been sold.

SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ListPrice >
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail)
ORDER BY ProductID;

SELECT AVG(UnitPrice)
FROM SalesLT.SalesOrderDetail;

--2. Retrieve Products with a list price of $100 or more that have been sold for 
--less than $100
--Retrieve the product ID, name, and list price for each product where the 
--list price is $100 or more, and the product has been sold for less than $100.
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ProductID IN 
	(SELECT ProductID
	FROM SalesLT.SalesOrderDetail
	WHERE UnitPrice < 100)
AND ListPrice >=100
ORDER BY ProductID;

--3. Retrieve the cost, list price, and average selling price for each product
--Retrieve the product ID, name, cost, and list price for each product along 
--with the average unit price for which that product has been sold.
SELECT ProductID, Name, StandardCost AS Cost, ListPrice, 
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail as sod
	WHERE p.ProductID = sod.ProductID) AS AvgUnitPrice
FROM SalesLT.Product AS p
ORDER BY ProductID;

--4. Retrieve products that have an average selling price that is lower than the cost.
--Filter your previous query to include only products where the cost price
-- is higher than the average selling price.
SELECT ProductID, Name, StandardCost AS Cost, ListPrice, 
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail as sod
	WHERE p.ProductID = sod.ProductID) AS AvgUnitPrice
FROM SalesLT.Product AS p
WHERE StandardCost > 
	(SELECT AVG(UnitPrice)
	FROM SalesLT.SalesOrderDetail as sod
	WHERE p.ProductID = sod.ProductID)
ORDER BY ProductID;

--CHALLENGE 2
--1. Retrieve customer information for all sales orders.
--Retrieve the sales order ID, customer ID, first name, last name, and 
--total due for all sales orders from the SalesLT.SalesOrderHeader table and 
--the dbo.ufnGetCustomerInformation function.

sp_helptext 'dbo.ufnGetCustomerInformation'

SELECT soh.SalesOrderID, soh.CustomerID, ci.FirstName, ci.LastName, soh.TotalDue
FROM SalesLT.SalesOrderHeader AS soh
CROSS APPLY dbo.ufnGetCustomerInformation(soh.CustomerID) AS ci
ORDER BY soh.SalesOrderID;

--Retrieve the customer ID, first name, last name, address line 1 and city 
--for all customers from the SalesLT.Address and SalesLT.CustomerAddress tables, 
--and the dbo.ufnGetCustomerInformation function.
SELECT ca.CustomerID, ci.FirstName, ci.LastName, a.AddressLine1, a.City
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca
ON a.addressID = ca.addressID
CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS ci
ORDER BY ca.CustomerID;