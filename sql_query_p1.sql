-------SQL RETAIL SALES ANALYSIS -------

CREATE DATABASE SQL_PROJECT;


---------CREATE TABLE -----
CREATE TABLE RETAIL_SALES
(
     transactions_id  INT PRIMARY KEY, 
     sale_date  DATE ,
     sale_time  TIMESTAMP ,
     customer_id INT ,
     gender VARCHAR2(15),
     age   INT,
     category  VARCHAR2(15),
     quantiy   INT,
     price_per_unit  FLOAT,
     cogs  FLOAT ,
     total_sale  FLOAT
     );
 
SELECT * FROM RETAIL_SALES;

SELECT COUNT(*) FROM RETAIL_SALES;

UPDATE RETAIL_SALES SET SALE_TIME = TO_CHAR (SALE_TIME ,'HH:MI:SS');
ALTER TABLE RETAIL_SALES MODIFY SALE_TIME VARCHAR2(20);
ALTER TABLE RETAIL_SALES ADD new_sales_time VARCHAR2(8);
UPDATE RETAIL_SALES
SET new_sales_time = TO_CHAR(sale_time, 'HH24:MI:SS');
ALTER TABLE RETAIL_SALES DROP COLUMN sale_time;
ALTER TABLE RETAIL_SALES RENAME COLUMN new_sales_time TO sale_time;
ALTER TABLE RETAIL_SALES RENAME COLUMN Quantiy TO Quantity;


------ DATA CLEANING-------

SELECT * FROM RETAIL_SALES 
WHERE TRANSACTIONS_ID IS NULL;

SELECT * FROM RETAIL_SALES 
WHERE
      TRANSACTIONS_ID IS NULL 
      OR
      SALE_DATE IS NULL
      OR 
      SALE_TIME IS NULL
      OR
      CUSTOMER_ID IS NULL
      OR
      GENDER IS NULL
      OR
      QUANTITY IS NULL
      OR 
      COGS IS NULL 
      OR 
      TOTAL_SALE IS NULL ;


DELETE FROM RETAIL_SALES 
WHERE 
      TRANSACTIONS_ID IS NULL 
      OR
      SALE_DATE IS NULL
      OR 
      SALE_TIME IS NULL
      OR
      CUSTOMER_ID IS NULL
      OR
      GENDER IS NULL
      OR
      QUANTITY IS NULL
      OR 
      COGS IS NULL 
      OR 
      TOTAL_SALE IS NULL ;
      
      
--------DATA EXPLORATION-----

---HOW MANY SALES WE HAVE ?

SELECT COUNT(*) FROM RETAIL_SALES;

--HOW MANY CUSTOMERS WE HAVE ?

SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_SALE FROM RETAIL_SALES;

--HOW MANY DISTINCT CATEGORY WE HAVE ? 

SELECT DISTINCT CATEGORY FROM RETAIL_SALES;

----DATA ANALYSIS & BUSSINESS KEY PROBLEMS & ANSWERS-----

 My Analysis & Findings
 
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '05-NOV-2022';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY CATEGORY;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY 
    category,GENDER
ORDER BY CATEGORY;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    ROUND(AVG(total_sale)) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 
    EXTRACT(YEAR FROM sale_date) ,
    EXTRACT(MONTH FROM sale_date)
) t1
WHERE rank = 1
;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    total_sales
FROM 
(
    SELECT 
        customer_id,
        SUM(total_sale) AS total_sales,
        ROW_NUMBER() OVER (ORDER BY SUM(total_sale) DESC) AS rnum
    FROM retail_sales
    GROUP BY customer_id
)
WHERE rnum <= 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category,    
    COUNT(distinct customer_id) as count_unique_cs
FROM retail_sales
GROUP BY category;



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS
(
    SELECT
        sale_time,
        CASE
            WHEN TO_NUMBER(SUBSTR(sale_time, 1, 2)) < 12 THEN 'Morning'
            WHEN TO_NUMBER(SUBSTR(sale_time, 1, 2)) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift; 


-- End of project

