create or alter procedure dbo.GetSalesByYearQtr
as
begin
set nocount on;
with cte as (select year(orderdate) as yr,
case
when month(OrderDate) in (1,2,3) then 'Q4'
when month(OrderDate) in (4,5,6) then 'Q1'
when month(OrderDate) in (7,8,9) then 'Q2'
else 'Q3'
end as qtr,
(od.UnitPrice*od.Quantity)*(1-od.Discount) as TotalCost
from orders o join
[Order Details] od on
o.OrderID=od.OrderID)
select yr,qtr,round(sum(totalcost),2) as totalsales from cte
group by yr,qtr;
end
exec dbo.GetSalesByYearQtr

create or alter procedure dbo.GetSalesByQtr
@year int
as
begin
set nocount on;
with cte as (select year(orderdate) as yr,
case
when month(OrderDate) in (1,2,3) then 'Q4'
when month(OrderDate) in (4,5,6) then 'Q1'
when month(OrderDate) in (7,8,9) then 'Q2'
else 'Q3'
end as qtr,
(od.UnitPrice*od.Quantity)*(1-od.Discount) as TotalCost
from orders o join
[Order Details] od on
o.OrderID=od.OrderID)
select yr,qtr,round(sum(totalcost),2) as totalsales 
from cte where yr=@year
group by yr,qtr;
end
create or alter procedure divide(
@a int,
@b int,
@c int out
)
as 
begin
set @c=@a/@b
end
declare @output int;
exec dbo.divide 5,2,@output output;
print @output;
CREATE PROC usp_divide(
    @a decimal,
    @b decimal,
    @c decimal output
) AS
BEGIN
    BEGIN TRY
        SET @c = @a / @b;
    END TRY
    BEGIN CATCH
        SELECT  
            ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;  
    END CATCH
END;
drop table  if exists Projects;
create table Projects(
id int identity(1,1)  primary key,
ProjectName VARCHAR(500),
    ClientName VARCHAR(500),
    ProjectManagerId VARCHAR(500),
	CreatedDate DATETIME,
    ProjectDescription VARCHAR(500),
    StartDate DATETIME);
CREATE PROCEDURE InsertProject
    @ProjectName NVARCHAR(500),
    @ClientName NVARCHAR(500),
    @ProjectManagerId NVARCHAR(500),
    @ProjectDescription NVARCHAR(500) = NULL,
    @StartDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Projects
    (
        [ProjectName],
        [ClientName],
        [ProjectManagerId],
        [CreatedDate],
        [ProjectDescription],
        [StartDate]
    )
    VALUES
    (
        @ProjectName,
        @ClientName,
        @ProjectManagerId,
        GETUTCDATE(),
        @ProjectDescription,
        @StartDate
    )
END

EXEC InsertProject
    @ProjectName = 'Management Software',
    @ClientName = 'Shubham Mishra',
    @ProjectManagerId = 'A51DC085-073F-4D3A-AFC8-ACE61B89E8C8',
    @ProjectDescription = 'This is a sample Management Software.',
    @StartDate = '2023-01-20 12:45:00.000';

CREATE PROCEDURE GetAllProject

AS
BEGIN
    SET NOCOUNT ON;
   SELECT Id, ProjectName, ClientName,ProjectDescription,StartDate,CreatedDate from Projects
END

EXEC GetAllProject

CREATE PROCEDURE GetProjectByProjectId
     @Id INT
AS
BEGIN
    SET NOCOUNT ON;
   SELECT ProjectName,ClientName,ProjectDescription,CreatedDate from Projects
      WHERE Id = @Id;
END

EXEC GetProjectByProjectId @Id=1

CREATE PROCEDURE [UpdateProject]
     @id INT
	,@ProjectName NVARCHAR(500)
	,@ClientName NVARCHAR(500)
	,@ProjectManagerId NVARCHAR(500)
	,@ProjectDescription NVARCHAR(500)
	,@StartDate DATETIME = NULL
	,@EndDate DATETIME = NULL
	,@UpdatedDate DATETIME = NULL
AS
BEGIN
	UPDATE Projects
	SET ProjectName = @ProjectName
		,ClientName = @ClientName
		,ProjectManagerId = @ProjectManagerId
		,ProjectDescription = @ProjectDescription
		,StartDate = @StartDate
		,EndDate = @EndDate
		,UpdatedDate = getutcdate()
	WHERE Id = @Id
END
EXEC UpdateProject
    @Id=1,
    @ProjectName = 'TimeSystem Software',
    @ClientName = 'Shubham Mishra',
    @ProjectManagerId = 'A51DC085-073F-4D3A-AFC8-ACE61B89E8C8',
    @ProjectDescription = 'This is a sample TimeSystem Software.',
    @StartDate = '2023-01-20 12:45:00.000',
    @EndDate = '2023-04-20 12:45:00.000',
    @UpdatedDate= getutcdate();

CREATE PROCEDURE DeleteProjectById
   @id int
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Projects
    WHERE id = @id;
END

EXEC DeleteProjectById @Id=2

CREATE PROCEDURE [DeleteProject]
@id int
AS
BEGIN

UPDATE Projects SET IsDelete =1, IsActive =0
WHERE Id = @id

END

EXEC DeleteProject @Id=2