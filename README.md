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

    