Objectives:

1. Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
2. Data Cleaning: Identify and remove any records with missing or null values.
3. Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
4. Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

Project Structure:

# 1. Database setup
- **Database Creation: The project starts by creating a database named p1_retail_db.
- **Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category,      quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.
    
```sql
CREATE DATABASE p1_retail_db;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```


# 2. Data Exploration & Cleaning
- **Record Count: Determine the total number of records in the dataset.
- **Customer Count: Find out how many unique customers are in the dataset.
- **Category Count: Identify all unique product categories in the dataset.
- **Null Value Check: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;
```

```sql
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

```sql
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

# 3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:

- **1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

```sql
SELECT * FROM retail_sales
WHERE sale_date='2022-01-05';
```

- **1. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

```sql
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >=4
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11;
```

or

```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

or

```sql  
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy >= 4
  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';
```

    
- **3. Write a SQL query to calculate the total sales (total_sale) for each category.:

```sql      
SELECT category, sum(total_sale) AS total_sales, COUNT(*) AS total_orders
FROM retail_sales
Group By category;
```


- **4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

```sql
SELECT category, ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;
```


- **5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

```sql
SELECT *
FROM retail_sales
WHERE total_sale>1000;
```


- **6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

```sql
SELECT category,gender, count(transactions_id) AS count
FROM retail_sales
GROUP BY  category,gender
ORDER BY category;
```



- **7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

```sql
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
```

- **8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
- 
```sql
SELECT  TOP 5 customer_id, SUM(total_sale) AS total_sales
FROM Retail_Sales_Analysis
Group by customer_id
ORDER BY total_sales DESC
```

- **9. Write a SQL query to find the number of unique customers who purchased items from each category.:

```sql
SELECT category, Count(distinct(customer_id)) AS Unique_customer
FROM Retail_Sales_Analysis
Group By category;
```


- **10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
  
```sql   
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
```

