--Module 10 Lab

--Challenge 1
/* 1. Write code to insert an order header.
Your script to insert an order header must enable users to specify values for the 
order date, due date, and customer ID. The SalesOrderID should be generated from 
the next value for the SalesLT.SalesOrderNumber sequence and assigned to a 
variable. The script should then insert a record into the SalesLT.SalesOrderHeader 
table using these values and a hard-coded value of ‘CARGO TRANSPORT 5’ for the 
shipping method with default or NULL values for all other columns.
After the script has inserted the record, it should display the inserted 
SalesOrderID using the PRINT command.
Test your code with the following values:
Order Date:  Today’s date
Due Date:  7 days from now
Customer ID:  1
*/
-- Insert sales order header
DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID int = 1;
DECLARE @OrderID int;

SET @OrderID = NEXT VALUE FOR SalesLT.SalesOrderNumber;

INSERT INTO SalesLT.SalesOrderHeader (SalesOrderID, OrderDate, DueDate, CustomerID, ShipMethod)
VALUES
(@OrderID, @OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');

PRINT @OrderID;

SELECT SalesOrderID, OrderDate, DueDate, CustomerID, ShipMethod
FROM SalesLT.SalesOrderHeader;

/* 2. Write code to insert an order detail.
The script to insert an order detail must enable users to specify a 
sales order ID, a product ID, a quantity, and a unit price. It must then 
check to see if the specified sales order ID exists in the SalesLT.SalesOrderHeader 
table. If it does, the code should insert the order details into the 
SalesLT.SalesOrderDetail table (using default values or NULL for unspecified 
columns). If the sales order ID does not exist in the SalesLT.SalesOrderHeader 
table, the code should print the message ‘The order does not exist’. You can test 
for the existence of a record by using the EXISTS predicate.

Test your code with the following values:
Sales Order ID:  The sales order ID returned by your previous code to insert a sales order header.
Product ID:  760
Quantity:  1
Unit Price:  782.99

Then test again with:
Sales Order ID:  0
Product ID:  760
Quantity:  1
Unit Price:  782.99

*/

-- Insert sales order details
DECLARE @SalesOrderID int = 4
DECLARE @ProductID int = 760;
DECLARE @Quantity int = 1;
DECLARE @UnitPrice money = 782.99;

SET @SalesOrderID = 0; -- test with the order ID generated for the sales order header inserted above

IF EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
BEGIN
	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice)
	VALUES
	(@SalesOrderID, @Quantity, @ProductID, @UnitPrice)
END
ELSE
BEGIN
	PRINT 'The order does not exist'
END

SELECT * FROM SalesLT.SalesOrderDetail;

--Challenge 2

--Updating prices using a loop

/* Adventure Works has determined that the market average price for a bike 
is $2,000, and consumer research has indicated that the maximum price any 
customer would be likely to pay for a bike is $5,000. You must write some 
Transact-SQL logic that incrementally increases the list price for all bike 
products by 10% until the average list price for a bike is at least the same 
as the market average, or until the most expensive bike is priced above the 
acceptable maximum indicated by the consumer research.
*/

/*  1. Write a WHILE loop to update bike prices.
The loop should:
- Execute only if the average list price of a product in the ‘Bikes’ parent 
	category is less than the market average. Note that the product categories in 
	the Bikes parent category can be determined from the SalesLT.vGetAllCategories 
	view.
- Update all products that are in the ‘Bikes’ parent category, increasing the 
	list price by 10%.
- Determine the new average and maximum selling price for products that are 
	in the ‘Bikes’ parent category.
- If the new maximum price is greater than or equal to the maximum acceptable 
	price, exit the loop; otherwise continue.

*/ 

--SELECT * FROM SalesLT.vGetAllCategories

DECLARE @MarketAverage money = 2000;
DECLARE @MarketMax money = 5000;
DECLARE @LPMax money;
DECLARE @LPAverage money;

SELECT @LPAverage =  AVG(ListPrice), @LPMax = MAX(ListPrice)
FROM SalesLT.Product
WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

WHILE @LPAverage < @MarketAverage
BEGIN
   UPDATE SalesLT.Product
   SET ListPrice = ListPrice * 1.1
   WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');
	  
	SELECT @LPAverage =  AVG(ListPrice), @LPMax = MAX(ListPrice)
	FROM SalesLT.Product
	WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

   IF @LPMax >= @MarketMax
      BREAK
   ELSE
      CONTINUE
END
PRINT 'New average bike price: ' + CONVERT(varchar, @LPAverage);
PRINT 'New maximum bike price: ' + CONVERT(varchar, @LPMax);
