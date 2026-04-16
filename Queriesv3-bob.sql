-- ==========================================
-- FINAL PROJECT: 14 REQUIRED QUERIES
-- Target Database: mydb
-- ==========================================

-- This file is used to easily extract the queries for our assignments.

-- Req 1: General SELECT with ORDER BY
-- Intent: Sort inventory from most to least expensive
SELECT paddle_id, model_name, price, stock_quantity, img_url 
FROM paddles 
ORDER BY price DESC;

-- Req 2: SELECT with WHERE clause
-- Intent: Identify items with low stock (less than 10 units)
SELECT paddle_id, model_name, price, stock_quantity, img_url 
FROM paddles 
WHERE stock_quantity < 10;

-- Req 3: Delete Query
-- Intent: Remove a specific manufacturer/brand from the system
DELETE FROM brands 
WHERE brand_id = 11;

-- Req 4: Update Query
-- Intent: Restock inventory for a specific product
UPDATE paddles 
SET stock_quantity = stock_quantity + 5 
WHERE paddle_id = 1;

-- Req 5: Insert Query
-- Intent: Register a new customer into the database
INSERT INTO customers (first_name, last_name, email, membership_level, member_since) 
VALUES ('Firstname', 'Lastname', 'email@example.com', 'Standard', CURDATE());

-- Req 6: Inner Join
-- Intent: Connect sales, customers, paddles, and brands to build the Sales Ledger
SELECT c.first_name, b.brand_name, p.model_name, s.total_amount 
FROM sales s 
JOIN customers c ON s.customer_id = c.customer_id 
JOIN paddles p ON s.paddle_id = p.paddle_id 
JOIN brands b ON p.brand_id = b.brand_id;

-- Req 7: Outer Join
-- Intent: Identify "Dead Stock" (products that have never been sold)
SELECT p.model_name 
FROM paddles p 
LEFT JOIN sales s ON p.paddle_id = s.paddle_id 
WHERE s.sale_id IS NULL;

-- Req 8: Aggregate Function (SUM)
-- Intent: Calculate the total gross revenue of the shop
SELECT SUM(total_amount) AS total_revenue 
FROM sales;

-- Req 9: GROUP BY and HAVING
-- Intent: Identify VIP customers who have spent over $200 total
SELECT customer_id, SUM(total_amount) AS total_spent 
FROM sales 
GROUP BY customer_id 
HAVING SUM(total_amount) > 200;

-- Req 10: Subquery
-- Intent: Filter for premium paddles priced above the store average
SELECT paddle_id, model_name, price, stock_quantity 
FROM paddles 
WHERE price > (SELECT AVG(price) FROM paddles);

-- Req 11: String Function (CONCAT & UPPER)
-- Intent: Format names into a professional directory (LAST, First)
SELECT CONCAT(UPPER(last_name), ', ', first_name) AS full_name, email 
FROM customers;

-- Req 12: Numeric Function (ROUND)
-- Intent: Display simplified whole-dollar pricing, including a 6% tax rate
SELECT paddle_id, model_name, ROUND(price * 1.06, 0) AS price, stock_quantity 
FROM paddles;

-- Req 13: Date Function (MONTH)
-- Intent: Filter sales records by a specific month (e.g., March = 3)
SELECT * FROM sales 
WHERE MONTH(sale_date) = 3;

-- Req 14: CASE Function
-- Intent: Dynamically categorize transactions and sort by VIP status
SELECT c.first_name, b.brand_name, p.model_name, s.total_amount, 
       CASE WHEN s.total_amount > 200 THEN 'VIP Tier' ELSE 'Standard Tier' END AS Tier 
FROM sales s 
JOIN customers c ON s.customer_id = c.customer_id 
JOIN paddles p ON s.paddle_id = p.paddle_id
JOIN brands b ON p.brand_id = b.brand_id
ORDER BY Tier DESC;
