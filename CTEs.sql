with cte as(
select ShipCountry,count(orderid)  as cnt
from Orders
group by ShipCountry
having count(orderid)>20
)
select * from cte left join orders o 
on cte.shipcountry=o.shipcountry
;

with cte(orderid,count) as (
select orderid,count(*)
from NORTHWND.dbo.[Order Details] 
group by orderid
having count(*)=1)
select * from  cte left join [Order Details] od
on od.OrderID=cte.orderid
;