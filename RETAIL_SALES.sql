-- CREATING THE TABLE WHERE DATA WILL BE ORGANISED IN THE DATABASE
CREATE TABLE retail_sales (
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR (15),
	age	INT,
	category VARCHAR (15),
	quantiy	INT,
	price_per_unit	FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- CONFIRMING THAT THE DATA HAS BEEN IMPORTED SUCCESFULLY
SELECT * FROM retail_sales

-- CONFIRMS THAT THE DATA IMPORTED IS ACCURATE BY CROSSCHECKING WITH THE NUMBER OFROWS OF DATA IN THE CSV FILE IMPORTED
SELECT 
	COUNT (*) FROM retail_sales;
-- DATA CLEANING, IIDENTIFYING ROWS THAT DO NOT CONTAIN EMPTY FIELDS
SELECT 
	*
FROM 
	retail_sales
WHERE
	transactions_id ISNULL
	OR
	sale_date ISNULL
	OR
	sale_time ISNULL
	OR
	customer_id ISNULL
	OR
	gender ISNULL
	OR
	category ISNULL
	OR
	quantiy ISNULL
	OR
	price_per_unit ISNULL
	OR
	cogs ISNULL
	OR
	total_sale ISNULL;
	
	
-- DATA CLEANING, DELETING ROWS WHERE VALUSES ARE NOT REPRESENTED
DELETE 	FROM retail_sales
WHERE
	transactions_id ISNULL
	OR
	sale_date ISNULL
	OR
	sale_time ISNULL
	OR
	customer_id ISNULL
	OR
	gender ISNULL
	OR
	category ISNULL
	OR
	quantiy ISNULL
	OR
	price_per_unit ISNULL
	OR
	cogs ISNULL
	OR
	total_sale ISNULL;
	

--DATA EXPLORATION 
--THE BUSINESS WOULD LIKE TO KNOW HOW MANY TRANSACTIONS WERE DONE IN THE PERIOD UNDER REVIEW
SELECT 
	COUNT (transactions_id) 
FROM retail_sales AS total_transactions;

-- THE BUSINESS WOULD LIKE TO KNOW HOW MANY CUSTOMERS THEY HAVE FOR THE PERIOD UNDER REVIEW
SELECT 
	COUNT (DISTINCT customer_id)
FROM retail_sales AS total_customers;

-- TO IDENTIFY THE NUMBER OF CATEGORIES WHERE THE TRANSACTIONS HAVE COME FROM
SELECT 
	COUNT (DISTINCT category)
FROM retail_sales AS categories;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Retrieve all columns for sales made on '2022-11-05
-- Q.2 Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Calculate the total sales (total_sale) for each category.
-- Find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Find all transactions where the total_sale is greater than 1000.
-- Q.6 Find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantIy > 10;
	
	

-- Q.3 Calculate the total sales (total_sale) for each category.

SELECT 
	category,
	SUM (quantiy) AS quantity_sold
FROM retail_sales
GROUP BY
	category;

-- Find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND (AVG(age), 2) AS beauty_customers_average_age
FROM
	retail_sales
WHERE 
	category = 'Beauty';
	
	
-- Q.6 Find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(transactions_id) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY category;


-- Q.7 Calculate the average sale for each month. Find out best selling month in each year
SELECT
	month,
	year,
	average_sale
FROM
	(SELECT
	 	EXTRACT (YEAR FROM sale_date) AS year,
	 	EXTRACT (MONTH FROM sale_date) AS month,
		AVG(total_sale) AS average_sale,
		RANK() 
		OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) 
		ORDER BY AVG(total_sale) DESC) as rank
		FROM 
			retail_sales
		GROUP BY 
			year, 
			month
	) as t1
WHERE RANK = 1
	 ;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
	customer_id,
	SUM(total_sale) AS total_sales
FROM	
	retail_sales
GROUP BY 
	customer_id
ORDER BY
	total_sales DESC 
	LIMIT 5;


-- Q.9 Find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) AS number_of_customers
FROM retail_sales
GROUP BY category;
	

-- Q.5 Find all transactions where the total_sale is greater than 1000.
SELECT
	*
FROM 
	retail_sales
WHERE 
	total_sale > 1000;



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- END OF PROJECT









