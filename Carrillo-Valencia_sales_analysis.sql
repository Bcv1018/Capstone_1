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
SELECT 
 DATE_FORMAT(Transaction_Date, '%Y-%m') AS Monthly_Period
,Format(SUM(Sale_Amount), 2) AS Monthly_Revenue FROM store_sales
WHERE Store_ID BETWEEN 901 AND 911
GROUP BY Monthly_Period
ORDER BY Monthly_Period ASC; 


