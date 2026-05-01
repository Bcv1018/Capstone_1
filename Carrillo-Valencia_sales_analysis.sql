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
-- Query to find what other states are in my region
SELECT Region, State FROM management -- South Region states are Texas, FLorida, and South Carolina
WHERE Region = 'South';
-- Queries to find the storeIDs for Florida and South Carolina
SELECT * FROM store_locations -- StoreIDs for Florida 719-729
WHERE State = 'Florida';
SELECT * FROM store_locations -- StoreID for South Carolina 852-853
WHERE State = 'South Carolina';

-- Query to compare Texas with the South Region yearly
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

/*What is the number of transactions per month and average transaction size by product category
for the sales territory?*/
SELECT
	 DATE_FORMAT(Transaction_Date, '%Y-%m') AS `Date`
    ,COUNT(Transaction_Date) AS Num_of_Transactions -- Counts how many transaction there are
    ,FORMAT(AVG(Sale_Amount),2) AS AVG_Transaction_Size -- Averages the transaction size by the sale amount
    ,i.Category
FROM store_sales AS s
JOIN products AS p ON s.Prod_Num = p.ProdNum
JOIN inventory_categories AS i ON p.Categoryid = i.Categoryid
WHERE s.Store_ID BETWEEN 901 AND 911
GROUP BY i.Category, `Date`
ORDER BY i.Category, `Date`;

/*Can you provide a ranking of in-store sales performance by each store in the sales territory*/
-- Tables store_sales and store_locations
SELECT 
	RANK() OVER (ORDER BY SUM(Sale_Amount) DESC) AS `Rank` -- Ranks the Sum of Sale_Amount from 1-11 1 being the highest performing and 11 lowest performing
    ,s.Store_ID
    ,l.StoreLocation
    ,FORMAT(SUM(Sale_Amount),2) AS Performance
FROM store_sales AS s
JOIN store_locations AS l ON s.Store_ID = l.StoreID
WHERE Store_ID BETWEEN 901 AND 911
GROUP BY l.StoreLocation, s.Store_ID
ORDER BY `Rank`;

/*What is your recommendation for where to focus sales attention in the next quarter?*/
 /* My recommendation based on rankings and performance is that for the next quarter we should focus on the Dallas location as it is the lowest performaing location in the Texas teritorry.
 With Dallas being the 9th most populous city in the US severly underperforming compared to the rest of the locations is a problem and needs to be our highest priority. I also reccomend to look at 
 the stationery and supplies product category as it is one of our highest number of transaction but is our lowest performing products.