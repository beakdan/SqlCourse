USE AdventureWorks2016CTP3;
GO

SELECT
	soh.SalesOrderID,
	soh.OrderDate,
	--soh.CustomerID,
	--CONCAT(per.FirstName, ' ', per.MiddleName + ' ', per.LastName) AS FullName,
	CONCAT_WS(' ', cper.FirstName, cper.MiddleName, cper.LastName) AS CustomerFullName,
	--soh.SalesPersonID,
	CONCAT_WS(' ', sper.FirstName, sper.MiddleName, sper.LastName) AS SalesPersonFullName,
	--soh.TerritoryID,
	ster.Name AS TerritoryName,
	ster.CountryRegionCode,
	--soh.ShipToAddressID,
	CONCAT_WS(',', CONCAT_WS(' ', paddr.AddressLine1, paddr.AddressLine2), 
		paddr.City, psp.Name, paddr.PostalCode) AS ShipToAddress,
	--soh.CurrencyRateID,
	curr.FromCurrencyCode, curr.ToCurrencyCode,
	soh.SubTotal,
	soh.TaxAmt,
	soh.Freight,
	soh.TotalDue,
	ppr.Name AS ProductName,
	top_prod.item_count,
	top_prod.top_item_price
FROM
	Sales.SalesOrderHeader soh
	INNER JOIN Sales.Customer cus
		INNER JOIN Person.Person cper
			ON cper.BusinessEntityID = cus.PersonID
		ON cus.CustomerID = soh.CustomerID
	LEFT JOIN Person.Person sper
		ON sper.BusinessEntityID = soh.SalesPersonID	--soh.SalesPersonID Admits NULL values
	LEFT JOIN Sales.SalesTerritory ster
		ON ster.TerritoryID = soh.TerritoryID	--soh.TerritoryID Admits NULL values
	INNER JOIN Person.Address paddr
		INNER JOIN Person.StateProvince psp
			ON psp.StateProvinceID = paddr.StateProvinceID
		ON paddr.AddressID = soh.ShipToAddressID
	LEFT JOIN Sales.CurrencyRate curr
		ON curr.CurrencyRateID = soh.CurrencyRateID
	--CROSS APPLY	-- INNER JOIN
	OUTER APPLY (	-- LEFT JOIN
		SELECT	TOP(1)
				ProductID,
				UnitPrice AS top_item_price,
				COUNT(*) OVER() AS item_count
		FROM	Sales.SalesOrderDetail sod-- WITH(FORCESEEK)
		WHERE	sod.SalesOrderID = soh.SalesOrderID
		ORDER BY
				UnitPrice DESC
	) top_prod
	INNER JOIN Production.Product ppr
		ON ppr.ProductID = top_prod.ProductID
WHERE
	soh.OrderDate >= '20140301'
	AND soh.OrderDate < '20140401'
ORDER BY
	soh.SalesOrderID;
