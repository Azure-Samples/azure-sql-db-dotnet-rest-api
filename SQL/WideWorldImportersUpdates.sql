/*
	Create schema
*/
IF SCHEMA_ID('web') IS NULL BEGIN	
	EXECUTE('CREATE SCHEMA [web]');
END
GO

/*
	Create user to be used in the sample API solution
*/
IF USER_ID('DotNetWebApp') IS NULL BEGIN	
	CREATE USER [DotNetWebApp] WITH PASSWORD = 'a987REALLY#$%TRONGpa44w0rd!';	
END

/*
	Grant execute permission to created users
*/
GRANT EXECUTE ON SCHEMA::[web] TO [DotNetWebApp];
GO

/*
	Return details on a specific customer
*/
CREATE OR ALTER PROCEDURE web.get_customer
@Id INT
AS
SET NOCOUNT ON;
SELECT 
	[CustomerID], 
	[CustomerName], 
	[PhoneNumber], 
	[FaxNumber], 
	[WebsiteURL],
	[DeliveryAddressLine1] AS 'Delivery.AddressLine1',
	[DeliveryAddressLine2] AS 'Delivery.AddressLine2',
	[DeliveryPostalCode] AS 'Delivery.PostalCode'	
FROM 
	[Sales].[Customers] 
WHERE 
	[CustomerID] = @Id
FOR JSON PATH
GO

/*
	Delete a specific customer
*/
CREATE OR ALTER PROCEDURE web.delete_customer
@Id INT
AS
SET NOCOUNT ON;
DELETE FROM [Sales].[Customers] WHERE CustomerId = @Id;
SELECT * FROM (SELECT CustomerID = @Id) D FOR JSON AUTO;
GO

/*
	Update (Patch) a specific customer
*/
CREATE OR ALTER PROCEDURE web.patch_customer
@Id INT,
@Json NVARCHAR(MAX)
AS
SET NOCOUNT ON;
WITH [source] AS 
(
	SELECT * FROM OPENJSON(@Json) WITH (
		[CustomerID] INT, 
		[CustomerName] NVARCHAR(100), 
		[PhoneNumber] NVARCHAR(20), 
		[FaxNumber] NVARCHAR(20), 
		[WebsiteURL] NVARCHAR(256),
		[DeliveryAddressLine1] NVARCHAR(60) '$.Delivery.AddressLine1',
		[DeliveryAddressLine2] NVARCHAR(60) '$.Delivery.AddressLine2',
		[DeliveryPostalCode] NVARCHAR(10) '$.Delivery.PostalCode'	
	)
)
UPDATE
	t
SET
	t.[CustomerName] = COALESCE(s.[CustomerName], t.[CustomerName]),
	t.[PhoneNumber] = COALESCE(s.[PhoneNumber], t.[PhoneNumber]),
	t.[FaxNumber] = COALESCE(s.[FaxNumber], t.[FaxNumber]),
	t.[WebsiteURL] = COALESCE(s.[WebsiteURL], t.[WebsiteURL]),
	t.[DeliveryAddressLine1] = COALESCE(s.[DeliveryAddressLine1], t.[DeliveryAddressLine1]),
	t.[DeliveryAddressLine2] = COALESCE(s.[DeliveryAddressLine2], t.[DeliveryAddressLine2]),
	t.[DeliveryPostalCode] = COALESCE(s.[DeliveryPostalCode], t.[DeliveryPostalCode])
FROM
	[Sales].[Customers] t
INNER JOIN
	[source] s ON t.[CustomerID] = s.[CustomerID]
WHERE
	t.CustomerId = @Id;

EXEC web.get_customer @Id;
GO

/*
	Create a new customer
*/

CREATE OR ALTER PROCEDURE web.put_customer
@Json NVARCHAR(MAX)
AS
SET NOCOUNT ON;
DECLARE @CustomerId INT = NEXT VALUE FOR Sequences.CustomerID;
WITH [source] AS 
(
	SELECT @Id AS CustomerID, * FROM OPENJSON(@Json) WITH (		
		[CustomerName] NVARCHAR(100), 
		[PhoneNumber] NVARCHAR(20), 
		[FaxNumber] NVARCHAR(20), 
		[WebsiteURL] NVARCHAR(256),
		[DeliveryAddressLine1] NVARCHAR(60) '$.Delivery.AddressLine1',
		[DeliveryAddressLine2] NVARCHAR(60) '$.Delivery.AddressLine2',
		[DeliveryPostalCode] NVARCHAR(10) '$.Delivery.PostalCode'	
	)
)
INSERT INTO [Sales].[Customers] 
(
	CustomerID, 
	CustomerName, 	
	BillToCustomerID, 
	CustomerCategoryID,	
	PrimaryContactPersonID,
	DeliveryMethodID,
	DeliveryCityID,
	PostalCityID,
	AccountOpenedDate,
	StandardDiscountPercentage,
	IsStatementSent,
	IsOnCreditHold,
	PaymentDays,
	PhoneNumber, 
	FaxNumber, 
	WebsiteURL, 
	DeliveryAddressLine1, 
	DeliveryAddressLine2, 
	DeliveryPostalCode,
	PostalAddressLine1, 
	PostalAddressLine2, 
	PostalPostalCode,
	LastEditedBy
)
SELECT
	@CustomerId, 
	CustomerName, 
	@CustomerId, 
	5, -- Computer Shop
	1, -- No contact person
	1, -- Post Delivery 
	28561, -- Redmond
	28561, -- Redmond
	SYSUTCDATETIME(),
	0.00,
	0,
	0,
	30,
	PhoneNumber, 
	FaxNumber, 
	WebsiteURL, 
	DeliveryAddressLine1, 
	DeliveryAddressLine2, 
	DeliveryPostalCode,
	DeliveryAddressLine1, 
	DeliveryAddressLine2, 
	DeliveryPostalCode,
	1 
FROM
	[source]
;

EXEC web.get_customer @CustomerId;
GO

CREATE OR ALTER PROCEDURE web.get_customers
AS
SET NOCOUNT ON;
-- Cast is needed to corretly inform the driver  
-- that output type is NVARCHAR(MAX)
-- to make sure it won't be truncated
SELECT CAST((
	SELECT 
		[CustomerID], 
		[CustomerName]
	FROM 
		[Sales].[Customers] 
	FOR JSON PATH) AS NVARCHAR(MAX)) AS JsonResult
GO
