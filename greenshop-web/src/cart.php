<?php
session_start();
require 'db.php';
require 'header.php';

$cart = $_SESSION['cart'] ?? [];

if (empty($cart)) {
    echo "<p>Your cart is empty.</p>";
    require 'footer.php';
    exit;
}

$placeholders = implode(',', array_fill(0, count($cart), '?'));
$stmt = $pdo->prepare("SELECT * FROM products WHERE id IN ($placeholders)");
$stmt->execute(array_keys($cart));
$products = $stmt->fetchAll(PDO::FETCH_ASSOC);

$total = 0;
?>

<h2>Your Cart</h2>

<ul>
<?php foreach ($products as $product): 
    $qty = $cart[$product['id']];
    $subtotal = $qty * $product['price'];
    $total += $subtotal;
?>
    <li>
        <?= htmlspecialchars($product['name']) ?> (<?= $qty ?> × <?= number_format($product['price'], 2) ?> €)
        = <strong><?= number_format($subtotal, 2) ?> €</strong>
    </li>
<?php endforeach; ?>
</ul>

<p><strong>Total: <?= number_format($total, 2) ?> €</strong></p>

<?php require 'footer.php'; ?>

