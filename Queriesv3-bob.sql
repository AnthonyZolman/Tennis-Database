-- ==========================================
-- FINAL PROJECT: 14 REQUIRED QUERIES
-- Target Database: mydb
-- ==========================================

USE mydb;

-- 1. Sorts all paddles from most expensive to least expensive
SELECT paddle_id, model_name, price, stock_quantity, img_url 
FROM paddles 
ORDER BY price DESC;

-- 2. Finds low-stock items (under 10 count)
SELECT paddle_id, model_name, price, stock_quantity, img_url 
FROM paddles 
WHERE stock_quantity < 10;

-- 3. Deletes the dummy brand we added specifically for this test
DELETE FROM brands 
WHERE brand_name = 'Dummy Brand';

-- 4. Adjusts stock quantity of paddles
UPDATE paddles 
SET stock_quantity = stock_quantity + 0
WHERE paddle_id = 0;

-- 5. Adds a new user customer
INSERT INTO customers (
    first_name, 
    last_name, 
    email, 
    membership_level, 
    member_since
) 
VALUES (
    'Firstname', 
    'Lastname', 
    'email@example.com', 
    'Standard', 
    CURDATE()
);

-- 6. Joins paddles and brands to show the paddle name alongside the company that makes it
SELECT p.model_name, b.brand_name 
FROM paddles p 
INNER JOIN brands b ON p.brand_id = b.brand_id;

-- 7. Uses a LEFT JOIN to list paddles with no sales
SELECT p.model_name 
FROM paddles p 
LEFT JOIN sales s ON p.paddle_id = s.paddle_id 
WHERE s.sale_id IS NULL;

-- 8. Calculates the Total Gross Revenue of the storefront
SELECT SUM(total_amount) AS total_revenue 
FROM sales;

-- 9. Returns the customers who have spent the most on the storefront
SELECT 
    customer_id, 
    SUM(total_amount) AS total_spent 
FROM sales 
GROUP BY customer_id 
HAVING SUM(total_amount) > 200;

-- 10. Finds all paddles that cost more than the average paddle price
SELECT model_name, price 
FROM paddles 
WHERE price > (SELECT AVG(price) FROM paddles);

-- 11. Uses CONCAT() to merge the customer first and last name into a single descriptive string
SELECT 
    CONCAT(last_name, ', ', first_name) AS full_name, 
    email 
FROM customers
ORDER BY last_name ASC;

-- 12. Uses ROUND() to round the paddle prices to the nearest whole dollar
SELECT model_name, price, ROUND(price, 0) AS rounded_price 
FROM paddles;

-- 13. Uses the MONTH() to get sales from the month of March
SELECT * FROM sales 
WHERE MONTH(sale_date) = 3;

-- 14. Categorizes paddles into price tiers based on their cost
SELECT model_name, price,
    CASE 
        WHEN price >= 200.00 THEN 'Premium Tier'
        WHEN price >= 150.00 THEN 'Mid-Range Tier'
        ELSE 'Budget Tier'
    END AS price_category
FROM paddles;
