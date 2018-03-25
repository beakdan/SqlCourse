DECLARE @JSonData AS NVARCHAR(MAX) = N'[
	{
		"SalesOrderID":43659,
		"OrderDate":"2011-05-31T00:00:00",
		"money":{"SubTotal":20565.6206,"TaxAmt":1971.5149,"Freight":616.0984,"TotalDue":23153.2339},
		"Person":[
			{
				"FirstName":"James",
				"LastName":"Hendergart",
				"Email":[
					{
						"Address":"james9@adventure-works.com",
						"ModifiedDate":"2011-05-31T00:00:00"
					},
					{
						"Address":"james9@gmail.com",
						"ModifiedDate":"2011-05-31T00:00:00"
					}
				]
			}
		]
	},
	{"SalesOrderID":43660,"OrderDate":"2011-05-31T00:00:00","money":{"SubTotal":1294.2529,"TaxAmt":124.2483,"Freight":38.8276,"TotalDue":1457.3288},"Person":[{"FirstName":"Takiko","MiddleName":"J.","LastName":"Collins","Email":[{"Address":"takiko0@adventure-works.com","ModifiedDate":"2011-05-31T00:00:00"}]}]},{"SalesOrderID":43661,"OrderDate":"2011-05-31T00:00:00","money":{"SubTotal":32726.4786,"TaxAmt":3153.7696,"Freight":985.5530,"TotalDue":36865.8012},"Person":[{"FirstName":"Jauna","MiddleName":"E.","LastName":"Elson","Email":[{"Address":"jauna0@adventure-works.com","ModifiedDate":"2011-05-31T00:00:00"}]}]},{"SalesOrderID":43662,"OrderDate":"2011-05-31T00:00:00","money":{"SubTotal":28832.5289,"TaxAmt":2775.1646,"Freight":867.2389,"TotalDue":32474.9324},"Person":[{"FirstName":"Robin","MiddleName":"M.","LastName":"McGuigan","Email":[{"Address":"robin0@adventure-works.com","ModifiedDate":"2011-05-31T00:00:00"}]}]},{"SalesOrderID":43663,"OrderDate":"2011-05-31T00:00:00","money":{"SubTotal":419.4589,"TaxAmt":40.2681,"Freight":12.5838,"TotalDue":472.3108},"Person":[{"FirstName":"Jimmy","LastName":"Bischoff","Email":[{"Address":"jimmy1@adventure-works.com","ModifiedDate":"2011-05-31T00:00:00"}]}]},{"SalesOrderID":43664,"OrderDate":"2011-05-31T00:00:00","money":{"SubTotal":24432.6088,"TaxAmt":2344.9921,"Freight":732.8100,"TotalDue":27510.4109},"Person":[{"FirstName":"Sandeep","LastName":"Katyal","Email":[{"Address":"sandeep2@adventure-works.com","ModifiedDate":"2011-05-31T00:00:00"}]}]},{"SalesOrderID":43665,"OrderDate":"2011-05-31T00:00:00","money":{"SubTotal":14352.7713,"TaxAmt":1375.9427,"Freight":429.9821,"TotalDue":16158.6961},"Person":[{"FirstName":"Richard","LastName":"Bready","Email":[{"Address":"richard1@adventure-works.com","ModifiedDate":"2011-05-31T00:00:00"}]}]},{"SalesOrderID":43666,"OrderDate":"2011-05-31T00:00:00","money":{"SubTotal":5056.4896,"TaxAmt":486.3747,"Freight":151.9921,"TotalDue":5694.8564},"Person":[{"FirstName":"Abraham","MiddleName":"L.","LastName":"Swearengin","Email":[{"Address":"abraham0@adventure-works.com","ModifiedDate":"2011-05-31T00:00:00"}]}]},{"SalesOrderID":43667,"OrderDate":"2011-05-31T00:00:00","money":{"SubTotal":6107.0820,"TaxAmt":586.1203,"Freight":183.1626,"TotalDue":6876.3649},"Person":[{"FirstName":"Scott","LastName":"MacDonald","Email":[{"Address":"scott7@adventure-works.com","ModifiedDate":"2011-05-31T00:00:00"}]}]},{"SalesOrderID":43668,"OrderDate":"2011-05-31T00:00:00","money":{"SubTotal":35944.1562,"TaxAmt":3461.7654,"Freight":1081.8017,"TotalDue":40487.7233},"Person":[{"FirstName":"Ryan","LastName":"Calafato","Email":[{"Address":"ryan1@adventure-works.com","ModifiedDate":"2011-05-31T00:00:00"}]}]}]';

--JSON_QUERY	--Get a Json String
--JSON_VALUE	--Get specific value
-- $  Root or context element
-- .  Get an attribute of Json element
-- [ix] get specific element in array (zero based)

SELECT	*
FROM	OPENJSON(@JSonData)
		WITH(
			SalesOrderID	INTEGER			'$.SalesOrderID',
			OrderDate		DATETIME		'$.OrderDate',
			SubTotal		MONEY			'$.money.SubTotal',
			FirstName		NVARCHAR(50)	'$.Person[0].FirstName',
			LastName		NVARCHAR(50)	'$.Person[0].LastName',
			Person			NVARCHAR(MAX)	AS JSON
		) R
	CROSS APPLY (
		SELECT	TOP(10)*
		FROM	OPENJSON(JSON_QUERY(r.Person, '$[0].Email'))
		WITH(
			EmailAddress	NVARCHAR(50)	'$.Address',
			ModifiedDate	DATETIME		'$.ModifiedDate'
		)
	) eml;

SELECT	r.SalesOrderID, r.OrderDate, r.SubTotal, 
		p.FirstName, p.LastName, eml.*
FROM	OPENJSON(@JSonData)
		WITH(
			SalesOrderID	INTEGER			'$.SalesOrderID',
			OrderDate		DATETIME		'$.OrderDate',
			SubTotal		MONEY			'$.money.SubTotal',
			Person			NVARCHAR(MAX)	AS JSON
		) R
	CROSS APPLY (
		SELECT	TOP(1) *
		FROM	OPENJSON(r.Person)
		WITH(
			FirstName	NVARCHAR(50)	'$.FirstName',
			LastName	NVARCHAR(50)	'$.LastName',
			Email		NVARCHAR(MAX)	AS JSON
		)
	) p
	CROSS APPLY (
		SELECT	*
		FROM	OPENJSON(p.Email)
		WITH(
			EmailAddress	NVARCHAR(50)	'$.Address',
			ModifiedDate	DATETIME		'$.ModifiedDate'
		)
	) eml
GO
