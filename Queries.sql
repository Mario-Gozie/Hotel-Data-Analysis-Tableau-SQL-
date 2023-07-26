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

-- Realization per platform

with Total_check_out as (select booking_platform,cast(count(booking_status) as float)
as checkout from fact_bookings
where booking_status = 'Checked Out'
group by booking_platform),

check_out_and_bookings as (select a.booking_platform, checkout, count(booking_id) as bookings 
from Total_check_out as a join fact_bookings as b on 
b.booking_platform = a.booking_platform
group by a.booking_platform, checkout)

select booking_platform, concat(round((checkout* 100/bookings),2),' %') 
as Total_Realization from check_out_and_bookings


-- ADR per Platform

select booking_platform, format(round((sum(revenue_realized)/
count(booking_id)),2),'c') as ADR from  fact_bookings 
group by booking_platform

go
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
select round(sum(revenue_realized)/count(booking_id),2) 
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

--RevPar
-- Revenue/capacity
select round(sum(revenue_realized)/(select sum(capacity)  
from fact_aggregated_bookings),2) as RevPAR from fact_bookings



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
go
with week_over_week_cte as (select DATEPART(WEEK,check_in_date) as week_no, 
sum(revenue_realized) as revenue, ROW_NUMBER() over(order by DATEPART(WEEK,check_in_date)) 
as row_num from fact_bookings
group by DATEPART(WEEK,check_in_date))

select current_week.week_no, current_week.revenue, previous_week.revenue
as previous_week_revenue, concat(round((((current_week.revenue - previous_week.revenue)/
previous_week.revenue)*100),2),' %') as week_over_week_Revenue
from week_over_week_cte as current_week join
week_over_week_cte as previous_week on previous_week.row_num = current_week.row_num - 1;

-- Occupancy WoW % Change
go
with weekly_occupancy as (select DATEPART(WEEK,check_in_date) as week_no, 
sum(successful_bookings)/ sum(capacity) as WoW_Occupancy_Change,
ROW_NUMBER() over(order by DATEPART(WEEK,check_in_date)) as row_num
from fact_aggregated_bookings
group by DATEPART(WEEK,check_in_date))

select week_no, concat(round((wow_Occupancy_Change-lag(WoW_Occupancy_Change) 
Over(order by week_no)) * 100/lag(WoW_Occupancy_Change) 
Over(order by week_no),2),' %') as WoW_change_of_Occupany from weekly_occupancy;

--Alternatively

with Total_weekly_occupancy as (select DATEPART(WEEK,check_in_date) as week_no, 
sum(successful_bookings)/ sum(capacity) as Weekly_Occupancy,
ROW_NUMBER() over(order by DATEPART(WEEK,check_in_date)) as row_num
from fact_aggregated_bookings
group by DATEPART(WEEK,check_in_date))

select current_week.week_no, current_week.weekly_Occupancy, 
previous_week.weekly_Occupancy, 
concat(round((current_week.Weekly_Occupancy - previous_week.Weekly_Occupancy)*100/
(previous_week.Weekly_Occupancy),2),' %') as Week_over_week_Occupancy
from Total_weekly_occupancy as current_week
join Total_weekly_occupancy as previous_week 
on current_week.row_num = previous_week.row_num + 1;


--WOW Average Daily Rate ADR 
go
with agg_ADR as (select DATEPART(WEEK,check_in_date) as week_no, 
sum(revenue_realized)/Count(booking_id) as Total_ADR from fact_bookings
group by DATEPART(WEEK,check_in_date))

select week_no, concat(round(((Total_ADR-lag(Total_ADR) over(order by week_no))*100/
lag(Total_ADR) over(order by week_no)),2),' %') as WoW_ADR from agg_ADR;

-- Alternatively

with agg_ADR as (select DATEPART(WEEK,check_in_date) as week_no, 
sum(revenue_realized)/Count(booking_id) as Total_ADR,
ROW_NUMBER() over(order by DATEPART(WEEK,check_in_date)) as rownum
from fact_bookings
group by DATEPART(WEEK,check_in_date))

select current_week.week_no, current_week.Total_ADR, Previous_week.Total_ADR 
as Previous_week_ADR, concat(round((((current_week.Total_ADR - previous_week.Total_ADR)/
previous_week.Total_ADR) *100),2),' %') as Week_over_ADR
from agg_ADR as current_week
join agg_ADR as previous_week on current_week.rownum = previous_week.rownum + 1;


go
-- WoW % RevPAR 

with Total_Revenues as (select DATEPART(week, check_in_date) as weeks, sum(revenue_realized) as Total_rev 
from fact_bookings
group by DATEPART(week, check_in_date)),

caps_included as (select a.weeks, Total_rev, sum(capacity) as Total_capacity, 
(Total_rev/sum(capacity)) as RevPar,
ROW_NUMBER() over(order by weeks) as rownum
from Total_Revenues as a
join fact_aggregated_bookings as b on a.weeks = DATEPART(week, check_in_date)
group by a.weeks,Total_rev),

current_and_Previous_week as (select current_week.weeks, current_week.Total_rev, current_week.Total_capacity, 
current_week.RevPar as current_RevPAR, 
previous_week.RevPAR as Previous_Revpar 
from caps_included as current_week join 
caps_included as previous_week on current_week.rownum = previous_week.rownum + 1)

select weeks, concat(round((((current_RevPAR-Previous_revPAR)/
Previous_Revpar)*100),2),' %') as WOW_REVPAR from current_and_Previous_week;

go
-- WOW Realization
-- checkout/Total Booking
with Total_Checkout_table as (select DATEPART(WEEK,check_in_date) as week_no, 
cast(count(booking_id) as float) as Total_Checkout, 
(select count(booking_id) from fact_bookings) as Total_bookings
from fact_bookings
where booking_status = 'Checked Out'
group by DATEPART(WEEK,check_in_date)),

Total_weekly_realization as (select week_no, Total_Checkout/Total_bookings 
as weekly_realization, 
ROW_NUMBER() over(order by week_no) as row_num 
from Total_Checkout_table)

select current_week.week_no, current_week.weekly_realization, 
previous_week.weekly_realization as Previous_week_realization,
concat(round(((current_week.weekly_realization- previous_week.weekly_realization) *100/
(previous_week.weekly_realization)),2),' %') as week_over_week_Realization
from Total_weekly_realization as current_week join
Total_weekly_realization as previous_week 
on current_week.row_num = previous_week.row_num + 1;

go
-- WOW DSRN %
-- Remember DSRN = Capacity/No of Days
with weekly_capacity as (select DATEPART(WEEK,check_in_date) as week_no, 
sum(capacity) as Total_Capacity from fact_aggregated_bookings
group by DATEPART(WEEK,check_in_date)),

days_and_capacity as (select caps.week_no, Total_capacity, 
dayss.Actual_week_days from weekly_capacity 
as caps join (select DATEPART(WEEK,check_in_date) as week_no ,
DATEDIFF(day, Min(check_in_date), Max(check_in_date)) 
+ 1 as actual_week_days from fact_aggregated_bookings 
group by DATEPART(WEEK,check_in_date)) as dayss 
on dayss.week_no = caps.week_no),

Total_DSRN as (select week_no, Total_capacity/Actual_week_days 
as DSRN_weekly, ROW_NUMBER() 
over(order by week_no) as Row_num from days_and_capacity)

select current_week.week_no, current_week.DSRN_weekly, Previous_week.DSRN_weekly,
concat(round(((current_week.DSRN_weekly - Previous_week.DSRN_weekly) * 100/
previous_week.DSRN_weekly),2),' %') as week_over_week_DSRN
from Total_DSRN as current_week join
Total_DSRN as previous_week on previous_week.Row_num = current_week.Row_num-1;



go

