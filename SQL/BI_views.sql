/*
 * Due to the recent growth of competition in the market, RetailGiant wants to do an analysis on all of their sales data since 
 * their inception in 2015 to find out what works best for them. They want to become more efficient in order to keep a leg up
 * on the rising competition. They would like to understand which products, regions, categories and customer segments they should
 * target or avoid.
 */
 
-- ---------------------------------------------------------------------------------------------------------------------------
-- Get Year-over-Year calculations for Total Sales and Total Profits by Region
-- ---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW YoY_Regions AS
WITH CTE AS
	-- Get sum sales per region per year
	(SELECT
		l.region,
		to_char(o.order_date, 'YYYY') AS order_year,
		SUM(o.sales) AS total_sales,
		SUM(o.profit) AS total_profit
	FROM orders AS o
		INNER JOIN locations AS l
			ON o.postal_code = l.postal_code
	GROUP BY l.region, order_year),

LAGS AS
	-- Lag window fcns for the sums per region per year
	(SELECT
		*,
		LAG(total_sales) OVER(PARTITION BY region ORDER BY order_year) AS lag_sales,
		LAG(total_profit) OVER(PARTITION BY region ORDER BY order_year) AS lag_profit
	FROM CTE)

-- Calculate the YoY sales and YoY profit per region
SELECT
	region,
	order_year,
	(total_sales - lag_sales) / lag_sales * 100 AS YoY_Sales,
	(total_profit - lag_profit) / lag_profit * 100 AS YoY_profit
FROM LAGS;

-- ---------------------------------------------------------------------------------------------------------------------------
-- -- Get Year-over-Year calculations for Total Sales and Total Profits by Customer Segment
-- ---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW YoY_Segments AS
WITH CTE AS
	-- Get sum sales per customer segment per year
	(SELECT
		c.segment,
		to_char(o.order_date, 'YYYY') AS order_year,
		SUM(o.sales) AS total_sales,
		SUM(o.profit) AS total_profit
	FROM orders AS o
		INNER JOIN customers AS c
			ON o.customer_id = c.customer_id
	GROUP BY c.segment, order_year),

LAGS AS
	-- Lag window fcns for the sums per customer segment per year
	(SELECT
		*,
		LAG(total_sales) OVER(PARTITION BY segment ORDER BY order_year) AS lag_sales,
		LAG(total_profit) OVER(PARTITION BY segment ORDER BY order_year) AS lag_profit
	FROM CTE)

-- Calculate the YoY sales and YoY profit per customer segment
SELECT
	segment,
	order_year,
	(total_sales - lag_sales) / lag_sales * 100 AS YoY_Sales,
	(total_profit - lag_profit) / lag_profit * 100 AS YoY_profit
FROM LAGS;

-- ---------------------------------------------------------------------------------------------------------------------------
-- -- Get Year-over-Year calculations for Total Sales and Total Profits by Category
-- ---------------------------------------------------------------------------------------------------------------------------
CREATE VIEW YoY_Categories AS
WITH CTE AS
	-- Get sum sales per category per year
	(SELECT
		p.category,
		to_char(o.order_date, 'YYYY') AS order_year,
		SUM(o.sales) AS total_sales,
		SUM(o.profit) AS total_profit
	FROM orders AS o
		INNER JOIN products AS p
			ON o.product_id = p.product_id
	GROUP BY p.category, order_year),

LAGS AS
	-- Lag window fcns for the sums per category per year
	(SELECT
		*,
		LAG(total_sales) OVER(PARTITION BY category ORDER BY order_year) AS lag_sales,
		LAG(total_profit) OVER(PARTITION BY category ORDER BY order_year) AS lag_profit
	FROM CTE)

-- Calculate the YoY sales and YoY profit per category
SELECT
	category,
	order_year,
	(total_sales - lag_sales) / lag_sales * 100 AS YoY_Sales,
	(total_profit - lag_profit) / lag_profit * 100 AS YoY_profit
FROM LAGS;

-- ---------------------------------------------------------------------------------------------------------------------------
-- Products - top 10 and bottom 10 in sales and profit each year
--
-- UNION ALL used to prevent repeating the calculations. Bottom ranks have to be calculated separately with limit 10 because
-- all years have different rank numbers for their bottom 10 products. This leads to years being hard-coded for bottom
-- calculations. Since the database is small, it might be simpler to just repeat the calculations 4 times.
-- ---------------------------------------------------------------------------------------------------------------------------

-- Get Total Sales and Total Profit of products by year
CREATE VIEW Top_and_bottom_products AS
WITH CTE AS
	(SELECT
		p.product_name,
		to_char(o.order_date, 'YYYY') AS order_year,
		SUM(o.sales) AS total_sales,
		SUM(o.profit) AS total_profit
	FROM orders AS o
		INNER JOIN products AS p
			ON o.product_id = p.product_id
	GROUP BY p.product_name, order_year),

RANKINGS AS
	-- Rank Total Sales and Total Profit of products by year
	(SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY order_year ORDER BY total_sales DESC) AS sales_rankings,
		ROW_NUMBER() OVER(PARTITION BY order_year ORDER BY total_profit DESC) AS profit_rankings
	FROM CTE)

-- UNION ALL to get top 10 and bottom 10 products by sales and profit
SELECT -- Top 10 products by sales for each year
	'sales' AS metric,
	order_year,
	product_name,
	total_sales AS totals,
	sales_rankings
FROM RANKINGS
WHERE sales_rankings <= 10

UNION ALL

(SELECT -- Bottom 10 products by sales for 2015
	'sales' AS metric,
	order_year,
	product_name,
	total_sales AS totals,
	sales_rankings
FROM RANKINGS
WHERE order_year = '2015'
ORDER BY sales_rankings DESC
LIMIT 10)

UNION ALL

(SELECT -- Bottom 10 products by sales for 2016
	'sales' AS metric,
	order_year,
	product_name,
	total_sales AS totals,
	sales_rankings
FROM RANKINGS
WHERE order_year = '2016'
ORDER BY sales_rankings DESC
LIMIT 10)

UNION ALL

(SELECT -- Bottom 10 products by sales for 2017
	'sales' AS metric,
	order_year,
	product_name,
	total_sales AS totals,
	sales_rankings
FROM RANKINGS
WHERE order_year = '2017'
ORDER BY sales_rankings DESC
LIMIT 10)

UNION ALL

(SELECT -- Bottom 10 products by sales for 2018
	'sales' AS metric,
	order_year,
	product_name,
	total_sales AS totals,
	sales_rankings
FROM RANKINGS
WHERE order_year = '2018'
ORDER BY sales_rankings DESC
LIMIT 10)

UNION ALL

SELECT -- Top 10 products by profit for all years
	'profit' AS metric,
	order_year,
	product_name,
	total_profit AS totals,
	profit_rankings
FROM RANKINGS
WHERE profit_rankings <= 10

UNION ALL

(SELECT -- Bottom 10 products by profit for 2015
	'profit' AS metric,
	order_year,
	product_name,
	total_sales AS totals,
	profit_rankings
FROM RANKINGS
WHERE order_year = '2015'
ORDER BY profit_rankings DESC
LIMIT 10)

UNION ALL

(SELECT -- Bottom 10 products by sales for 2016
	'profit' AS metric,
	order_year,
	product_name,
	total_sales AS totals,
	profit_rankings
FROM RANKINGS
WHERE order_year = '2016'
ORDER BY profit_rankings DESC
LIMIT 10)

UNION ALL

(SELECT -- Bottom 10 products by sales for 2017
	'profit' AS metric,
	order_year,
	product_name,
	total_sales AS totals,
	profit_rankings
FROM RANKINGS
WHERE order_year = '2017'
ORDER BY profit_rankings DESC
LIMIT 10)

UNION ALL

(SELECT -- Bottom 10 products by sales for 2018
	'profit' AS metric,
	order_year,
	product_name,
	total_sales AS totals,
	profit_rankings
FROM RANKINGS
WHERE order_year = '2018'
ORDER BY profit_rankings DESC
LIMIT 10)	