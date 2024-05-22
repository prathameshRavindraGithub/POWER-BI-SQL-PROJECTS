-- Create an Employee table.
CREATE TABLE dbo.MyEmployees
(
EmployeeID SMALLINT NOT NULL,
FirstName NVARCHAR(30) NOT NULL,
LastName NVARCHAR(40) NOT NULL,
Title NVARCHAR(50) NOT NULL,
DeptID SMALLINT NOT NULL,
ManagerID SMALLINT NULL,
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC),
CONSTRAINT FK_MyEmployees_ManagerID_EmployeeID FOREIGN KEY (ManagerID) REFERENCES dbo.MyEmployees (EmployeeID)
);
-- Populate the table with values.
INSERT INTO dbo.MyEmployees VALUES
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16, NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales', 3, 1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager', 3, 273)
,(275, N'Michael', N'Blythe', N'Sales Representative', 3, 274)
,(276, N'Linda', N'Mitchell', N'Sales Representative', 3, 274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager', 3, 273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative', 3, 285)
,(16, N'David', N'Bradley', N'Marketing Manager', 4, 273)
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);
/*
The following example shows the hierarchical list of 
managers and the employees who report to them. 
*/
WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel) AS
(
    SELECT ManagerID, EmployeeID, Title, 0 AS EmployeeLevel
    FROM dbo.MyEmployees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel + 1
    FROM dbo.MyEmployees AS e
        INNER JOIN DirectReports AS d
        ON e.ManagerID = d.EmployeeID
)
SELECT ManagerID,EmployeeID, Title, EmployeeLevel
FROM DirectReports
ORDER BY ManagerID;

/*
Use a recursive common table expression to display 
two levels of recursion
The following example shows managers and the employees 
reporting to them. The number of levels returned is 
limited to two.
*/
WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel) AS
(
    SELECT ManagerID, EmployeeID, Title, 0 AS EmployeeLevel
    FROM dbo.MyEmployees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel + 1
    FROM dbo.MyEmployees AS e
        INNER JOIN DirectReports AS d
        ON e.ManagerID = d.EmployeeID
)
SELECT ManagerID, EmployeeID, Title, EmployeeLevel
FROM DirectReports
WHERE EmployeeLevel <= 2 ;
/*
Use a recursive common table expression to display a 
hierarchical list
The following example adds the names of the manager 
and employees, and their respective titles. 
The hierarchy of managers and employees is additionally
emphasized by indenting each level.
*/
WITH DirectReports(Name, Title, EmployeeID, EmployeeLevel, Sort)
AS (SELECT CONVERT(VARCHAR(255), e.FirstName + ' ' + e.LastName),
        e.Title,
        e.EmployeeID,
        1,
        CONVERT(VARCHAR(255), e.FirstName + ' ' + e.LastName)
    FROM dbo.MyEmployees AS e
    WHERE e.ManagerID IS NULL
    UNION ALL
    SELECT CONVERT(VARCHAR(255), REPLICATE ('|    ' , EmployeeLevel) +
        e.FirstName + ' ' + e.LastName),
        e.Title,
        e.EmployeeID,
        EmployeeLevel + 1,
        CONVERT (VARCHAR(255), RTRIM(Sort) + '|    ' + FirstName + ' ' +
                 LastName)
    FROM dbo.MyEmployees AS e
    JOIN DirectReports AS d ON e.ManagerID = d.EmployeeID
    )
SELECT EmployeeID, Name, Title, EmployeeLevel
FROM DirectReports
ORDER BY Sort;
/*
Use MAXRECURSION to cancel a statement
MAXRECURSION can be used to prevent a poorly formed 
recursive CTE from entering into an infinite loop. 
The following example intentionally creates an infinite 
loop and uses the MAXRECURSION hint to limit the number 
of recursion levels to two.
*/
--Creates an infinite loop
WITH cte (EmployeeID, ManagerID, Title) AS
(
    SELECT EmployeeID, ManagerID, Title
    FROM dbo.MyEmployees
    WHERE ManagerID IS NOT NULL
  UNION ALL
    SELECT cte.EmployeeID, cte.ManagerID, cte.Title
    FROM cte
    JOIN dbo.MyEmployees AS e
        ON cte.ManagerID = e.EmployeeID
)
--Uses MAXRECURSION to limit the recursive levels to 2
SELECT EmployeeID, ManagerID, Title
FROM cte
OPTION (MAXRECURSION 2);
/*
After the coding error is corrected, 
MAXRECURSION is no longer required. 
The following example shows the corrected code.
*/
WITH cte (EmployeeID, ManagerID, Title)
AS
(
    SELECT EmployeeID, ManagerID, Title
    FROM dbo.MyEmployees
    WHERE ManagerID IS NOT NULL
  UNION ALL
    SELECT e.EmployeeID, e.ManagerID, e.Title
    FROM dbo.MyEmployees AS e
    JOIN cte ON e.ManagerID = cte.EmployeeID
)
SELECT EmployeeID, ManagerID, Title
FROM cte;

/*
H. Use multiple anchor and recursive members
The following example uses multiple anchor and recursive
members to return all the ancestors of a specified person.
A table is created and values inserted to establish the 
family genealogy returned by the recursive CTE.
*/
-- Genealogy table
IF OBJECT_ID('dbo.Person','U') IS NOT NULL DROP TABLE dbo.Person;
GO
CREATE TABLE dbo.Person(ID int, Name VARCHAR(30), Mother INT, Father INT);
GO
INSERT dbo.Person
VALUES(1, 'Sue', NULL, NULL)
      ,(2, 'Ed', NULL, NULL)
      ,(3, 'Emma', 1, 2)
      ,(4, 'Jack', 1, 2)
      ,(5, 'Jane', NULL, NULL)
      ,(6, 'Bonnie', 5, 4)
      ,(7, 'Bill', 5, 4);
GO
-- Create the recursive CTE to find all of Bonnie's ancestors.
WITH Generation (ID) AS
(
-- First anchor member returns Bonnie's mother.
    SELECT Mother
    FROM dbo.Person
    WHERE Name = 'Bonnie'
UNION
-- Second anchor member returns Bonnie's father.
    SELECT Father
    FROM dbo.Person
    WHERE Name = 'Bonnie'
UNION ALL
-- First recursive member returns male ancestors of the previous generation.
    SELECT Person.Father
    FROM Generation, Person
    WHERE Generation.ID=Person.ID
UNION ALL
-- Second recursive member returns female ancestors of the previous generation.
    SELECT Person.Mother
    FROM Generation, dbo.Person
    WHERE Generation.ID=Person.ID
)
SELECT Person.ID, Person.Name, Person.Mother, Person.Father
FROM Generation, dbo.Person
WHERE Generation.ID = Person.ID;
GO