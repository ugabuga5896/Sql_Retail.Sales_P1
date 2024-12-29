-- SQL Retail Sales Analysis -- P1
Use sql_project_P1;

Create table  retail_sales
 (
	transactions_id	int PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender VARCHAR(15),
	age	int,
	category VARCHAR(5),
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale float
 );
 
 Select * from retail_sales 
 where sale_time is null
 or sale_date is null
 or transactions_id is null
 or gender is null
 or category is null
 or quantiy is null
 or cogs is null
 or total_sale is null;

-- data exploration--

-- HOW MANY SALES WE HAVE ;

select COUNT(*) as total_sale from retail_sales;

-- HOW MANY SALES WE HAVE ;

select COUNT(DISTINCT category) as total_sale from retail_sales;


--- data analysis and business key problems;
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
and quantiy >=2
;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
category, 
sum(total_sale) as net_sale,
count( * ) as total_orders
 from retail_sales
 group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
round(AVG(AGE), 2) AS AVG_AGE
from retail_sales
where category = "Beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,
gender,
count(*) as total_trans
from retail_sales
group by
category,
gender
order by gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select *  from 
(select 
	Year(sale_date) as year,
	month(sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over (partition by year(sale_date) order by avg(total_sale) desc) as score
	from retail_sales
group by 1,2 ) as t1
where score = 1
 ;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

 select 
 customer_id,
 sum(total_sale) as total_sales
 from retail_sales
 group by 1
 order by 2 desc
 limit 5;
 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

 select 
 category,
 count( distinct customer_id)
 from retail_sales
 Group by category;
 


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS (
    SELECT 
        *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

