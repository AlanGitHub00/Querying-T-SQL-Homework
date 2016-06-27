--MODULE 3 Lectures

--Basic inner join
SELECT SalesLT.Product.Name AS ProductName, SalesLT.ProductCategory.Name AS Category
FROM SalesLT.Product
INNER JOIN SalesLT.ProductCategory
ON SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID;

--Same query using aliases
SELECT p.Name AS ProductName, c.Name AS Category
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID;

--Joining more than two tables

SELECT oh.OrderDate, oh.SalesOrderNumber, p.Name as ProductName, od.OrderQty, od.UnitPrice, od.LineTotal
FROM SalesLT.SalesOrderHeader AS oh
JOIN SalesLT.SalesOrderDetail AS od
ON od.SalesOrderID = oh.SalesOrderID
JOIN SalesLT.Product AS p
ON od.ProductID = p.ProductID
ORDER BY oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID;

--Multiple join predicates

SELECT oh.OrderDate, oh.SalesOrderNumber, p.Name as ProductName, od.OrderQty, od.UnitPrice, od.LineTotal
FROM SalesLT.SalesOrderHeader AS oh
JOIN SalesLT.SalesOrderDetail AS od
ON od.SalesOrderID = oh.SalesOrderID
JOIN SalesLT.Product AS p
ON od.ProductID = p.ProductID AND od.UnitPrice < p.ListPrice  --Note multiple predicates 
ORDER BY oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID;

--Outer join, get all customers, with sales orders for those who've bought anything

SELECT c.FirstName, c.LastName, oh.SalesOrderNumber
FROM SalesLT.Customer AS c
LEFT OUTER JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
ORDER BY c.CustomerID;

--Outer join, returning only customers who haven't bought anything

SELECT c.FirstName, c.LastName, oh.SalesOrderNumber
FROM SalesLT.Customer AS c
LEFT OUTER JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
WHERE oh.SalesOrderNumber IS NULL
ORDER BY c.CustomerID;

--Outer join, using more than 2 tables.  Returns all products with and without sales orders.
--Note that this retrieves data from the first and third table by JOINing a chain of tables.

SELECT p.Name AS ProductName, oh.SalesOrderNumber
FROM SalesLT.Product AS p
LEFT JOIN SalesLT.SalesOrderDetail AS od
ON p.ProductID = od.ProductID
LEFT JOIN SalesLT.SalesOrderHeader as oh --Additional tables added to the right must also LEFT JOINed
ON od.SalesOrderID = oh.SalesOrderID
ORDER BY p.ProductID;

--Adding a fourth table to the above query to include product category name.

SELECT p.Name AS ProductName, c.Name AS Category, oh.SalesOrderNumber
FROM SalesLT.Product AS p
LEFT JOIN SalesLT.SalesOrderDetail AS od
ON p.ProductID = od.ProductID
LEFT JOIN SalesLT.SalesOrderHeader as oh --Additional tables added to the right must also LEFT JOINed
ON od.SalesOrderID = oh.SalesOrderID
INNER JOIN SalesLT.ProductCategory AS c  --Added to the left, so can use inner join
ON p.ProductCategoryID = c.ProductCategoryID
ORDER BY p.ProductID;

--An alternate way to do the above is to do an inner join first

SELECT p.Name AS ProductName, c.Name AS Category, oh.SalesOrderNumber
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS c  --Alternatively, do the inner join first
ON p.ProductCategoryID = c.ProductCategoryID
LEFT JOIN SalesLT.SalesOrderDetail AS od
ON p.ProductID = od.ProductID
LEFT JOIN SalesLT.SalesOrderHeader as oh --Additional tables added to the right must also LEFT JOINed
ON od.SalesOrderID = oh.SalesOrderID
ORDER BY p.ProductID;

--Cross joins (This query returns 249,865 rows!)

SELECT p.Name, c.FirstName, c.LastName, c.Phone
FROM SalesLT.Product AS p
CROSS JOIN SalesLT.Customer AS c;

--Self joins
--First, create an employee table because non exists in the database
CREATE TABLE SalesLT.Employee
(EmployeeID int IDENTITY PRIMARY KEY,
EmployeeName nvarchar(256),
ManagerID int);
GO  --Execute this query to create the table.  You will get a message that the command completed successfully

--Next, insert some data from the existing Customers table, which has a SalesPerson column
INSERT INTO SalesLT.Employee (EmployeeName, ManagerID)
SELECT DISTINCT Salesperson, NULLIF(CAST(RIGHT(Salesperson, 1) AS INT), 0)
FROM SalesLT.Customer;
GO --Execute this query to insert the data

--Next, update the table like so
UPDATE SalesLT.Employee
SET ManagerID = (SELECT MIN(EmployeeID) FROM SalesLT.Employee WHERE ManagerID IS NULL)
WHERE ManagerID IS NULL
AND EmployeeID > (SELECT MIN(EmployeeID) FROM SalesLT.Employee WHERE ManagerID IS NULL);
GO

--Check your work by viewing the table you created
--This table gives EmployeeID, EmployeeName, and the corresponding ManagerID (but not ManagerName)

SELECT * 
FROM SalesLT.Employee;

--Perform a self join with a left outer join to make a table of each employee and their manager

SELECT e.EmployeeName, m.EmployeeName AS Manager
FROM SalesLT.Employee AS e
LEFT JOIN SalesLT.Employee AS m --LEFT JOIN because you want to see employees who don't have managers
ON e.ManagerID = m.EmployeeID  --BE CAREFUL HERE or you get the wrong results
ORDER BY e.ManagerID;

