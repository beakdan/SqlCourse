USE AdventureWorks2016CTP3;
GO

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
SELECT	CASE
			WHEN GROUPING_ID([Year]) = 1 THEN 'Grand Total'
			WHEN GROUPING_ID([Quarter]) = 1 THEN  FORMAT([Year], 'Total 0000')
			ELSE CAST([Year] AS CHAR(4))
		END	AS [Year],
		--GROUPING_ID([Quarter]),
		--GROUPING_ID([Month]),
		--[Year], 
		ISNULL(CASE
			WHEN GROUPING_ID([Month]) = 1 THEN FORMAT([Quarter], 'Total Q0')
			ELSE FORMAT([Quarter], '\Q0')
		END, '') AS [Quarter],
		--[Month],
		--ISNULL(SUBSTRING('JanFebMarAprMayJunJulAugSepOctNovDec', (([Month]-1) * 3) + 1, 3), '') AS [Month],
		ISNULL(CHOOSE([Month], 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'), '') AS [Month],
		SUM(OrderQty)	AS OrderQty,
		SUM(LineTotal)	AS LineTotal
FROM	[grouping] grp
GROUP BY
		GROUPING SETS(
			([Year], [Quarter], [Month]),
			([Year], [Quarter]),
			([Year])
		)	
		--[Year], [Quarter], [Month]
		--WITH ROLLUP;

