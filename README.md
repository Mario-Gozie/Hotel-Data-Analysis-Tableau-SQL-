## INTRODUCTION

This a data analysis project/visualization of data of a hospitality industry called **Atliq Grands.** which own multiple five star hotel across India and has been in the business for the past 20 years.

## PROBLEM STATEMENT
Due to stactegic move form competitors and ineffective decision-making in management, Atliq Frand are loosing its market share and revenue in the luxury/hotel business. As a stractegic move, the Managing director of Atliq wanted to incoperate "Business and Data Intelligence" to regain their market share and revenue. However, they do not have an in house Data Analytics team to provide them with insights. Their Revenue Team has decited to have a third party servive provider to provide them with insits from their historical data and they have scheduled to meet in two days time.

## Discussion at the Meeting

There were three major points discussed at this meeting which were:

* Creation of Metrics in a Metric list.
* Creation of dashboard according to mock-up provided by the stakeholders
* Creation of relevant insights that are not provided in the metric list/Mock-up

### SOME KEY METIRCS PRESENTED BY THE STAKEHOLDERS ARE 

1) RevPar  - Revenue per Available room. 

    * This is the Ration of Revenue to Available rooms. mathematically RevPar = Total Revenue/Avialable rooms

**_NB:_** Room that have plumbing issues, leaking roofs, bad air-conditions and/fridges are not considered to be sellable or available.

2) Occupancy in Percentage

    *  This is the ratio of occupied rooms to available rooms, Mathematically, its given as No of occupied rooms / no of available rooms.

3) Average Daily Rate

    *  This is the ratio of Total Room Revenue to Total rooms sold. Mathematically, this is Total room Revenue/Total room sold.

4) SNR 

     * Sellable Room Night. while discussing with the board, they agreed that this would not be so important to them and they would prefer it to be daily. That led to the **Daily dellable room matrix** (DSRN).

5) DSRN

    * Daily Sellable Room Nights is the number of rooms that are sellable per day

6) REALIZATION

    * This it the ratio of utilized room nights to booked room nights. Mathematically, it is URN/BRN. This matrix gives an idea of the industry's revenue. All rooms used are considered under URN while URN, cancelled and No show (rooms paid for but wasn't later used) are considerd as BRN. 

**_NB:_** A data Analyst once asked why _No show_ is not added as under URN when in the industry may not refund when they dont show up. The Managing Director replied that its not considered as URN in because some booking companies do refund. in some cases it's a percentage, in the other, its in full. so for the sake of accounting, its only considered at bottom line level.

7)  WEEKDAY AND WEEKEND FILTER

* creating a weekday and weekend filter will help understand businees and leisure hotels.

**_NB:_** The Manager made us under stand that weekdays in the hospitality industry start from sunday and ends on thursday. while fridays and saturdays are considered as weekend, unlike the conventional believe.

## THE TASK WITH SQL 

### VIEWING DATE TABLE

`Select * from dim_date`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Viewing_Date_Table.png)

### VIEWING THE HOTEL TABLE

`select * from dim_hotels`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Viewing_hotel_type_table.png)

### VIEWING THE ROOMS TABLE

`select * from dim_rooms;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Viewing%20room%20type%20Table.png)

### VIEWING AGGREGATED BOOKINGS TABLE

`select * from fact_aggregated_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/viewing_Agg_bookings_Table.png)

### VIEWING THE ACTUAL BOOKINGS TABLE

`select * from fact_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Viewing_the_actual_booking_Table.png)

### TOTAL BOOKINGS

`select count(booking_id) as Total_booking`
`from fact_bookings`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_Bookings.png)

### TOTAL CAPACITY

`select sum(capacity) as Total_Capacity`  
`from fact_aggregated_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_Capacity.png)

### TOTAL SUCCESSFUL BOOKINGS

`select sum(successful_bookings) as Total_Successful_Bookings`
`from fact_aggregated_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_Successful_bookings.png)

### TOTAL OCCUPANCY (IN PERCENTAGE)

`select concat(round((sum(successful_bookings)/sum(capacity))*100,2),' %')`
`as Total_Percentage_Occupancy`
`from fact_aggregated_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_Percentage_Occupancy.png)

### AVERAGE RATING

`select round(AVG(ratings_given),2)`
`as Total_Average_Rating`
`from fact_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_Average_Rating.png)

### NO OF DAYS

`select DATEDIFF(day, Min(date), Max(date)) + 1` 
`as Total_No_of_Days`
`from dim_date;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_No_of_Days.png)

**_NB:_** I had to add 1 to the date difference function because the **DATEDIFF** function do not add the last day.

### TOTAL CANCELLED BOOKINGS

`select count([booking_status])`
`as total_cancelled_Bookings`
`from fact_bookings`
`where booking_status = 'Cancelled';`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_Canceled_Bookings.png)

### PERCENTAGE OF CANCELLED BOOKINGS

`with agg_booking_status as (select booking_status, cast(count(booking_status)as float)` 
`as agg_status from fact_bookings`
`group by booking_status)`

`select booking_status, concat(round((agg_status * 100) /`
`(select count(booking_status) from fact_bookings),2),' %')`
`as Percentage_Cancelled`
`from agg_booking_status`
`where booking_status = 'Cancelled';`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Percentage_Canceled_Bookings.png)

### TOTAL CHECK-OUT

`select count([booking_status])` 
`as total_Checked_Out_Bookings` 
`from fact_bookings`
`where booking_status = 'Checked Out';`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_Checked_Out.png)

### TOTAL NO SHOW

`select count([booking_status])` 
`as total_No_Show_Bookings` 
`from fact_bookings`
`where booking_status = 'No Show';`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_No_Show.png)

### PERCENTAGE OF NO SHOW

`with agg_booking_status as (select booking_status, cast(count(booking_status)as float)`
`as agg_status from fact_bookings`
`group by booking_status)`

`select booking_status, concat(round((agg_status * 100) /`
`(select count(booking_status) from fact_bookings),2),' %')`
`as Percentage_No_Show`
`from agg_booking_status`
`where booking_status = 'No Show';`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Percentage_No_Show.png)

### PERCENTAGE BOOKINGS PER PLATFORM

`with agg_booking_per_Platform as`
`(select booking_platform, cast(count(booking_id) as float)` 
`as booking_Per_platform` 
`from fact_bookings`
`group by booking_platform)`

`select booking_platform, concat(Round((booking_per_platform * 100)/`
`(select count(booking_id) from fact_bookings),2),' %')` 
`as Percentage_per_Platform`
`from agg_booking_per_Platform;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Percentage_Booking_Per_Platform.png)

### REALIZATION PER PLATFORM

`with Total_check_out as (select booking_platform,cast(count(booking_status) as float)`
`as checkout from fact_bookings`
`where booking_status = 'Checked Out'`
`group by booking_platform),`

`check_out_and_bookings as (select a.booking_platform, checkout, count(booking_id) as bookings`
`from Total_check_out as a join fact_bookings as b on`
`b.booking_platform = a.booking_platform`
`group by a.booking_platform, checkout)`

`select booking_platform, concat(round((checkout* 100/bookings),2),' %')`
`as Total_Realization from check_out_and_bookings`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Realization%20per%20platform.png)

### ADR PER PLATFORM

`select booking_platform, format(round((sum(revenue_realized)/`
`count(booking_id)),2),'c') as ADR from  fact_bookings`
`group by booking_platform`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/ADR_per%20Platform.png)

### PERCENTAGE BOOKINGGS PER ROOM CLASS

`with agg_room_count as (select room_category, room_class,`
`cast(count(booking_id) as float)`
`as room_count`
`from fact_bookings`
`join dim_rooms on room_id = room_category`
`group by room_category, room_class)`

`select room_category,room_class, concat(round(room_count * 100/`
`(select count(booking_id) as tot_bookings from fact_bookings),2),' %')`
`as room_booking_ratio`
`from agg_room_count;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Percentage_Booking_Per_Room_Type.png)

### AVERAGE DAILY RATE

* Revenue/Bookings

`select round(sum(revenue_realized)/count(booking_id),2)` 
`as Average_Daily_Rate from fact_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/ADR.png)

### REALIZATION

* Propotion of checkouts = 1 - (Propotion of No Show + Propotion of Cancellation)

`with agg_booking_status as (select booking_status, cast(count(booking_status)as float)` 
`as agg_status from fact_bookings`
`group by booking_status)`

`select booking_status, concat(round((agg_status * 100) /`
`(select count(booking_status) from fact_bookings),2),' %')`
`as Percentage_Checked_Out_or_Realization`
`from agg_booking_status`
`where booking_status = 'Checked Out';`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Realization_or_Percentage_Checked_out.png)

### REVENUE PER ROOM 

* Revenue/Capacity

`select round(sum(revenue_realized)/(select sum(capacity)`
`from fact_aggregated_bookings),2) as RevPAR from fact_bookings`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Total_RevPAR.png)

### DAILY BOOKING RATE NIGHT 

* Bookings/Number of Days

`select Round(cast(count(booking_id) as float)/`
`(select DATEDIFF(day, Min(date), Max(date)) + 1`
`as Total_No_of_Days`
`from dim_date),2) as DBRN from fact_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Daily_Booking_Rate_Night.png)

### DAILY SELLABLE RATE NIGHT

* Capacity/Number of Days

`select round(sum(Capacity)/(select DATEDIFF(day, Min(date), Max(date)) + 1`
`as Total_No_of_Days`
`from dim_date),2) as DSRN from fact_aggregated_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Daily_Sellable_Room_Night.png)

### DAILY USEABLE ROOM NIGHT (DURN)

* Number of Check Outs/Number of Days

`select distinct (select count([booking_status])`
`as total_Checked_Out_Bookings`
`from fact_bookings`
`where booking_status = 'Checked Out')/(select DATEDIFF(day, Min(date), Max(date)) + 1`
`as Total_No_of_Days`
`from dim_date) as DURN from fact_bookings;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Daily_Usable_Room_Night.png)

### WEEK OVER WEEK PERCENTAGE REVENUE CHANGE

`with week_over_week_cte as (select DATEPART(WEEK,check_in_date) as week_no,` 
`sum(Revenue_realized) as revenue, ROW_NUMBER() over(order by DATEPART(WEEK,check_in_date))` 
`as row_num from fact_bookings`
`group by DATEPART(WEEK,check_in_date))`

`select current_week.week_no, current_week.revenue, previous_week.revenue`
`as previous_week_revenue, concat(round((((current_week.revenue - previous_week.revenue)/`
`previous_week.revenue)*100),2),' %') as week_over_week_Revenue`
`from week_over_week_cte as current_week join`
`week_over_week_cte as previous_week on previous_week.row_num = current_week.row_num - 1;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/week%20over%20week%20Revenue.png)

### WEEK OVER WEEK OCCUPANCY PERCENTAGE CHANGE

* successful bookings/capacity

`with weekly_occupancy as (select DATEPART(WEEK,check_in_date) as week_no,` 
`sum(successful_bookings)/ sum(capacity) as WoW_Occupancy_Change,`
`ROW_NUMBER() over(order by DATEPART(WEEK,check_in_date)) as row_num`
`from fact_aggregated_bookings`
`group by DATEPART(WEEK,check_in_date))`

`select week_no, concat(round((wow_Occupancy_Change-lag(WoW_Occupancy_Change)`
`Over(order by week_no)) * 100/lag(WoW_Occupancy_Change)`
`Over(order by week_no),2),' %') as WoW_change_of_Occupany from weekly_occupancy;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/week%20over%20week%20Occupancy.png)

* Alternatively

`with Total_weekly_occupancy as (select DATEPART(WEEK,check_in_date) as week_no,`
`sum(successful_bookings)/ sum(capacity) as Weekly_Occupancy,`
`ROW_NUMBER() over(order by DATEPART(WEEK,check_in_date)) as row_num`
`from fact_aggregated_bookings`
`group by DATEPART(WEEK,check_in_date))`

`select current_week.week_no, current_week.weekly_Occupancy,`
`previous_week.weekly_Occupancy,`
`concat(round((current_week.Weekly_Occupancy - previous_week.Weekly_Occupancy)*100/`
`(previous_week.Weekly_Occupancy),2),' %') as Week_over_week_Occupancy`
`from Total_weekly_occupancy as current_week`
`join Total_weekly_occupancy as previous_week` 
`on current_week.row_num = previous_week.row_num + 1;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Alternative%20week%20over%20week%20occupancy.png)

### WEEK OVER WEEK ADR CHANGE

* Revenue/Bookings

`with agg_ADR as (select DATEPART(WEEK,check_in_date) as week_no,`
`sum(Revenue_realized)/Count(booking_id) as Total_ADR from fact_bookings`
`group by DATEPART(WEEK,check_in_date))`

`select week_no, concat(round(((Total_ADR-lag(Total_ADR) over(order by week_no))*100/`
`lag(Total_ADR) over(order by week_no)),2),' %') as WoW_ADR from agg_ADR;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Week%20over%20week%20Average%20Daily%20Rate.png)

* Alternatively

`with agg_ADR as (select DATEPART(WEEK,check_in_date) as week_no,`
`sum(Revenue_realized)/Count(booking_id) as Total_ADR,`
`ROW_NUMBER() over(order by DATEPART(WEEK,check_in_date)) as rownum`
`from fact_bookings`
`group by DATEPART(WEEK,check_in_date))`

`select current_week.week_no, current_week.Total_ADR, Previous_week.Total_ADR`
`as Previous_week_ADR, concat(round((((current_week.Total_ADR - previous_week.Total_ADR)/`
`previous_week.Total_ADR) *100),2),' %') as Week_over_week_occupancy`
`from agg_ADR as current_week`
`join agg_ADR as previous_week on current_week.rownum = previous_week.rownum + 1;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Alternative%20Week%20over%20week%20Average%20Daily%20Rate.png)

### WEEK OVER WEEK REVENUE PER DAY (RevPAR)

* Revenue/Capacity

`with Total_Revenues as (select DATEPART(week, check_in_date) as weeks, sum(revenue_realized) as Total_rev`
`from fact_bookings`
`group by DATEPART(week, check_in_date)),`

`caps_included as (select a.weeks, Total_rev, sum(capacity) as Total_capacity,` 
`(Total_rev/sum(capacity)) as RevPar,`
`ROW_NUMBER() over(order by weeks) as rownum`
`from Total_Revenues as a`
`join fact_aggregated_bookings as b on a.weeks = DATEPART(week, check_in_date)`
`group by a.weeks,Total_rev),`

`current_and_Previous_week as (select current_week.weeks, current_week.Total_rev, current_week.Total_capacity,` 
`current_week.RevPar as current_RevPAR,`
`previous_week.RevPAR as Previous_Revpar`
`from caps_included as current_week join`
`caps_included as previous_week on current_week.rownum = previous_week.rownum + 1)`

`select weeks, concat(round((((current_RevPAR-Previous_revPAR)/`
`Previous_Revpar)*100),2),' %') as WOW_REVPAR from current_and_Previous_week;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Week%20over%20Week%20RevPAR.png)

### WEEK OVER WEEK REALIZATION

* Propotion of checkouts. This is also equal to 1 - (propotion of no show + Propotion of cancellation)

`with Total_Checkout_table as (select DATEPART(WEEK,check_in_date) as week_no,`
`cast(count(booking_id) as float) as Total_Checkout,`
`(select count(booking_id) from fact_bookings) as Total_bookings`
`from fact_bookings`
`where booking_status = 'Checked Out'`
`group by DATEPART(WEEK,check_in_date)),`

`Total_weekly_realization as (select week_no, Total_Checkout/Total_bookings`
`as weekly_realization,`
`ROW_NUMBER() over(order by week_no) as row_num`
`from Total_Checkout_table)`

`select current_week.week_no, current_week.weekly_realization,`
`previous_week.weekly_realization as Previous_week_realization,`
`(current_week.weekly_realization- previous_week.weekly_realization) *100/`
`previous_week.weekly_realization as week_over_week_Realization`
`from Total_weekly_realization as current_week join`
`Total_weekly_realization as previous_week`
`on current_week.row_num = previous_week.row_num + 1;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Week%20over%20week%20Realization.png)

### WEEK OVER WEEK DAILY SELLABLE ROOM NIGHT

* Capacity/Number of Days

`with weekly_capacity as (select DATEPART(WEEK,check_in_date) as week_no,` 
`sum(capacity) as Total_Capacity from fact_aggregated_bookings`
`group by DATEPART(WEEK,check_in_date)),`

`days_and_capacity as (select caps.week_no, Total_capacity,` 
`dayss.Actual_week_days from weekly_capacity`
`as caps join (select DATEPART(WEEK,check_in_date) as week_no ,`
`DATEDIFF(day, Min(check_in_date), Max(check_in_date))`
`+ 1 as actual_week_days from fact_aggregated_bookings` 
`group by DATEPART(WEEK,check_in_date)) as dayss` 
`on dayss.week_no = caps.week_no),`

`Total_DSRN as (select week_no, Total_capacity/Actual_week_days` 
`as DSRN_weekly, ROW_NUMBER()`
`over(order by week_no) as Row_num from days_and_capacity)`

`select current_week.week_no, current_week.DSRN_weekly, Previous_week.DSRN_weekly,`
`concat(round(((current_week.DSRN_weekly - Previous_week.DSRN_weekly) * 100/`
`previous_week.DSRN_weekly),2),' %') as week_over_week_DSRN`
`from Total_DSRN as current_week join`
`Total_DSRN as previous_week on previous_week.Row_num = current_week.Row_num-1;`

![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/week%20over%20week%20DSRN.png)

## AT THIS POINT ALL YOU WILL SEE ARE CRAZY AGGREGATED QUERIES TO SOLVE SAME PROBLEMS YOU SEE ABOVE. YOU CAN OVERLOOK IF IT WILL BORE YOU.

*  CALCULATING TOTAL REVENUE, BOOKING, DAYS, ADR, REVPAR, OCCUPANCY AND DSRN PER WEEK

`with Total_bookings as (select DATEPART(week, check_in_date) as weeks,`
`Min(Check_in_date) as week_start, Max(check_in_date) as week_end,`
`(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as weekdays,`
 `sum(revenue_realized) as Total_revenue,` 
`count(booking_id) as total_bookings`
`from fact_bookings`
`group by DATEPART(week, check_in_date)),`

`Agg_table_Join as (select A.weeks, weekdays, Total_Revenue, total_bookings,`
`Total_successful_bookings, Total_capacity`
 `from Total_bookings as A join`
`(select DATEPART(week, check_in_date) weeks,`
`sum(successful_bookings) as Total_successful_bookings,`
`sum(capacity) as Total_capacity from fact_aggregated_bookings`
`group by DATEPART(week, check_in_date)) as agg_of_agg on agg_of_agg.weeks = A.weeks)`

`select weeks, Total_successful_bookings, weekdays, Total_revenue, Total_bookings,`
 `Total_capacity,`
`sum(Total_Revenue)/sum(total_bookings) as ADR,`
`sum(Total_Revenue)/sum(Total_Capacity) as  Total_RevPar,`
`sum(Total_successful_bookings)/sum(Total_capacity) as Occupancy,`
 `Total_Capacity/weekdays DSRN` 
`from Agg_table_Join`
`group by weeks, Total_successful_bookings, weekdays, Total_revenue, Total_bookings,`
 `Total_capacity;`

 [Alt Text]()

 * CALCULATING WEEK OVER WEEK REVENUE, ADR, REVPAR, OCCUPANCY, DSRN

  `with Total_bookings as (select DATEPART(week, check_in_date) as weeks,`
`Min(Check_in_date) as week_start, Max(check_in_date) as week_end,`
`(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as weekdays,`
 `sum(revenue_realized) as Total_revenue,` 
`count(booking_id) as total_bookings`
`from fact_bookings`
`group by DATEPART(week, check_in_date)),`

`Agg_table_Join as (select A.weeks, weekdays, Total_Revenue, total_bookings,`
`Total_successful_bookings, Total_capacity`
 `from Total_bookings as A join`
`(select DATEPART(week, check_in_date) weeks,`
`sum(successful_bookings) as Total_successful_bookings,`
`sum(capacity) as Total_capacity from fact_aggregated_bookings`
`group by DATEPART(week, check_in_date)) as agg_of_agg on agg_of_agg.weeks = A.weeks),`

 `week_over as (select weeks, Total_successful_bookings, weekdays, Total_revenue, Total_bookings,`
 `Total_capacity,`
`sum(Total_Revenue)/sum(total_bookings) as ADR,`
`sum(Total_Revenue)/sum(Total_Capacity) as  Total_RevPar,`
`sum(Total_successful_bookings)/sum(Total_capacity) as Occupancy,`
 `Total_Capacity/weekdays DSRN, ROW_NUMBER() over(order by weeks) as rowss`
`from Agg_table_Join`
`group by weeks, Total_successful_bookings, weekdays, Total_revenue, Total_bookings,`
 `Total_capacity),`

 `previous_and_current as (select current_week.weeks as weeks, current_week.Total_revenue as current_total_Revenue,`
 `previous_week.Total_revenue as previous_Total_Revenue, current_week.ADR as current_ADR,`
 `previous_week.ADR as Previous_ADR, current_week.Total_RevPar as current_RevPar,`
 `previous_week.Total_Revpar as Previous_Revpar, current_week.Occupancy as current_occupancy,`
 `previous_week.Occupancy as Previous_occupancy, current_week.DSRN as current_DSRN,`
 `previous_week.DSRN as Previous_DSRN from week_over as current_week`
 `join week_over as previous_week on current_week.rowss = previous_week.rowss + 1)`

`select weeks, (current_total_Revenue-previous_Total_Revenue)/previous_Total_Revenue as WoW_Revenue,`
`(current_ADR -Previous_ADR)/Previous_ADR as WoW_ADR,`
`(current_RevPar -Previous_Revpar)/Previous_Revpar as WoW_Revpar,`
`(current_occupancy-Previous_occupancy)/Previous_occupancy as WoW_Occupancy,`
`(current_DSRN-Previous_DSRN)/Previous_DSRN as WoW_Revenue`
`from previous_and_current;`

[Alt Text]()

* CALCULATING WEEK OVER WEEK REALIZATION

 `with Total_Checkout_table as (select DATEPART(WEEK,check_in_date) as week_no,`
`cast(count(booking_id) as float) as Total_Checkout,`
`(select count(booking_id) from fact_bookings) as Total_bookings`
`from fact_bookings`
`where booking_status = 'Checked Out'`
`group by DATEPART(WEEK,check_in_date)),`

`Total_weekly_realization as (select week_no, Total_Checkout/Total_bookings` 
`as weekly_realization,`
`ROW_NUMBER() over(order by week_no) as row_num` 
`from Total_Checkout_table)`

`select current_week.week_no, current_week.weekly_realization,` 
`previous_week.weekly_realization as Previous_week_realization,`
`concat(round(((current_week.weekly_realization- previous_week.weekly_realization) *100/`
`(previous_week.weekly_realization)),2),' %') as week_over_week_Realization`
`from Total_weekly_realization as current_week join`
`Total_weekly_realization as previous_week`
`on current_week.row_num = previous_week.row_num + 1;`

[Alt Text]()

* AGGREGATION PER DAY FOR REVENUE, TOTAL BOOKINGS, CHECK OUTS, CANCELLED BOOKINGS, NO SHOW, CAPACITY.


`with First_agg_booking as (select cast(check_in_date as date) as weekdays,  DATEPART(week,check_in_date) as weeks,`
`Min(Check_in_date) as week_start, Max(check_in_date) as week_end,`
`(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as No_of_days,`
 `sum(revenue_realized) as Total_revenue,`
`count(booking_id) as total_bookings`
`from fact_bookings`
`group by DATEPART(week, check_in_date), cast (check_in_date as date)),`

`Second_agg_booking as (select weekdays, weeks, No_of_days, Total_revenue, Total_Bookings,checked_out, cancelled, No_Show`
`from First_agg_booking as A`
`join (select check_in_date, sum(case when booking_status = 'Checked Out' then 1 else 0 End) as checked_out,`
`sum(case when booking_status = 'Cancelled' then 1 else 0 End) as cancelled,`
`sum(case when booking_status = 'No Show' then 1 else 0 End) as No_Show from fact_bookings`
`group by check_in_date)  as B on A.weekdays = B.check_in_date)`

`select weekdays, weeks, No_of_days, Total_revenue, Total_bookings, checked_out, cancelled, No_show,` 
`successful_bookings, capacity from Second_agg_booking as C join (select check_in_date, sum(successful_bookings)`
`as successful_bookings, sum(capacity) as capacity from`
`fact_aggregated_bookings`
`group by check_in_date) as D`
`on C.weekdays = D.check_in_date;`

[Alt text]()

* AGGREGATED TABLE ON WEEK LEVEL TO CALCULATE TOTAL REVENUE, TOTAL BOOKINGS , TOTAL CHECK OUTS, TOTAL NO SHOW, TOTAL CAPACITY, OCCUPANCY, ADR, REVPAR, DSRN, REALIZAION.

`with First_agg_booking as (select cast(check_in_date as date) as weekdays,  DATEPART(week, check_in_date) as weeks,`
`Min(Check_in_date) as week_start, Max(check_in_date) as week_end,`
`(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as No_of_days,`
 `sum(revenue_realized) as Total_revenue,` 
`count(booking_id) as total_bookings`
`from fact_bookings`
`group by DATEPART(week, check_in_date), cast (check_in_date as date)),`

`Second_agg_booking as (select weekdays, weeks, No_of_days, Total_revenue, Total_Bookings,checked_out, cancelled, No_Show`
`from First_agg_booking as A`
`join (select check_in_date, sum(case when booking_status = 'Checked Out' then 1 else 0 End) as checked_out,`
`sum(case when booking_status = 'Cancelled' then 1 else 0 End) as cancelled,`
`sum(case when booking_status = 'No Show' then 1 else 0 End) as No_Show from fact_bookings`
`group by check_in_date)  as B on A.weekdays = B.check_in_date),`

`agg_final as (select weekdays, weeks, No_of_days, Total_revenue, Total_bookings, checked_out, cancelled, No_show,`
`successful_bookings, capacity from Second_agg_booking as C join (select check_in_date, sum(successful_bookings)`
`as successful_bookings, sum(capacity) as capacity from`
`fact_aggregated_bookings`
`group by check_in_date) as D`
`on C.weekdays = D.check_in_date),`

`Matrixes_in_one_Table as (select weeks, sum(no_of_days) as No_of_Days, sum(Total_revenue) as Total_Revenue, sum(Total_bookings) as Total_Bookings,`
`sum(checked_out) as Total_checkout,`
`sum(cancelled) as Total_Cancelled, sum(No_Show) as Total_No_show, sum(successful_bookings) as successful_bookings,`
`sum(capacity) as Total_capacity from agg_final`
`group by weeks)`


[Alt Text]()

* CALCULATING THE WEEK OVER WEEK VALUES FOR THE MATRICES ABOVE (REVENUE, OCCUPANCY, ADR, REVPAR, REALIZATION, DSRN)

`with First_agg_booking as (select cast(check_in_date as date) as weekdays,  DATEPART(week, check_in_date) as weeks,`
`Min(Check_in_date) as week_start, Max(check_in_date) as week_end,`
`(DATEDIFF(day, Min(Check_in_date), Max(check_in_date)) + 1) as No_of_days,`
 `sum(revenue_realized) as Total_revenue,` 
`count(booking_id) as total_bookings`
`from fact_bookings`
`group by DATEPART(week, check_in_date), cast (check_in_date as date)),`

`Second_agg_booking as (select weekdays, weeks, No_of_days, Total_revenue, Total_Bookings, checked_out, cancelled, No_Show`
`from First_agg_booking as A`
`join (select check_in_date, sum(case when booking_status = 'Checked Out' then 1 else 0 End) as checked_out,`
`sum(case when booking_status = 'Cancelled' then 1 else 0 End) as cancelled,`
`sum(case when booking_status = 'No Show' then 1 else 0 End) as No_Show from fact_bookings`
`group by check_in_date)  as B on A.weekdays = B.check_in_date),`

`agg_final as (select weekdays, weeks, No_of_days, Total_revenue, Total_bookings, checked_out, cancelled, No_show,` 
`successful_bookings, capacity from Second_agg_booking as C join (select check_in_date, sum(successful_bookings)`
`as successful_bookings, sum(capacity) as capacity from`
`fact_aggregated_bookings`
`group by check_in_date) as D`
`on C.weekdays = D.check_in_date),`

`Matrixes_in_one_Table as (select weeks, sum(no_of_days) as No_of_Days, sum(Total_revenue) as Total_Revenue, sum(Total_bookings) as Total_Bookings,`
`sum(checked_out) as Total_checkout,`
`sum(cancelled) as Total_Cancelled, sum(No_Show) as Total_No_show, sum(successful_bookings) as successful_bookings,`
`sum(capacity) as Total_capacity from agg_final`
`group by weeks),`

`Normal_Matrices as (select weeks, No_of_Days, Total_Revenue, Total_Bookings, Total_checkout, Total_No_show, successful_bookings, Total_capacity,`
`(successful_bookings/Total_capacity) as occupancy, (Total_Revenue/successful_bookings) as ADR,`
`(Total_Revenue/Total_capacity) as RevPar, (Total_checkout/successful_bookings) as Realization, (Total_capacity/No_of_Days) as DSRN,`
`ROW_NUMBER() over(order by weeks) as calc_rownum`
`from Matrixes_in_one_Table`
`group by weeks, No_of_Days, Total_Revenue, Total_Bookings, Total_checkout, Total_No_show, successful_bookings, Total_capacity),`

`Previous_and_current_week as (select current_week.weeks, current_week.Total_Revenue as current_Revenue, previous_week.Total_Revenue as Previous_Revenue,`
`current_week.Occupancy as current_Occupancy, previous_week.Occupancy as previous_occupancy,` 
`current_week.ADR as current_ADR, previous_week.ADR as Previous_ADR, current_week.RevPar as current_Revpar, previous_week.RevPar as Previous_Revpar,`
`current_week.Realization as current_Realization, previous_week.Realization as Previous_Realization, current_week.DSRN as current_DSRN,`
`previous_week.DSRN as Previous_DSRN from Normal_Matrices`
`as current_week join Normal_Matrices as previous_week on current_week.weeks = previous_week.weeks + 1 )`

`select weeks, (current_Revenue - Previous_Revenue)/Previous_Revenue  as WOW_Revenue,`
`(current_Occupancy - previous_occupancy)/previous_occupancy  as WOW_Occupancy,`
`(current_ADR - Previous_ADR)/Previous_ADR  as WOW_ADR,`
`(current_Revpar - Previous_Revpar)/Previous_Revpar  as WOW_Revpar,`
`(current_Realization - Previous_Realization)/Previous_Realization as WOW_Realization,`
`(current_DSRN - Previous_DSRN)/Previous_DSRN  as WOW_DSRN`
`from Previous_and_current_week`
`order by weeks;`

[Alt Text]()

* AGGREGATING HOTEL DETAIL

`with hotel_info_and_agg as (select A.property_id as Property_id, B.property_name as property_name,`
`category as Hotel_category, room_category, B.city as city, check_in_date as check_in_date, successful_bookings, capacity`
`from fact_aggregated_bookings as A`
`Join dim_hotels as B on A.property_id = B.property_id),`

`Hotel_and_room_category as (select check_in_date, property_id, property_name, city,  room_category, room_class, successful_bookings, capacity` 
`from hotel_info_and_agg join dim_rooms as D on  room_id = room_category)`

`select check_in_date, Property_id, property_name,city, room_category, room_class, successful_bookings, capacity`
`from Hotel_and_room_category`

[Alt Text]()


AGGREGATING TABLE TO MAKE CREATION OF KPI EASY IN TABLEAU

`with for_KPI as (`
`select distinct check_in_date, sum(revenue_realized) over(partition by check_in_date order by check_in_date) as revenue_realized,`
 `sum(case when booking_status = 'Checked Out' then 1 else 0 End) over(partition by check_in_date order by check_in_date) as checked_out,`
`sum(case when booking_status = 'Cancelled' then 1 else 0 End) over(partition by check_in_date order by check_in_date) as cancelled,`
`sum(case when booking_status = 'No Show' then 1 else 0 End) over(partition by check_in_date order by check_in_date) as No_Show`
 `from fact_bookings)`


`select distinct A.check_in_date, checked_out, cancelled, No_show , Total_capacity, successful_bookings, revenue_realized from for_KPI as A Join` 
 `(select distinct check_in_date,  sum(successful_bookings) as successful_bookings,`
 `sum(capacity) as Total_capacity`
 `from fact_aggregated_bookings group by check_in_date) as B on A.check_in_date = B.check_in_date;`








`select weeks, No_of_Days, Total_Revenue, Total_Bookings, Total_checkout, Total_No_show, successful_bookings, Total_capacity,`
(successful_bookings/Total_capacity) as occupancy, (Total_Revenue/successful_bookings) as ADR,`
(Total_Revenue/Total_capacity) as RevPar,(Total_capacity/No_of_Days) as DSRN, (Total_checkout/successful_bookings) as Realization`
from Matrixes_in_one_Table`
`group by weeks, No_of_Days, Total_Revenue, Total_Bookings, Total_checkout, Total_No_show, successful_bookings, Total_capacity`
`order by weeks`





### THE TASK WITH TABLEU

To carry out this task with tableau, there is need to need to link the five (5) tables for this task together. There are three was to create a link between tables in tableau which are 

* Relationship: Relationship is a the fairest way of linking tables in tableau.
* Blending: blending is used to create different database within Tableau and query them differently. it is perfect when you have aggregate data or data coming from different source. in most cases it works as a left join where the table were the first value is selected from is known as the primary table.
* Join: join is a way of physically linking tables

For this task, I will be using Relationship to join 4 of the tables because its the fairest and blend for the aggregate table because to aid proper analysis between the aggregate table and the other 4.

|  Relationship                             |   Blending                                 |
|------------------------------------------ | ------------------------------------------ |
|    ![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Better%20Relationship%20Tableau.png)                          |     ![Alt Text](https://github.com/Mario-Gozie/Hotel-Data-Analysis-Tableau-SQL-/blob/main/Images/Blending%20in%20Tableau.png)                                           |



## CALCULATION OF MATRICES AND THEIR FORMULAS IN TABLEAU

* WEEKS COLUMN _(Calculated week no)_: `DATEPART('week',[Date])`
* WEEKDAY AND WEEKEND COLUMN _(Calculated Week no)_: `if DATEPART('weekday',[Date])>5 then 'Weekend' Else 'Weekday' END`

**_NB:_** Remember that the Managing Director said that weekends are Fridays and Saturdays while the week starts on Sunday. in other words, Sundays to Thursdays are considered Weekdays in the Hospitality industry. since Tableau starts Numbering days from sunday and The Manager has already established that Sunday is a weekday, that is why the formula says any day greater than 5 should be weekend.

* TOTAL BOOKINGS _(Calculated Total Bookings)_: `COUNTD([Booking ID])`
* TOTAL CAPACITY _(Calculated Total Capacity)_: `SUM([Capacity])`
* TOTAL SUCCESSFUL BOOKINGS _(Calculated Total Successful Bookings)_: `SUM([Successful bookings])`
* TOTAL PERCENTAGE OCCUPANCY _(Calculated % Occupancy)_: `[Calculated Total Successful Bookings]/[Calaculated Total Capacity]`
* AVERAGE RATING _(Calculated Average Rating): `AVG([Ratings Given])`
* NO OF DAYS _(Calculated Total No of Days)_: `DATEDIFF('day', Min(Date),Max(Date)) + 1`

**_NB_** I added one because Tableau usually do not add the end date and its necessary in this situation.
* TOTAL CANCELLED BOOKINGS _(Calculated Total Cancelled Bookings)_: `COUNT(IF [Booking Status] = 'Cancelled' Then ['Booking Status] END)`
* TOTAL PERCENTAGE CANCELLED BOOKINGS _(Calculated Total % cancelled Bookings)_: `[Calculated Total Cancelled Bookings]/[Calculated Total Bookings]`
* TOTAL CHECK-OUT _(Calculated Total Check-out)_: `COUNT(IF [Booking Status] = 'Checked Out' Then [Booking Status]) END`
* TOTAL NO SHOW BOOKINGS _(Calculated No Show Bookings)_: `COUNT(if [Booking Status] = 'No Show' Then [Booking Status] END)`
* TOTAL % NO SHOW RATE _(Calculated Total % No Show Rate)_: `[Calculated Total No show ]/[Calculated total Bookings]`
* TOTAL BOOKING PERCENTAGE PER PLATFORM _(Calculated Fixed booking % per Platform)_: `{FIXED [Booking Platform]: COUNT([Booking Id])}/ {FIXED :[Calculated Total Bookings]}`
* BOOKING PERCENTAGE PER ROOM CLASS _(Calculated Fixed Booking % by Room Class)_: `{FIXED [Room Category]:COUNT([Booking Id])}/{FIXED : [Calculated Total Bookings]}`
* AVERAGE DAILY RATE (ADR) _(Calculated Average Daily Rate)_: `SUM([Revenue Generated])/[Calculated Total Bookings]`
* REALIZATION _(Calculated Total Realization (Rate))_: `1- ([Calculated Total % Cacelled Bookings ]+[Calculated Total % No Show Rate])`
* REVENUE PER ROOM (RevPAR) _(Calculated Revenue Per Room (RevPAR))_: `SUM([Revenue Generated])/[Calculated Total Capacity]`
* DAILY BOOKING RATE NIGHT (DBRN) _(Calculated Daily Booking Night Rate (DBRN))_: `[Calculated Total Bookings]/[Calculated Total No of Days]`
* DAILY SELLABLE ROOM NIGHT (DSRN) _(Calculated Daily Sellable Room (DSRN))_: `[Calculated Total Capacity]/[Calculated Total No of Days]`
* DAILY USABLE ROOM NIGHT (DURN) _(Calculated Daily Usable Room Night (DURN))_: `[Calculated Total Check-out]/[Calculated Total No of Days]`
* CREATED BOOKING PLATFORM: **I Created this because the booking platform names started with small letters and I want them to be in proper format i.e starting with capital letters.** : `Proper([Booking Platform])`
* WEEK OVER WEEK REVENU PERCENTAGE DIFFERECE _(Calculated week over week Revenue)_: `(SUM([Revenue Generated])-LOOKUP(SUM([Revenue Generated]),-1))/ABS(LOOKUP(SUM([Revenue Generated]),-1))`
* WOW PERCENTAGE OCCUPANCY -(Calculated WoW change in % occupancy)_:
* 
    

## MAJOR CHALLENGES AND KEY LESSON  I GOT FROM THIS TASK

* First Major challenge Calculation of week over week matrices was a bit difficult using sql because the week numbers didn't appear in the right order. interestingly I was able to figure my way around it after a long search using ROW_NUMBER function and a self join on the row numbers equating current row number to previous row number + 1.

* Second Major challenge was figuring out why calculations from the aggregate table was giving me fixed value over week numbers. well after a long search I understood that using a relationship for an aggregate data was the wrong thing to do. so I had to use a blend. This challenge helped me understand how blend work. for example, 

1) Fixed table calculation does not work in a case of blend when taking values from different tables. 
2) For every sheet, you must establish the link between the two different data basees in othter to use them. 
3) The tables in a blend are querried differently and it works as a left join. so to return all values from a desired table in the case of blending, you must select the desired value first from its table, thereby making it the primary table.