-- Superstore Capstone: Import script
-- Creates the orders table and loads the cleaned data (dates fixed).
-- -- Before running: edit the file path in the LOAD DATA line (use forward slashes).
-- LOAD DATA LOCAL needs local_infile enabled: SET GLOBAL local_infile = 1;

CREATE DATABASE IF NOT EXISTS superstore;
USE superstore;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    Row_ID INT, Order_ID VARCHAR(20), Ship_Mode VARCHAR(20),
    Customer_ID VARCHAR(15), Customer_Name VARCHAR(50), Segment VARCHAR(20),
    Country VARCHAR(30), City VARCHAR(50), State VARCHAR(30),
    Postal_Code VARCHAR(10), Region VARCHAR(10), Product_ID VARCHAR(20),
    Category VARCHAR(20), Sub_Category VARCHAR(20), Product_Name VARCHAR(255),
    Sales DECIMAL(10,4), Quantity INT, Discount DECIMAL(4,2), Profit DECIMAL(12,4),
    Order_Date DATE, Ship_Date DATE, Shipping_Days INT,
    Order_Year INT, Order_Month INT, Profit_Margin DECIMAL(8,4),
    Discount_Band VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'C:/path/to/superstore_for_mysql.csv'
INTO TABLE orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Check after loading: expect 9994 rows, profit 286397.02,
-- shipping days 0-7, order dates 2014-01-03 to 2017-12-30
SELECT COUNT(*) AS total_rows,
       ROUND(SUM(Profit), 2) AS total_profit,
       MIN(Shipping_Days) AS min_ship, MAX(Shipping_Days) AS max_ship,
       MIN(Order_Date) AS first_order, MAX(Order_Date) AS last_order
FROM orders;
