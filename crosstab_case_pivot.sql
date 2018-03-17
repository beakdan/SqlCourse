WITH pre_format AS (
	SELECT
		YEAR(ModifiedDate)					 AS [Year],
		MONTH(ModifiedDate)					 AS [Month],
		LineTotal
	FROM
		Sales.SalesOrderDetail
),
group_data AS (
	SELECT
		IIF(GROUPING_ID([Year]) = 1, 'Total', CAST([Year] AS CHAR(4))) AS [Year], 
		IIF(GROUPING_ID([Month]) = 1, 'Total', 
			CHOOSE([Month], 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')
		) AS [Month], 
		SUM(LineTotal) AS LineTotal
	FROM
		pre_format
	GROUP BY
		GROUPING SETS (
			([Year], [Month]),
			([Year]),
			([Month]),()
		)
)
SELECT	*
--INTO	dbo.pivoted_data	--Save to have something to unpivot
FROM	group_data
PIVOT(SUM(LineTotal) FOR [Month] IN(
			[Total],[Jan],[Feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[Sep],[Oct],[Nov],[Dec]
		)) pvt;
--DROP TABLE dbo.pivoted_data
