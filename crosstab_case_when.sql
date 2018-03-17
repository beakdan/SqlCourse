--Crosstab Queries
-- PIVOT UNPIVOT
--SET 	STATISTICS TIME ON
WITH group_data AS (
	SELECT
		YEAR(ModifiedDate)					 AS [Year],
		--DATEPART([QUARTER], ModifiedDate)	 AS [Quarter],
		MONTH(ModifiedDate)					 AS [Month],
		OrderQty,
		LineTotal
	FROM
		Sales.SalesOrderDetail
)
SELECT	[Year],
		--Usin simple CASE WHEN has the advantage of allowing us
		--to pivot on more than one column or having differente aggregates
		SUM(CASE WHEN [Month] = 1 THEN LineTotal END)	AS [lt_1 ],
		SUM(CASE WHEN [Month] = 1 THEN OrderQty END)	AS [oq_1 ],

		SUM(CASE WHEN [Month] = 2 THEN LineTotal END)	AS [lt_2 ],
		SUM(CASE WHEN [Month] = 2 THEN OrderQty END)	AS [oq_2 ],

		SUM(CASE WHEN [Month] = 3 THEN LineTotal END)	AS [lt_3 ],
		SUM(CASE WHEN [Month] = 3 THEN OrderQty END)	AS [oq_3 ],

		SUM(CASE WHEN [Month] = 4 THEN LineTotal END)	AS [lt_4 ],
		SUM(CASE WHEN [Month] = 4 THEN OrderQty END)	AS [oq_4 ],

		SUM(CASE WHEN [Month] = 5 THEN LineTotal END)	AS [lt_5 ],
		SUM(CASE WHEN [Month] = 6 THEN LineTotal END)	AS [lt_6 ],
		SUM(CASE WHEN [Month] = 7 THEN LineTotal END)	AS [lt_7 ],
		SUM(CASE WHEN [Month] = 8 THEN LineTotal END)	AS [lt_8 ],
		SUM(CASE WHEN [Month] = 9 THEN LineTotal END)	AS [lt_9 ],
		SUM(CASE WHEN [Month] = 10 THEN LineTotal END)	AS [lt_10],
		SUM(CASE WHEN [Month] = 11 THEN LineTotal END)	AS [lt_11],
		SUM(CASE WHEN [Month] = 12 THEN LineTotal END)	AS [lt_12]
		--  null as x, null as y
FROM	group_data
GROUP BY
		[Year];