use education
go
select productid
from supplies X
where NOT EXISTS (
                  SELECT *
                  FROM supplies
                  WHERE supplierid  <> 3
                    AND X.productid = productid
                 );



Select [dbo].[Suppliers].supplierid, name
FROM [dbo].[Supplies] join [dbo].[Suppliers] ON [dbo].[Supplies].[supplierid]  = [dbo].[Suppliers].[supplierid] 
where detailid=1 and quantity > (Select avg( quantity) from [dbo].[Supplies] where detailid=1)
go



Select DISTINCT detailid
FROM 
(Select [dbo].[Details].detailid
FROM [dbo].[Supplies] join [dbo].[Details] ON [dbo].[Supplies].[detailid]  = [dbo].[Details].[detailid] 
join [dbo].[Products] ON [dbo].[Supplies].[productid] = [dbo].[Products].[productid]
where [dbo].[Products].city = 'London')
rs
go



Select DISTINCT supplierid,name
FROM 
(Select [dbo].[Suppliers].supplierid, [dbo].[Suppliers].name
FROM [dbo].[Supplies] join [dbo].[Details] ON [dbo].[Supplies].[detailid]  = [dbo].[Details].[detailid] 
join [dbo].[Suppliers] ON [dbo].[Supplies].[supplierid] = [dbo].[Suppliers].[supplierid]
where color = 'Red')
rs
go 



Select DISTINCT  detailid
FROM 
(Select detailid
FROM supplies
where supplierid = 2)
rs
go 



select productid
from supplies
group by productid
Having avg( quantity) > (Select max ( quantity) from  Supplies where productid=1)
go



SELECT Productid
from Products
where not exists
(SELECT Productid from Supplies )
go



;WITH CT1 AS (SELECT * FROM Products),
     CT2 AS (SELECT name FROM CT1)
SELECT * FROM CT2;



;with Value (Position, Value) AS
(Select 1, CAST (1 as bigint)
Union ALL 
SELECT Position+1, (Position+1) * Value
From Value
Where Position<10)
Select Position, Value
From Value
where position = 10



;WITH Fibonacci (PrevN, N) AS
(
     SELECT 1,1
     UNION ALL
     SELECT N, PrevN + N
     FROM Fibonacci
     WHERE N < 6766
)
SELECT PrevN as Value
     FROM Fibonacci
     OPTION (MAXRECURSION 0);



declare @sDate datetime,
        @eDate datetime

select  @sDate = '2013-11-25',
        @eDate = '2014-03-05'
;with cte as (
  select convert(date,left(convert(varchar,@sdate,112),6) + '01') StartDate1,
         month(@sdate) n
  union all
  select dateadd(month,n,convert(date,convert(varchar,year(@sdate)) + '0101')) StartDate1,
        (n+1) n
  from cte
  where n < month(@sdate) + datediff(month,@sdate,@edate)
)
select StartDate1, dateadd(day,-1,dateadd(month,1,Startdate1)) EndDate1, 
case
        when StartDate1 < '2013-11-25' then '2013-11-25'
        when StartDate1 = '2013-12-01' then '2013-12-01'
		when StartDate1 = '2014-01-01' then '2014-01-01'
		when StartDate1 = '2014-02-01' then '2014-02-01'
		when StartDate1 = '2014-03-01' then '2014-03-01'
    end as StartDate,
case
       when dateadd(day,-1,dateadd(month,1,Startdate1))  = '2013-11-30' then '2013-11-30'
	   when dateadd(day,-1,dateadd(month,1,Startdate1))  = '2013-12-31' then '2013-12-31'
	   when dateadd(day,-1,dateadd(month,1,Startdate1))  = '2014-01-31' then '2014-01-31'
	   when dateadd(day,-1,dateadd(month,1,Startdate1))  = '2014-02-28' then '2014-02-28'
       when dateadd(day,-1,dateadd(month,1,Startdate1))  > '2014-03-05' then '2014-03-05'
       
    end as EndDate
from cte


					
declare @month tinyint = 7, @year smallint = 2019;
 
with month_days as
(
 select
  a.d, b.wd, b.wd as start_wd, (day(a.d) + b.wd - 2) / 7 as wn
 from
  (select datefromparts(@year, @month, 1)) a(d) cross apply
  (select (datepart(weekday, a.d) + @@datefirst - 2) % 7+1 , datepart(week, a.d)) b(wd, w)
  union all
  select
  b.d, c.wd, a.start_wd, (day(b.d) + a.start_wd - 2) / 7
 from
  month_days a cross apply
  (select dateadd(day, 1, a.d)) b(d) cross apply
  (select (datepart(weekday, b.d) + @@datefirst - 2) % 7+1 , datepart(week, b.d)) c(wd, w)
 where
  b.d < dateadd(month, 1, datefromparts(@year, @month, 1))
)
select
 dn.dn,
 max(case when md.wn = 0 then day(md.d) end),
 max(case when md.wn = 1 then day(md.d) end),
 max(case when md.wn = 2 then day(md.d) end),
 max(case when md.wn = 3 then day(md.d) end),
 max(case when md.wn = 4 then day(md.d) end)

 from
 month_days md join
 (
  values
   (1, 'Monday'), (2, 'Tuesday'), (3, 'Wednesday'),
   (4, 'Thursday'), (5, 'Friday'), (6, 'Saturday'),
   (7, 'Sunday')
 ) dn(wd, dn) on dn.wd = md.wd
group by
 md.wd, dn.dn
order by
md.wd	
 

;with geography_cte as (
  Select region_id,id, name, region_id as PlaceLevel
  From geography
  where region_id = 1
)
Select * from geography_cte;



;with regions( regin_id, place_id, name, PlaceLevel) AS
(
      Select  region_id, id, name, PlaceLevel=0
      FROM geography
      WHERE name = 'Ivano-Frankivsk' 
UNION ALL
      SELECT  g.region_id, g.id, g.name, f.PlaceLevel+1
      FROM geography g INNER JOIN regions f
      ON g.region_id=f.place_id
	  )   
Select   regin_id,place_id, name, PlaceLevel from regions
WHERE name not like 'Ivano-Frankivsk' 



;with regions( regin_id, place_id, name, PlaceLevel) AS
(
      Select  region_id, id, name, PlaceLevel=0
      FROM geography
      WHERE name = 'Ukraine' 
UNION ALL
      SELECT  g.region_id, g.id, g.name, f.PlaceLevel+1
      FROM geography g INNER JOIN regions f
      ON g.region_id=f.place_id
	  )   
Select   regin_id,place_id, name, PlaceLevel from regions
WHERE name not like 'Ukraine'  
Order by PlaceLevel ASC



;with regions( regin_id, place_id, name, PlaceLevel) AS
(
      Select  region_id, id, name, PlaceLevel=1
      FROM geography
      WHERE name = 'Lviv' 

UNION ALL
      SELECT  g.region_id, g.id, g.name, f.PlaceLevel+1
      FROM geography g INNER JOIN regions f
      ON g.region_id=f.place_id
	  )   
Select  name,place_id,  regin_id, PlaceLevel from regions



;WITH regions
    AS ( 
        
        SELECT  id, Name,  Region_ID, PlaceLevel=1,
                CAST('/'+ Name AS VARCHAR(1000)) Rating 
        FROM    geography
         WHERE   name = 'Lviv'  
        UNION ALL 
         
        SELECT  t.id, t.Name, t.Region_ID, PlaceLevel+1,
                CAST((a.Rating  + '/' + t.Name) AS VARCHAR(1000)) AS "Rating "
        FROM    geography AS t 
                JOIN regions AS a 
                  ON t.Region_ID = a.id 
       )
SELECT name,PlaceLevel,Rating FROM regions



;WITH regions
    AS ( 
        
        SELECT  id, Name,  Region_ID, PlaceLevel=1,
                CAST('/'+ Name AS VARCHAR(1000)) Rating 
        FROM    geography
         WHERE   name = 'Lviv'  
        UNION ALL 
         
        SELECT  t.id, t.Name, t.Region_ID, PlaceLevel+1,
                CAST((a.Rating  + '/' + t.Name) AS VARCHAR(1000)) AS "Rating "
        FROM    geography AS t 
                JOIN regions AS a 
                  ON t.Region_ID = a.id 
       )
SELECT name,PlaceLevel,Rating FROM regions 
WHERE name not like 'Lviv' 



Select supplierid, name
from suppliers
where city = 'London'
union all
Select supplierid, name
from suppliers
where city = 'Paris'



SELECT  details.city
FROM details,suppliers
where suppliers.city = details.city
Order by City asc

Select city
from suppliers
union
Select city
from details
Order by City asc



Select  [Suppliers].[supplierid], [Suppliers].[name]
FROM [dbo].[Supplies] join [dbo].[Suppliers] ON [dbo].[Supplies].[supplierid]  = [dbo].[Suppliers].[supplierid] 
join [dbo].[Details] ON [dbo].[Supplies].[productid] = [dbo].[Details].[detailid]
except
Select  [Suppliers].[supplierid], [Suppliers].[name]
FROM [dbo].[Supplies] join [dbo].[Suppliers] ON [dbo].[Supplies].[supplierid]  = [dbo].[Suppliers].[supplierid] 
join [dbo].[Details] ON [dbo].[Supplies].[productid] = [dbo].[Details].[detailid]
where [Details].[city]='London'



(select *
FROM [dbo].[Supplies] join [dbo].[Products] ON [dbo].[Supplies].[productid] = [dbo].[Products].[productid]
where city='Paris' or city='Roma'
except
select *
FROM [dbo].[Supplies] join [dbo].[Products] ON [dbo].[Supplies].[productid] = [dbo].[Products].[productid]
where city='London' or city='Paris')
union 
(select *
FROM [dbo].[Supplies] join [dbo].[Products] ON [dbo].[Supplies].[productid] = [dbo].[Products].[productid]
where city='London' or city='Paris'
except
select *
FROM [dbo].[Supplies] join [dbo].[Products] ON [dbo].[Supplies].[productid] = [dbo].[Products].[productid]
where city='Paris' or city='Roma')



select [Supplies].supplierid, [Supplies].detailid, [Supplies].productid
FROM [dbo].[Supplies] join [dbo].[Details ] ON [dbo].[Supplies].[detailid]  = [dbo].[Details ].[detailid] 
join [dbo].[Products] ON [dbo].[Supplies].[productid] = [dbo].[Products].[productid]
join [dbo].[Suppliers] on [dbo].[Suppliers].[supplierid]=[dbo].[Supplies].[supplierid]
where [suppliers].[city]='London' 
union
select [Supplies].supplierid, [Supplies].detailid, [Supplies].productid
FROM [dbo].[Supplies] join [dbo].[Details ] ON [dbo].[Supplies].[detailid]  = [dbo].[Details ].[detailid] 
join [dbo].[Products] ON [dbo].[Supplies].[productid] = [dbo].[Products].[productid]
join [dbo].[Suppliers] on [dbo].[Suppliers].[supplierid]=[dbo].[Supplies].[supplierid]
where  [details].[color]='Green'  and   [products].[city] <>'Paris'
order by supplierid
