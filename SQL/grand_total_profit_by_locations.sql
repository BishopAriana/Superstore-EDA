/*
 * Query to make a formatted table that shows the Grand Total and Subtotal profits
 * by Region, State, and City.
 */

-- Location CTE
WITH location AS
	(SELECT
		l.city,
		l.state,
		l.region,
		o.profit
	FROM orders	AS o
		INNER JOIN locations AS l
			ON o.postal_code = l.postal_code)

-- Show Grand total and subtotals for all Regions, States, and Cities
SELECT
	-- Using COALESCE because the CASE WHEN way changes the order of the rows
	COALESCE(region, 'Regions Grand Total:') AS regions,
	CASE
		WHEN state IS NULL AND region IS NOT NULL THEN COALESCE(state, CONCAT(region, ' Grand Total:')) 
			ELSE state END AS states,
	CASE
		WHEN city IS NULL AND state IS NOT NULL THEN COALESCE(city, CONCAT(state, ' Grand Total:')) 
			ELSE city END AS cities,
	-- Converted to Numeric and then Money for formatting because concat with negative numbers leads to $-99 intead of -$99
	SUM(profit)::NUMERIC::MONEY AS total_profit -- negatives will show up in parenthesis
FROM location
 -- ROLLUP to get the wanted permutations
GROUP BY ROLLUP(region, state, city)
ORDER BY region, state, city;