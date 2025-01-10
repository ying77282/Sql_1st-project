
-- CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
		(
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age    INT,
			category  VARCHAR(50),
			quantiy  INT,
			price_per_unit FLOAT,
			cogs  FLOAT,
			total_sale  FLOAT
		);

SELECT TOP 10 * FROM Retail_Sales_Analysis;

--How many rows
SELECT COUNT(*) FROM Retail_Sales_Analysis;

-- DONT have null , check all column whether got null
SELECT * FROM Retail_Sales_Analysis
WHERE transactions_id IS NULL;

SELECT * FROM Retail_Sales_Analysis
WHERE customer_id IS NULL;

-- directly check all column where got null
-- if use or, means only one column need to be null
--if use and, means need to match, all the column need to be null
SELECT * FROM Retail_Sales_Analysis
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	customer_id IS NULL


DELETE  FROM Retail_Sales_Analysis
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	customer_id IS NULL

SELECT COUNT(*) FROM Retail_Sales_Analysis;

-- Data exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM Retail_Sales_Analysis

-- How many unique customer we have?
SELECT COUNT(DISTINCT(customer_id)) as count_unique_customer FROM Retail_Sales_Analysis

-- How many category we have?
SELECT COUNT(DISTINCT(category)) as count_category_unique FROM Retail_Sales_Analysis
-- List of the unique category
SELECT DISTINCT(category) as category_unique FROM Retail_Sales_Analysis
	
-- Data Analysis & Business Problem & Answers
--1. Write a SQL Query to retrieve all columns for sales made on'2022-01-05'

SELECT * FROM Retail_Sales_Analysis
WHERE sale_date='2022-01-05';

--2. Write a SQL quey to retrieve all transactions where the category is clothing and the quantity sold is more than 10 in the month of Nov-2022
SELECT * 
FROM Retail_Sales_Analysis
WHERE category = 'Clothing'
  AND quantiy >=4
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11;

--or 

SELECT * 
FROM Retail_Sales_Analysis
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';

-- 3. Write a quey to calculate the total sales for each category

SELECT category, sum(total_sale) AS total_sales, COUNT(*) AS total_orders
FROM Retail_Sales_Analysis
Group By category;

--4. write a query to find the average age of customers who purchased items from 'Beauty' category
SELECT category, AVG(age) AS avg_age
FROM Retail_Sales_Analysis
WHERE category = 'Beauty'
GROUP BY category;

--5. Write a query to find all transactions where the total sales+ is greater than 1000

SELECT *
FROM Retail_Sales_Analysis
WHERE total_sale>1000;

--6. write sql query to find the total number of transactions (transaction_id)made by each gender in each category

SELECT category,gender, count(transactions_id) AS count
FROM Retail_Sales_Analysis
GROUP BY  category,gender
ORDER BY category;

--7. write a query to calculate the average sale for each month. Find the best selling month in each year
SELECT Year,Month,avg_total_sale
FROM (
    SELECT YEAR(sale_date) AS Year, 
           MONTH(sale_date) AS Month, 
           AVG(total_sale) AS avg_total_sale, 
           RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_per_year
    FROM Retail_Sales_Analysis
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rank_per_year = 1
ORDER BY Year, Month;

--8.write quey+ry find top 5 customers based on the highest total sales

SELECT  TOP 5 customer_id, SUM(total_sale) AS total_sales
FROM Retail_Sales_Analysis
Group by customer_id
ORDER BY total_sales DESC

--9. find number of unique customers who purchased items from each category

SELECT category, Count(distinct(customer_id)) AS Unique_customer
FROM Retail_Sales_Analysis
Group By category;

--10. create each shift and number of orders (Example mnorning <=12 , afternoon between 12 &17, Evening >=17)
-- Temporarily table
WITH hourly_rate
AS
(
SELECT *,
       CASE 
           WHEN DATEPART(HOUR, sale_time) <= 12 THEN 'Morning'
           WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS shift
FROM Retail_Sales_Analysis
)
SELECT shift, COUNT(*) as total_orders FROM hourly_rate
GROUP BY shift
