--Module 8:  Grouping Sets and Pivoting Tables

--GROUP BY and GROUPING SETS

SELECT SalesOrderID, CustomerID, SUM(TotalDue) AS TotalAmount
FROM SalesLT.SalesOrderHeader
GROUP BY
GROUPING SETS
(
	SalesOrderID,  --When NULL, the TotalAmount fields represent Customer subtotals
	CustomerID,  --When NULL, the TotalAmount fields represent SalesOrder subtotals
	()           --NULLs in both SalesOrderID and CustomerID represent grand total of all sales   
);

--GROUP BY ROLLUP

SELECT StateProvince, City, COUNT(CustomerID) AS NumberOfCustomers
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca
ON a.AddressID = ca.AddressID
GROUP BY ROLLUP(StateProvince, City)
--GROUP BY GROUPING SETS (StateProvince, (StateProvince, City),())  --Will produce the same results!
ORDER BY StateProvince, City;

--GROUP BY CUBE
SELECT SalesPerson, LastName AS CustomerName, SUM(TotalDue) AS TotalAmount
FROM SalesLT.Customer as c
JOIN SalesLT.SalesOrderHeader AS soh
ON c.CustomerID = soh.CustomerID
GROUP BY CUBE(SalesPerson, LastName)
ORDER BY SalesPerson, CustomerName;

--GROUPING_ID function
SELECT GROUPING_ID(SalesPerson) AS SalesPersonGroup,
		GROUPING_ID(LastName) AS CustomerGroup,
		SalesPerson, LastName AS CustomerName, SUM(TotalDue) AS TotalAmount
FROM SalesLT.Customer as c
JOIN SalesLT.SalesOrderHeader AS soh
ON c.CustomerID = soh.CustomerID
GROUP BY CUBE(SalesPerson, LastName)
ORDER BY SalesPerson, CustomerName;

--Demo:  Grouping Sets
 --Basic GROUP BY
 SELECT cat.ParentProductCategoryName, cat.ProductCategoryName, COUNT(prd.ProductID) AS Products
 FROM SalesLT.vGetAllCategories as cat
 LEFT JOIN SalesLT.Product as prd
 ON prd.ProductCategoryID = cat.ProductCategoryID
 GROUP BY cat.ParentProductCategoryName, cat.ProductCategoryName
 --GROUP BY GROUPING SETS(cat.ParentProductCategoryName, cat.ProductCategoryName, ())
 --GROUP BY ROLLUP(cat.ParentProductCategoryName, cat.ProductCategoryName)
 --GROUP BY CUBE(cat.ParentProductCategoryName, cat.ProductCategoryName)
 ORDER BY cat.ParentProductCategoryName, cat.ProductCategoryName;

 --Demo:  Pivoting Data
SELECT * FROM
(SELECT p.ProductID, pc.Name, ISNULL(p.Color, 'Uncolored') AS Color
FROM SalesLT.ProductCategory as pc
JOIN SalesLT.Product as p
ON p.ProductCategoryID = pc.ProductCategoryID
) AS ppc
PIVOT (COUNT(ProductID) FOR Color 
	IN([Red], [Blue], [Black], [Silver], [Yellow], [Grey], [Multi], [Uncolored])) AS pvt
ORDER BY Name;  --This creates a nice report of each product and its count of each color

--Create a temporary table
CREATE TABLE #ProductColorPivot
(Name varchar(50), Red int, Blue int, Black int, Silver int, Yellow int, Grey int, Multi int, Uncolored int)

--Insert data into the temporary table

INSERT INTO #ProductColorPivot
SELECT * FROM
(SELECT p.ProductID, pc.Name, ISNULL(p.Color, 'Uncolored') AS Color
FROM SalesLT.ProductCategory as pc
JOIN SalesLT.Product as p
ON p.ProductCategoryID = pc.ProductCategoryID
) AS ppc
PIVOT (COUNT(ProductID) FOR Color 
	IN([Red], [Blue], [Black], [Silver], [Yellow], [Grey], [Multi], [Uncolored])) AS pvt
ORDER BY Name;

--View populated temporary table
SELECT * FROM #ProductColorPivot;

--Just for kicks, unpivot the temporary table.  In real life, this might be useful
--if you get pivoted data from an external source and want to unpivot it to see
--a different presentation of the data.  Keep in mind that you may lose the detail
--because SQL does not unaggregate any aggregated data residing in the pivoted table.
SELECT Name, Color, ProductCount
FROM
(SELECT Name, 
[Red], [Blue], [Black], [Silver], [Yellow], [Grey], [Multi], [Uncolored]
FROM #ProductColorPivot) AS pcp
UNPIVOT
(ProductCount FOR Color IN ([Red], [Blue], [Black], [Silver], [Yellow], [Grey], [Multi], [Uncolored])
) AS ProductCount;