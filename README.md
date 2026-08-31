# E-Commerce SQL Data Analysis

## 📌 Project Overview

This project analyzes an e-commerce dataset using MySQL to understand customer behavior, product performance, revenue trends, website traffic, conversion rates, and customer retention.

The analysis contains 100+ business-oriented SQL questions covering both basic and advanced SQL concepts.

---

## 🗂️ Dataset

The project uses the Maven Analytics E-commerce dataset.

### Main tables used:

* `orders`
* `products`
* `order_items`
* `order_item_refunds`
* `website_sessions`
* `website_pageviews`

---

## 🛠️ Tools & Technologies

* MySQL
* SQL
* MySQL Workbench
* GitHub

---

## 📊 Analysis Areas

### 1. Customer Analysis

Analyzed:

* First and last order dates
* Customer order frequency
* Customer revenue
* Top customers
* Repeat customers
* Customer retention
* First, second, and third order behavior
* Consecutive order-day streaks

### 2. Product Analysis

Analyzed:

* Revenue by product
* Top products by revenue
* Product revenue contribution
* Monthly and yearly product performance

### 3. Revenue Analysis

Analyzed:

* Total revenue
* Yearly revenue
* Monthly revenue
* Highest-revenue months
* Month-over-month revenue growth
* Customer revenue contribution

### 4. Website & Conversion Analysis

Analyzed:

* Website sessions
* Traffic sources
* Orders by traffic source
* Conversion rates
* Device performance
* Website pageviews
* Average pageviews per session

### 5. Advanced SQL Analysis

Used advanced SQL techniques to analyze:

* Customer retention
* Customer purchase patterns
* Revenue rankings
* Consecutive-day order streaks
* First vs. second order behavior
* First three order progression
* Customers with increasing order values

---

## 🧠 SQL Concepts Used

This project demonstrates practical use of:

* SELECT
* WHERE
* GROUP BY
* HAVING
* ORDER BY
* JOINs
* LEFT JOIN
* Subqueries
* CTEs
* CASE WHEN
* EXISTS
* NOT EXISTS
* Aggregate functions
* Date functions
* ROW_NUMBER()
* RANK()
* DENSE_RANK()
* LAG()
* Conditional aggregation
* DATEDIFF()
* Revenue calculations
* Customer segmentation

---

## 📁 Project Structure

```text
ecommerce-sql-data-analysis/
│
├── README.md
│
└── sql/
    ├── 01_customer_analysis.sql
    ├── 02_product_analysis.sql
    ├── 03_revenue_analysis.sql
    ├── 04_website_analysis.sql
    └── 05_advanced_customer_analysis.sql
```

---

## 🎯 Project Objective

The main objective of this project is to use SQL to transform raw e-commerce data into meaningful business insights.

The analysis focuses on understanding:

* Who the most valuable customers are
* Which products generate the most revenue
* How revenue changes over time
* Which traffic sources generate conversions
* How customers behave after their first purchase
* Which customers show strong repeat-purchase behavior

---

## 💡 Key Business Insights

### 1. Top Customer Revenue

The highest-value customer generated **$251.94** in total revenue. The top five customers generated between **$219.96 and $251.94**.

### 2. Top Product by Revenue

**The Original Mr. Fuzzy** was the strongest revenue-generating product, generating approximately **$1.42 million** in revenue.

### 3. Monthly Revenue Trend

**December 2013** recorded the highest monthly revenue at **$58,262.60**, while March recorded the lowest at **$19,896.15**. Revenue generally increased during the second half of the year.

### 4. Traffic Source Conversion

Direct/unspecified traffic had the highest conversion rate at **6.96%**, followed by `bsearch` at **6.49%** and `gsearch` at **6.04%**. `socialbook` had the lowest conversion rate at **1.53%**.

### 5. Customer Retention

Out of **7,343 customers** who placed an order in 2013, **24 customers** also purchased in 2014, resulting in a **0.33% retention rate** based on this definition.

### 6. Device Conversion

Desktop users had a **7.05% conversion rate**, compared with **3.97% for mobile users**. This indicates a potential opportunity to investigate the mobile shopping experience and conversion funnel.

---

## 🚀 Key Learning Outcomes

Through this project, I strengthened my ability to:

* Write complex SQL queries
* Analyze real-world business datasets
* Use CTEs and window functions
* Perform customer and revenue analysis
* Analyze website conversion data
* Solve business problems using SQL
* Translate raw data into actionable insights

---

## 👤 Author

**Malleshwari**

Aspiring Data Analyst | SQL | Power BI
