--Module 4, UNION queries

--Simple UNION
SELECT FirstName, LastName, 'Employee' AS Type  
FROM SalesLT.Employee  --Won't work with this table!
UNION --Substitute UNION ALL to understand how that works, deleting 'Employee' AS Type above and 'Customer' below
SELECT FirstName, LastName, 'Customer'
FROM SalesLT.Customer
ORDER BY LastName;

SELECT * FROM SalesLT.Employee;

--INTERSECT
SELECT FirstName, LastName
FROM SalesLT.Employee  --Won't work with this table!
INTERSECT
SELECT FirstName, LastName
FROM SalesLT.Customer
ORDER BY LastName;

--EXCEPT
SELECT FirstName, LastName
FROM SalesLT.Customer 
EXCEPT
SELECT FirstName, LastName
FROM SalesLT.Employee   --Won't work with this table!
ORDER BY LastName;