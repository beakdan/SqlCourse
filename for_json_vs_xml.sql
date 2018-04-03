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

USE AdventureWorks2016CTP3
GO

SELECT
	TOP(10)
	soh.SalesOrderID,
	soh.OrderDate,
	soh.SubTotal	AS [Money/@SubTotal],
	soh.TaxAmt		AS [Money/@TaxAmt],
	soh.Freight		AS [Money/@Freight],
	soh.TotalDue	AS [Money/@TotalDue],
	(
		SELECT
			Person.FirstName, Person.MiddleName, Person.LastName,
			Email.EmailAddress AS [Address],
			Email.ModifiedDate
		FROM
			Sales.Customer cus
			INNER JOIN Person.Person Person
				ON Person.BusinessEntityID = cus.PersonID
			INNER JOIN Person.EmailAddress Email
				ON Email.BusinessEntityID = Person.BusinessEntityID
		WHERE
			cus.CustomerID = soh.CustomerID
		FOR XML AUTO, TYPE
	)-- Person
FROM
	Sales.SalesOrderHeader soh
FOR XML PATH('Order'), ROOT('Orders') --, XMLSCHEMA
