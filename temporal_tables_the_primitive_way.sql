--Create a copy of Person table for testing purposes
SELECT	BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName
INTO	dbo.Person
FROM	Person.Person
GO

--Another copy of the structure for archiving
SELECT	BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName
INTO	dbo.Person_Hist
FROM	Person.Person
WHERE	1 = 0
GO

--Datetime columns to keep track of changes
IF COLUMNPROPERTY(OBJECT_ID(N'dbo.Person', N'U'), N'ValidFrom', N'ColumnId') IS NULL
BEGIN
	ALTER TABLE dbo.Person
		ADD	ValidFrom	DATETIME2(6) NOT NULL
				CONSTRAINT DF_dbo_Person__ValidFrom
				DEFAULT(SYSDATETIME()),
			ValidTo		DATETIME2(6) NOT NULL
				CONSTRAINT DF_dbo_Person__ValidTo
				DEFAULT('9999-12-31');
END;
GO

CREATE OR ALTER TRIGGER trgPersonKeepHist
ON dbo.Person
FOR DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
	INSERT INTO dbo.Person_hist
	SELECT	BusinessEntityID, PersonType, NameStyle, Title, FirstName,
			MiddleName, LastName, ValidFrom, SYSDATETIME()
	FROM	deleted

	UPDATE	dbo.Person
	SET		ValidFrom = DEFAULT
	FROM	dbo.Person upd
			INNER JOIN inserted d
				ON d.BusinessEntityID = upd.BusinessEntityID
END
GO

--Current snapshot is always the original table
SELECT	*
FROM	dbo.Person
ORDER BY
		validFrom DESC

--Make Some changes
UPDATE	dbo.Person
SET		MiddleName = 'M.'
WHERE	BusinessEntityId = 14233

INSERT dbo.Person(BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName)
VALUES(999999, 1, 2, 'Sra', 'Mary', 'Sol', 'Martinez');

DELETE	dbo.Person
WHERE	BusinessEntityId = 8515


--Get point in time snapshot
DECLARE @now AS DATETIME2(6) = DATEADD([MINUTE], -10, SYSDATETIME());
SELECT	*
FROM	dbo.Person
WHERE	ValidFrom <= @now 
		AND ValidTo > @now
UNION ALL
SELECT	*
FROM	dbo.Person_HIST
WHERE	ValidFrom <= @now 
		AND ValidTo > @now
ORDER BY
		validFrom DESC;


--? How could we avoid a truncate in main or hist table ?
--? Is it posible to stop user modifications on hist table ?
