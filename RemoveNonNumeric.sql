DECLARE @textval NVARCHAR(30)
SET @textval = 'AB ABCDE # 123'

SELECT LEFT(SUBSTRING(@textval, PATINDEX('%[0-9.-]%', @textval), 8000),
           PATINDEX('%[^0-9.-]%', SUBSTRING(@textval, PATINDEX('%[0-9.-]%', @textval), 8000) + 'X') -1)