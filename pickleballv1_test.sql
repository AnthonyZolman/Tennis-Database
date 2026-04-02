CREATE DATABASE if not exists mydb;
use mydb;

-- 2. Create the side tables first (so Foreign Keys have something to reference)
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

-- 3. Create the Main Table (Must have at least 30 rows later)
CREATE TABLE paddles (
    paddle_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT,
    shape_id INT,
    core_id INT,
    model_name VARCHAR(100) NOT NULL,
    face_material VARCHAR(50),
    price DECIMAL(6,2),
    weight_oz DECIMAL(4,2),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id) ON DELETE CASCADE,
    FOREIGN KEY (shape_id) REFERENCES paddle_shapes(shape_id) ON DELETE SET NULL,
    FOREIGN KEY (core_id) REFERENCES core_materials(core_id) ON DELETE SET NULL
);

-- 4. Create the Evaluations/Recommendations Table
CREATE TABLE paddle_evaluations (
    eval_id INT AUTO_INCREMENT PRIMARY KEY,
    paddle_id INT,
    evaluator_name VARCHAR(50),
    pop_rating INT CHECK (pop_rating BETWEEN 1 AND 10),
    power_rating INT CHECK (power_rating BETWEEN 1 AND 10),
    control_rating INT CHECK (control_rating BETWEEN 1 AND 10),
    overall_quality INT CHECK (overall_quality BETWEEN 1 AND 10),
    recommended_skill VARCHAR(50),
    play_style VARCHAR(50),
    FOREIGN KEY (paddle_id) REFERENCES paddles(paddle_id) ON DELETE CASCADE
);

-- ==========================================
-- INSERTING DATA (Meeting the 30/10 Row Rule)
-- ==========================================

-- Insert 10 Brands
INSERT INTO brands (brand_name, country_of_origin) VALUES 
('Joola', 'USA'), ('Selkirk', 'USA'), ('Paddletek', 'USA'), ('CRBN', 'USA'), 
('Engage', 'USA'), ('Gearbox', 'USA'), ('Six Zero', 'Australia'), 
('Vatic Pro', 'USA'), ('Ronbus', 'USA'), ('Diadem', 'USA');

-- Insert 10 Shapes
INSERT INTO paddle_shapes (shape_name, description) VALUES 
('Standard', 'Classic 16x8 dimensions, great sweet spot'), 
('Elongated', 'Longer face for reach and power'), 
('Widebody', 'Wider face for maximum sweet spot and blocking'), 
('Hybrid', 'Curved top, blending standard and elongated'), 
('Teardrop', 'Wider at the top, aerodynamic'), 
('Blade', 'Extremely long and narrow for singles play'), 
('Oversized', 'Maximum legal surface area'), 
('Edgeless Standard', 'Standard shape without a plastic edge guard'), 
('Edgeless Elongated', 'Elongated shape without edge guard'), 
('Oval', 'Rounded edges for maneuverability');

-- Insert 10 Core Materials
INSERT INTO core_materials (material_name, thickness_mm) VALUES 
('Polymer Honeycomb', 16.0), ('Polymer Honeycomb', 14.0), 
('Polymer Honeycomb', 13.0), ('Polymer Honeycomb', 12.0), 
('Nomex Honeycomb', 14.0), ('Aluminum Honeycomb', 14.0), 
('Solid SST Carbon', 11.0), ('Kevlar Blend', 16.0), 
('EVA Foam Hybrid', 20.0), ('Wood', 10.0);

-- Insert 30 Paddles (Main Table)
INSERT INTO paddles (brand_id, shape_id, core_id, model_name, face_material, price, weight_oz) VALUES 
(1, 2, 1, 'Perseus CFS 16', 'Carbon Friction Surface', 249.99, 8.0),
(1, 2, 2, 'Perseus CFS 14', 'Carbon Friction Surface', 249.99, 7.8),
(1, 1, 1, 'Scorpeus CFS 16', 'Carbon Friction Surface', 249.99, 8.0),
(2, 4, 1, 'Vanguard Control Invikta', 'Raw Carbon Fiber', 199.99, 7.9),
(2, 1, 1, 'Vanguard Control Epic', 'Raw Carbon Fiber', 199.99, 7.8),
(2, 8, 1, 'Power Air Invikta', 'Fiberglass/Carbon Blend', 250.00, 7.9),
(3, 1, 5, 'Bantam EX-L', 'Polycarbonate', 99.99, 7.8),
(3, 2, 1, 'Tempest Wave II', 'Graphite', 129.99, 7.6),
(3, 2, 2, 'TS-5 Pro', 'Fiberglass', 149.99, 7.7),
(4, 2, 1, 'CRBN 1X 16mm', 'Raw Toray Carbon', 229.99, 8.1),
(4, 1, 2, 'CRBN 2X 14mm', 'Raw Toray Carbon', 229.99, 7.9),
(4, 4, 1, 'CRBN 3X 16mm', 'Raw Toray Carbon', 229.99, 8.0),
(5, 2, 1, 'Pursuit Pro EX 6.0', 'Raw Toray Carbon', 259.99, 8.1),
(5, 1, 2, 'Pursuit Pro MX', 'Raw Toray Carbon', 259.99, 7.9),
(5, 3, 1, 'Encore EX 6.0', 'Fiberglass', 159.99, 8.0),
(6, 2, 7, 'CX14E Ultimate', 'SST Ribbed Core', 249.99, 8.0),
(6, 1, 7, 'CX14H', 'SST Ribbed Core', 199.99, 8.0),
(6, 2, 7, 'Pro Power Elongated', 'SST Ribbed Core', 279.99, 8.0),
(7, 4, 1, 'Double Black Diamond', 'Raw Composite', 180.00, 8.1),
(7, 4, 2, 'Black Diamond Power', 'Raw Composite', 180.00, 8.0),
(7, 1, 1, 'Ruby', 'Kevlar', 199.00, 8.2),
(8, 2, 1, 'V7 Pro', 'Raw Carbon Fiber', 139.99, 8.1),
(8, 4, 1, 'Flash Pro', 'Raw Carbon Fiber', 139.99, 8.0),
(8, 4, 2, 'Alchemy 14mm', 'Raw Carbon Fiber', 179.99, 7.9),
(9, 2, 1, 'R1 Nova', 'Raw Carbon Fiber', 149.99, 8.0),
(9, 4, 1, 'R3 Pulsar', 'Raw Carbon Fiber', 169.99, 8.1),
(9, 1, 2, 'EV1.16', 'EVA Foam', 159.99, 8.2),
(10, 1, 1, 'Vice', 'EVA Foam', 199.99, 8.1),
(10, 2, 1, 'Edge 18k', '18k Carbon Fiber', 229.99, 8.0),
(10, 1, 2, 'Icon V2', 'Carbon Fiber', 159.99, 7.9);

-- Insert 15 Evaluations (Meeting the 10+ row requirement for side tables)
INSERT INTO paddle_evaluations (paddle_id, evaluator_name, pop_rating, power_rating, control_rating, overall_quality, recommended_skill, play_style) VALUES 
(1, 'PB Studio', 8, 9, 7, 9, 'Advanced', 'Aggressive Drive'),
(1, 'Johnnies Reviews', 7, 9, 8, 9, 'Intermediate-Pro', 'Power Baseline'),
(4, 'PB Studio', 6, 6, 10, 9, 'Beginner-Pro', 'Soft Kitchen Play'),
(6, 'The PB Guy', 10, 10, 5, 8, 'Advanced', 'Pure Power'),
(7, 'Johnnies Reviews', 9, 8, 6, 7, 'Beginner', 'Pop & Block'),
(10, 'PB Studio', 8, 8, 8, 9, 'Intermediate-Pro', 'All-Court'),
(13, 'The PB Guy', 7, 9, 8, 9, 'Advanced', 'Counter-Puncher'),
(16, 'PB Studio', 6, 7, 9, 10, 'Intermediate-Pro', 'Singles/Control'),
(18, 'Johnnies Reviews', 10, 10, 6, 8, 'Pro', 'Aggressive Drive'),
(19, 'PB Studio', 8, 8, 9, 10, 'Intermediate-Pro', 'All-Court'),
(21, 'The PB Guy', 7, 8, 9, 10, 'Advanced', 'Spin & Control'),
(22, 'Johnnies Reviews', 8, 8, 8, 9, 'Intermediate', 'All-Court'),
(25, 'PB Studio', 7, 7, 9, 9, 'Beginner-Pro', 'Soft Kitchen Play'),
(28, 'The PB Guy', 10, 10, 4, 7, 'Recreational', 'Pure Power'),
(29, 'Johnnies Reviews', 8, 8, 8, 9, 'Intermediate-Pro', 'All-Court');