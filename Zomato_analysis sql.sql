create database Zomato_analysis;
use Zomato_analysis;

select * from currency;
select * from country;
select * from main_2;

------ ----------------------------------- KPIs ------------------------------------------------------------
select count(*) as Total_restuarants from main_2 where RestaurantID;
select count(distinct(countrycode)) as total_no_countries from main_2;
SELECT ROUND(AVG(Average_Cost_for_two),2) AS avg_cost_for_2 FROM main_2;
select round(avg(Rating),2) as avg_rating from main_2;
select count(distinct(cuisines)) as total_cuisines from main_2;

select distinct cuisines, countryname, Average_Cost_for_two from main_2 where Restaurant limit 10;
select cuisines, round(avg(rating),0) as avg_cuisine_rating from main_2 group by Cuisines order by avg_cuisine_rating desc limit 10;
select cuisines, round(avg(Average_Cost_for_two),0) as avg_cuisine_cost_2 from main_2 group by Cuisines order by avg_cuisine_cost_2 desc;


-------------------- Question2 -------------------------------------

alter table main_2
add column Month_Name VARCHAR(20),
add column Year INT,
add column Quarter CHAR(5),
add column Financial_Month CHAR(5),
add column Financial_Quarter CHAR(5);

update main_2
set 
    month_name = DATE_FORMAT(Date, '%M'),
    year = YEAR(Date),
    quarter = CONCAT('Q', QUARTER(Date)),
    financial_month = CASE
        WHEN MONTH(Date) >= 4 THEN CONCAT('FM', MONTH(Date) - 3)
        ELSE CONCAT('FM', MONTH(Date) + 9)
    END,
    financial_quarter = CASE
        WHEN MONTH(Date) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(Date) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(Date) BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END;
    
    set sql_safe_updates =0;

-------------------- Question_3 ---------------------------------
--  Convert the Average cost for 2 column into USD dollars (currently the Average cost for 2 in local currencies --
select Average_Cost_for_two, Average_Cost_for_two * USD_Rate as avg_cost_usd from main_2 join
currency on main_2.currency = currency.cc;

-------------------- Question_4 ------------------------------
-- Find the Numbers of Restaurants  based on City and Country.--

select count(distinct(city)) as total_no_cities from main_2;
select count(distinct(cuisines)) as total_no_cuisines from main_2;
SELECT city, countryname, COUNT(*) AS number_of_restaurants FROM main_2 GROUP BY city, countryname ORDER BY countryname, city;

-------------------- Question_5 ---------------------------------
-------- Numbers of Restaurants  opening based on Year , Quarter , Month --------
select year(date) as year, count(*) as no_of_restaurants from main_2 group by year(date) order by year;

-------------------- Question_6 ----------------------------------------
----- Count of Restaurants based on Average Ratings --
select rating, count(*) as no_of_restaurants from main_2 group by rating order by rating desc;

----------------- Question_7 ------------------------------------
-- Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets --

SELECT 
CASE
        WHEN  Average_Cost_for_two < 600 THEN '0-600'
        WHEN Average_Cost_for_two BETWEEN 601 AND 2000 THEN '601-2000'
        WHEN Average_Cost_for_two BETWEEN 2001 AND 5000 THEN '2001-5000'
        WHEN Average_Cost_for_two BETWEEN 5001 AND 10000 THEN '5001-10000'
        WHEN Average_Cost_for_two  BETWEEN 10001 AND 30000 THEN '10001-30000'
        ELSE '30001 and above'
    END AS price_bucket,
    COUNT(*) AS number_of_restaurants FROM main_2 GROUP BY price_bucket ORDER BY price_bucket;

-------------------- Question_8 ------------------------------
----- Percentage of Resturants based on "Has_Table_booking ---

select has_table_booking, count(*) as no_of_restaurants,concat(round((count(*)/ (select count(*) from main_2) * 100), 2),'%') as  percentage_of_restaurants
from main_2 group by has_table_booking order by Has_Table_booking desc; 

----------------------- Question_9 -------------------------------
----- Percentage of Resturants based on "Has_online_delivery ---

select Has_Online_delivery, count(*) as no_of_restaurants,concat(round((count(*)/ (select count(*) from main_2) * 100), 2),'%') as  
percentage_of_restaurants from main_2 group by Has_Online_delivery order by Has_Online_delivery desc; 




