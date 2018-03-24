DECLARE @XmlData AS XML = N'<Orders>
  <Order>
    <SalesOrderID>43659</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="20565.6206" TaxAmt="1971.5149" Freight="616.0984" TotalDue="23153.2339" />
    <Person FirstName="James" LastName="Hendergart">
      <Email Address="james9@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
  <Order>
    <SalesOrderID>43660</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="1294.2529" TaxAmt="124.2483" Freight="38.8276" TotalDue="1457.3288" />
    <Person FirstName="Takiko" MiddleName="J." LastName="Collins">
      <Email Address="takiko0@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
  <Order>
    <SalesOrderID>43661</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="32726.4786" TaxAmt="3153.7696" Freight="985.5530" TotalDue="36865.8012" />
    <Person FirstName="Jauna" MiddleName="E." LastName="Elson">
      <Email Address="jauna0@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
  <Order>
    <SalesOrderID>43662</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="28832.5289" TaxAmt="2775.1646" Freight="867.2389" TotalDue="32474.9324" />
    <Person FirstName="Robin" MiddleName="M." LastName="McGuigan">
      <Email Address="robin0@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
  <Order>
    <SalesOrderID>43663</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="419.4589" TaxAmt="40.2681" Freight="12.5838" TotalDue="472.3108" />
    <Person FirstName="Jimmy" LastName="Bischoff">
      <Email Address="jimmy1@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
  <Order>
    <SalesOrderID>43664</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="24432.6088" TaxAmt="2344.9921" Freight="732.8100" TotalDue="27510.4109" />
    <Person FirstName="Sandeep" LastName="Katyal">
      <Email Address="sandeep2@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
  <Order>
    <SalesOrderID>43665</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="14352.7713" TaxAmt="1375.9427" Freight="429.9821" TotalDue="16158.6961" />
    <Person FirstName="Richard" LastName="Bready">
      <Email Address="richard1@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
  <Order>
    <SalesOrderID>43666</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="5056.4896" TaxAmt="486.3747" Freight="151.9921" TotalDue="5694.8564" />
    <Person FirstName="Abraham" MiddleName="L." LastName="Swearengin">
      <Email Address="abraham0@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
  <Order>
    <SalesOrderID>43667</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="6107.0820" TaxAmt="586.1203" Freight="183.1626" TotalDue="6876.3649" />
    <Person FirstName="Scott" LastName="MacDonald">
      <Email Address="scott7@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
  <Order>
    <SalesOrderID>43668</SalesOrderID>
    <OrderDate>2011-05-31T00:00:00</OrderDate>
    <Money SubTotal="35944.1562" TaxAmt="3461.7654" Freight="1081.8017" TotalDue="40487.7233" />
    <Person FirstName="Ryan" LastName="Calafato">
      <Email Address="ryan1@adventure-works.com" ModifiedDate="2011-05-31T00:00:00" />
    </Person>
  </Order>
</Orders>';
DECLARE @docId AS INTEGER;

EXECUTE sp_xml_preparedocument @docId OUTPUT, @XmlData;   

SELECT    *  
FROM      OPENXML (@docId, '/Orders/Order')   
WITH (
	SalesOrderID	INTEGER			'SalesOrderID',
	OrderDate		DATETIME		'OrderDate',
	SubTotal		MONEY			'Money/@SubTotal',
	TaxAmt			MONEY			'Money/@TaxAmt',
	Freight			MONEY			'Money/@Freight',
	TotalDue		MONEY			'Money/@TotalDue',
	FirstName		NVARCHAR(50)	'Person/@FirstName',
	LastName		NVARCHAR(50)	'Person/@LastName',
	EmailAddress		NVARCHAR(50)	'Person/Email/@Address',
	EmailModifiedDate	DATETIME		'Person/Email/@ModifiedDate'
)

EXECUTE sp_xml_removedocument @docId;  
