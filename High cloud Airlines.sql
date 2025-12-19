use airline;
select * from maindata;

SELECT COUNT(*) AS TOTAL_CONTENT
FROM maindata;


alter table maindata
add column date date;

update maindata 
set Date=(concat(Year,'-',Month,'-',Day));

/* KPI 1--*/
select Date,
Year,
Month,
Day,
dayofweek(Date) as week_no,
monthname(Date) as month_name,
dayname(Date) as weekday_name,
concat(year(Date),'-',monthname(Date)) as yearmonth,

case 
when monthname(Date) in ('January','February','March') then 'Q1'
when monthname(Date) in ('April','May','June') then 'Q2'
when monthname(Date) in ('July','August','September') then 'Q3'
else 'Q4' end as Quarter,

CASE
WHEN monthname(Date)='January' then 'FM10'
WHEN monthname(Date)='February' then 'FM11'
WHEN monthname(Date)='March' then 'FM12'
WHEN monthname(Date)='April' then 'FM1'
WHEN monthname(Date)='May' then 'FM2'
WHEN monthname(Date)='June' then 'FM3'
WHEN monthname(Date)='July' then 'FM4'
WHEN monthname(Date)='August' then 'FM5'
WHEN monthname(Date)='September' then 'FM6'
WHEN monthname(Date)='October' then 'FM7'
WHEN monthname(Date)='November' then 'FM8'
WHEN monthname(Date)='December' then 'FM9'
end Financial_month,
case 
when monthname(Date) in ('January','February','March') then 'FQ4'
when monthname(Date) in ('April','May','June') then 'FQ1'
when monthname(Date) in ('July','August','September') then 'FQ2'
else 'FQ3' end as Financial_quarter
from
maindata;   
/* KPI 2 - LOAD FACTOR PERCENTAGE on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)*/

select Year as yearly,
concat(round(sum(Transported_Passengers)/sum(Available_Seats)*100,2),"%") AS Load_factor_percent
from maindata
group by yearly
order by Load_factor_percent desc;

select quarter(date) as Quarterly,
concat(round(sum(Transported_Passengers)/sum(Available_Seats)*100,2),"%") AS Load_factor_percent
from maindata
group by Quarterly
order by Load_factor_percent desc;

select monthname(date) as monthly,
concat(round(sum(Transported_Passengers)/sum(Available_Seats)*100,2),"%") AS Load_factor_percent
from maindata
group by monthly
order by Load_factor_percent desc limit 10;

/* KPI 3 - CARRIER NAME WISE LOAD FACTOR PERCENTAGE */
select Carrier_Name,
concat(round(sum(Transported_Passengers)/sum(Available_Seats)*100,2),"%") AS Load_factor_percent
from maindata
group by Carrier_Name
order by Load_factor_percent desc limit 10;

/* KPI 4 - Top 10 Carrier Names based passengers preference */
select Carrier_Name,sum(Transported_Passengers) as total_passenger
from maindata
group by  Carrier_Name
order by sum(Transported_Passengers) desc limit 10;

/*KPI-5 Top routes(from-to city) based on no. of flights*/
select From_To_City,count(Departures_Performed) as no_of_flights
from maindata
group by From_To_City
order by no_of_flights desc limit 5;

/*KPI-6 Load factor on weekdays and weekend*/
select 
case
when dayofweek(date) in (1,7) then "Weekend"
else "Weekday" 
end as day_of_week,
concat(round(sum(Transported_Passengers)/sum(Available_Seats)*100,2),"%") AS Load_factor_percent
from maindata
group by day_of_week
order by Load_factor_percent;

/*KPI-7 number of flights based on Distance group*/
SELECT 
    CASE 
        WHEN Distance < 500 THEN 'Short'
        WHEN Distance BETWEEN 500 AND 1500 THEN 'Medium'
        ELSE 'Long'
    END AS Distance_Group,
    COUNT(*) AS Number_of_Flights
FROM maindata
GROUP BY 
    CASE 
        WHEN Distance < 500 THEN 'Short'
        WHEN Distance BETWEEN 500 AND 1500 THEN 'Medium'
        ELSE 'Long'
    END
ORDER BY Number_of_Flights DESC;