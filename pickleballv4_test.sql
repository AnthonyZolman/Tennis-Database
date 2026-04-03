-- 1. Setup and Reset
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

-- Drop child tables first to avoid Foreign Key constraint errors
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS paddles;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS brands;
DROP TABLE IF EXISTS paddle_shapes;
DROP TABLE IF EXISTS core_materials;

-- 2. Create tables
CREATE TABLE brands (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(50) NOT NULL,
    country_of_origin VARCHAR(50)
);

CREATE TABLE paddle_shapes (
    shape_id INT AUTO_INCREMENT PRIMARY KEY,
    shape_name VARCHAR(50) NOT NULL,
    description VARCHAR(150)
);

CREATE TABLE core_materials (
    core_id INT AUTO_INCREMENT PRIMARY KEY,
    material_name VARCHAR(50) NOT NULL,
    thickness_mm DECIMAL(4,1)
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    membership_level VARCHAR(20), -- 'Standard', 'Gold', 'Platinum'
    member_since DATE
);

CREATE TABLE paddles (
    paddle_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT,
    shape_id INT,
    core_id INT,
    model_name VARCHAR(100) NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    stock_quantity INT DEFAULT 20,
    release_date DATE,
    weight_oz DECIMAL(4,2),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE CASCADE,
    FOREIGN KEY (shape_id) REFERENCES paddle_shapes(shape_id) ON DELETE SET NULL,
    FOREIGN KEY (core_id) REFERENCES core_materials(core_id) ON DELETE SET NULL
);

CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    paddle_id INT,
    customer_id INT,
    sale_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    quantity INT DEFAULT 1,
    total_amount DECIMAL(8,2),
    FOREIGN KEY (paddle_id) REFERENCES paddles(paddle_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL
);

-- 3. Inserting Data
INSERT INTO brands (brand_name, country_of_origin) VALUES 
('Joola', 'USA'), ('Selkirk', 'USA'), ('Paddletek', 'USA'), ('CRBN', 'USA'), 
('Engage', 'USA'), ('Gearbox', 'USA'), ('Six Zero', 'Australia'), 
('Vatic Pro', 'USA'), ('Ronbus', 'USA'), ('Diadem', 'USA');

INSERT INTO paddle_shapes (shape_name, description) VALUES 
('Standard', 'Classic dimensions'), ('Elongated', 'Power focus'), ('Widebody', 'Large sweet spot'), 
('Hybrid', 'Curved top'), ('Teardrop', 'Aerodynamic'), ('Blade', 'Singles play'), 
('Oversized', 'Max surface'), ('Edgeless', 'No guard'), ('Slim', 'Fast speed'), ('Oval', 'Maneuverable');

INSERT INTO core_materials (material_name, thickness_mm) VALUES 
('Polymer 16', 16.0), ('Polymer 14', 14.0), ('Polymer 13', 13.0), ('Polymer 12', 12.0), 
('Nomex', 14.0), ('Aluminum', 14.0), ('SST Carbon', 11.0), ('Kevlar', 16.0), 
('EVA Foam', 20.0), ('Wood', 10.0);

-- Corrected Customer Data (Anonymous)
INSERT INTO customers (first_name, last_name, email, membership_level, member_since) VALUES
('Alex', 'Carter', 'alex.c@email.com', 'Platinum', '2024-01-15'),
('Jordan', 'Smith', 'jsmith99@email.com', 'Gold', '2024-02-10'),
('Taylor', 'Brooks', 'tbrooks@email.com', 'Standard', '2023-11-05'),
('Casey', 'Jones', 'cjones@email.com', 'Standard', '2024-03-01'),
('Morgan', 'Lee', 'mlee_pickleball@email.com', 'Gold', '2023-12-20'),
('Riley', 'Davis', 'riley.davis@email.com', 'Platinum', '2024-01-05'),
('Sam', 'Wilson', 'swilson@email.com', 'Standard', '2024-02-28'),
('Quinn', 'Taylor', 'qtaylor@email.com', 'Gold', '2023-10-15'),
('Avery', 'Clark', 'aclark@email.com', 'Standard', '2024-03-12'),
('Blake', 'Evans', 'bevans@email.com', 'Platinum', '2024-01-30');

-- 30 Paddles
INSERT INTO paddles (brand_id, shape_id, core_id, model_name, price, stock_quantity, release_date, weight_oz) VALUES 
(1, 2, 1, 'Perseus CFS 16', 249.99, 10, '2023-06-01', 8.0),
(1, 2, 2, 'Perseus CFS 14', 249.99, 8, '2023-06-01', 7.8),
(1, 1, 1, 'Scorpeus CFS 16', 249.99, 12, '2023-07-15', 8.0),
(2, 4, 1, 'Vanguard Control Invikta', 199.99, 15, '2024-01-10', 7.9),
(2, 1, 1, 'Vanguard Control Epic', 199.99, 5, '2024-01-10', 7.8),
(2, 8, 1, 'Power Air Invikta', 250.00, 20, '2022-08-20', 7.9),
(3, 1, 5, 'Bantam EX-L', 99.99, 4, '2019-05-12', 7.8),
(3, 2, 1, 'Tempest Wave II', 129.99, 6, '2021-03-15', 7.6),
(3, 2, 2, 'TS-5 Pro', 149.99, 9, '2022-11-01', 7.7),
(4, 2, 1, 'CRBN 1X 16mm', 229.99, 3, '2023-02-14', 8.1),
(4, 1, 2, 'CRBN 2X 14mm', 229.99, 10, '2023-02-14', 7.9),
(4, 4, 1, 'CRBN 3X 16mm', 229.99, 11, '2023-04-10', 8.0),
(5, 2, 1, 'Pursuit Pro EX 6.0', 259.99, 8, '2023-08-22', 8.1),
(5, 1, 2, 'Pursuit Pro MX', 259.99, 2, '2023-08-22', 7.9),
(5, 3, 1, 'Encore EX 6.0', 159.99, 14, '2021-07-05', 8.0),
(6, 2, 7, 'CX14E Ultimate', 249.99, 12, '2022-09-30', 8.0),
(6, 1, 7, 'CX14H', 199.99, 7, '2021-12-01', 8.0),
(6, 2, 7, 'Pro Power Elongated', 279.99, 18, '2023-10-15', 8.0),
(7, 4, 1, 'Double Black Diamond', 180.00, 22, '2023-01-20', 8.1),
(7, 4, 2, 'Black Diamond Power', 180.00, 15, '2023-01-20', 8.0),
(7, 1, 1, 'Ruby', 199.00, 5, '2023-11-25', 8.2),
(8, 2, 1, 'V7 Pro', 139.99, 10, '2022-10-10', 8.1),
(8, 4, 1, 'Flash Pro', 139.99, 9, '2023-03-05', 8.0),
(8, 4, 2, 'Alchemy 14mm', 179.99, 12, '2023-09-12', 7.9),
(9, 2, 1, 'R1 Nova', 149.99, 6, '2023-05-18', 8.0),
(9, 4, 1, 'R3 Pulsar', 169.99, 14, '2023-07-22', 8.1),
(9, 1, 2, 'EV1.16', 159.99, 3, '2024-02-01', 8.2),
(10, 1, 1, 'Vice', 199.99, 1, '2022-12-15', 8.1),
(10, 2, 1, 'Edge 18k', 229.99, 10, '2023-08-08', 8.0),
(10, 1, 2, 'Icon V2', 159.99, 5, '2022-06-25', 7.9);

-- 15 Sales
INSERT INTO sales (paddle_id, customer_id, sale_date, quantity, total_amount) VALUES
(1, 1, '2024-03-15 10:30:00', 1, 249.99),
(4, 2, '2024-03-16 14:20:00', 2, 399.98),
(7, 3, '2024-03-17 09:15:00', 1, 99.99),
(10, 4, '2024-03-18 11:45:00', 1, 229.99),
(13, 5, '2024-03-19 16:00:00', 1, 259.99),
(16, 6, '2024-03-20 12:30:00', 1, 249.99),
(19, 7, '2024-03-21 15:10:00', 1, 180.00),
(22, 8, '2024-03-22 09:45:00', 1, 139.99),
(25, 9, '2024-03-23 13:20:00', 1, 149.99),
(28, 10, '2024-03-24 10:00:00', 1, 199.99),
(2, 1, '2024-03-25 14:00:00', 1, 249.99),
(5, 2, '2024-03-26 11:30:00', 1, 199.99),
(8, 3, '2024-03-27 16:45:00', 1, 129.99),
(11, 4, '2024-03-28 08:15:00', 1, 229.99),
(14, 5, '2024-03-29 12:00:00', 1, 259.99);

-- Extra brand for Delete requirement
INSERT INTO brands (brand_name, country_of_origin) VALUES ('Dummy Brand', 'Nowhere');