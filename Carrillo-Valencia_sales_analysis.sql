USE sample_sales;
-- Finding Manager, region, state
SELECT 
	 SalesManager
    ,Region
    ,State 
FROM management
WHERE SalesManager LIKE '%Jeff "Howdy" Richards%'; -- Manger is Jeff "Howdy" Richards, Region is South, State is Texas
--------------------------------------------------------------------------------------------------------------------------------------------------------
/*What is total revenue overall for sales in the assigned territory, plus the start date and end date
that tell you what period the data covers?*/
-- StoreLocation,Store ID = Arlington 901, Austin 902,Bacliff 903,Baytown 904,Beaumont 905, Cedar Park 906,Dallas 907,Denton 908,Desoto 909,Fort Worth F910,Georgetown 911
SELECT * FROM store_locations
WHERE State LIKE '%Texas';

-- Total revenue overall 
SELECT 
 MIN(Transaction_Date) AS Start_Date
,MAX(Transaction_Date) AS End_Date -- Time period from 2022-01-01 to 2025-12-31
,Format(SUM(Sale_Amount), 2) AS Total_Revenue FROM store_sales
WHERE Store_ID BETWEEN 901 AND 911; --  Total Revenue = $3,417,850.01

/*What is the month by month revenue breakdown for the sales territory?*/
-- Month by Month Revenue from years 2022 to 2025
SELECT 
 DATE_FORMAT(Transaction_Date, '%Y-%m') AS Monthly_Period -- formats the year and month in one column
,Format(SUM(Sale_Amount), 2) AS Monthly_Revenue FROM store_sales
WHERE Store_ID BETWEEN 901 AND 911
GROUP BY Monthly_Period
ORDER BY Monthly_Period ASC; -- Orders monthly_revenue by the oldest date

/*Provide a comparison of total revenue for the specific sales territory and the region it belongs to.*/
-- Total revenue of the South Region comparing to the Total Revenue of Texas year by year
SELECT
	DATE_FORMAT(Transaction_Date, '%Y') AS `Year`
    ,'Texas' AS Territory
    ,Format(SUM(Sale_Amount), 2) AS Total_Revenue
FROM store_sales
WHERE Store_ID BETWEEN 901 AND 911
GROUP BY Territory, `Year`
UNION 
SELECT
	DATE_FORMAT(Transaction_Date, '%Y') AS `Year`
    ,'South Region' AS Territory
	,FORMAT(SUM(Sale_Amount),2) AS Total_Revenue
FROM store_sales
WHERE
Store_ID BETWEEN 719 AND 729
OR Store_Id BETWEEN 852 AND 853
OR Store_Id BETWEEN 901 AND 911
GROUP BY Territory, `Year`
ORDER BY Year, Territory;
