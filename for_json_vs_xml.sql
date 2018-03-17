USE AdventureWorks2016CTP3
GO

SELECT
	TOP(10)
	soh.SalesOrderID,
	soh.OrderDate,
	soh.SubTotal	AS [money.SubTotal],
	soh.TaxAmt		AS [money.TaxAmt],
	soh.Freight		AS [money.Freight],
	soh.TotalDue	AS [money.TotalDue],
	(
		SELECT
			cper.FirstName, cper.MiddleName, cper.LastName,
			Email.EmailAddress AS [Address],
			Email.ModifiedDate
		FROM
			Sales.Customer cus
			INNER JOIN Person.Person cper
				ON cper.BusinessEntityID = cus.PersonID
			INNER JOIN Person.EmailAddress Email
				ON Email.BusinessEntityID = cper.BusinessEntityID
		WHERE
			cus.CustomerID = soh.CustomerID
		FOR JSON AUTO
	) Person
FROM
	Sales.SalesOrderHeader soh
--WHERE
--	soh.SalesOrderID = 67614
FOR JSON PATH--, ROOT('Dummy')--, WITHOUT_ARRAY_WRAPPER;

SELECT
	soh.SalesOrderID,
	soh.OrderDate,
	soh.SubTotal	AS [money/data()],
	soh.TaxAmt		AS [money/data()],
	soh.Freight		AS [money/data()],
	soh.TotalDue	AS [money/data()],
	CONCAT_WS(' ', cper.FirstName, cper.MiddleName, cper.LastName) AS CustomerFullName
FROM
	Sales.SalesOrderHeader soh
	INNER JOIN Sales.Customer cus
		INNER JOIN Person.Person cper
			ON cper.BusinessEntityID = cus.PersonID
		ON cus.CustomerID = soh.CustomerID
WHERE
	soh.SalesOrderID = 67614
FOR XML PATH--, ROOT('Dummy')--, WITHOUT_ARRAY_WRAPPER;

