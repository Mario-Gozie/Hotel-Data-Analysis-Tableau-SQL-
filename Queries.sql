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

-- For week over week Data

with Total_bookings as (select DATEPART(week, check_in_date) as weeks,
Min(Check_in_date) as week_start, Max(check_in_date) as week_end,
(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as weekdays,
 sum(revenue_realized) as Total_revenue, 
count(booking_id) as total_bookings
from fact_bookings
group by DATEPART(week, check_in_date)),

Agg_table_Join as (select A.weeks, weekdays, Total_Revenue, total_bookings, 
Total_successful_bookings, Total_capacity
 from Total_bookings as A join
(select DATEPART(week, check_in_date) weeks, 
sum(successful_bookings) as Total_successful_bookings, 
sum(capacity) as Total_capacity from fact_aggregated_bookings
group by DATEPART(week, check_in_date)) as agg_of_agg on agg_of_agg.weeks = A.weeks)

select weeks, Total_successful_bookings, weekdays, Total_revenue, Total_bookings,
 Total_capacity,
sum(Total_Revenue)/sum(total_bookings) as ADR, 
sum(Total_Revenue)/sum(Total_Capacity) as  Total_RevPar,
sum(Total_successful_bookings)/sum(Total_capacity) as Occupancy,
 Total_Capacity/weekdays DSRN 
from Agg_table_Join
group by weeks, Total_successful_bookings, weekdays, Total_revenue, Total_bookings,
 Total_capacity;

 go
 -- week over week calculation
 with Total_bookings as (select DATEPART(week, check_in_date) as weeks,
Min(Check_in_date) as week_start, Max(check_in_date) as week_end,
(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as weekdays,
 sum(revenue_realized) as Total_revenue, 
count(booking_id) as total_bookings
from fact_bookings
group by DATEPART(week, check_in_date)),

Agg_table_Join as (select A.weeks, weekdays, Total_Revenue, total_bookings, 
Total_successful_bookings, Total_capacity
 from Total_bookings as A join
(select DATEPART(week, check_in_date) weeks, 
sum(successful_bookings) as Total_successful_bookings, 
sum(capacity) as Total_capacity from fact_aggregated_bookings
group by DATEPART(week, check_in_date)) as agg_of_agg on agg_of_agg.weeks = A.weeks),

 week_over as (select weeks, Total_successful_bookings, weekdays, Total_revenue, Total_bookings,
 Total_capacity,
sum(Total_Revenue)/sum(total_bookings) as ADR, 
sum(Total_Revenue)/sum(Total_Capacity) as  Total_RevPar,
sum(Total_successful_bookings)/sum(Total_capacity) as Occupancy,
 Total_Capacity/weekdays DSRN, ROW_NUMBER() over(order by weeks) as rowss
from Agg_table_Join
group by weeks, Total_successful_bookings, weekdays, Total_revenue, Total_bookings,
 Total_capacity),

 previous_and_current as (select current_week.weeks as weeks, current_week.Total_revenue as current_total_Revenue, 
 previous_week.Total_revenue as previous_Total_Revenue, current_week.ADR as current_ADR, 
 previous_week.ADR as Previous_ADR, current_week.Total_RevPar as current_RevPar, 
 previous_week.Total_Revpar as Previous_Revpar, current_week.Occupancy as current_occupancy, 
 previous_week.Occupancy as Previous_occupancy, current_week.DSRN as current_DSRN, 
 previous_week.DSRN as Previous_DSRN from week_over as current_week
 join week_over as previous_week on current_week.rowss = previous_week.rowss + 1)

select weeks, (current_total_Revenue-previous_Total_Revenue)/previous_Total_Revenue as WoW_Revenue,
(current_ADR -Previous_ADR)/Previous_ADR as WoW_ADR,
(current_RevPar -Previous_Revpar)/Previous_Revpar as WoW_Revpar,
(current_occupancy-Previous_occupancy)/Previous_occupancy as WoW_Occupancy,
(current_DSRN-Previous_DSRN)/Previous_DSRN as WoW_DSRN
from previous_and_current;

-- week over week Realization
 go
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


-- Aggregation on days

go

with First_agg_booking as (select cast(check_in_date as date) as weekdays,  DATEPART(week, check_in_date) as weeks,
Min(Check_in_date) as week_start, Max(check_in_date) as week_end,
(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as No_of_days,
 sum(revenue_realized) as Total_revenue, 
count(booking_id) as total_bookings
from fact_bookings
group by DATEPART(week, check_in_date), cast (check_in_date as date)),

Second_agg_booking as (select weekdays, weeks, No_of_days, Total_revenue, Total_Bookings, checked_out, cancelled, No_Show
from First_agg_booking as A
join (select check_in_date, sum(case when booking_status = 'Checked Out' then 1 else 0 End) as checked_out,
sum(case when booking_status = 'Cancelled' then 1 else 0 End) as cancelled,
sum(case when booking_status = 'No Show' then 1 else 0 End) as No_Show from fact_bookings
group by check_in_date)  as B on A.weekdays = B.check_in_date)

select weekdays, weeks, No_of_days, Total_revenue, Total_bookings, checked_out, cancelled, No_show, 
successful_bookings, capacity from Second_agg_booking as C join (select check_in_date, sum(successful_bookings)
as successful_bookings, sum(capacity) as capacity from 
fact_aggregated_bookings
group by check_in_date) as D
on C.weekdays = D.check_in_date;



go

--Aggregation to week level

with First_agg_booking as (select cast(check_in_date as date) as weekdays,  DATEPART(week, check_in_date) as weeks,
Min(Check_in_date) as week_start, Max(check_in_date) as week_end,
(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as No_of_days,
 sum(revenue_realized) as Total_revenue, 
count(booking_id) as total_bookings
from fact_bookings
group by DATEPART(week, check_in_date), cast (check_in_date as date)),

Second_agg_booking as (select weekdays, weeks, No_of_days, Total_revenue, Total_Bookings, checked_out, cancelled, No_Show
from First_agg_booking as A
join (select check_in_date, sum(case when booking_status = 'Checked Out' then 1 else 0 End) as checked_out,
sum(case when booking_status = 'Cancelled' then 1 else 0 End) as cancelled,
sum(case when booking_status = 'No Show' then 1 else 0 End) as No_Show from fact_bookings
group by check_in_date)  as B on A.weekdays = B.check_in_date),

agg_final as (select weekdays, weeks, No_of_days, Total_revenue, Total_bookings, checked_out, cancelled, No_show, 
successful_bookings, capacity from Second_agg_booking as C join (select check_in_date, sum(successful_bookings)
as successful_bookings, sum(capacity) as capacity from 
fact_aggregated_bookings
group by check_in_date) as D
on C.weekdays = D.check_in_date),

Matrixes_in_one_Table as (select weeks, sum(no_of_days) as No_of_Days, sum(Total_revenue) as Total_Revenue, sum(Total_bookings) as Total_Bookings, 
sum(checked_out) as Total_checkout, 
sum(cancelled) as Total_Cancelled, sum(No_Show) as Total_No_show, sum(successful_bookings) as successful_bookings, 
sum(capacity) as Total_capacity from agg_final
group by weeks)

select weeks, No_of_Days, Total_Revenue, Total_Bookings, Total_checkout, Total_No_show, successful_bookings, Total_capacity,
(successful_bookings/Total_capacity) as occupancy, (Total_Revenue/successful_bookings) as ADR, 
(Total_Revenue/Total_capacity) as RevPar,(Total_capacity/No_of_Days) as DSRN, (Total_checkout/successful_bookings) as Realization
from Matrixes_in_one_Table
group by weeks, No_of_Days, Total_Revenue, Total_Bookings, Total_checkout, Total_No_show, successful_bookings, Total_capacity
order by weeks

-- Bringing it down to week over week calculation

with First_agg_booking as (select cast(check_in_date as date) as weekdays,  DATEPART(week, check_in_date) as weeks,
Min(Check_in_date) as week_start, Max(check_in_date) as week_end,
(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as No_of_days,
 sum(revenue_realized) as Total_revenue, 
count(booking_id) as total_bookings
from fact_bookings
group by DATEPART(week, check_in_date), cast (check_in_date as date)),

Second_agg_booking as (select weekdays, weeks, No_of_days, Total_revenue, Total_Bookings, checked_out, cancelled, No_Show
from First_agg_booking as A
join (select check_in_date, sum(case when booking_status = 'Checked Out' then 1 else 0 End) as checked_out,
sum(case when booking_status = 'Cancelled' then 1 else 0 End) as cancelled,
sum(case when booking_status = 'No Show' then 1 else 0 End) as No_Show from fact_bookings
group by check_in_date)  as B on A.weekdays = B.check_in_date),

agg_final as (select weekdays, weeks, No_of_days, Total_revenue, Total_bookings, checked_out, cancelled, No_show, 
successful_bookings, capacity from Second_agg_booking as C join (select check_in_date, sum(successful_bookings)
as successful_bookings, sum(capacity) as capacity from 
fact_aggregated_bookings
group by check_in_date) as D
on C.weekdays = D.check_in_date),

Matrixes_in_one_Table as (select weeks, sum(no_of_days) as No_of_Days, sum(Total_revenue) as Total_Revenue, sum(Total_bookings) as Total_Bookings, 
sum(checked_out) as Total_checkout, 
sum(cancelled) as Total_Cancelled, sum(No_Show) as Total_No_show, sum(successful_bookings) as successful_bookings, 
sum(capacity) as Total_capacity from agg_final
group by weeks),

Normal_Matrices as (select weeks, No_of_Days, Total_Revenue, Total_Bookings, Total_checkout, Total_No_show, successful_bookings, Total_capacity,
(successful_bookings/Total_capacity) as occupancy, (Total_Revenue/successful_bookings) as ADR, 
(Total_Revenue/Total_capacity) as RevPar, (Total_checkout/successful_bookings) as Realization, (Total_capacity/No_of_Days) as DSRN,
ROW_NUMBER() over(order by weeks) as calc_rownum
from Matrixes_in_one_Table
group by weeks, No_of_Days, Total_Revenue, Total_Bookings, Total_checkout, Total_No_show, successful_bookings, Total_capacity),

Previous_and_current_week as (select current_week.weeks, current_week.Total_Revenue as current_Revenue, previous_week.Total_Revenue as Previous_Revenue,
current_week.Occupancy as current_Occupancy, previous_week.Occupancy as previous_occupancy, 
current_week.ADR as current_ADR, previous_week.ADR as Previous_ADR, current_week.RevPar as current_Revpar, previous_week.RevPar as Previous_Revpar, 
current_week.Realization as current_Realization, previous_week.Realization as Previous_Realization, current_week.DSRN as current_DSRN,
previous_week.DSRN as Previous_DSRN from Normal_Matrices
as current_week join Normal_Matrices as previous_week on current_week.weeks = previous_week.weeks + 1 )

select weeks, (current_Revenue - Previous_Revenue)/Previous_Revenue  as WOW_Revenue,
(current_Occupancy - previous_occupancy)/previous_occupancy  as WOW_Occupancy,
(current_ADR - Previous_ADR)/Previous_ADR  as WOW_ADR,
(current_Revpar - Previous_Revpar)/Previous_Revpar  as WOW_Revpar,
(current_Realization - Previous_Realization)/Previous_Realization as WOW_Realization,
(current_DSRN - Previous_DSRN)/Previous_DSRN  as WOW_DSRN
from Previous_and_current_week
order by weeks;

go



-- Hotel Detail Data

with hotel_info_and_agg as (select A.property_id as Property_id, B.property_name as property_name,
category as Hotel_category, room_category, B.city as city, check_in_date as check_in_date, successful_bookings, capacity
from fact_aggregated_bookings as A
Join dim_hotels as B on A.property_id = B.property_id),

Hotel_and_room_category as (select check_in_date, property_id, property_name, city,  room_category, room_class, successful_bookings, capacity 
from hotel_info_and_agg join dim_rooms as D on  room_id = room_category)

select check_in_date, Property_id, property_name,city, room_category, room_class, successful_bookings, capacity
from Hotel_and_room_category 




go
--- Aggregated for KPI

go
with for_KPI as (
select distinct check_in_date, sum(revenue_realized) over(partition by check_in_date order by check_in_date) as revenue_realized,
 sum(case when booking_status = 'Checked Out' then 1 else 0 End) over(partition by check_in_date order by check_in_date) as checked_out,
sum(case when booking_status = 'Cancelled' then 1 else 0 End) over(partition by check_in_date order by check_in_date) as cancelled,
sum(case when booking_status = 'No Show' then 1 else 0 End) over(partition by check_in_date order by check_in_date) as No_Show
 from fact_bookings)


select distinct A.check_in_date, checked_out, cancelled, No_show , Total_capacity, successful_bookings, revenue_realized from for_KPI as A Join 
 (select distinct check_in_date,  sum(successful_bookings) as successful_bookings,
 sum(capacity) as Total_capacity
 from fact_aggregated_bookings group by check_in_date) as B on A.check_in_date = B.check_in_date;









