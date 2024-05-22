select * from Orders;
select sum(freight) as sumofreight from orders;
select sum(freight) as sumofreight from orders where ShipCountry='belgium';
select round(avg(freight),2) as avgofreight from orders;
select min(freight) as minofreight from orders;
select max(freight) as maxofreight from orders;
select count(orderid) as totalorders from orders;
select count(shipregion) as totalregioncount from orders;
select count(*) as totalrowcount from orders;
select distinct shipcountry from orders;
select count(distinct(shipcountry)) as dcount from orders;
select count(distinct(shipcity)) as dcount from orders;

select shipcountry,count(orderid) as totalorders from orders group by shipcountry;
select shipcountry,shipvia,count(orderid) as totalorders 
from orders group by shipcountry,shipvia order by shipcountry desc;
select shipcountry,shipvia,count(orderid) as totalorders 
from orders group by shipcountry,shipvia order by shipcountry;
select shipcountry,shipvia,count(orderid) as totalorders 
from orders group by shipcountry,shipvia order by totalorders desc;
select shipcountry,shipvia,count(orderid) as totalorders 
from orders group by shipcountry,shipvia order by shipcountry,shipvia ;
select shipcountry,shipvia,count(orderid) as totalorders 
from orders where (ShipCountry like 'A%' or ShipCountry like 'B%') and ShipVia=3
group by shipcountry,shipvia order by shipcountry,shipvia ;
select shipcountry,shipvia,count(orderid) as totalorders 
from orders group by shipcountry,shipvia 
having count(orderid)>10 order by shipcountry,shipvia ;
select shipregion,sum(freight) from Orders group by shipregion;

create table table1(id int);
create table table2(id int);
insert into table1 values(1),(2),(2),(4),(5);
insert into table2 values(1),(2),(3),(4),(6);
insert into table1 values(null);
insert into table2 values(null);
select * from table1;
select * from table2;
select * from table1
union
select * from table2;
select * from table1
union all
select * from table2;
select * from table1
intersect
select * from table2;
select * from table1
except
select * from table2;
select * from table2
except
select * from table1;















