-- =========================================================
-- E-COMMERCE SQL DATA ANALYSIS
-- Advanced Customer & Retention Analysis
-- Database: Maven Analytics E-commerce Dataset
-- Tool: MySQL
-- =========================================================


-- 1. Users with at least 3 active months in 2013
-- and at least 5 total orders

SELECT
    user_id,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT MONTH(created_at)) AS active_months
FROM orders
WHERE YEAR(created_at) = 2013
GROUP BY user_id
HAVING COUNT(order_id) >= 5
   AND COUNT(DISTINCT MONTH(created_at)) >= 3
ORDER BY total_orders DESC;


-- 2. Users who ordered in January and February 2013
SELECT
    user_id,
    SUM(CASE
        WHEN MONTH(created_at) = 1 THEN 1
        ELSE 0
    END) AS january_orders,
    SUM(CASE
        WHEN MONTH(created_at) = 2 THEN 1
        ELSE 0
    END) AS february_orders
FROM orders
WHERE YEAR(created_at) = 2013
GROUP BY user_id
HAVING SUM(CASE
           WHEN MONTH(created_at) = 1 THEN 1
           ELSE 0
       END) > 0
   AND SUM(CASE
           WHEN MONTH(created_at) = 2 THEN 1
           ELSE 0
       END) > 0;


-- 3. Users who ordered in January but not February 2013
SELECT
    user_id,
    SUM(CASE
        WHEN MONTH(created_at) = 1 THEN 1
        ELSE 0
    END) AS january_orders,
    SUM(CASE
        WHEN MONTH(created_at) = 2 THEN 1
        ELSE 0
    END) AS february_orders
FROM orders
WHERE YEAR(created_at) = 2013
GROUP BY user_id
HAVING SUM(CASE
           WHEN MONTH(created_at) = 1 THEN 1
           ELSE 0
       END) > 0
   AND SUM(CASE
           WHEN MONTH(created_at) = 2 THEN 1
           ELSE 0
       END) = 0;


-- 4. Users with first order in 2013
-- and last order in 2014

SELECT
    user_id,
    MIN(created_at) AS first_order_date,
    MAX(created_at) AS last_order_date
FROM orders
GROUP BY user_id
HAVING YEAR(MIN(created_at)) = 2013
   AND YEAR(MAX(created_at)) = 2014;


-- 5. First and second order analysis
-- Second order must be within 30 days
-- and have a higher value than the first order

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
        MAX(CASE
            WHEN row_num = 1 THEN created_at
        END) AS first_order_date,
        MAX(CASE
            WHEN row_num = 1 THEN price_usd
        END) AS first_order_amount,
        MAX(CASE
            WHEN row_num = 2 THEN created_at
        END) AS second_order_date,
        MAX(CASE
            WHEN row_num = 2 THEN price_usd
        END) AS second_order_amount
    FROM ranked_orders
    GROUP BY user_id
)
SELECT
    user_id,
    first_order_date,
    first_order_amount,
    second_order_date,
    second_order_amount,
    DATEDIFF(
        second_order_date,
        first_order_date
    ) AS days_between
FROM customer_orders
WHERE DATEDIFF(
          second_order_date,
          first_order_date
      ) <= 30
  AND second_order_amount > first_order_amount;


-- 6. Users whose first three orders increased
-- in value each time

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
        MAX(CASE
            WHEN row_num = 1 THEN price_usd
        END) AS first_order_amount,
        MAX(CASE
            WHEN row_num = 2 THEN price_usd
        END) AS second_order_amount,
        MAX(CASE
            WHEN row_num = 3 THEN price_usd
        END) AS third_order_amount
    FROM ranked_orders
    GROUP BY user_id
)
SELECT
    user_id,
    first_order_amount,
    second_order_amount,
    third_order_amount
FROM customer_orders
WHERE first_order_amount < second_order_amount
  AND second_order_amount < third_order_amount;


-- 7. Users with exactly 3 orders where
-- the third order was at least 60 days after the first

WITH ranked_orders AS (
    SELECT
        user_id,
        created_at,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY created_at ASC
        ) AS row_num
    FROM orders
),
customer_orders AS (
    SELECT
        user_id,
        MAX(CASE
            WHEN row_num = 1 THEN created_at
        END) AS first_order_date,
        MAX(CASE
            WHEN row_num = 3 THEN created_at
        END) AS third_order_date
    FROM ranked_orders
    GROUP BY user_id
    HAVING COUNT(*) = 3
)
SELECT
    user_id,
    first_order_date,
    third_order_date,
    DATEDIFF(
        third_order_date,
        first_order_date
    ) AS days_between
FROM customer_orders
WHERE DATEDIFF(
          third_order_date,
          first_order_date
      ) >= 60;


-- 8. Longest consecutive order-day streak
-- for each user

WITH distinct_days AS (
    SELECT DISTINCT
        user_id,
        DATE(created_at) AS order_date
    FROM orders
),
ranked_days AS (
    SELECT
        user_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY order_date
        ) AS row_num
    FROM distinct_days
),
grouped_days AS (
    SELECT
        user_id,
        order_date,
        DATE_SUB(
            order_date,
            INTERVAL row_num DAY
        ) AS grp
    FROM ranked_days
),
streaks AS (
    SELECT
        user_id,
        grp,
        COUNT(*) AS streak_length
    FROM grouped_days
    GROUP BY user_id, grp
)
SELECT
    user_id,
    MAX(streak_length) AS longest_streak
FROM streaks
GROUP BY user_id
HAVING MAX(streak_length) >= 3;


-- 9. Customers whose total revenue is greater
-- than the average customer revenue

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


-- 10. Customers who placed at least 3 orders
-- and generated more than $1,000 revenue,
-- with first order in 2013

SELECT
    user_id,
    MIN(created_at) AS first_order_date,
    COUNT(*) AS total_orders,
    SUM(price_usd) AS total_revenue
FROM orders
GROUP BY user_id
HAVING YEAR(MIN(created_at)) = 2013
   AND COUNT(*) >= 3
   AND SUM(price_usd) > 1000
ORDER BY total_revenue DESC;
