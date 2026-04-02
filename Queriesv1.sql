-- Sorts all paddles from most expensive to least expensive
SELECT model_name, face_material, price 
FROM paddles 
ORDER BY price DESC;


-- Finds lightweight paddles (under 8.0 oz)
SELECT model_name, weight_oz 
FROM paddles 
WHERE weight_oz < 8.0;


-- Deletes the dummy brand we added specifically for this test
DELETE FROM brands 
WHERE brand_name = 'Dummy Brand';


-- Applies a $10 discount to all Joola paddles (brand_id 1)
UPDATE paddles 
SET price = price - 10.00 
WHERE brand_id = 1;


-- Adds a new user evaluation for the Ruby paddle
INSERT INTO paddle_evaluations (paddle_id, evaluator_name, pop_rating, power_rating, control_rating, overall_quality, recommended_skill, play_style) 
VALUES (21, 'Pickleball Fanatic', 8, 7, 9, 9, 'Intermediate', 'Control & Reset');


-- Joins paddles and brands to show the paddle name alongside the company that makes it
SELECT p.model_name, b.brand_name 
FROM paddles p 
INNER JOIN brands b ON p.brand_id = b.brand_id;


-- Uses a LEFT JOIN to list all core materials and any paddles that use them
SELECT c.material_name, p.model_name 
FROM core_materials c 
LEFT JOIN paddles p ON c.core_id = p.core_id;


-- Calculates the average price of all paddles in the database
SELECT AVG(price) AS average_paddle_price 
FROM paddles;


-- Counts how many paddles each brand has, but only shows brands that have more than 2 paddles listed
SELECT b.brand_name, COUNT(p.paddle_id) AS total_paddles 
FROM brands b 
JOIN paddles p ON b.brand_id = p.brand_id 
GROUP BY b.brand_name 
HAVING COUNT(p.paddle_id) > 2;


-- Finds all paddles that cost more than the average paddle price
SELECT model_name, price 
FROM paddles 
WHERE price > (SELECT AVG(price) FROM paddles);


-- Uses CONCAT() to merge the brand name and country into a single descriptive string
SELECT CONCAT(brand_name, ' (Based in: ', country_of_origin, ')') AS brand_description 
FROM brands;


-- Uses ROUND() to round the paddle prices to the nearest whole dollar
SELECT model_name, price, ROUND(price, 0) AS rounded_price 
FROM paddles;


-- Uses the YEAR() function to isolate and find all paddles released specifically in 2023
SELECT model_name, release_date 
FROM paddles 
WHERE YEAR(release_date) = 2023;


-- Categorizes paddles into price tiers based on their cost
SELECT model_name, price,
    CASE 
        WHEN price >= 200.00 THEN 'Premium Tier'
        WHEN price >= 150.00 THEN 'Mid-Range Tier'
        ELSE 'Budget Tier'
    END AS price_category
FROM paddles;

