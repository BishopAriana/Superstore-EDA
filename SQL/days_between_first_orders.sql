/*
 * A query that calculates how long it usually takes for a customer to make their
 * second order after their first one.
 */

-- Rank all of a customer's orders by date placed
WITH order_ranking AS
	(SELECT
		*,
		-- ranking needs to be after all unique rows are found or it'll cause dupes
		ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS ranking
	FROM
		(SELECT DISTINCT
			customer_id,
			order_id,
			order_date
		FROM orders
		ORDER BY customer_id, order_date)),

-- calculate difference in days between a customer's 1st and 2nd order
date_diffs AS
	(SELECT
		order_date - prev_date AS first_orders_diff
	FROM
		(SELECT
			customer_id,
			order_date,
			ranking,
			-- The order 1 row is needed for this LAG fcn to work
			LAG(order_date) OVER(PARTITION BY customer_id ORDER BY ranking) AS prev_date
		FROM order_ranking
		-- only get the 1st and 2nd orders for the lag and datediff calculations
		WHERE ranking IN(1,2)
		ORDER BY customer_id, order_date) 
	WHERE ranking = 2), -- only get the row for customers' second order for the datediff calculation

-- calculate percentages of how long betweeen customers' first two orders
percentages AS 
	(SELECT
		AVG(CASE WHEN first_orders_diff < 90 THEN 1 ELSE 0 END) AS pct_reorder_within_90_days,
		AVG(CASE WHEN first_orders_diff > 90 AND first_orders_diff < 180 THEN 1 ELSE 0 END) AS pct_reorder_3_to_6_months,
		AVG(CASE WHEN first_orders_diff > 180 AND first_orders_diff < 270 THEN 1 ELSE 0 END) AS pct_reorder_6_to_9_months,
		AVG(CASE WHEN first_orders_diff > 270 AND first_orders_diff < 365 THEN 1 ELSE 0 END) AS pct_reorder_9_to_12_months,
		AVG(CASE WHEN first_orders_diff > 365 THEN 1 ELSE 0 END) AS pct_reorder_after_year
	FROM date_diffs)

-- Put the percentages in long format view
SELECT
	'Percent Reordered within 90 Days' AS reorder_window,
	to_char(pct_reorder_within_90_days * 100, 'FM99.99%') AS reorder_percentage
FROM percentages
UNION ALL
SELECT
	'Percent Reordered Between 3 and 6 Months' AS reorder_window,
	to_char(pct_reorder_3_to_6_months * 100, 'FM99.99%') AS reorder_percentage
FROM percentages
UNION ALL
SELECT
	'Percent Reordered Between 6 and 9 Months' AS reorder_window,
	to_char(pct_reorder_6_to_9_months * 100, 'FM99.99%') AS reorder_percentage
FROM percentages
UNION ALL
SELECT
	'Percent Reordered within Between 9 and 12 Months' AS reorder_window,
	to_char(pct_reorder_9_to_12_months * 100, 'FM99.99%') AS reorder_percentage
FROM percentages
UNION ALL
SELECT
	'Percent Reordered after a Year' AS reorder_window,
	to_char(pct_reorder_after_year * 100, 'FM99.99%') AS reorder_percentage
FROM percentages
-- The biggest portions of returning customers happen either within 90 days of the first order OR after a year has passed.
/*
 * Percent Reordered within 90 Days                 | 23.05%
 * Percent Reordered Between 3 and 6 Months         | 19.72%
 * Percent Reordered Between 6 and 9 Months         | 16.77%
 * Percent Reordered within Between 9 and 12 Months | 10.37%
 * Percent Reordered after a Year                   | 29.45%
 */