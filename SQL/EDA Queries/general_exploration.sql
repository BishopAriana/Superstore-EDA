/*
 * A collection of simple queries in order to learn a bit about the data set (unique dimension
 * values, date range/timespan, and basic aggregations).
 */

-- ---------------------------------------------------------------------------------------------
-- Identify unique values in dimensions --------------------------------------------------------
-- ---------------------------------------------------------------------------------------------

SELECT DISTINCT
	ship_mode
FROM orders
ORDER BY ship_mode;
-- Only 4: First Class, Same Day, Second Class, Standard Class

SELECT DISTINCT
	returned
FROM returns
ORDER BY returned;
-- Only 1: Yes

SELECT DISTINCT
	segment
FROM customers
ORDER BY segment;
-- Only 3: Consumer, Corporate, Home Office

SELECT DISTINCT
	city
FROM locations
ORDER BY city;
-- 530 Unique Cities

SELECT DISTINCT
	state
FROM locations
ORDER BY state;
-- 48 Unique States

SELECT DISTINCT
	region
FROM locations
ORDER BY region;
-- Only 4: Central, East, South, West

SELECT DISTINCT
	country
FROM locations
ORDER BY country;
-- Only 1: United States

SELECT DISTINCT
	product_name
FROM products
ORDER BY product_name;
-- 1818 Unique Products

SELECT DISTINCT
	category
FROM products
ORDER BY category;
-- Only 3: Furniture, Office Supplies, Technology

SELECT DISTINCT
	sub_category
FROM products
ORDER BY sub_category;
-- 17 Unique Sub_categories

-- ---------------------------------------------------------------------------------------------
-- General Data Exploration --------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------

-- First and Last order_date and ship_date
SELECT
	*,
	-- No DATEDIFF Fcn in PostgreSQL, just subtract for days
	latest_order_date - earliest_order_date AS order_date_timespan_days,
	latest_ship_date  - earliest_ship_date  AS ship_date_timespan_days,
	(latest_order_date - earliest_order_date) / 365.0 AS order_date_timespan_years,
	(latest_ship_date  - earliest_ship_date)  / 365.0 AS ship_date_timespan_years
FROM
	(SELECT
		MAX(order_date) AS latest_order_date,
		MIN(order_date) AS earliest_order_date,
		MAX(ship_date) AS latest_ship_date,
		MIN(ship_date) AS earliest_ship_date
	FROM orders) AS subq;
/*
 * Earliest Order Date: 01/03/2015
 * Latest Order Date:   12/30/2018
 * Earliest Ship Date:  01/07/2015
 * Latest Order Date:   01/05/2019
 * The time span for this dataset is about 4 years.
 */

-- Basic Aggregations --
SELECT -- Formatting
	CONCAT('$', to_char(total_sales, 'FM9,999,999,999.99')) AS total_sales,
	CONCAT('$', to_char(avg_sales, 'FM9,999,999,999.99')) AS avg_sales,
	total_units_sold,
	to_char(avg_units_sold, 'FM999.99') AS avg_units_sold,
	CONCAT('$', to_char(total_profit, 'FM9,999,999,999.99')) AS total_profit,
	CONCAT('$', to_char(avg_profit, 'FM9,999,999,999.99')) AS avg_profit,
	CONCAT(to_char(avg_discount * 100, 'FM99.99'), '%') AS avg_discount
FROM
	(SELECT -- Calculate Aggregations
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		SUM(quantity) AS total_units_sold,
		AVG(quantity) AS avg_units_sold,
		SUM(profit) AS total_profit,
		AVG(profit) AS avg_profit,
		AVG(discount) AS avg_discount
	FROM orders) AS subq;
/*
 * Total Sales:        $2,297,200.86
 * Average Sales:      $229.86
 * Total Units Sold:   37873
 * Average Units Sold: 3.79
 * Total Profit:       $286,397.02
 * Average Profit:     $28.66
 * Average Discount:   15.62%
 */

-- A look at these measures across different dimensions --
-- Ship Mode
SELECT -- Formatting
	ship_mode,
	CONCAT('$', to_char(total_sales, 'FM9,999,999,999.99')) AS total_sales,
	CONCAT('$', to_char(avg_sales, 'FM9,999,999,999.99')) AS avg_sales,
	total_units_sold,
	to_char(avg_units_sold, 'FM999.99') AS avg_units_sold,
	CONCAT('$', to_char(total_profit, 'FM9,999,999,999.99')) AS total_profit,
	CONCAT('$', to_char(avg_profit, 'FM9,999,999,999.99')) AS avg_profit,
	CONCAT(to_char(avg_discount * 100, 'FM99.99'), '%') AS avg_discount
FROM
	(SELECT -- Calculate Aggregations
		ship_mode,
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		SUM(quantity) AS total_units_sold,
		AVG(quantity) AS avg_units_sold,
		SUM(profit) AS total_profit,
		AVG(profit) AS avg_profit,
		AVG(discount) AS avg_discount
	FROM orders
	GROUP BY ship_mode
	ORDER BY total_profit DESC) AS subq;
-- Order from highest to lowest total profit: Standard Class, Second Class, First Class, Same Day

-- Customer Segment
SELECT -- Formatting
	segment,
	CONCAT('$', to_char(total_sales, 'FM9,999,999,999.99')) AS total_sales,
	CONCAT('$', to_char(avg_sales, 'FM9,999,999,999.99')) AS avg_sales,
	total_units_sold,
	to_char(avg_units_sold, 'FM999.99') AS avg_units_sold,
	CONCAT('$', to_char(total_profit, 'FM9,999,999,999.99')) AS total_profit,
	CONCAT('$', to_char(avg_profit, 'FM9,999,999,999.99')) AS avg_profit,
	CONCAT(to_char(avg_discount * 100, 'FM99.99'), '%') AS avg_discount
FROM
	(SELECT -- Calculate Aggregations
		segment,
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		SUM(quantity) AS total_units_sold,
		AVG(quantity) AS avg_units_sold,
		SUM(profit) AS total_profit,
		AVG(profit) AS avg_profit,
		AVG(discount) AS avg_discount
	FROM orders AS o
		INNER JOIN customers AS c
			ON o.customer_id = c.customer_id
	GROUP BY segment
	ORDER BY total_profit DESC) AS subq;
-- Order from highest to lowest total profit: Consumer, Corporate, Home Office

-- City
SELECT -- Formatting
	city,
	CONCAT('$', to_char(total_sales, 'FM9,999,999,999.99')) AS total_sales,
	CONCAT('$', to_char(avg_sales, 'FM9,999,999,999.99')) AS avg_sales,
	total_units_sold,
	to_char(avg_units_sold, 'FM999.99') AS avg_units_sold,
	CONCAT('$', to_char(total_profit, 'FM9,999,999,999.99')) AS total_profit,
	CONCAT('$', to_char(avg_profit, 'FM9,999,999,999.99')) AS avg_profit,
	CONCAT(to_char(avg_discount * 100, 'FM99.99'), '%') AS avg_discount
FROM
	(SELECT -- Calculate Aggregations
		city,
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		SUM(quantity) AS total_units_sold,
		AVG(quantity) AS avg_units_sold,
		SUM(profit) AS total_profit,
		AVG(profit) AS avg_profit,
		AVG(discount) AS avg_discount
	FROM orders AS o
		INNER JOIN locations AS l
			ON o.postal_code = l.postal_code
	GROUP BY city
	ORDER BY total_profit DESC) AS subq;
/*
 * Most Profitable City:  New York City
 * Least Profitable City: Philidelphia
 */


-- State
SELECT -- Formatting
	state,
	CONCAT('$', to_char(total_sales, 'FM9,999,999,999.99')) AS total_sales,
	CONCAT('$', to_char(avg_sales, 'FM9,999,999,999.99')) AS avg_sales,
	total_units_sold,
	to_char(avg_units_sold, 'FM999.99') AS avg_units_sold,
	CONCAT('$', to_char(total_profit, 'FM9,999,999,999.99')) AS total_profit,
	CONCAT('$', to_char(avg_profit, 'FM9,999,999,999.99')) AS avg_profit,
	CONCAT(to_char(avg_discount * 100, 'FM99.99'), '%') AS avg_discount
FROM
	(SELECT -- Calculate Aggregations
		state,
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		SUM(quantity) AS total_units_sold,
		AVG(quantity) AS avg_units_sold,
		SUM(profit) AS total_profit,
		AVG(profit) AS avg_profit,
		AVG(discount) AS avg_discount
	FROM orders AS o
		INNER JOIN locations AS l
			ON o.postal_code = l.postal_code
	GROUP BY state
	ORDER BY total_profit DESC) AS subq;
/*
 * Most Profitable State:  California
 * Least Profitable State: Texas
 */

-- Region
SELECT -- Formatting
	region,
	CONCAT('$', to_char(total_sales, 'FM9,999,999,999.99')) AS total_sales,
	CONCAT('$', to_char(avg_sales, 'FM9,999,999,999.99')) AS avg_sales,
	total_units_sold,
	to_char(avg_units_sold, 'FM999.99') AS avg_units_sold,
	CONCAT('$', to_char(total_profit, 'FM9,999,999,999.99')) AS total_profit,
	CONCAT('$', to_char(avg_profit, 'FM9,999,999,999.99')) AS avg_profit,
	CONCAT(to_char(avg_discount * 100, 'FM99.99'), '%') AS avg_discount
FROM
	(SELECT -- Calculate Aggregations
		region,
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		SUM(quantity) AS total_units_sold,
		AVG(quantity) AS avg_units_sold,
		SUM(profit) AS total_profit,
		AVG(profit) AS avg_profit,
		AVG(discount) AS avg_discount
	FROM orders AS o
		INNER JOIN locations AS l
			ON o.postal_code = l.postal_code
	GROUP BY region
	ORDER BY total_profit DESC) AS subq;
-- Order from highest to lowest total profit: West, East, South, Central

-- Product
SELECT -- Formatting
	product_name,
	CONCAT('$', to_char(total_sales, 'FM9,999,999,999.99')) AS total_sales,
	CONCAT('$', to_char(avg_sales, 'FM9,999,999,999.99')) AS avg_sales,
	total_units_sold,
	to_char(avg_units_sold, 'FM999.99') AS avg_units_sold,
	CONCAT('$', to_char(total_profit, 'FM9,999,999,999.99')) AS total_profit,
	CONCAT('$', to_char(avg_profit, 'FM9,999,999,999.99')) AS avg_profit,
	CONCAT(to_char(avg_discount * 100, 'FM99.99'), '%') AS avg_discount
FROM
	(SELECT -- Calculate Aggregations
		product_name,
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		SUM(quantity) AS total_units_sold,
		AVG(quantity) AS avg_units_sold,
		SUM(profit) AS total_profit,
		AVG(profit) AS avg_profit,
		AVG(discount) AS avg_discount
	FROM orders AS o
		INNER JOIN products AS p
			ON o.product_id = p.product_id
	GROUP BY product_name
	ORDER BY total_profit DESC) AS subq;
/*
 * Most Profitable Product:  Canon imageCLASS 2200 Advanced Copier
 * Least Profitable Product: Cubify CubeX 3D Printer Double Head Print
 */

-- Product Category
SELECT -- Formatting
	category,
	CONCAT('$', to_char(total_sales, 'FM9,999,999,999.99')) AS total_sales,
	CONCAT('$', to_char(avg_sales, 'FM9,999,999,999.99')) AS avg_sales,
	total_units_sold,
	to_char(avg_units_sold, 'FM999.99') AS avg_units_sold,
	CONCAT('$', to_char(total_profit, 'FM9,999,999,999.99')) AS total_profit,
	CONCAT('$', to_char(avg_profit, 'FM9,999,999,999.99')) AS avg_profit,
	CONCAT(to_char(avg_discount * 100, 'FM99.99'), '%') AS avg_discount
FROM
	(SELECT -- Calculate Aggregations
		category,
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		SUM(quantity) AS total_units_sold,
		AVG(quantity) AS avg_units_sold,
		SUM(profit) AS total_profit,
		AVG(profit) AS avg_profit,
		AVG(discount) AS avg_discount
	FROM orders AS o
		INNER JOIN products AS p
			ON o.product_id = p.product_id
	GROUP BY category
	ORDER BY total_profit DESC) AS subq;
-- Order from highest to lowest total profit: Technology, Office Supplies, Furniture

-- Product Subcategory
SELECT -- Formatting
	sub_category,
	CONCAT('$', to_char(total_sales, 'FM9,999,999,999.99')) AS total_sales,
	CONCAT('$', to_char(avg_sales, 'FM9,999,999,999.99')) AS avg_sales,
	total_units_sold,
	to_char(avg_units_sold, 'FM999.99') AS avg_units_sold,
	CONCAT('$', to_char(total_profit, 'FM9,999,999,999.99')) AS total_profit,
	CONCAT('$', to_char(avg_profit, 'FM9,999,999,999.99')) AS avg_profit,
	CONCAT(to_char(avg_discount * 100, 'FM99.99'), '%') AS avg_discount
FROM
	(SELECT -- Calculate Aggregations
		sub_category,
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		SUM(quantity) AS total_units_sold,
		AVG(quantity) AS avg_units_sold,
		SUM(profit) AS total_profit,
		AVG(profit) AS avg_profit,
		AVG(discount) AS avg_discount
	FROM orders AS o
		INNER JOIN products AS p
			ON o.product_id = p.product_id
	GROUP BY sub_category
	ORDER BY total_profit DESC) AS subq;
/*
 * Most Profitable Subcategory:  Copiers
 * Least Profitable Subcategory: Tables
 */