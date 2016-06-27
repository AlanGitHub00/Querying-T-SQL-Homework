--LAB 4 - Set operators (UNION, INTERSECT, EXCEPT)

--Challenge 1, UNION

--1. Retrieve billing addresses.  Write a query that retrieves the company name, 
--first line of the street address, city, and a column named AddressType with 
--the value ‘Billing’ for customers where the address type in the SalesLT.CustomerAddress 
--table is ‘Main Office’.

SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType --Renames all items in column 'Billing'
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Main Office'; --Filters out shipping addresses.  Change this to 'Shipping' to see the 10 rows of shipping addresses

--2. Retrieve shipping addresses.  Write a similar query that retrieves the 
--company name, first line of the street address, city, and a column named 
--AddressType with the value ‘Shipping’ for customers where the address 
--type in the SalesLT.CustomerAddress table is ‘Shipping’.

SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType --Renames all items in column 'Shipping'
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Shipping';  --Filters out billing addresses. Change this to 'Main Office to see the 407 rows that are billing addresses

--3. Combine billing and shipping addresses.  Combine the results returned by the two 
--queries to create a list of all customer addresses that is sorted by company name 
--and then address type.

SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Main Office'
UNION ALL
SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName, AddressType;

--Challenge 2, INTERSECT and EXCEPT 

--1. Retrieve customers with only a main office address.  Write a query that returns the 
--company name of each company that appears in a table of customers with a 
--‘Main Office’ address, but not in a table of customers with a ‘Shipping’ address.

SELECT c.CompanyName
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Main Office' --Filters out shipping addresses.  This is a table of all Billing addresses.
EXCEPT
SELECT c.CompanyName
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Shipping'; --Filters out all billing addresses.  This is a table of all shipping addresses.

--2. Retrieve only customers with both a main office address and a shipping address
--Write a query that returns the company name of each company that appears in a 
--table of customers with a ‘Main Office’ address, and also in a table of customers 
--with a ‘Shipping’ address. 

SELECT c.CompanyName
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Main Office' --Filters out shipping addresses.  This is a table of all Billing addresses.
INTERSECT
SELECT c.CompanyName
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Shipping'; --Filters out all billing addresses.  This is a table of all shipping addresses.

