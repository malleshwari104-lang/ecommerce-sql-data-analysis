-- =========================================================
-- E-COMMERCE SQL DATA ANALYSIS
-- Website & Conversion Analysis
-- Database: Maven Analytics E-commerce Dataset
-- Tool: MySQL
-- =========================================================


-- 1. Total website sessions
SELECT
    COUNT(*) AS total_sessions
FROM website_sessions;


-- 2. Sessions by traffic source
SELECT
    utm_source,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY total_sessions DESC;


-- 3. Sessions and orders by traffic source
SELECT
    w.utm_source,
    COUNT(DISTINCT w.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM website_sessions w
LEFT JOIN orders o
    ON w.website_session_id = o.website_session_id
GROUP BY w.utm_source
ORDER BY total_sessions DESC;


-- 4. Conversion rate by traffic source
WITH traffic_data AS (
    SELECT
        w.utm_source,
        COUNT(DISTINCT w.website_session_id) AS total_sessions,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM website_sessions w
    LEFT JOIN orders o
        ON w.website_session_id = o.website_session_id
    GROUP BY w.utm_source
)
SELECT
    utm_source,
    total_sessions,
    total_orders,
    ROUND(
        total_orders * 100.0 / total_sessions,
        2
    ) AS conversion_rate
FROM traffic_data
ORDER BY conversion_rate DESC;


-- 5. Sessions and orders by device type
SELECT
    w.device_type,
    COUNT(DISTINCT w.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM website_sessions w
LEFT JOIN orders o
    ON w.website_session_id = o.website_session_id
GROUP BY w.device_type
ORDER BY total_sessions DESC;


-- 6. Conversion rate by device type
WITH device_data AS (
    SELECT
        w.device_type,
        COUNT(DISTINCT w.website_session_id) AS total_sessions,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM website_sessions w
    LEFT JOIN orders o
        ON w.website_session_id = o.website_session_id
    GROUP BY w.device_type
)
SELECT
    device_type,
    total_sessions,
    total_orders,
    ROUND(
        total_orders * 100.0 / total_sessions,
        2
    ) AS conversion_rate
FROM device_data
ORDER BY conversion_rate DESC;


-- 7. Top 10 website pages by pageviews
SELECT
    pageview_url,
    COUNT(*) AS total_pageviews
FROM website_pageviews
GROUP BY pageview_url
ORDER BY total_pageviews DESC
LIMIT 10;


-- 8. Average pageviews per website session
SELECT
    AVG(pageview_count) AS average_pageviews_per_session
FROM (
    SELECT
        website_session_id,
        COUNT(website_pageview_id) AS pageview_count
    FROM website_pageviews
    GROUP BY website_session_id
) AS session_pageviews;


-- 9. Sessions with more than 3 pageviews
SELECT
    website_session_id,
    COUNT(website_pageview_id) AS total_pageviews
FROM website_pageviews
GROUP BY website_session_id
HAVING COUNT(website_pageview_id) > 3
ORDER BY total_pageviews DESC;
