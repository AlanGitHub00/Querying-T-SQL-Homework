--Module 6 Lectures, Using Subqueries and APPLY

--Demo:  Using subqueries

--Display a list of products whose list price (Products table) is higher than
--the highest unit price of products actually sold (SalesOrderDetail table).

--First, find the maximum unit price sold
SELECT MAX(UnitPrice)
FROM SalesLT.SalesOrderDetail; --Returns 1466.01

--Next, use the value you obtained to see what products have a higher list price 
-- than the maximum unit price sold obtained with the above query.
SELECT *
FROM SalesLT.Product
WHERE ListPrice > 1466.01 --Returns 39 rows

--Next, use a subquery so you don't have to type in the number
SELECT *
FROM SalesLT.Product
WHERE ListPrice > 
	(SELECT MAX(UnitPrice)
	FROM SalesLT.SalesOrderDetail); --Returns the same 39 rows as above.

--Correlated subqueries

--For each customer, list all sales on the last day they placed an order
--First, 
SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader AS SO1
ORDER BY CustomerID, OrderDate; --Returns 32 rows

--Next,
SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader AS SO1
WHERE OrderDate = 
	(SELECT MAX(OrderDate) 
	FROM SalesLT.SalesOrderHeader); --Returns 32 rows because all the order dates are the same 2008-06-01


--You can't build up the correlated query like a self-contained
--query because of the dependency of the inner query on the outer query.
SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader AS SO1
WHERE OrderDate = 
	(SELECT MAX(OrderDate) 
	FROM SalesLT.SalesOrderHeader AS SO2
	WHERE SO1.CustomerID = SO2.CustomerID)
ORDER BY CustomerID, OrderDate;  --Returns the info desired

--Note that correlated subqueries are complex logically and difficult to check.

--The APPLY Operator
--Display the sales order details for items that are equal to 
--the maximum unit price for that sales order

--First, ask SQL Server what udfmaxunitprice function is.
sp_helptext 'saleslt.udfmaxunitprice'  

--Function does not exist so the following query will produce an error.

SELECT soh.SalesOrderID, mup.MaxUnitPrice
FROM SalesLT.SalesOrderHeader AS soh
CROSS APPLY SalesLT.udfMaxUnitPrice(soh.SalesOrderID) AS mup 
ORDER BY soh.SalesOrderID;