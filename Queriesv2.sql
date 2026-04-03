-- ==========================================
-- FINAL PROJECT: 14 REQUIRED QUERIES
-- Target Database: mydb
-- ==========================================

USE mydb;

-- 1. A general SELECT query with an ORDER BY clause
SELECT model_name, price 
FROM paddles 
ORDER BY price DESC;

-- 2. A SELECT query that includes a WHERE clause
SELECT model_name, stock_quantity 
FROM paddles 
WHERE stock_quantity < 10;

-- 3. A Delete Query
DELETE FROM brands 
WHERE brand_name = 'Dummy Brand';

-- 4. An Update Query
UPDATE paddles 
SET price = price - 10.00 
WHERE brand_id = 1;

-- 5. An Insert Query
INSERT INTO sales (paddle_id, customer_id, quantity, total_amount) 
VALUES (1, 3, 1, 249.99);

-- 6. A query for inner join
SELECT c.first_name, c.last_name, p.model_name, s.total_amount 
FROM sales s 
INNER JOIN customers c ON s.customer_id = c.customer_id 
INNER JOIN paddles p ON s.paddle_id = p.paddle_id;

-- 7. A query for outer join (left or right)
SELECT p.model_name, s.sale_id 
FROM paddles p 
LEFT JOIN sales s ON p.paddle_id = s.paddle_id 
WHERE s.sale_id IS NULL;

-- 8. A query with an aggregate function(s)
SELECT SUM(total_amount) AS total_gross_revenue 
FROM sales;

-- 9. A query that includes GROUP BY and HAVING clauses
SELECT customer_id, SUM(total_amount) AS total_spent 
FROM sales 
GROUP BY customer_id 
HAVING SUM(total_amount) > 300;

-- 10. A query with a subquery
SELECT model_name, price 
FROM paddles 
WHERE price > (SELECT AVG(price) FROM paddles);

-- 11. A query that includes a string function
SELECT CONCAT(UPPER(last_name), ', ', first_name) AS formatted_name 
FROM customers;

-- 12. A query that includes a numeric function
SELECT model_name, price, ROUND(price * 1.06, 2) AS total_with_tax 
FROM paddles;

-- 13. A query that includes a date function
SELECT * FROM sales 
WHERE MONTH(sale_date) = 3;

-- 14. A query that uses the CASE function
SELECT sale_id, total_amount,
    CASE 
        WHEN total_amount >= 200.00 THEN 'Premium Transaction'
        ELSE 'Standard Transaction'
    END AS sale_type
FROM sales;