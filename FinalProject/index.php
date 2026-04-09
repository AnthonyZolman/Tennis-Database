<?php
// 1. CONNECTION & ERROR REPORTING
ini_set('display_errors', 1); 
error_reporting(E_ALL);

// Ensure these match your actual credentials
$conn = new mysqli("127.0.0.1", "root", "root", "mydb", 3306);
if ($conn->connect_error) { 
    die("Connection failed: " . $conn->connect_error); 
}

// Turn off safe updates for internal management tasks
$conn->query("SET SQL_SAFE_UPDATES = 0;");

// 2. PAGE LOGIC
$view = isset($_GET['view']) ? $_GET['view'] : 'inventory';
$message = ""; 
$sql_log = "";

// 3. INTERACTIVE ACTIONS (Handling POST requests)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    switch($_POST['action']) {
        case 'delete':
            $id = (int)$_POST['id'];
            $conn->query("DELETE FROM brands WHERE brand_id = $id");
            $message = "Brand ID #$id successfully removed from system. (Req 3)";
            break;
        case 'update':
            $id = (int)$_POST['id']; 
            $qty = (int)$_POST['qty'];
            $conn->query("UPDATE paddles SET stock_quantity = stock_quantity + $qty WHERE paddle_id = $id");
            $message = "Stock level updated for Item #$id. (Req 4)"; // THERE IS SOMETHING WRONG HERE!!!!
            break;
        case 'add_cust':
            $f = $conn->real_escape_string($_POST['f']); 
            $l = $conn->real_escape_string($_POST['l']);
            $e = $conn->real_escape_string($_POST['e']);
            $conn->query("INSERT INTO customers (first_name, last_name, email, membership_level, member_since) VALUES ('$f', '$l', '$e', 'Standard', CURDATE())");
            $message = "New customer registered: $f $l. (Req 5)";
            break;
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pickleball Pro-Shop | Management Console</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* Small addition for image alignment */
        .img-preview {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
            background-color: #f8fafc;
        }
        table td { vertical-align: middle; }
    </style>
</head>
<body>
    <nav class="top-nav">
        <div class="logo">🏓 Pickleball Pro-Shop <span>Manager</span></div>
        <div class="nav-links">
            <a href="?view=inventory" class="<?= $view=='inventory'?'active':'' ?>">Inventory</a>
            <a href="?view=customers" class="<?= $view=='customers'?'active':'' ?>">Customers</a>
            <a href="?view=sales" class="<?= $view=='sales'?'active':'' ?>">Sales Ledger</a>
            <a href="?view=analytics" class="<?= $view=='analytics'?'active':'' ?>">Analytics</a>
        </div>
    </nav>

    <div class="main-wrapper">
        <?php if($message): ?><div class="alert success"><?= $message ?></div><?php endif; ?>

        <?php if($view == 'inventory'): ?>
            <div class="section-header">
                <h2>Product Inventory</h2>
                <div class="filter-bar">
                    <a href="?view=inventory&sort=price" class="btn-sm">Sort Premium (Req 1)</a>
                    <a href="?view=inventory&filter=low" class="btn-sm warn">Low Stock (Req 2)</a>
                    <a href="?view=inventory&filter=premium" class="btn-sm" style="background:#8b5cf6;">Above Avg Price (Req 10)</a>
                    <a href="?view=inventory" class="btn-sm" style="background:#64748b;">Reset</a>
                </div>
            </div>
            
            <div class="card">
                <table>
                    <thead>
                        <tr>
                            <th>Preview</th>
                            <th>ID</th>
                            <th>Model</th>
                            <th>Price (w/ 6% Tax)</th>
                            <th>Stock</th>
                            <th>Restock Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        // UPDATED: Added img_url to the SELECT statement
                        $sql = "SELECT paddle_id, model_name, price, stock_quantity, img_url FROM paddles";
                        
                        if(isset($_GET['filter']) && $_GET['filter'] == 'low') {
                            $sql .= " WHERE stock_quantity < 10"; 
                        } elseif(isset($_GET['filter']) && $_GET['filter'] == 'premium') {
                            $sql .= " WHERE price > (SELECT AVG(price) FROM paddles)"; 
                        }
                        
                        if(isset($_GET['sort']) && $_GET['sort'] == 'price') {
                            $sql .= " ORDER BY price DESC"; 
                        }
                        
                        $sql_log = $sql; 
                        $res = $conn->query($sql);
                        
                        if ($res && $res->num_rows > 0) {
                            while($row = $res->fetch_assoc()): ?>
                                <tr>
                                    <td>
                                        <img src="<?= htmlspecialchars($row['img_url']) ?>" 
                                             alt="Paddle Image" 
                                             class="img-preview"
                                             onerror="this.src='https://placehold.co/60x60?text=No+Img'">
                                    </td>
                                    <td>#<?= $row['paddle_id'] ?></td>
                                    <td><?= $row['model_name'] ?></td>
                                    <td>$<?= number_format(round($row['price'] * 1.06, 2), 2) ?></td>
                                    <td><?= $row['stock_quantity'] ?></td>
                                    <td>
                                        <form method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="id" value="<?= $row['paddle_id'] ?>">
                                            <input type="number" name="qty" placeholder="+Qty" style="width:60px" required>
                                            <button type="submit" class="btn-sm">Add (Req 4)</button>
                                        </form>
                                    </td>
                                </tr>
                            <?php endwhile; 
                        } else { echo "<tr><td colspan='6'>No products match this filter.</td></tr>"; } ?>
                    </tbody>
                </table>
            </div>

        <?php elseif($view == 'customers'): ?>
            <div class="section-header"><h2>Customer Registry</h2></div>
            <div class="card">
                <form method="POST" class="input-form">
                    <input type="hidden" name="action" value="add_cust">
                    <input type="text" name="f" placeholder="First Name" required>
                    <input type="text" name="l" placeholder="Last Name" required>
                    <input type="email" name="e" placeholder="Email" required>
                    <button type="submit">Add New Customer (Req 5)</button>
                </form>
                <hr style="margin: 20px 0; border: 0; border-top: 1px solid #eee;">
                <?php 
                $sql = "SELECT CONCAT(UPPER(last_name), ', ', first_name) AS full_name, email FROM customers"; 
                $sql_log = $sql;
                ?>
                <table>
                    <thead><tr><th>Formatted Directory Name (Req 11)</th><th>Email Account</th></tr></thead>
                    <?php $res = $conn->query($sql); while($row = $res->fetch_assoc()): ?>
                        <tr><td><strong><?= $row['full_name'] ?></strong></td><td><?= $row['email'] ?></td></tr>
                    <?php endwhile; ?>
                </table>
            </div>

        <?php elseif($view == 'sales'): ?>
            <div class="section-header">
                <h2>Sales Ledger</h2>
                <a href="?view=sales&month=3" class="btn-sm">March Sales Only (Req 13)</a>
                <a href="?view=sales" class="btn-sm" style="background:#64748b;">Clear Filter</a>
            </div>
            
            <div class="card">
                <?php 
                $sql = "SELECT c.first_name, p.model_name, s.total_amount, 
                        CASE WHEN s.total_amount > 200 THEN 'VIP Tier' ELSE 'Standard Tier' END as Tier 
                        FROM sales s 
                        JOIN customers c ON s.customer_id = c.customer_id 
                        JOIN paddles p ON s.paddle_id = p.paddle_id"; 
                if(isset($_GET['month'])) { $sql .= " WHERE MONTH(s.sale_date) = 3"; }
                $sql_log = $sql;
                ?>
                <table>
                    <thead><tr><th>Customer</th><th>Product</th><th>Amount</th><th>Tier</th></tr></thead>
                    <?php $res = $conn->query($sql); while($row = $res->fetch_assoc()): ?>
                        <tr>
                            <td><?= $row['first_name'] ?></td>
                            <td><?= $row['model_name'] ?></td>
                            <td>$<?= number_format($row['total_amount'], 2) ?></td>
                            <td><span class="badge <?= substr($row['Tier'], 0, 3) ?>"><?= $row['Tier'] ?></span></td>
                        </tr>
                    <?php endwhile; ?>
                </table>
            </div>

        <?php elseif($view == 'analytics'): ?>
            <div class="section-header"><h2>Business Analytics</h2></div>
                <div style="display:flex; gap:20px; flex-wrap:wrap;">
                <div class="card" style="flex:1; background: #eff6ff; border-left: 5px solid #2563eb;">
                    <h3>Total Gross Revenue (Req 8)</h3>
                    <?php 
                    $sql1 = "SELECT SUM(total_amount) as total FROM sales"; 
                    $r = $conn->query($sql1)->fetch_assoc(); 
                    $sql_log .= $sql1 . "; \n\n";
                    ?>
                    <h1 style="color: #1e3a8a; font-size: 2.5rem; margin: 10px 0;">$<?= number_format($r['total'], 2) ?></h1>
                </div>

                <div class="card" style="flex:1;">
                    <h3>VIP Customers (Req 9 - Spent over $200)</h3>
                    <?php 
                    $sql2 = "SELECT customer_id, SUM(total_amount) as total_spent FROM sales GROUP BY customer_id HAVING SUM(total_amount) > 200"; 
                    $sql_log .= $sql2 . "; \n\n";
                    ?>
                    <table>
                        <thead><tr><th>Customer ID</th><th>Total Lifetime Spend</th></tr></thead>
                        <?php $res = $conn->query($sql2); while($row = $res->fetch_assoc()): ?>
                            <tr><td>Customer #<?= $row['customer_id'] ?></td><td>$<?= number_format($row['total_spent'], 2) ?></td></tr>
                        <?php endwhile; ?>
                    </table>
                </div>
            </div>

            <div class="card">
                <h3>Dead Stock Report (Req 7 - Zero Sales)</h3>
                <?php 
                $sql3 = "SELECT p.model_name FROM paddles p LEFT JOIN sales s ON p.paddle_id = s.paddle_id WHERE s.sale_id IS NULL"; 
                $sql_log .= $sql3 . "; \n\n";
                ?>
                <ul>
                    <?php 
                    $res = $conn->query($sql3); 
                    if($res->num_rows > 0) {
                        while($row = $res->fetch_assoc()) echo "<li>" . $row['model_name'] . "</li>"; 
                    } else { echo "<li>No dead stock found.</li>"; }
                    ?>
                </ul>
            </div>

            <div class="card" style="border: 1px solid #fecaca;">
                <h3 style="color: #dc2626;">System Maintenance</h3>
                <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 15px;">Remove a manufacturer from the database completely.</p>
                <form method="POST" class="input-form">
                    <input type="hidden" name="action" value="delete">
                    <input type="number" name="id" placeholder="Brand ID (e.g., 11)" required>
                    <button type="submit" class="btn-delete">Execute Delete (Req 3)</button>
                </form>
            </div>

        <?php endif; ?>
             

        <div class="dev-console">
            <strong>Active Query Log:</strong><br>
            <code><?= htmlspecialchars($sql_log) ?></code>
        </div>
    </div>
</body>
</html>