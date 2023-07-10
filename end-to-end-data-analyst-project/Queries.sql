--viewing Tables

--Date table
Select * from dim_date

--Hotel type table
select * from dim_hotels

--types of room table
select * from dim_rooms;

-- Aggregated bookings table
select * from fact_aggregated_bookings;

-- Normal booking table
select * from fact_bookings;

-- Total bookings
select count(booking_id) as Total_booking 
from fact_bookings;

-- Total Capacity
select sum(capacity) as Total_Capacity 
from fact_aggregated_bookings;

-- Total Successful Bookings 
select sum(successful_bookings) as Total_Successful_Bookings 
from fact_aggregated_bookings;

--Total Percentage Occupancy
select concat(round((sum(successful_bookings)/sum(capacity))*100,2),' %')
as Total_Percentage_Occupancy
from fact_aggregated_bookings;

-- Average Rating
select round(AVG(ratings_given),2) 
as Total_Average_Rating 
from fact_bookings;

-- No of Days
select DATEDIFF(day, Min(date), Max(date)) + 1 
as Total_No_of_Days
from dim_date;

-- Total Cancelled Bookings
select count([booking_status]) 
as total_cancelled_Bookings 
from fact_bookings
where booking_status = 'Cancelled';

-- Percentage of Cancelled bookings
with agg_booking_status as (select booking_status, cast(count(booking_status)as float) 
as agg_status from fact_bookings
group by booking_status)

select booking_status, concat(round((agg_status * 100) /
(select count(booking_status) from fact_bookings),2),' %')
as Percentage_Cancelled
from agg_booking_status
where booking_status = 'Cancelled';

--Total Check out
select count([booking_status]) 
as total_Checked_Out_Bookings 
from fact_bookings
where booking_status = 'Checked Out';

-- Total No Show
select count([booking_status]) 
as total_No_Show_Bookings 
from fact_bookings
where booking_status = 'No Show';

-- Percentage No Show
with agg_booking_status as (select booking_status, cast(count(booking_status)as float) 
as agg_status from fact_bookings
group by booking_status)

select booking_status, concat(round((agg_status * 100) /
(select count(booking_status) from fact_bookings),2),' %')
as Percentage_No_Show
from agg_booking_status
where booking_status = 'No Show';

--Percentage Booking per Platform
go

with agg_booking_per_Platform as 
(select booking_platform, cast(count(booking_id) as float) 
as booking_Per_platform 
from fact_bookings
group by booking_platform)

select booking_platform, concat(Round((booking_per_platform * 100)/
(select count(booking_id) from fact_bookings),2),' %') 
as Percentage_per_Platform
from agg_booking_per_Platform;

-- Booking Percentage Per Room Class

with agg_room_count as (select room_category, room_class, 
cast(count(booking_id) as float) 
as room_count
from fact_bookings
join dim_rooms on room_id = room_category
group by room_category, room_class)

select room_category,room_class, concat(round(room_count * 100/
(select count(booking_id) as tot_bookings from fact_bookings),2),' %')
as room_booking_ratio 
from agg_room_count;

-- Average Daily Rate (ADR)
select round(sum(revenue_generated)/count(booking_id),2) 
as Average_Daily_Rate from fact_bookings;

-- Realization 
-- Realization is simply 1 - (pecentage of cancelled + Percentage of No show)
with agg_booking_status as (select booking_status, cast(count(booking_status)as float) 
as agg_status from fact_bookings
group by booking_status)

select booking_status, concat(round((agg_status * 100) /
(select count(booking_status) from fact_bookings),2),' %')
as Percentage_Checked_Out_or_Realization
from agg_booking_status
where booking_status = 'Checked Out';

--Revenue Per Room
-- Revenue/No of Days
select round(sum(a.revenue_generated)/sum(agg.capacity),2) as RevPAR 
from fact_bookings as a join fact_aggregated_bookings as agg on
a.property_id = agg.property_id;

-- Daily Booking Rate Night (DBRN)
-- Bookings/No of Days
select Round(cast(count(booking_id) as float)/
(select DATEDIFF(day, Min(date), Max(date)) + 1
as Total_No_of_Days
from dim_date),2) as DBRN from fact_bookings;

-- Daily Sellable Rate Night (DSRN)
-- Capacity/No of Days
select round(sum(Capacity)/(select DATEDIFF(day, Min(date), Max(date)) + 1
as Total_No_of_Days
from dim_date),2) as DSRN from fact_aggregated_bookings;

-- Daily Useable Room Night (DURN)
-- Total checked out/ No of Days

select distinct (select count([booking_status]) 
as total_Checked_Out_Bookings 
from fact_bookings
where booking_status = 'Checked Out')/(select DATEDIFF(day, Min(date), Max(date)) + 1
as Total_No_of_Days
from dim_date) as DURN from fact_bookings;

-- Week over Week Percentage Difference for Revenue

with agg_week_Revenue as (select week_no, sum(revenue_generated) 
as Total_revenue_per_week from dim_date 
join fact_bookings on checkout_date = date
group by week_no)

select week_no, concat(Round(Total_revenue_per_week-lag(Total_revenue_per_week) 
over(order by (select null))/lag(Total_revenue_per_week) 
over(order by (select null)),2),' %') as WoW_Revenue_Change from agg_week_Revenue;

-- Occupancy WoW % Change
go

with weekly_occupancy as (select DATEPART(WEEK,check_in_date) as week_no, 
sum(successful_bookings)/ sum(capacity) as WoW_Occupancy_Change,
ROW_NUMBER() over(order by DATEPART(WEEK,check_in_date)) as row_num
from fact_aggregated_bookings
group by DATEPART(WEEK,check_in_date))

select week_no, row_num, concat(round((wow_Occupancy_Change-lag(WoW_Occupancy_Change) 
Over(order by week_no)) * 100/lag(WoW_Occupancy_Change) 
Over(order by week_no),2),' %') as WoW_change_of_Occupany from weekly_occupancy;

--WOW Average Daily Rate ADR 
go
with agg_ADR as (select DATEPART(WEEK,check_in_date) as week_on, 
sum(Revenue_generated)/Count(booking_id) as Total_ADR from fact_bookings
group by DATEPART(WEEK,check_in_date))

select week_on, concat(round(((Total_ADR-lag(Total_ADR) over(order by week_on))*100/
lag(Total_ADR) over(order by week_on)),7),' %') as WoW_ADR from agg_ADR;


go

-- WoW % RevPAR 
go
with agg_revpar as (select DATEPART(WEEK,a.check_in_date) as week_on,
sum(a.revenue_generated)/(select DATEDIFF(day, Min(b.date), Max(b.date)) + 1)
as Total_RevPAR from fact_bookings as a 
join dim_date as b on date = check_in_date
group by DATEPART(WEEK,a.check_in_date))

select week_on, 
concat(round((Total_RevPAR-(lag(Total_RevPAR) over(order by week_on)))*100/
(lag(Total_RevPAR) over(order by week_on)),2),' %') as WOW_RevPAR
from agg_revpar

-- WOW Realization
-- checkout/Total Booking
go

with Total_Checkout_table as (select DATEPART(WEEK,check_in_date) as week_on, 
count(booking_id) as Total_Checkout from fact_bookings
where booking_status = 'Checked Out'
group by DATEPART(WEEK,check_in_date)),

week_realizations as (select a.week_on, a.Total_Checkout, count(b.booking_id) 
as Total_Booking,
cast (a.Total_Checkout as float)/count(b.booking_id) as week_Realization
from Total_Checkout_table  as a
join fact_bookings as b
on DATEPART(WEEK,check_in_date) = week_on 
group by a.week_on,a.Total_Checkout)

select week_on, ((week_Realization) - 
(lag(week_Realization) over(order by week_on))*100) 
/(lag(week_Realization) over(order by week_on)) from week_realizations;


go






