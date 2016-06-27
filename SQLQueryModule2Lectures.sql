--LECTURES 

SELECT * 
FROM SalesLT.Product;

SELECT DISTINCT Color, Size
FROM SalesLT.Product;

SELECT ProductCategoryID AS Category, Name, ListPrice
FROM SalesLT.Product
ORDER BY Category, ListPrice DESC;

SELECT TOP 10 ProductCategoryID AS Category, Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;

SELECT ProductCategoryID AS Category, Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;

-- DEMO, Eliminating Duplicates and Sorting Results

--Display a list of product colors, returns all products (295 rows)
SELECT ISNULL(Color, 'None') AS Color
FROM SalesLT.Product;

--Display a list of product colors, returns colors (10 rows)
SELECT DISTINCT ISNULL(Color, 'None') AS Color
FROM SalesLT.Product;

SELECT DISTINCT ISNULL(Color, 'None') AS Color
FROM SalesLT.Product
ORDER BY Color;

SELECT DISTINCT ISNULL(Color, 'None') AS Color, ISNULL(Size, '-') AS Size
FROM SalesLT.Product
ORDER BY Color;

SELECT TOP 100 Name, ListPrice
FROM SalesLT.Product 
ORDER BY ListPrice DESC;

--Display the first ten products by product number (preferred code for paging, use instead of TOP 10)
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
ORDER BY ProductNumber
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

--Fetch the next 10 rows
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
ORDER BY ProductNumber
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;

--LECTURES

--List information about product model 6
SELECT ProductModelID, Name, Color, Size 
FROM SalesLT.Product
WHERE ProductModelID = 6;

SELECT ProductModelID, Name, Color, Size 
FROM SalesLT.Product
WHERE ProductModelID > 6;

--List information about all product models except 6 (information about all products not 6)
SELECT ProductModelID, Name, Color, Size 
FROM SalesLT.Product
WHERE ProductModelID <> 6;

--Find products that have no sell end date, being careful with NULLs
--First take a look at what is in the database
SELECT Name, SellEndDate
FROM SalesLT.Product;

--This returns erroneous results
SELECT Name, SellEndDate
FROM SalesLT.Product
WHERE SellEndDate <> NULL;

--This returns correct results
SELECT Name, SellEndDate
FROM SalesLT.Product
WHERE SellEndDate IS NOT NULL;

--Find products that have a sell end date in 2006 (returning a range)
SELECT Name, SellEndDate
FROM SalesLT.Product
WHERE SellEndDate BETWEEN '2006/1/1' AND '2006/12/31';

--Find products that have a category ID of 5, 6, or 7.  Notice that ProductCategoryID is not ordered.
SELECT ProductCategoryID, Name, ListPrice
FROM SalesLT.Product
WHERE ProductCategoryID IN (5, 6, 7);

SELECT ProductCategoryID, Name, ListPrice
FROM SalesLT.Product
WHERE ProductCategoryID IN (5, 6, 7)
ORDER BY ProductCategoryID;

--Find products that have a category ID of 5, 6, or 7 and have an unknown sell end date
SELECT ProductCategoryID, Name, ListPrice, SellEndDate
FROM SalesLT.Product
WHERE ProductCategoryID IN (5, 6, 7)
AND SellEndDate IS NULL
ORDER BY ProductCategoryID;

--Select products that have a category ID of 5, 6, or 7 or a product number that begins with FR
SELECT ProductCategoryID, ProductNumber
FROM SalesLT.Product
WHERE ProductNumber LIKE 'FR%' OR ProductCategoryID IN (5, 6, 7);

SELECT ProductCategoryID, ProductNumber
FROM SalesLT.Product
WHERE ProductNumber LIKE 'FR%' AND ProductCategoryID IN (5, 6, 7);