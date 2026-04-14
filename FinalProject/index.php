<?php
// 1. CONNECTION & ERROR REPORTING
session_start();
ini_set('display_errors', 1); error_reporting(E_ALL);
$conn = new mysqli("127.0.0.1", "root", "root", "mydb", 3306);
if ($conn->connect_error) { die("Connection failed: " . $conn->connect_error); }

// Turn off safe updates so our Delete/Update queries work smoothly
$conn->query("SET SQL_SAFE_UPDATES = 0;");

// 2. PAGE LOGIC
$view = isset($_GET['view']) ? $_GET['view'] : 'inventory';
$message = isset($_GET['message']) ? htmlspecialchars($_GET['message']) : ""; 
$sql_log = isset($_SESSION['sql_log_flash']) ? $_SESSION['sql_log_flash'] : "";
unset($_SESSION['sql_log_flash']);

function append_sql_log(&$sql_log, $sql) {
    $sql_log .= ($sql_log !== "" ? "; \n\n" : "") . $sql;
}

function paddle_placeholder($label) {
    $safe_label = htmlspecialchars($label, ENT_QUOTES, 'UTF-8');
    $svg = <<<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="72" height="72" viewBox="0 0 72 72">
  <defs>
    <linearGradient id="g" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#dbeafe"/>
      <stop offset="100%" stop-color="#bfdbfe"/>
    </linearGradient>
  </defs>
  <rect width="72" height="72" rx="18" fill="url(#g)"/>
  <circle cx="36" cy="26" r="12" fill="#2563eb" opacity="0.15"/>
  <path d="M28 22c0-4.4 3.6-8 8-8h3c4.4 0 8 3.6 8 8v14c0 4.4-3.6 8-8 8h-3c-4.4 0-8-3.6-8-8V22Z" fill="#2563eb"/>
  <circle cx="38" cy="48" r="3" fill="#93c5fd"/>
  <title>{$safe_label}</title>
</svg>
SVG;

    return 'data:image/svg+xml;utf8,' . rawurlencode($svg);
}

// 3. INTERACTIVE ACTIONS (Handling POST requests)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    switch($_POST['action']) {
        case 'delete': // Req 3: Delete Query
            $id = (int)$_POST['id'];
            $sql = "DELETE FROM brands WHERE brand_id = $id";
            $conn->query($sql);
            $_SESSION['sql_log_flash'] = $sql;
            header("Location: ?view=analytics&message=" . urlencode("Brand ID #$id successfully removed from system. (Req 3)"));
            exit;
        case 'update': // Req 4: Update Query
            $id = (int)$_POST['id']; 
            $qty = (int)$_POST['qty'];
            
            if ($qty > 0) {
                $sql = "UPDATE paddles SET stock_quantity = stock_quantity + $qty WHERE paddle_id = $id";
                $conn->query($sql);
                $_SESSION['sql_log_flash'] = $sql;
                header("Location: ?view=inventory&message=" . urlencode("Stock level updated for Item #$id. (Req 4)"));
                exit;
            } else {
                header("Location: ?view=inventory&message=" . urlencode("Error: You must enter a quantity greater than zero."));
                exit;
            }
            break;
        case 'add_cust': // Req 5: Insert Query
            $f = $_POST['f']; 
            $l = $_POST['l'];
            $e = $_POST['e'];
            
            $sql = "INSERT INTO customers (first_name, last_name, email, membership_level, member_since) VALUES (?, ?, ?, 'Standard', CURDATE())";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("sss", $f, $l, $e);
            $stmt->execute();
            $_SESSION['sql_log_flash'] = sprintf(
                "INSERT INTO customers (first_name, last_name, email, membership_level, member_since) VALUES ('%s', '%s', '%s', 'Standard', CURDATE())",
                $conn->real_escape_string($f),
                $conn->real_escape_string($l),
                $conn->real_escape_string($e)
            );
            
            header("Location: ?view=customers&message=" . urlencode("New customer registered: $f $l. (Req 5)"));
            exit;
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
</head>
<body>
    <nav class="top-nav">
        <div class="brand-mark">
            <img src="Pickleball_Inc..png" alt="Pro-Shop Manager logo" class="site-logo" width="70" height="70">
        </div>
        <div class="logo">Pro-Shop <span>Manager</span></div>
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
                    <a href="?view=inventory&filter=round" class="btn-sm">Round Prices (Req 12)</a>
                    <a href="?view=inventory" class="btn-sm" style="background:#64748b;">Reset</a>
                </div>
            </div>
            
            <div class="card">
                <table>
                    <thead><tr><th>ID</th><th>Paddle</th><th>Model</th><th>Price (w/ 6% Tax)</th><th>Stock</th><th>Restock Action</th></tr></thead>
                    <tbody>
                        <?php
                        $priceSelect = "price";
                        if(isset($_GET['filter']) && $_GET['filter'] == 'round') {
                            $priceSelect = "ROUND(price * 1.06, 0) AS price";
                        }

                        $sql = "SELECT paddle_id, model_name, img_url, $priceSelect, stock_quantity FROM paddles";
                        
                        // Applying filters based on buttons clicked
                        if(isset($_GET['filter']) && $_GET['filter'] == 'low') {
                            $sql .= " WHERE stock_quantity < 10"; // Req 2: WHERE clause
                        } elseif(isset($_GET['filter']) && $_GET['filter'] == 'premium') {
                            $sql .= " WHERE price > (SELECT AVG(price) FROM paddles)"; // Req 10: Subquery
                        }
                        
                        if(isset($_GET['sort']) && $_GET['sort'] == 'price') {
                            $sql .= " ORDER BY price DESC"; // Req 1: ORDER BY
                        }
                        
                        append_sql_log($sql_log, $sql); // Save for the Developer console at the bottom
                        $res = $conn->query($sql);
                        
                        if ($res && $res->num_rows > 0) {
                            while($row = $res->fetch_assoc()): ?>
                                <tr>
                                    <td>#<?= $row['paddle_id'] ?></td>
                                    <td class="inventory-image-cell">
                                        <?php
                                        $img_src = paddle_placeholder($row['model_name']);
                                        if (!empty($row['img_url'])) {
                                            $asset_path = __DIR__ . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $row['img_url']);
                                            if (file_exists($asset_path)) {
                                                $img_src = htmlspecialchars($row['img_url'], ENT_QUOTES, 'UTF-8');
                                            }
                                        }
                                        ?>
                                        <img src="<?= $img_src ?>" alt="<?= htmlspecialchars($row['model_name']) ?>" class="inventory-thumb" width="56" height="56">
                                    </td>
                                    <td><?= $row['model_name'] ?></td>
                                    <td>
                                        <?php if(isset($_GET['filter']) && $_GET['filter'] == 'round'): ?>
                                            $<?= number_format($row['price'], 0) ?> <span style="font-size:10px; color:gray;">(Req 12)</span>
                                        <?php else: ?>
                                            $<?= number_format(round($row['price'] * 1.06, 2), 2) ?> <span style="font-size:10px; color:gray;"></span>
                                        <?php endif; ?>
                                    </td>
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
                // Req 11: String Function (CONCAT and UPPER)
                $sql = "SELECT CONCAT(UPPER(last_name), ', ', first_name) AS full_name, email FROM customers"; 
                append_sql_log($sql_log, $sql);
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
                <div class="filter-bar" style="display: flex; align-items: center; gap: 10px;">
                    <form method="GET" style="margin: 0; display: inline-block;">
                        <input type="hidden" name="view" value="sales">
                        <select name="month" onchange="this.form.submit()" style="padding: 8px; border-radius: 8px; border: 1px solid #cbd5e1; outline: none;">
                            <option value="">Filter by Month (Req 13)</option>
                            <option value="1" <?= (isset($_GET['month']) && $_GET['month'] == '1') ? 'selected' : '' ?>>January</option>
                            <option value="2" <?= (isset($_GET['month']) && $_GET['month'] == '2') ? 'selected' : '' ?>>February</option>
                            <option value="3" <?= (isset($_GET['month']) && $_GET['month'] == '3') ? 'selected' : '' ?>>March</option>
                            <option value="4" <?= (isset($_GET['month']) && $_GET['month'] == '4') ? 'selected' : '' ?>>April</option>
                            <option value="5" <?= (isset($_GET['month']) && $_GET['month'] == '5') ? 'selected' : '' ?>>May</option>
                            <option value="6" <?= (isset($_GET['month']) && $_GET['month'] == '6') ? 'selected' : '' ?>>June</option>
                            <option value="7" <?= (isset($_GET['month']) && $_GET['month'] == '7') ? 'selected' : '' ?>>July</option>
                            <option value="8" <?= (isset($_GET['month']) && $_GET['month'] == '8') ? 'selected' : '' ?>>August</option>
                            <option value="9" <?= (isset($_GET['month']) && $_GET['month'] == '9') ? 'selected' : '' ?>>September</option>
                            <option value="10" <?= (isset($_GET['month']) && $_GET['month'] == '10') ? 'selected' : '' ?>>October</option>
                            <option value="11" <?= (isset($_GET['month']) && $_GET['month'] == '11') ? 'selected' : '' ?>>November</option>
                            <option value="12" <?= (isset($_GET['month']) && $_GET['month'] == '12') ? 'selected' : '' ?>>December</option>
                        </select>
                    </form>
                    <a href="?view=sales<?= isset($_GET['month']) && $_GET['month'] != '' ? '&month=' . $_GET['month'] : '' ?>&sort=tier" class="btn-sm" style="background:#8b5cf6;">Sort by Tier (Req 14)</a>
                    <a href="?view=sales" class="btn-sm" style="background:#64748b;">Clear Filter</a>
                </div>
            </div>
            <div class="card">
                <?php 
                // Req 6: Inner Join (Joining sales, customers, and paddles)
                // Req 14: CASE Function (Assigning VIP or Standard Tier)
                $sql = "SELECT c.first_name, b.brand_name, p.model_name, s.total_amount, 
                        CASE WHEN s.total_amount > 200 THEN 'VIP Tier' ELSE 'Standard Tier' END as Tier 
                        FROM sales s 
                        JOIN customers c ON s.customer_id = c.customer_id 
                        JOIN paddles p ON s.paddle_id = p.paddle_id
                        JOIN brands b ON p.brand_id = b.brand_id"; // Added this JOIN to get brand names
                
                if(isset($_GET['month']) && $_GET['month'] != '') {
                    // Req 13: Date Function (MONTH)
                    $m = (int)$_GET['month']; 
                    $sql .= " WHERE MONTH(s.sale_date) = $m"; 
                }

                if(isset($_GET['sort']) && $_GET['sort'] == 'tier') {
                    $sql .= " ORDER BY Tier DESC";
                }
                append_sql_log($sql_log, $sql);
                ?>
                <table>
                    <thead><tr><th>Customer Name</th><th>Brand</th><th>Product Purchased (Req 6)</th><th>Total Amount</th><th>Transaction Tier (Req 14)</th></tr></thead>
                    <?php $res = $conn->query($sql); while($row = $res->fetch_assoc()): ?>
                        <tr>
                            <td><?= $row['first_name'] ?></td>
                            <td><?= $row['brand_name'] ?></td>
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
                    append_sql_log($sql_log, $sql1);
                    ?>
                    <h1 style="color: #1e3a8a; font-size: 2.5rem; margin: 10px 0;">$<?= number_format($r['total'], 2) ?></h1>
                </div>

                <div class="card" style="flex:1;">
                    <h3>VIP Customers (Req 9 - Spent over $200)</h3>
                    <?php 
                    $sql2 = "SELECT customer_id, SUM(total_amount) as total_spent FROM sales GROUP BY customer_id HAVING SUM(total_amount) > 200"; 
                    append_sql_log($sql_log, $sql2);
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
                append_sql_log($sql_log, $sql3);
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
            <strong>Active Query Log (Screenshot this for your report):</strong><br>
            <code><?= htmlspecialchars($sql_log) ?></code>
        </div>
    </div>
</body>
</html>
