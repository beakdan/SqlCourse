USE AdventureWorks2016CTP3;
GO

CREATE OR ALTER FUNCTION dbo.TestTableFn (
    @LastName	NVARCHAR(50),
    @FirstName	NVARCHAR(50)
)
RETURNS @returntable TABLE (
	BusinessEntityID	INTEGER,
	LastName			NVARCHAR(50),
	FirstName			NVARCHAR(50),
	MiddleName			NVARCHAR(50)
)
AS
BEGIN
    INSERT @returntable
	SELECT	BusinessEntityID,
			LastName,
			FirstName,
			MiddleName
	FROM	Person.Person
	WHERE	LastName = @LastName
			AND (@FirstName IS NULL OR FirstName = @FirstName)
    RETURN 
END
GO

CREATE OR ALTER FUNCTION dbo.TestTableFnInline
(
    @LastName	NVARCHAR(50),
    @FirstName	NVARCHAR(50)
)
RETURNS TABLE AS RETURN
(
	SELECT	BusinessEntityID,
			LastName,
			FirstName,
			MiddleName
	FROM	Person.Person
	WHERE	EXISTS (
				SELECT	NULL
				WHERE	LastName = @LastName AND FirstName = @FirstName
						AND @LastName IS NOT NULL AND @FirstName IS NOT NULL
				UNION ALL
				SELECT	NULL
				WHERE	LastName = @LastName
						AND @LastName IS NOT NULL AND @FirstName IS NULL
				UNION ALL
				SELECT	NULL
				WHERE	FirstName = @FirstName
						AND @LastName IS NULL AND @FirstName IS NOT NULL
			)
	UNION ALL
	SELECT	BusinessEntityID,
			LastName,
			FirstName,
			MiddleName
	FROM	Person.Person
	WHERE	@LastName IS NULL AND @FirstName IS NULL
)
GO
/*
CREATE INDEX IX_Person_Person__K5
    ON Person.Person(FirstName);
GO
*/

SELECT	*
FROM	dbo.TestTableFnInline(NULL, NULL)

SELECT	*
FROM	dbo.TestTableFnInline('Diaz', NULL)

SELECT	*
FROM	dbo.TestTableFnInline(NULL, 'Aidan')

SELECT	*
FROM	dbo.TestTableFnInline('Diaz', 'Aidan')
GO

DECLARE @LastName	AS NVARCHAR(50),
		@FirstName	AS NVARCHAR(50);

SELECT	*
FROM	dbo.TestTableFnInline(@LastName, @FirstName)
OPTION(RECOMPILE)

SELECT @LastName	= 'Diaz',
	   @FirstName	= NULL;

SELECT	*
FROM	dbo.TestTableFnInline(@LastName, @FirstName)
OPTION(RECOMPILE)

SELECT @LastName	= NULL,
	   @FirstName	= 'Aidan';

SELECT	*
FROM	dbo.TestTableFnInline(@LastName, @FirstName)
OPTION(RECOMPILE)

SELECT @LastName	= 'Diaz',
	   @FirstName	= 'Aidan';

SELECT	*
FROM	dbo.TestTableFnInline(@LastName, @FirstName)
OPTION(RECOMPILE)
GO

DECLARE @LastName	AS NVARCHAR(50),
		@FirstName	AS NVARCHAR(50);

DECLARE @parameters AS NVARCHAR(4000) = N'@LastName NVARCHAR(50), @FirstName NVARCHAR(50)';
DECLARE @query AS NVARCHAR(MAX) = N'
SELECT	*
FROM	dbo.TestTableFnInline(' + IIF(@LastName IS NULL, 'NULL' , '@LastName') + 
			', ' + IIF(@FirstName IS NULL, 'NULL' , '@FirstName') + ')
';

EXECUTE sp_executesql
	@statement	= @query, 
	@parameters = @parameters,
	@LastName = @LastName,
	@FirstName = @FirstName;

SELECT @LastName	= 'Diaz',
	   @FirstName	= NULL;

SET @query = N'
SELECT	*
FROM	dbo.TestTableFnInline(' + IIF(@LastName IS NULL, 'NULL' , '@LastName') + 
			', ' + IIF(@FirstName IS NULL, 'NULL' , '@FirstName') + ')
';

EXECUTE sp_executesql
	@statement	= @query, 
	@parameters = @parameters,
	@LastName = @LastName,
	@FirstName = @FirstName;

SELECT @LastName	= NULL,
	   @FirstName	= 'Aidan';

SET @query = N'
SELECT	*
FROM	dbo.TestTableFnInline(' + IIF(@LastName IS NULL, 'NULL' , '@LastName') + 
			', ' + IIF(@FirstName IS NULL, 'NULL' , '@FirstName') + ')
';

EXECUTE sp_executesql
	@statement	= @query, 
	@parameters = @parameters,
	@LastName = @LastName,
	@FirstName = @FirstName;

SELECT @LastName	= 'Diaz',
	   @FirstName	= 'Aidan';

SET @query = N'
SELECT	*
FROM	dbo.TestTableFnInline(' + IIF(@LastName IS NULL, 'NULL' , '@LastName') + 
			', ' + IIF(@FirstName IS NULL, 'NULL' , '@FirstName') + ')';

EXECUTE sp_executesql
	@statement	= @query, 
	@parameters = @parameters,
	@LastName = @LastName,
	@FirstName = @FirstName;






SELECT	*
FROM	dbo.TestTableFn('Diaz', 'Aidan')



SELECT	*
FROM	Person.Person
WHERE	LastName = @LastName