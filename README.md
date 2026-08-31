-- =========================================================
-- E-COMMERCE SQL DATA ANALYSIS
-- Customer Analysis
-- Database: Maven Analytics E-commerce Dataset
-- Tool: MySQL
-- ======================================================
-- 1. Customers who ordered in 2013 but not in 2014
SELECT DISTINCT o.user_id
FROM orders o
WHERE YEAR(o.created_at) = 2013
  AND NOT EXISTS (
      SELECT 1
      FROM orders o1
      WHERE o.user_id = o1.user_id
        AND YEAR(o1.created_at) = 2014
  );


-- 2. Customers who ordered in both 2013 and 2014
SELECT DISTINCT o.user_id
FROM orders o
WHERE YEAR(o.created_at) = 2013
  AND EXISTS (
      SELECT 1
      FROM orders o1
      WHERE o.user_id = o1.user_id
        AND YEAR(o1.created_at) = 2014
  );


-- 3. First and last order date for each customer
SELECT
    user_id,
    MIN(created_at) AS first_order_date,
    MAX(created_at) AS last_order_date
FROM orders
GROUP BY user_id;


-- 4. Customers whose first order was in 2013
SELECT
    user_id,
    MIN(created_at) AS first_order_date
FROM orders
GROUP BY user_id
HAVING YEAR(MIN(created_at)) = 2013;


-- 5. Top 5 customers by total revenue
SELECT
    user_id,
    SUM(price_usd) AS total_revenue
FROM orders
GROUP BY user_id
ORDER BY total_revenue DESC
LIMIT 5;


-- 6. Customers whose revenue is greater than
-- the average revenue per customer
WITH customer_revenue AS (
    SELECT
        user_id,
        SUM(price_usd) AS total_revenue
    FROM orders
    GROUP BY user_id
)
SELECT
    user_id,
    total_revenue
FROM customer_revenue
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM customer_revenue
)
ORDER BY total_revenue DESC;


-- 7. Second-highest customer revenue
WITH customer_revenue AS (
    SELECT
        user_id,
        SUM(price_usd) AS total_revenue,
        DENSE_RANK() OVER (
            ORDER BY SUM(price_usd) DESC
        ) AS revenue_rank
    FROM orders
    GROUP BY user_id
)
SELECT
    user_id,
    total_revenue
FROM customer_revenue
WHERE revenue_rank = 2;


-- 8. First and second order amounts
WITH ranked_orders AS (
    SELECT
        user_id,
        created_at,
        price_usd,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY created_at ASC
        ) AS row_num
    FROM orders
)
SELECT
    user_id,
    MAX(CASE WHEN row_num = 1 THEN price_usd END)
        AS first_order_amount,
    MAX(CASE WHEN row_num = 2 THEN price_usd END)
        AS second_order_amount
FROM ranked_orders
GROUP BY user_id;


-- 9. Customers whose second order was larger than first order
WITH ranked_orders AS (
    SELECT
        user_id,
        created_at,
        price_usd,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY created_at ASC
        ) AS row_num
    FROM orders
),
customer_orders AS (
    SELECT
        user_id,
        MAX(CASE WHEN row_num = 1 THEN price_usd END)
            AS first_order_amount,
        MAX(CASE WHEN row_num = 2 THEN price_usd END)
            AS second_order_amount
    FROM ranked_orders
    GROUP BY user_id
)
SELECT
    user_id,
    first_order_amount,
    second_order_amount
FROM customer_orders
WHERE second_order_amount > first_order_amount;


-- 10. Customers whose first order was in 2013
-- and last order was in 2014
SELECT
    user_id,
    MIN(created_at) AS first_order_date,
    MAX(created_at) AS last_order_date
FROM orders
GROUP BY user_id
HAVING YEAR(MIN(created_at)) = 2013
   AND YEAR(MAX(created_at)) = 2014;
