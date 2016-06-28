--Lab 8:  Grouping Sets and Pivoting Tables

Challenge 1:  ROLLUP, GROUP_ID
--1. Retrieve totals for country/region and state/province Tip: Review the documentation for GROUP BY in the Transact-SQL Language Reference.
--An existing report uses the following query to return total sales revenue grouped 
--by country/region and state/province.

SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca 
ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c 
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh 
ON c.CustomerID = soh.CustomerID
GROUP BY a.CountryRegion, a.StateProvince
ORDER BY a.CountryRegion, a.StateProvince;

--Modify this query so that the results include a grand total for all sales revenue 
--and a subtotal for each country/region in addition to the state/province 
--subtotals that are already returned.

SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca 
ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c 
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh 
ON c.CustomerID = soh.CustomerID
--GROUP BY a.CountryRegion, a.StateProvince
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

--2. Indicate the grouping level in the results Tip: Review the documentation for the GROUPING_ID function in the Transact-SQL Language Reference.
--Modify your query to include a column named Level that indicates at which level 
--in the total, country/region, and state/province hierarchy the revenue figure in 
--the row is aggregated. For example, the grand total row should contain the 
--value ‘Total’, the row showing the subtotal for United States should contain 
--the value ‘United States Subtotal’, and the row showing the subtotal for California 
--should contain the value ‘California Subtotal’.

--TIP:  Review IIF and CHOOSE syntax

SELECT a.CountryRegion, a.StateProvince,
	IIF(GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1, 'Total',IIF(GROUPING_ID(a.StateProvince) = 1, a.CountryRegion + 'Subtotal', a.StateProvince + 'Subtotal')) 
	AS Level,
	SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca 
ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c 
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh 
ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

--3. Add a grouping level for cities
Extend your query to include a grouping for individual cities.

SELECT a.CountryRegion, a.StateProvince, a.City,
	CHOOSE(1 + GROUPING_ID(a.CountryRegion) + GROUPING_ID(a.StateProvince) + GROUPING_ID(a.City), a.City + ' Subtotal', a.StateProvince + ' Subtotal', a.CountryRegion + ' Subtotal', 'Total')
	AS Level,
	SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca 
ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c 
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh 
ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;

--Challenge 2: 
--1. Retrieve customer sales revenue for each parent category 
--Tip: Review the documentation for the PIVOT operator in the FROM clause syntax in 
--the Transact-SQL language reference.
--Retrieve a list of customer company names together with their total revenue 
--for each parent category in Accessories, Bikes, Clothing, and Components.

SELECT * FROM SalesLT.vGetAllCategories;

SELECT cat.ParentProductCategoryName, cust.CompanyName, sod.LineTotal
FROM SalesLT.SalesOrderDetail AS sod
JOIN SalesLT.SalesOrderHeader AS soh 
ON sod.SalesOrderID = soh.SalesOrderID
JOIN SalesLT.Customer AS cust 
ON soh.CustomerID = cust.CustomerID
JOIN SalesLT.Product AS prod 
ON sod.ProductID = prod.ProductID
JOIN SalesLT.vGetAllCategories AS cat 
ON prod.ProductcategoryID = cat.ProductCategoryID;

--Pivot the table
SELECT CompanyName, Accessories, Bikes, Clothing, Components  --Could also use SELECT *
FROM 
(SELECT cat.ParentProductCategoryName, cust.CompanyName, sod.LineTotal
FROM SalesLT.SalesOrderDetail AS sod
JOIN SalesLT.SalesOrderHeader AS soh 
ON sod.SalesOrderID = soh.SalesOrderID
JOIN SalesLT.Customer AS cust 
ON soh.CustomerID = cust.CustomerID
JOIN SalesLT.Product AS prod 
ON sod.ProductID = prod.ProductID
JOIN SalesLT.vGetAllCategories AS cat 
ON prod.ProductcategoryID = cat.ProductCategoryID) AS Sales
PIVOT (SUM(LineTotal) FOR ParentProductCategoryName IN([Accessories],[Bikes],[Clothing],[Components])
) AS pvt;