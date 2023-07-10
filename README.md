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

![Alt Text]()

### VIEWING THE HOTEL TABLE

`select * from dim_hotels`

![Alt Text]()

### VIEWING THE ROOMS TABLE

`select * from dim_rooms;`

![Alt Text]()

### VIEWING AGGREGATED BOOKINGS TABLE

`select * from fact_aggregated_bookings;`

![Alt Text]()

### VIEWING THE ACTUAL BOOKINGS TABLE

`select * from fact_bookings;`

![Alt Text]()

### TOTAL BOOKINGS

`select count(booking_id) as Total_booking`
`from fact_bookings`

![Alt Text]()

### TOTAL CAPACITY

`select sum(capacity) as Total_Capacity`  
`from fact_aggregated_bookings;`

![Alt Text]()

### TOTAL SUCCESSFUL BOOKINGS

`select sum(successful_bookings) as Total_Successful_Bookings`
`from fact_aggregated_bookings;`

![Alt Text]()

### TOTAL OCCUPANCY (IN PERCENTAGE)

`select concat(round((sum(successful_bookings)/sum(capacity))*100,2),' %')`
`as Total_Percentage_Occupancy`
`from fact_aggregated_bookings;`

![Alt Text]()

### AVERAGE RATING

`select round(AVG(ratings_given),2)`
`as Total_Average_Rating`
`from fact_bookings;`

![Alt Text]()

### NO OF DAYS

`select DATEDIFF(day, Min(date), Max(date)) + 1` 
`as Total_No_of_Days`
`from dim_date;`

![Alt Text]()

**_NB:_** I had to add 1 to the date difference function because the **DATEDIFF** function do not add the last day.

### TOTAL CANCELLED BOOKINGS

`select count([booking_status])`
`as total_cancelled_Bookings`
`from fact_bookings`
`where booking_status = 'Cancelled';`

![Alt Text]()

### PERCENTAGE OF CANCELLED BOOKINGS

`with agg_booking_status as (select booking_status, cast(count(booking_status)as float)` 
`as agg_status from fact_bookings`
`group by booking_status)`

`select booking_status, concat(round((agg_status * 100) /`
`(select count(booking_status) from fact_bookings),2),' %')`
`as Percentage_Cancelled`
`from agg_booking_status`
`where booking_status = 'Cancelled';`

![Alt Text]()

### TOTAL CHECK-OUT

`select count([booking_status])` 
`as total_Checked_Out_Bookings` 
`from fact_bookings`
`where booking_status = 'Checked Out';`

![Alt Text]()

### TOTAL NO SHOW

`select count([booking_status])` 
`as total_No_Show_Bookings` 
`from fact_bookings`
`where booking_status = 'No Show';`

![Alt Text]()

### PERCENTAGE OF NO SHOW

`with agg_booking_status as (select booking_status, cast(count(booking_status)as float)`
`as agg_status from fact_bookings`
`group by booking_status)`

`select booking_status, concat(round((agg_status * 100) /`
`(select count(booking_status) from fact_bookings),2),' %')`
`as Percentage_No_Show`
`from agg_booking_status`
`where booking_status = 'No Show';`

![Alt Text]()

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

![Alt Text]()

### AVERAGE DAILY RATE

`select round(sum(revenue_generated)/count(booking_id),2)` 
`as Average_Daily_Rate from fact_bookings;`

![Alt Text]()

### REALIZATION

`with agg_booking_status as (select booking_status, cast(count(booking_status)as float)` 
`as agg_status from fact_bookings`
`group by booking_status)`

`select booking_status, concat(round((agg_status * 100) /`
`(select count(booking_status) from fact_bookings),2),' %')`
`as Percentage_Checked_Out_or_Realization`
`from agg_booking_status`
`where booking_status = 'Checked Out';`

![Alt Text]()

### REVENUE PER ROOM 

`select round(sum(a.revenue_generated)/sum(agg.capacity),2) as RevPAR`
`from fact_bookings as a join fact_aggregated_bookings as agg on`
`a.property_id = agg.property_id;`

![Alt Text]()

### DAILY BOOKING RATE NIGHT 

`select Round(cast(count(booking_id) as float)/`
`(select DATEDIFF(day, Min(date), Max(date)) + 1`
`as Total_No_of_Days`
`from dim_date),2) as DBRN from fact_bookings;`

![Alt Text]()

### DAILY SELLABLE RATE NIGHT

`select round(sum(Capacity)/(select DATEDIFF(day, Min(date), Max(date)) + 1`
`as Total_No_of_Days`
`from dim_date),2) as DSRN from fact_aggregated_bookings;`

![Alt Text]()

### DAILY USEABLE ROOM NIGHT

`select distinct (select count([booking_status])`
`as total_Checked_Out_Bookings`
`from fact_bookings`
`where booking_status = 'Checked Out')/(select DATEDIFF(day, Min(date), Max(date)) + 1`
`as Total_No_of_Days`
`from dim_date) as DURN from fact_bookings;`

![Alt Text]()
   


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
* WEEK OVER WEEK PERCENTAGE DIFFERECE _(Calculated week over week Revenue)_: `(SUM([Revenue Generated])-LOOKUP(SUM([Revenue Generated]),-1))/ABS(LOOKUP(SUM([Revenue Generated]),-1))`
* WOW PERCENTAGE OCCUPANCY -(Calculated WoW change in % occupancy)_:
* 
    