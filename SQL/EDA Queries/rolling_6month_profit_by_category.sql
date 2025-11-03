/*
 * Calculate 6 Month rolling profit by Category.
 */

-- Product CTE
WITH product AS
	(SELECT
		o.order_id,
		o.order_date,
		p.category,
		o.profit
	FROM orders	AS o
		INNER JOIN products AS p
			ON o.product_id = p.product_id)

SELECT -- Do rolling sum of profit per last 6 months (inclusive of current month)
	category,
	order_year,
	order_month,
	ROUND(total_profit::NUMERIC, 2) AS total_profits,
	SUM(total_profit) OVER(PARTITION BY category ORDER BY order_year, order_month
		ROWS BETWEEN 5 PRECEDING AND CURRENT ROW)::NUMERIC::MONEY AS rolling_6month_profit
FROM
	(SELECT -- sum all profits by category per month
		category,
		to_char(order_date, 'YYYY') AS order_year,
		to_char(order_date, 'MM') AS order_month,
		SUM(profit) AS total_profit
	FROM product
	GROUP BY category, order_year, order_month);