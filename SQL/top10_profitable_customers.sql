/*
 * Query to take a look at the Top 10 Customers by Total Profit: identify these 10 customers by name
 * and find the product category that these 10 customers order from the most.
 */
 
-- Customer CTE
WITH customer AS
	(SELECT
		o.order_id,
		o.order_date,
		o.ship_date,
		o.ship_mode,
		o.customer_id,
		o.product_id,
		o.postal_code,
		c.customer_name,
		c.segment,
		o.sales,
		o.quantity,
		o.discount,
		o.profit
	FROM orders	AS o
		INNER JOIN customers AS c
			ON o.customer_id = c.customer_id),

-- Product CTE
product AS
	(SELECT
		o.order_id,
		o.order_date,
		o.ship_date,
		o.ship_mode,
		o.customer_id,
		o.product_id,
		o.postal_code,
		p.product_name,
		p.category,
		p.sub_category,
		o.sales,
		o.quantity,
		o.discount,
		o.profit
	FROM orders	AS o
		INNER JOIN products AS p
			ON o.product_id = p.product_id),

-- ---------------------------------------------------------------------------------------------
-- TOP 10 Profit: Customer Analysis ------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------

-- Name the top 10 overall customers by profit
top10_profit_customers AS
	(SELECT
		customer_id,
		customer_name,
		segment,
		-- Cast to numeric so ROUND fcn works in PostgreSQL
		ROUND(SUM(profit)::numeric, 2) AS total_customer_profit
	FROM customer
	GROUP BY segment, customer_name, customer_id
	ORDER BY total_customer_profit DESC
	LIMIT 10)
/*
 * IN ORDER: Tamara Chand, Raymond Buch, Sajit Chand, Hunter Lopez, Adrian Barton
 * Tom Ashbrook, Christopher Martinez, Keith Dawkins, Andy Reiter, Daniel Raglin
 *    -Most are in the Consumers customer segment-
 */

-- What category did those top 10 customers purchase from the most?
SELECT -- convert into percentage out of 100 to be more readable
	ROUND(total_percent_furniture / total_percent * 100, 2) AS percent_furniture,
	ROUND(total_percent_office / total_percent * 100, 2) AS percent_office,
	ROUND(total_percent_tech / total_percent * 100, 2) AS percent_tech
FROM
	(SELECT -- add all of the percentges up by category and overall
		SUM(percent_furniture) AS total_percent_furniture,
		SUM(percent_office) AS total_percent_office,
		SUM(percent_tech) AS total_percent_tech,
		SUM(percent_furniture) + SUM(percent_office) + SUM(percent_tech) AS total_percent
	FROM
		(SELECT -- calculate percentage of the customer orders that are in each category
			top10.customer_name,
			ROUND(AVG(CASE WHEN p.category = 'Furniture' THEN 1 ELSE 0 END) * 100, 2) AS percent_furniture,
			ROUND(AVG(CASE WHEN p.category = 'Office Supplies' THEN 1 ELSE 0 END) * 100, 2) AS percent_office,
			ROUND(AVG(CASE WHEN p.category = 'Technology' THEN 1 ELSE 0 END) * 100, 2) AS percent_tech
		FROM top10_profit_customers AS top10
			LEFT JOIN product AS p
				ON top10.customer_id = p.customer_id
		GROUP BY top10.customer_name));
/*
 * The highest category is Office Supplies, which makes up about 61% of all orders across the top 10 profit customers.
 * Furniture and Technology are close with Furniture being about 20% and Technology being about 19%.
 */