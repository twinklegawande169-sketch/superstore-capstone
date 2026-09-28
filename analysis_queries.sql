-- Superstore Capstone: Analysis Queries
-- Run these after superstore_import.sql has created and populated the `orders` table.

-- 1. Profit and discount by sub-category (identifies loss-making sub-categories)
SELECT Sub_Category,
       ROUND(SUM(Profit),2) AS total_profit,
       ROUND(AVG(Discount),3) AS avg_discount,
       ROUND(SUM(Sales),2) AS total_sales
FROM orders
GROUP BY Sub_Category
ORDER BY total_profit ASC;

-- 2. Root cause check: does discount level explain Tables' losses?
SELECT
  CASE
    WHEN Discount = 0 THEN '0%'
    WHEN Discount <= 0.2 THEN '1-20%'
    WHEN Discount <= 0.4 THEN '21-40%'
    ELSE '40%+'
  END AS discount_band,
  COUNT(*) AS num_orders,
  ROUND(SUM(Profit),2) AS total_profit
FROM orders
WHERE Sub_Category = 'Tables'
GROUP BY discount_band
ORDER BY discount_band;

-- 3. Sales by region
SELECT Region, ROUND(SUM(Sales),2) AS total_sales, ROUND(SUM(Profit),2) AS total_profit
FROM orders
GROUP BY Region
ORDER BY total_sales DESC;

-- 4. Sales trend by year and month (for seasonality analysis)
SELECT Order_Year, Order_Month, ROUND(SUM(Sales),2) AS total_sales
FROM orders
GROUP BY Order_Year, Order_Month
ORDER BY Order_Year, Order_Month;
