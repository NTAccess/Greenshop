<?php
require 'db.php';
require 'header.php';

$id = isset($_GET['id']) ? (int) $_GET['id'] : 0;

$stmt = $pdo->prepare("SELECT * FROM products WHERE id = ?");
$stmt->execute([$id]);
$product = $stmt->fetch();

if (!$product) {
    echo "<p>Product not found.</p>";
    require 'footer.php';
    exit;
}
?>

<h2><?= htmlspecialchars($product['name']) ?></h2>
<p><?= htmlspecialchars($product['description']) ?></p>
<p><strong><?= number_format($product['price'], 2) ?> €</strong></p>

<form action="add_to_cart.php" method="post">
    <input type="hidden" name="product_id" value="<?= $product['id'] ?>">
    <button type="submit">Add to Cart</button>
</form>

<?php require 'footer.php'; ?>

