USE sample_sales;

-- SELECT, Filtering & Sorting
/*1. Create a list of all transactions that took place on January 15, 2024, sorted by sale amount from
highest to lowest.*/
SELECT Transaction_Date , Sale_Amount FROM store_sales
WHERE Transaction_Date = '2024-01-15'
ORDER BY Sale_Amount DESC;

/*2. Which transactions had a sale amount greater than $500? Display the transaction date, store ID,
product number, and sale amount.*/
SELECT 
	Transaction_Date
    ,Store_ID
    ,Prod_Num
    ,Sale_Amount
FROM store_sales
WHERE Sale_Amount > 500
ORDER BY Sale_Amount;

/*3. Find all products whose product number begins with the prefix 105250. What category do they
belong to?*/
SELECT Prod_Num FROM store_sales
Where Prod_Num LIKE '105250%';
-- They belong to the IT category
-- Aggregation
/*4. What is the total sales revenue across all transactions? What is the average transaction amount?*/
SELECT 
    FORMAT(SUM(Sale_Amount),2) AS Total_Revenue
    ,FORMAT(AVG(Sale_Amount),2) AS AVG_Transaction_Size
FROM store_sales;

/*5. How many transactions were recorded for each product category? Which category has the most
transactions?*/
SELECT
	 ic.Category
     ,COUNT(Transaction_Date) AS Num_Transactions
FROM store_sales AS s
JOIN products AS p ON s.Prod_Num = p.ProdNum
JOIN inventory_categories AS ic ON p.Categoryid = ic.Categoryid
GROUP BY ic.Category
ORDER BY Num_Transactions DESC; -- Stationery and Supplies has the most 

/*6. Which store generated the highest total revenue? Which generated the lowest?*/
(SELECT
	sl.StoreLocation
    ,sl.State
    ,sl.StoreID
    ,'Highest' AS Performance
	,FORMAT(SUM(Sale_Amount),2) AS Total_Revenue
FROM store_sales AS ss
JOIN store_locations AS sl ON ss.Store_ID = sl.StoreId
GROUP BY sl.StoreLocation, sl.State, sl.StoreID 
ORDER BY Total_Revenue DESC
LIMIT 1)
UNION
(SELECT
	sl.StoreLocation
    ,sl.State
    ,sl.StoreID
    ,'Lowest' AS Performance
	,FORMAT(SUM(Sale_Amount),2) AS Total_Revenue
FROM store_sales AS ss
JOIN store_locations AS sl ON ss.Store_ID = sl.StoreId
GROUP BY sl.StoreLocation, sl.State, sl.StoreID 
ORDER BY Total_Revenue
LIMIT 1);

/*7. What is the total revenue for each category, sorted from highest to lowest?*/
SELECT	 
     ic.Category
     ,FORMAT(SUM(Sale_Amount),2) AS Total_Revenue
FROM store_sales AS s
JOIN products AS p ON s.Prod_Num = p.ProdNum
JOIN inventory_categories AS ic ON p.Categoryid = ic.Categoryid
GROUP BY ic.Category
ORDER BY SUM(Sale_Amount) DESC;

/*8. Which stores had total revenue above $50,000? (Hint: you'll need HAVING.)*/
SELECT	
    sl.StoreLocation
    ,sl.State
    ,sl.StoreID
	,FORMAT(SUM(Sale_Amount),2) AS Total_Revenue
FROM store_sales AS ss
JOIN store_locations AS sl ON ss.Store_ID = sl.StoreId
GROUP BY sl.StoreLocation, sl.State, sl.StoreID
HAVING SUM(Sale_Amount) > 50000
ORDER BY SUM(Sale_Amount); 

-- JOINS
/*9. Find all sales records where the category is either "Textbooks" or "Technology & Accessories."*/
SELECT
	s.Transaction_Date
    ,ic.Category
FROM store_sales AS s
JOIN products AS p ON s.Prod_Num = p.ProdNum
JOIN inventory_categories AS ic ON p.Categoryid = ic.Categoryid
WHERE Category IN ('Textbooks','Technology & Accessories')
ORDER BY Category;

/*10. List all transactions where the sale amount was between $100 and $200, and the category was
"Textbooks."*/
SELECT
	ic.Category
    ,s.Transaction_Date
    ,s.Sale_Amount
FROM store_sales AS s
JOIN products AS p ON s.Prod_Num = p.ProdNum
JOIN inventory_categories AS ic ON p.Categoryid = ic.Categoryid
WHERE Sale_Amount BETWEEN 100 and 200 AND Category = 'Textbooks'
ORDER BY Sale_Amount;
/*11. Write a query that displays each store's total sales along with the city and state where that store is
located. */
/*12. For each sale, display the transaction date, sale amount, city, state, and the name of the store
manager responsible for that state. */
/*13. Write a query that shows total sales by region. Which region generates the most revenue?*/
/*14. For states that have a preferred shipper listed in Shipper_List, show the total sales alongside the
preferred shipper and volume discount. */
/*15. Are there any states with sales data that do not appear in Shipper_List?*/
/*16. Display total revenue by regional director.*/
-- Subqueries
/*17. Using a subquery, find all transactions from stores located in Texas.*/
/*18. Which stores had total sales above the average store revenue? (Hint: use a subquery to calculate the
average first.)*/
/*19. Find the top 5 highest-grossing stores, then use that result to look up their city and state from
Store_Locations.*/
/*20. Write a query using a subquery to find all sales records from stores managed by the Northeast
region's store managers.*/