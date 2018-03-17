--Unpivot clause
SELECT	*
FROM	dbo.pivoted_data
UNPIVOT ([value] FOR [month] IN(
		Total, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, [Dec]
	)) pvt

--Clasic unpivot with CASE
SELECT	pd.[Year],
		x.[value],
		CASE x.[value]
			WHEN 'Total' THEN Total
			WHEN 'Jan' THEN Jan
			WHEN 'Feb' THEN Feb
			WHEN 'Mar' THEN Mar
			WHEN 'Apr' THEN Apr
			WHEN 'May' THEN May
			WHEN 'Jun' THEN Jun
			WHEN 'Jul' THEN Jul
			WHEN 'Aug' THEN Aug
			WHEN 'Sep' THEN Sep
			WHEN 'Oct' THEN Oct
			WHEN 'Nov' THEN Nov
			WHEN 'Dec' THEN [Dec]
		END AS [Value]
FROM	dbo.pivoted_data pd
		CROSS JOIN (SELECT TOP(13) * FROM STRING_SPLIT('Total,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec', ',')) x
