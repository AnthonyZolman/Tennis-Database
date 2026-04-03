# Pickleball Pro-Shop Manager

A dynamic web application and inventory management system designed for a local Pickleball Pro-Shop. Built using PHP, MySQL, and HTML/CSS.

## Project Setup Instructions

### Prerequisites
- MAMP (or XAMPP) installed to run local Apache and MySQL servers.
- MySQL Workbench (or phpMyAdmin) to execute the database script.

### 1. Database Configuration
1. Open MySQL Workbench and connect to your local server.
2. Open the `pickleball_pro_shop.sql` file.
3. Run the entire script to generate the `mydb` database, build the 6 relational tables, and populate the system with sample data.

### 2. Application Setup
1. Move the project folder (`index.php` and `style.css`) into your `htdocs` directory (e.g., `C:\MAMP\htdocs\FinalProject`).
2. Open the MAMP Control Panel and click **Start Servers** (ensure both Apache and MySQL are running).
3. Check your MAMP port configurations. The `index.php` file is currently set to look for MySQL on port `3306`. If your MAMP uses a different port (like 8889), update line 4 in `index.php`.

### 3. Usage
- Open a web browser and navigate to `http://localhost/FinalProject/`.
- Use the top navigation bar to switch between Inventory, Customers, Sales Ledger, and Analytics.
- **Developer Console:** Scroll to the bottom of any page to view the exact SQL queries firing in real-time as you interact with the UI.
