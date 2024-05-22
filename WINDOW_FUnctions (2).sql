--https://learn.microsoft.com/en-us/sql/t-sql/queries/select-window-transact-sql?view=sql-server-ver16
select year(shippeddate)as [year],sum(freight) as netfreight 
from Orders group by year(shippeddate);

create table data1(id  int,name varchar(25),sal money);
create table data2(id  int,name varchar(25),sal money);
create table data3(id  int,name varchar(25),sal money,dept varchar(20));
insert into data1 values(1,'john',1000),(2,'jane',5000),(3,'Jenny',6000),(4,'ben',7000);
insert into data2 values(1,'tim',10000),(2,'mike',5000),(3,'scott',6000),(4,'steven',7000);
insert into data1 values(1,'tim',10000),(2,'mike',5000);
select * from data1
union
select * from data2;
select * from data1
union
select id,name,sal from data3;
select * from data1
union all
select * from data2;
select * from data1
intersect
select * from data2;
--rows present in data1 and not in data2
select * from data1
except
select * from data2;
--rows present in data2 and not in data1
select * from data2
except--minus in oracle
select * from data1;

select ROW_NUMBER() over(order by orderid asc) as [SNo],
OrderID,Freight,ShipCity,ShipCountry from orders;
select ROW_NUMBER() over(partition by shipcountry order by orderid asc) as [SNo],
OrderID,Freight,ShipCity,ShipCountry from orders;

create table salesdata(Country varchar(25),	Customer varchar(25),Product varchar(25),
SalesAmount money);
insert into salesdata values
('India',	'Reliance JIO',	'Phones',	650),
('India',	'TATA',	'Phones',	200),
('USA',	'AT&T'	,'Phones',	870),
('USA',	'UBER'	,'cabs'	,150),
('UK'	,'Bet365',	'Betting',	900),
('Japan',	'Samsung',	'Phones',	260),
('South Korea',	'LG	','Phones',	200),
('India',	'OLA'	,'cabs',	100),
('India',	'MERU'	,'cabs',	100),
('India',	'HERO'	,'bikes',	100),
('India',	'MERU'	,'cabs',	90)
;

select * from salesdata order by SalesAmount desc;

select max(salesamount) from salesdata;
--outer query outside outermost
--inner query in bracket () executed first
select * from salesdata where --highest
SalesAmount=(select max(salesamount) from salesdata);
select * from salesdata where
SalesAmount=(select min(salesamount) from salesdata);
select * from salesdata where --highest
SalesAmount=
(select max(salesamount) from salesdata where SalesAmount<>
(select max(salesamount) from salesdata)
);

select * from salesdata where --2nd highest
SalesAmount=
(select min(salesamount) from salesdata where SalesAmount<>
(select min(salesamount) from salesdata)
);
--2nd highest
select *,RANK() over(order by salesamount desc) as [Rank] from salesdata;
select * from (select *,RANK() over(order by salesamount desc) as [Rank] from salesdata) t 
where [Rank]=2;

select *,RANK() over(order by salesamount desc) as [Rank]
,DENSE_RANK() over(order by salesamount desc) as [DENSE Rank]
from salesdata;

select *
,DENSE_RANK() over(partition by country order by salesamount desc) as [DENSE Rank]
from salesdata;
select *,sum(salesamount) over() as totalsalesamount from salesdata;
select *,(SalesAmount/totalsalesamount)*100 as [%sales] from (select *,sum(salesamount) over() as totalsalesamount from salesdata
)t;

select *,sum(salesamount) over(partition by country) as totalsalesamount from salesdata;













