CREATE DATABASE WalmartSalesData;
USE WalmartSalesData;

CREATE TABLE IF NOT EXISTS Sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

SELECT * FROM Sales;

-- time_of_day

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE Sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE Sales
SET time_of_day = (
		CASE
            WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
            ELSE "Evening"
        END);
        

-- DayName

SELECT 
     Date,
     DAYNAME(Date)
FROM Sales;

ALTER TABLE Sales ADD COLUMN Day_Name VARCHAR(20);
                       
UPDATE Sales
SET Day_Name = DAYNAME(Date);

-- MonthName

SELECT 
     Date,
     monthname(Date)
FROM Sales;

ALTER TABLE Sales ADD COLUMN Month_Name VARCHAR(20);
                       
UPDATE Sales
SET Month_Name = MONTHNAME(Date);

SELECT * FROM Sales;

-- --------------------------------------------------------

-- GENERIC

-- How many unique cities does the data have?
SELECT DISTINCT City
FROM Sales;

-- In which city is each branch?
SELECT DISTINCT Branch
FROM Sales;

SELECT DISTINCT City, Branch
FROM Sales;

-- ------------------------
-- PRODUCT

-- How many unique product lines does the data have?
SELECT 
COUNT(DISTINCT product_line )
FROM Sales;

-- ---------------------------
-- What is the most selling product line
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

--  What is the most common payment method?
SELECT payment,
COUNT(payment) AS CNT
FROM Sales
GROUP BY payment
ORDER BY CNT;

-- What is the total revenue by month?
SELECT 
     month_name as Month,
     SUM(TOTAL) AS Total_Revenue
FROM Sales
GROUP BY month_name
ORDER BY Total_Revenue DESC;

-- What month had the largest COGS?
SELECT
      month_name as Month,
      SUM(cogs) AS Cogs
FROM Sales
GROUP BY month_name
ORDER BY Cogs DESC;

-- What product line had the largest revenue?
SELECT
      product_line,
      SUM(TOTAL) AS Total_Revenue
FROM Sales
GROUP BY product_line
ORDER BY Total_Revenue DESC;

-- What is the city with the largest revenue?
SELECT
     Branch, City,
     SUM(TOTAL) AS Total_Revenue
FROM Sales
GROUP BY Branch, City
ORDER BY Total_Revenue DESC;

-- What product line had the largest VAT?

SELECT
      product_line,
      AVG(tax_pct) as Avg_Tax
FROM Sales
GROUP BY product_line
ORDER BY Avg_Tax;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5.5 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT
      Branch,
      SUM(Quantity) AS Qty
FROM Sales
GROUP BY Branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM Sales);

-- What is the most common product line by gender?
SELECT
      Gender, Product_line,
      COUNT(Gender) AS Total_gender_cnt
FROM Sales
GROUP BY Gender, Product_line
ORDER BY Total_gender_cnt DESC;

-- What is the average rating of each product line?
SELECT
      Product_line,
      ROUND(AVG(Rating), 2) AS Avg_Rating
FROM Sales
GROUP BY Product_line
ORDER BY Avg_Rating DESC;

--  -----------------------------------------------------------------------------------------------
-- --------------------------------Sales----------------------------------------------------------

-- Number of sales made in each time of the day per weekday

SELECT 
      time_of_day,
      Count(*) as total_sales
FROM Sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;


-- Which of the customer types brings the most revenue?

SELECT
      customer_type,
      SUM(TOTAL) AS total_rev
FROM Sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT
      city,
      AVG(tax_pct) AS VAT
FROM Sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?

SELECT
      customer_type,
      AVG(tax_pct) AS VAT
FROM Sales
GROUP BY customer_type
ORDER BY VAT DESC LIMIT 1;

-- ------------------------------------------------------------------------------------------------
-- ------------------------------------Customer----------------------------------------------------

-- How many unique customer types does the data have?

SELECT
      DISTINCT customer_type
FROM Sales;

-- How many unique payment methods does the data have?

SELECT
      DISTINCT payment
FROM Sales;

-- What is the most common customer type?
SELECT
      customer_type,
	  COUNT(*) AS cst_cnt
FROM Sales
GROUP BY customer_type;


-- Which customer type buys the most?
SELECT
      customer_type,
      COUNT(*) AS cst_cnt
FROM Sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT
      gender,
      COUNT(*) AS gender_cnt
FROM Sales
GROUP BY gender;

-- What is the gender distribution per branch?
SELECT
      gender,
      COUNT(*) AS gender_cnt
FROM Sales
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?

SELECT
      time_of_day,
      AVG(rating) AS avg_rating
FROM Sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?

SELECT
      time_of_day,
      AVG(rating) AS avg_rating
FROM Sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?

SELECT
      Day_Name,
      AVG(rating) AS avg_rating
FROM Sales
GROUP BY Day_Name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?

SELECT
      Day_Name,
      AVG(rating) AS avg_rating
FROM Sales
WHERE branch = "B"
GROUP BY Day_Name
ORDER BY avg_rating DESC;


