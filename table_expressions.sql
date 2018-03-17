USE AdventureWorks2016CTP3;
GO

SELECT
	YEAR(ModifiedDate)					 AS [Year],
	DATEPART([QUARTER], ModifiedDate)	 AS [Quarter],
	MONTH(ModifiedDate)					 AS [Month],
	SUM(OrderQty),
	SUM(LineTotal)
FROM
	Sales.SalesOrderDetail
GROUP BY
	YEAR(ModifiedDate),
	DATEPART([QUARTER], ModifiedDate),
	MONTH(ModifiedDate);

--Derived table
SELECT	[Year], [Quarter], [Month],
		SUM(OrderQty)	AS OrderQty,
		SUM(LineTotal)	AS LineTotal
FROM	(
			SELECT
				YEAR(ModifiedDate)					 AS [Year],
				DATEPART([QUARTER], ModifiedDate)	 AS [Quarter],
				MONTH(ModifiedDate)					 AS [Month],
				OrderQty,
				LineTotal
			FROM
				Sales.SalesOrderDetail
		) grp
GROUP BY
		[Year], [Quarter], [Month];


--Common table expression
WITH [grouping] AS (
	SELECT
		YEAR(ModifiedDate)					 AS [Year],
		DATEPART([QUARTER], ModifiedDate)	 AS [Quarter],
		MONTH(ModifiedDate)					 AS [Month],
		OrderQty,
		LineTotal
	FROM
		Sales.SalesOrderDetail
)
SELECT	[Year], [Quarter], [Month],
		SUM(OrderQty)	AS OrderQty,
		SUM(LineTotal)	AS LineTotal
FROM	[grouping] grp
GROUP BY
		[Year], [Quarter], [Month];
