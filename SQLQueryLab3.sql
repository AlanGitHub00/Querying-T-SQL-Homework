--MODULE 3 LAB, Querying Multiple Tables With JOIN

--1.  As an initial step towards generating a customers invoice report, 
--write a query that returns the company name from the SalesLT.Customer table, 
--and the sales order ID and total due from the SalesLT.SalesOrderHeader table.

SELECT c.CompanyName, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
ORDER BY c.CompanyName;

--2.  Extend your customer orders query to include the Main Office address 
--for each customer, including the full street address, city, state or 
--province, postal code, and country or region.

SELECT c.CompanyName, a.AddressLine1, a.AddressLine2, a.City, a.StateProvince, 
a.CountryRegion, a.PostalCode, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
JOIN SalesLT.CustomerAddress AS ca 
ON c.CustomerID = ca.CustomerID AND AddressType = 'Main Office'
JOIN SalesLT.Address as a
ON a.AddressID = ca.AddressID
ORDER BY c.CompanyName;

--Solve using the tip (must use Address and CustomerAddress table)
--First view the contents of these tables

SELECT * 
FROM SalesLT.Address;  --450 rows, Doesn't tell you much

SELECT *
FROM SalesLT.CustomerAddress;  --417 rows, Note AddressType column that specifies Main Office, Shipping

--1. Retrieve a list of all customers and their orders
--The sales manager wants a list of all customer companies and their contacts 
--(first name and last name), showing the sales order ID and total due for each 
--order they have placed. Customers who have not placed any orders should be 
--included at the bottom of the list with NULL values for the order ID and total due.

SELECT c.CompanyName, c.FirstName, c.LastName, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.Customer as c
LEFT JOIN SalesLT.SalesOrderHeader as oh
ON oh.CustomerID  = c.CustomerID
ORDER BY oh.SalesOrderID DESC; --I did oh.TotalDue DESC; to order by amount due

--2. Retrieve a list of customers with no address
--A sales employee has noticed that Adventure Works does not have address information 
--for all customers. You must write a query that returns a list of customer IDs, 
--company names, contact names (first name and last name), and phone numbers for 
--customers with no address stored in the database. 

SELECT * 
FROM SalesLT.Address;  --450 rows

SELECT *
FROM SalesLT.CustomerAddress;  --417 rows

SELECT *
FROM SalesLT.Customer
ORDER BY CompanyName;  --847 rows, shows duplicate contacts

SELECT c.CustomerID, c.CompanyName, ca.AddressID, c.FirstName, c.LastName, c.Phone 
FROM SalesLT.Customer as c
LEFT JOIN SalesLT.CustomerAddress as ca
ON c.CustomerID = ca.CustomerID; --Shows all customers, including NULL AddressID (857 rows)

SELECT c.CustomerID, c.CompanyName, ca.AddressID, c.FirstName, c.LastName, c.Phone 
FROM SalesLT.Customer as c
LEFT JOIN SalesLT.CustomerAddress as ca
ON c.CustomerID = ca.CustomerID
WHERE ca.AddressID IS NULL;  --Shows only customers lacking addresses (440 rows)

--3. Retrieve a list of customers and products without orders
--Some customers have never placed orders, and some products have never been ordered. 
--Create a query that returns a column of customer IDs for customers who have never 
--placed an order, and a column of product IDs for products that have never been 
--ordered. Each row with a customer ID should have a NULL product ID 
--(because the customer has never ordered a product) and each row with a product ID 
--should have a NULL customer ID (because the product has never been ordered by a customer).

SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
FULL JOIN SalesLT.SalesOrderHeader as oh
ON c.CustomerID = oh.CustomerID
FULL JOIN SalesLT.SalesOrderDetail as od
ON oh.SalesOrderID = od.SalesOrderID
FULL JOIN SalesLT.Product AS p
ON p.ProductID = od.ProductID
WHERE oh.SalesOrderNumber IS NULL
ORDER BY p.ProductID, c.CustomerID;
