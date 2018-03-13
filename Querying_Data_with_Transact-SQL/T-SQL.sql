----------------------------------Lab 1-----------------------------------

--Retrieving Customer Data
select * from SalesLT.Customer 

--Create List of Customer Contacts
SELECT Title, FirstName,MiddleName,LastName,Suffix
FROM SalesLT.Customer;

--Create List of Customer Contacts (2)
SELECT SalesPerson, Title + ' ' + LastName AS CustomerName,Phone
FROM SalesLT.Customer;

--Retrieving Customer and Sales Data
SELECT CAST(CustomerID AS VARCHAR) + ': ' + CompanyName AS CustomerCompany
FROM SalesLT.Customer;

--Retrieving Customer and Sales Data (2)
Retrieving Customer and Sales Data (2)

--Retrieving Customer Contact Names
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName
AS CustomerName
FROM SalesLT.Customer;

--Retrieving Primary Contact Details
SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer;

--Retrieving Shipping Status
SELECT SalesOrderID, OrderDate,
  CASE
    WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
    ELSE 'Shipped'
  END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;

----------------------------------Lab 2-----------------------------------

--Retrieving Transportation Report Data

SELECT DISTINCT City, StateProvince
FROM SalesLT.Address;

--Retrieving Transportation Report Data (2)

SELECT TOP 10 PERCENT Name
FROM SalesLT.Product
-- order by the weight in descending order
ORDER BY Weight DESC;

--Retrieving Transportation Report Data (3)

SELECT Name
FROM SalesLT.Product
ORDER BY Weight DESC
-- offset 10 rows and get the next 100
OFFSET 10 ROWS FETCH NEXT 100 ROWS ONLY;

--Retrieving Product Data

SELECT Name, Color, Size
FROM SalesLT.Product
-- check ProductModelID is 1
WHERE ProductModelID = 1;

--Retrieving Product Data (2)

-- select the ProductNumber and Name columns
SELECT ProductNumber, Name
FROM SalesLT.Product
-- check that Color is one of 'Black', 'Red' or 'White'
-- check that Size is one of 'S' or 'M'
WHERE Color IN ('Black', 'Red', 'White') AND Size IN ('S', 'M');

--Retrieving Product Data (3)

-- select the ProductNumber, Name, and ListPrice columns
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
-- filter for product numbers beginning with BK- using LIKE
WHERE ProductNumber LIKE 'BK%';

--Retrieving Product Data (4)

-- select the ProductNumber, Name, and ListPrice columns
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
-- filter for ProductNumbers
WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]';


----------------------------------Lab 3-----------------------------------

--Generating Invoice Reports

SELECT CompanyName, SalesOrderId, TotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
-- join tables based on CustomerID
ON C.CustomerID = oh.CustomerID;

--Generating Invoice Reports (2)

SELECT c.CompanyName, a.AddressLine1, ISNULL(a.AddressLine2, '') AS AddressLine2, a.City, a.StateProvince, a.PostalCode, a.CountryRegion, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.Customer AS c
-- join the SalesOrderHeader table
JOIN SalesLT.SalesOrderHeader AS oh
ON oh.CustomerID = c.CustomerID
-- join the CustomerAddress table
JOIN SalesLT.CustomerAddress AS ca
-- filter for where the AddressType is 'Main Office'
ON c.CustomerID = ca.CustomerID AND AddressType = 'Main Office'
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID;

--Retrieving Sales Data

-- select the CompanyName, FirstName, FirstName, SalesOrderID and TotalDue columns
-- from the appropriate tables
SELECT CompanyName, FirstName, LastName, SalesOrderID, TotalDue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
-- join based on CustomerID
ON c.CustomerID = oh.CustomerID
-- order the SalesOrderIDs from highest to lowest
ORDER by oh.SalesOrderID DESC;

--Retrieving Sales Data (2)

SELECT c.CompanyName, c.FirstName, c.LastName, c.Phone
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- filter for when the AddressID doesn't exist
WHERE ca.AddressID IS NULL;

--Retrieving Sales Data (3)

SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
FULL JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
FULL JOIN SalesLT.SalesOrderDetail AS od
-- join based on the SalesOrderID
ON od.SalesOrderID = oh.SalesOrderID
FULL JOIN SalesLT.Product AS p
-- join based on the ProductID
ON p.ProductID = od.ProductID
-- filter for nonexistent SalesOrderIDs


----------------------------------Lab 4-----------------------------------

--Retrieving Customer Addresses
SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- join another table
JOIN SalesLT.Address AS a
-- join based on AddressID
ON A.AddressID = ca.AddressID

--Retrieving Customer Addresses (2)

SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
-- edit this
WHERE ca.AddressType = 'Shipping';

--Retrieving Customer Addresses (3)

SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
-- edit this as per the instructions
UNION ALL
SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName, AddressType;

--Filtering Customer Addresses (1)

SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- join the CustomerAddress table
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
-- join based on AddressID
ON a.AddressID = ca.AddressID
WHERE ca.AddressType = 'Main Office'
EXCEPT
SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- use the appropriate join to join the CustomerAddress table
JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- use the appropriate join to join the Address table
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
-- filter for the appropriate AddressType
WHERE AddressType = 'Shipping'
ORDER BY c.CompanyName;

--Filtering Customer Addresses (2)

-- select the CompanyName column
SELECT c.CompanyName
-- from the appropriate table
FROM SalesLT.Customer AS c
-- use the appropriate join with the appropriate table
JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- use the appropriate join with the appropriate table
JOIN SalesLT.Address AS a
-- join based on AddressID
ON a.AddressID = ca.AddressID
-- filter based on AddressType
WHERE ca.AddressType = 'Main Office'
INTERSECT
-- select the CompanyName column
SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- use the appropriate join with the appropriate table
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
-- join based on AddressID
ON a.AddressID = ca.AddressID
-- filter based on AddressType
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;



----------------------------------Lab 5-----------------------------------

--Retrieving Product Information
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight
FROM SalesLT.Product;

--Retrieving Product Information (2)
SELECT ProductID,
       UPPER(Name) AS ProductName,
       ROUND(Weight, 0) AS ApproxWeight,
       YEAR(SellStartDate) as SellStartYear,
       DATENAME(m, SellStartDate) as SellStartMonth
FROM SalesLT.Product;

--Retrieving Product Information (3)
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight,
       YEAR(SellStartDate) as SellStartYear,
       DATENAME(m, SellStartDate) as SellStartMonth,
       -- use the appropriate function to extract substring from ProductNumber
       LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product;

--Retrieving Product Information (4)
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight,
       YEAR(SellStartDate) as SellStartYear,
       DATENAME(m, SellStartDate) as SellStartMonth,
       LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product
-- filter for numeric product size data
WHERE ISNUMERIC(size) = 1;

--Ranking Customers By Revenue
-- select CompanyName and TotalDue columns
SELECT C.CompanyName, SOH.TotalDue AS Revenue,
       -- get ranking and order by appropriate column
       RANK() OVER (ORDER BY SOH.TotalDue DESC) AS RankByRevenue
FROM SalesLT.SalesOrderHeader AS SOH
-- use appropriate join on appropriate table
JOIN SalesLT.Customer AS C
ON SOH.CustomerID = C.CustomerID;

--Aggregating Product Sales
-- select the Name column and use the appropriate function with the appropriate column
SELECT Name, SUM(LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
-- use the appropriate join
JOIN SalesLT.Product AS P
-- join based on ProductID
ON SOD.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY TotalRevenue DESC;

--Aggregating Product Sales (2)
SELECT Name, SUM(LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
JOIN SalesLT.Product AS P
ON SOD.ProductID = P.ProductID
-- filter as per the instructions
WHERE  P.ListPrice > 1000
GROUP BY P.Name
ORDER BY TotalRevenue DESC;

--
Aggregating Product Sales (3)
SELECT Name, SUM(LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
JOIN SalesLT.Product AS P
ON SOD.ProductID = P.ProductID
WHERE P.ListPrice > 1000
GROUP BY P.Name
-- add having clause as per instructions
HAVING SUM(LineTotal) > 20000
ORDER BY TotalRevenue DESC;

----------------------------------Lab 6-----------------------------------

--Retrieving Product Price Information
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
-- filter based on ListPrice
WHERE ListPrice >
-- get the average UnitPrice
(SELECT avg(UnitPrice) FROM SalesLT.SalesOrderDetail)
ORDER BY ProductID;

--Retrieving Product Price Information (2)
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ProductID IN
  -- select ProductID from the appropriate table
  (SELECT ProductID FROM SalesLT.SalesOrderDetail
   WHERE UnitPrice < 100)
AND ListPrice >= 100
ORDER BY ProductID;

--Retrieving Product Price Information (3)

SELECT ProductID, Name, StandardCost, ListPrice,
-- get the average UnitPrice
    (SELECT AVG(UnitPrice)
    -- from the appropriate table, aliased as SOD
     FROM SalesLT.SalesOrderDetail AS SOD
     -- filter when the appropriate ProductIDs are equal
     WHERE P.ProductID = SOD.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS P
ORDER BY P.ProductID;

--Retrieving Product Price Information (4)
SELECT ProductID, Name, StandardCost, ListPrice,
(SELECT AVG(UnitPrice)
 FROM SalesLT.SalesOrderDetail AS SOD
 WHERE P.ProductID = SOD.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS P
-- filter based on StandardCost
WHERE StandardCost >
-- get the average UnitPrice
(SELECT avg(UnitPrice)
 -- from the appropriate table aliased as SOD
 FROM SalesLT.SalesOrderDetail AS SOD
 -- filter when the appropriate ProductIDs are equal
 WHERE P.ProductID = SOD.ProductID)
ORDER BY P.ProductID;

--Retrieving Customer Information
SELECT SOH.SalesOrderID, CI.CustomerID, CI.FirstName, CI.LastName, SOH.TotalDue
FROM SalesLT.SalesOrderHeader AS SOH
-- cross apply as per the instructions
cross apply dbo.ufnGetCustomerInformation(SOH.CustomerID) AS CI
-- finish the clause
ORDER by SOH.SalesOrderID;

--Retrieving Customer Information (2)
-- select the CustomerID, FirstName, LastName, Addressline1, and City columns from the appropriate tables
SELECT CI.CustomerID, CI.FirstName, CI.LastName, A.Addressline1, A.City
FROM SalesLT.Address AS A
JOIN SalesLT.CustomerAddress AS CA
-- join based on AddressID
ON A.AddressID = CA.AddressID
-- cross apply as per instructions
cross apply dbo.ufnGetCustomerInformation(CA.CustomerID) AS CI
ORDER BY CA.CustomerID;
----------------------------------Lab 7-----------------------------------


--Retrieving Product Information
SELECT P.ProductID, P.Name AS ProductName, PM.Name AS ProductModel, PM.Summary
FROM SalesLT.Product AS P
JOIN SalesLT.vProductModelCatalogDescription AS PM
-- join based on ProductModelID
ON P.ProductModelID = PM.ProductModelID
ORDER BY ProductID;

--Retrieving Product Information (2)
DECLARE @Colors AS TABLE (COLOR NVARCHAR(15));

INSERT INTO @Colors
SELECT DISTINCT COLOR FROM SalesLT.Product;

SELECT ProductID, Name, Color
FROM SalesLT.Product
WHERE COLOR IN (SELECT COLOR FROM @Colors);

--Retrieving Product Information (3)
SELECT C.ParentProductCategoryName AS ParentCategory,
       C.ProductCategoryName  AS Category,
       P.ProductID, P.Name  AS ProductName
FROM SalesLT.Product AS P
JOIN dbo.ufnGetAllCategories() AS C
ON P.ProductCategoryID  = C.ProductCategoryID 
ORDER BY ParentCategory, Category, ProductName;

--Retrieving Customer Sales Revenue
SELECT CompanyContact, sum(SalesAmount) AS Revenue
FROM
	(SELECT concat(c.CompanyName, concat(' (' + c.FirstName + ' ', c.LastName + ')')), SOH.TotalDue
	 FROM SalesLT.SalesOrderHeader AS SOH
	 JOIN SalesLT.Customer AS c
	 ON SOH.CustomerID = c.CustomerID) AS CustomerSales(CompanyContact, SalesAmount)
GROUP BY CompanyContact
ORDER BY CompanyContact;
----------------------------------Lab 8-----------------------------------

--Retrieving Regional Sales Totals
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca
ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh
ON c.CustomerID = soh.CustomerID
-- Modify GROUP BY to use ROLLUP
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;

--Retrieving Regional Sales Totals (2)

SELECT a.CountryRegion, a.StateProvince,
IIF(GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1, 'Total', IIF(GROUPING_ID(a.StateProvince) = 1, a.CountryRegion + ' Subtotal', a.StateProvince + ' Subtotal')) AS Level,
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


--Retrieving Regional Sales Totals (3)
SELECT a.CountryRegion, a.StateProvince, a.City,
CHOOSE (1 + GROUPING_ID(a.CountryRegion) + GROUPING_ID(a.StateProvince) + GROUPING_ID(a.City),
        a.City + ' Subtotal', a.StateProvince + ' Subtotal',
        a.CountryRegion + ' Subtotal', 'Total') AS Level,
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


--Retrieving Customer Sales By Category
SELECT * FROM
(SELECT cat.ParentProductCategoryName, cust.CompanyName, sod.LineTotal
 FROM SalesLT.SalesOrderDetail AS sod
 JOIN SalesLT.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
 JOIN SalesLT.Customer AS cust ON  soh.CustomerID = cust.CustomerID
 JOIN SalesLT.Product AS prod ON sod.ProductID = prod.ProductID
 JOIN SalesLT.vGetAllCategories AS cat ON prod.ProductcategoryID = cat.ProductCategoryID) AS catsales
PIVOT (SUM(LineTotal) FOR ParentProductCategoryName
IN ([Accessories], [Bikes], [Clothing], [Components])) AS pivotedsales
ORDER BY CompanyName;


----------------------------------Lab 9-----------------------------------

--Inserting Products (1)
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE());

-- Get last identity value that was inserted
SELECT SCOPE_IDENTITY();

-- Finish the SELECT statement
SELECT * FROM SalesLT.Product
WHERE ProductID = SCOPE_IDENTITY();


--Inserting Products (2)
-- Insert product category
INSERT INTO SalesLT.ProductCategory (ParentProductCategoryID, Name)
VALUES
(4, 'Bells and Horns');

-- Insert 2 products
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('Bicycle Bell', 'BB-RING', 2.47, 4.99, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE()),
('Bicycle Horn', 'BB-PARP', 1.29, 3.75, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE());

-- Check if products are properly inserted
SELECT c.Name As Category, p.Name AS Product
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory as c ON p.ProductCategoryID  = c.ProductCategoryID 
WHERE p.ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory');

--Updating Products
-- Update the SalesLT.Product table
UPDATE SalesLT.Product
SET ListPrice = ListPrice * 1.1
WHERE ProductCategoryID =
  (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');

  
  --Updating Products (2)
  UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductCategoryID = 37 AND ProductNumber <> 'LT-L123'

--Deleting Products
-- Delete records from the SalesLT.Product table
DELETE FROM SalesLT.Product
WHERE ProductCategoryID =
	(SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');

-- Delete records from the SalesLT.ProductCategory table
DELETE FROM SalesLT.ProductCategory
WHERE ProductCategoryID =
	(SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');
	
	
----------------------------------Lab 10-----------------------------------


--Writing a Script to Insert an Order Header
DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate  datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID  int = 1;

INSERT INTO SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');

PRINT SCOPE_IDENTITY();

--Extend Script to Insert an Order Detail
-- Code from previous exercise
DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID int = 1;
INSERT INTO SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');
DECLARE @OrderID int = SCOPE_IDENTITY();

-- Additional script to complete
DECLARE @ProductID int = 760;
DECLARE @Quantity int = 1;
DECLARE @UnitPrice money = 782.99;

IF EXISTS  (SELECT * FROM SalesLT.SalesOrderHeader  WHERE SalesOrderID  = @SalesOrderID)
BEGIN
	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice)
	VALUES (@OrderID, @Quantity, @ProductID, @UnitPrice)
END
ELSE
BEGIN
	PRINT 'The order does not exist'
END

--Updating Bike Prices
DECLARE @MarketAverage money = 2000;
DECLARE @MarketMax money = 5000;
DECLARE @AWMax money;
DECLARE @AWAverage money;

SELECT @AWAverage = AVG(ListPrice), @AWMax = MAX(ListPrice)
FROM SalesLT.Product
WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

WHILE @AWAverage < @MarketAverage
BEGIN
   UPDATE SalesLT.Product
   SET ListPrice = ListPrice * 1.1
   WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

	SELECT @AWAverage = AVG(ListPrice), @AWMax = MAX(ListPrice)
	FROM SalesLT.Product
	WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

   IF @AWMax >= @MarketMax
      BREAK
   ELSE
      CONTINUE
END

PRINT 'New average bike price:' + CONVERT(VARCHAR, @AWAverage);
PRINT 'New maximum bike price:' + CONVERT(VARCHAR, @AWMax);
----------------------------------Lab 11-----------------------------------
-- Logging Errors
DECLARE @OrderID int = 0

-- Declare a custom error if the specified order doesn't exist
declare @error VARCHAR(25) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
BEGIN
  THROW 50001, @error, 0;
END
ELSE
BEGIN
  SELECT FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID;
  DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID;
END


--Logging Errors(2)

DECLARE @OrderID int = 71774
DECLARE @error VARCHAR(25) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

-- Wrap IF ELSE in a TRY block
BEGIN TRY
  IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
  BEGIN
    THROW 50001, @error, 0
  END
  ELSE
  BEGIN
    DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID;
    DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID;
  END
END TRY
-- Add a CATCH block to print out the error
BEGIN CATCH
PRINT ERROR_MESSAGE();
END CATCH


--Ensuring Data Consistency
DECLARE @OrderID int = 0
DECLARE @error VARCHAR(25) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

BEGIN TRY
  IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
  BEGIN
    THROW 50001, @error, 0
  END
  ELSE
  BEGIN
    BEGIN TRANSACTION
    DELETE FROM SalesLT.SalesOrderDetail
    WHERE SalesOrderID = @OrderID;
    DELETE FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @OrderID;
    COMMIT TRANSACTION
  END
END TRY
BEGIN CATCH
  IF @@TRANCOUNT > 0
  BEGIN
    ROLLBACK TRANSACTION;;
  END
  ELSE
  BEGIN
    PRINT ERROR_MESSAGE();
  END
END CATCH
----------------------------------Ass 1-----------------------------------


--Select the quantity per unit for all products in the Products table.
SELECT QuantityPerUnit FROM DBO.PRODUCTS 

--Select the unique category IDs from the Products table.
SELECT DISTINCT CategoryID FROM PRODUCTS

--Select the names of products from the Products table which have more than 20 units left in stock.
SELECT ProductName FROM PRODUCTS WHERE UnitsInStock>20

--Select the product ID, product name, and unit price of the 10 most expensive products from the Products table.
SELECT Top 10 ProductID,ProductName,UnitPrice FROM Products order by UnitPrice 
desc

--Select the product ID, product name, and quantity per unit for all products in the Products table. Sort your results alphabetically by product name.
select ProductID,ProductName,QuantityPerUnit from products order by ProductName

--Select the product ID, product name, and unit price of all products in the Products table. Sort your results by number of units in stock, from greatest to least.
--Skip the first 10 results and get the next 5 after that.
select ProductID,ProductName,UnitPrice 
 from products order by UnitsInStock desc
 offset 10 rows fetch next 5 rows only
 
 --<<FirstName>> has an EmployeeID of <<EmployeeID>> and was born <<BirthDate>>
 SELECT FirstName +' has an EmployeeID of ' +CAST(EmployeeID AS VarChar(5)) +' and 
 was born '+CONVERT(NVARCHAR(30), BirthDate, 126) AS Employees FROM Employees

 --<<ShipName>> is from <<ShipCity or ShipRegion or ShipCountry>>
 SELECT 
ShipName + ' is from ' + COALESCE(ShipCity, ShipRegion,ShipCountry) AS destination
FROM Orders

--Select the ship name and ship postal code from the Orders table. If the postal code is missing, display 'unknown'.
SELECT ShipName , ISNULL(ShipPostalCode, 'unknown') 
FROM  ORDERS

--Using the Suppliers table, select the company name, and use a simple CASE expression to display 'outdated' if the company has a fax number, or 'modern' if it doesn't. Alias the result of the CASE expression to Status.
SELECT CompanyName,
    CASE
       WHEN Fax IS NULL THEN 'modern'
     ELSE 'outdated'
   END AS Status
FROM Suppliers;


----------------------------------Ass 2-----------------------------------

--Get the order ID and unit price for each order by joining the Orders table and the Order Details table
select o.OrderID,od.UnitPrice
from orders as o
join [order details] as od
on o.OrderID=od.OrderID

--Get the order ID and first name of the associated employee by joining the Orders and Employees tables.
select o.OrderID,e.FirstName
from orders as o
join employees as e
on o.EmployeeID=e.EmployeeID

--Get the employee ID and related territory description for each territory an employee is in, by joining the Employees, EmployeeTerritories and Territories tables.
select e.EmployeeID,td.TerritoryDescription
from employees as e
join employeeterritories as et
on e.EmployeeID = et.EmployeeID
join territories as td
on td.TerritoryID=et.TerritoryID

--Select all the different countries from the Customers table and the Suppliers table using UNION.
select distinct Country from Customers
union
select distinct Country from Suppliers

--Select all the countries, including duplicates, from the Customers table and the Suppliers table using UNION ALL.
select Country from Customers
union all
select  Country from Suppliers

--Using the Products table, get the unit price of each product, rounded to the nearest dollar.
select round(UnitPrice,0) from products

--Using the Products table, get the total number of units in stock across all products.
select SUM(UnitsInStock) from Products;

--Using the Orders table, get the order ID and year of the order by using YEAR(). Alias the year as OrderYear.
select OrderID,year(OrderDate) as  OrderYear
from orders

--Using the Orders table, get the order ID and month of the order by using DATENAME(). Alias the month as OrderMonth.
select OrderID,DATENAME(m,OrderDate) as  OrderMonth
from orders

--Use LEFT() to get the first two letters of each region description from the Region table.
select left(RegionDescription,2) from region

--Using the Suppliers table, select the city and postal code for each supplier, using WHERE and ISNUMERIC() to select only those postal codes which have no letters in them.
select City,PostalCode 
from suppliers
WHERE ISNUMERIC(PostalCode) = 1


--Use LEFT() and UPPER() to get the first letter (capitalized) of each region description from the Region table.
select upper(left(RegionDescription,1)) from region


----------------------------------Ass 3-----------------------------------

--Use a subquery to get the product name and unit price of products from the Products table which have a unit price greater than the average unit price from the Order Details table.
select ProductName,UnitPrice
from products where UnitPrice > (
select avg(UnitPrice) from [Order Details]
)

--Select from the Employees and Orders tables. Use a subquery to get the first name and employee ID for employees who were associated with orders which shipped from the USA.
select EmployeeID,FirstName
from employees where EmployeeID in(
select EmployeeID from orders where ShipCountry='USA'
)

--Create a new temporary table called ProductNames which has one field called ProductName (a VARCHAR of max length 40). Insert into this table the names of every product from the Products table. Select all columns from the ProductNames table you created.
create table #ProductNames(ProductName varchar(40))

insert into #ProductNames
select ProductName from products

select * from #ProductNames


----------------------------------Ass 4-----------------------------------

--Use CHOOSE() and MONTH() to get the season in which each order was shipped from the Orders table.
select OrderID,ShippedDate,
CHOOSE(MONTH(ShippedDate),'Winter', 'Winter', 'Spring', 'Spring', 'Spring', 'Summer', 'Summer', 'Summer', 'Autumn', 'Autumn', 'Autumn', 'Winter') as ShippedSeason
from orders
where ShippedDate is not null;


--Using the Suppliers table, select the company name and use a simple IIF expression to display 'outdated'
SELECT CompanyName,
IIF(Fax IS NULL, 'modern', 'outdated' ) as Status
FROM SUPPLIERS


--Select from the Customers, Orders, and Order Details tables. Note that you need to use [Order Details] since the table name contains whitespace
SELECT c.Country , SUM(od.Quantity) AS TotalQuantity
FROM DBO.Customers AS c
JOIN DBO.orders AS o
ON c.CustomerID = o.CustomerID
JOIN DBO.[Order Details] AS od
ON od.OrderID = o.OrderID
-- Modify GROUP BY to use ROLLUP
GROUP BY ROLLUP(c.Country)
ORDER BY c.Country;

--From the Customers table, use GROUP BY to select the country, contact title, and count of that contact title aliased as Count, grouped by country and contact title (in that order


--Convert the following query to be pivoted, using PIVOT()

--Insert into the Region table the region ID 5 and the description 'Space'
insert into Region values(5,'Space');
select * from Region where regionID=5;




--Update the region descriptions in the Region table to be all uppercase, using SET and UPPER().
update DBO.Region 
SET RegionDescription=UPPER(RegionDescription);
select * from region;


--Declare a custom region @region called 'Space', of type NVARCHAR(25).
