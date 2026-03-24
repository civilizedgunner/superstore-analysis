/* Name of my dataset */
SELECT name 
FROM sqlite_master 
WHERE type = 'table';

/* Show first 10 rows */
SELECT * 
FROM superstore
LIMIT 10;

/* look at all columns to try and understand dataset structure */
PRAGMA table_info(superstore);

/* Count order lines per shipping method */
SELECT "Ship Mode", count(*) AS order_lines 
FROM superstore
GROUP  BY "Ship Mode"
ORDER BY order_lines DESC;

/* Count distinct orders per shipping method */
SELECT 
	"Ship Mode", 
	count(DISTINCT "Order ID") AS orders 
FROM superstore
GROUP  BY "Ship Mode"
ORDER BY orders DESC;

/* Count distinct orders per shipping method and the total profit for each */
SELECT 
	"Ship Mode", 
	count(DISTINCT "Order ID") AS orders, sum(Profit) 
FROM superstore
GROUP  BY "Ship Mode"
ORDER BY orders DESC;

/* average profit per order per ship mode */
SELECT 
"Ship Mode", 
count(DISTINCT "Order ID") AS orders, 
sum(Profit) AS total_profit, 
sum(Profit) * 1.0 / count(DISTINCT "Order ID") AS average_profit_per_order
FROM superstore
GROUP BY "Ship Mode"
ORDER BY average_profit_per_order DESC;

/* Loss rate by shipping method at order line level */
SELECT
"Ship Mode",
count(*) AS order_lines,
sum(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS loss_lines,
sum(CASE WHEN profit < 0 THEN 1 ELSE 0 END) * 1.0 / count(*) AS loss_rate
FROM superstore
GROUP BY "Ship Mode"
ORDER BY loss_rate DESC;

/* Loss rate by shipping method at order level */
SELECT
"Ship Mode",
count(*) AS orders,
sum(CASE WHEN order_profit < 0 THEN 1 ELSE 0 END) AS loss_orders,
sum(CASE WHEN order_profit < 0 THEN 1 ELSE 0 END) * 1.0 / count(*) AS loss_rate
FROM
	(SELECT
		"Ship Mode",
		"Order ID",
		SUM(profit) AS order_profit
		FROM superstore
		GROUP BY "Ship Mode", "Order ID"
		)
	GROUP BY "Ship Mode"
	ORDER BY loss_rate DESC;
	
/* Impact of discount level on profitability */	
SELECT 
	ROUND(Discount, 2) AS discount_level,
	COUNT(*) AS order_lines,
	AVG(Profit) AS avg_profit
FROM superstore
GROUP BY ROUND(Discount, 2)
ORDER BY discount_level;

/* frequency of discount levels and real impact on the business  */
SELECT 
	ROUND(Discount, 2) AS discount_level,
	count(*) AS order_lines,
	count(*) * 1.0 /  (SELECT count(*) FROM superstore) AS share_of_orders,
	avg(profit) AS profit_level
FROM superstore
GROUP BY round(Discount, 2)
ORDER BY discount_level;

/* how many lines of each discount level are loss making and what is the loss rate  */
SELECT
	ROUND(Discount, 2) AS discount_level,
	count(*) AS order_lines,
	sum(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS loss_lines,
	sum(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) * 1.0 / count(*) AS loss_rate
FROM superstore
GROUP BY round(Discount, 2)
ORDER BY discount_level;

/* which categories receive which discount levels */
SELECT
	Category,
	round(Discount, 2) AS discount_level,
	count(*) AS order_lines
FROM superstore
GROUP BY Category, round(Discount, 2)
ORDER BY Category, discount_level;

/* profitability by category */
SELECT 
	Category,
	count(*) AS order_lines,
	sum(Profit) AS total_profit,
	avg(Profit) AS avg_profit
FROM superstore
GROUP BY Category
ORDER BY avg_profit;

/* loss rate by category */
SELECT 
	Category,
	count(*) AS order_lines,
	sum(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS loss_lines,
	sum(CASE WHEN profit < 0 THEN 1 ELSE 0 END) * 1.0 / count(*) AS loss_rate
FROM superstore
GROUP BY Category
ORDER BY loss_rate DESC;

/* compare average discount levels acoss categories */
SELECT 
	Category,
	avg(Discount) AS avg_discount,
	max(Discount) AS max_discount
FROM superstore
GROUP BY Category
ORDER BY avg_discount DESC;