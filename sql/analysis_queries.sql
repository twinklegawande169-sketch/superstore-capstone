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

-- 5. JOIN: which regional manager's region earns the most profit, and at what margin?
-- (regional_managers is a small reference table created to demonstrate a JOIN)
DROP TABLE IF EXISTS regional_managers;
CREATE TABLE regional_managers (
    Region VARCHAR(20),
    Manager VARCHAR(50)
);
INSERT INTO regional_managers (Region, Manager) VALUES
('Central', 'Manager A'), ('East', 'Manager B'),
('South', 'Manager C'), ('West', 'Manager D');

SELECT m.Manager,
       o.Region,
       ROUND(SUM(o.Sales), 2)  AS total_sales,
       ROUND(SUM(o.Profit), 2) AS total_profit,
       ROUND(SUM(o.Profit) / SUM(o.Sales) * 100, 1) AS margin_pct
FROM orders o
JOIN regional_managers m ON o.Region = m.Region
GROUP BY m.Manager, o.Region
ORDER BY total_profit DESC;
-- Note: SQL was easier than Excel here because one query linked two tables and
-- totalled 9,994 rows, where Excel needs a lookup column plus a pivot. The query
-- can also be re-run unchanged if the data is refreshed.

-- 6. Outlier check: are the biggest losses real business losses or data errors?
SELECT Order_ID, Sub_Category, Sales, Quantity, Discount, Profit
FROM orders
ORDER BY Profit ASC
LIMIT 5;
-- Finding: all 5 are Machines/Binders sold at 50-80% discount, so they are
-- real losses from deep discounting, not data errors.

-- 7. Data quality check after the date fix (expect 9994 rows, profit 286397.02, shipping days 0-7)
SELECT COUNT(*) AS total_rows,
       ROUND(SUM(Profit), 2) AS total_profit,
       MIN(Shipping_Days) AS min_ship, MAX(Shipping_Days) AS max_ship,
       MIN(Order_Date) AS first_order, MAX(Order_Date) AS last_order
FROM orders;

-- 8. Profiling: row counts and missing values
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT Row_ID) AS unique_row_ids,
       COUNT(DISTINCT Order_ID) AS unique_orders,
       SUM(Sales IS NULL) + SUM(Profit IS NULL) + SUM(Order_Date IS NULL) + SUM(Ship_Date IS NULL) AS missing_in_key_columns
FROM orders;
