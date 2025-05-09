<?php
require 'db.php';
require 'header.php';

$stmt = $pdo->query("SELECT * FROM products");
$products = $stmt->fetchAll();
?>

<h2>Our Fresh Products</h2>

<?php foreach ($products as $product): ?>
    <div class="product">
        <!-- Affichage du nom du produit -->
        <h3><a href="product.php?id=<?= $product['id'] ?>"><?= htmlspecialchars($product['name']) ?></a></h3>

        <!-- Affichage de la description du produit -->
        <p><?= htmlspecialchars($product['description']) ?></p>

        <!-- Affichage du prix -->
        <p><strong><?= number_format($product['price'], 2) ?> €</strong></p>

        <!-- Affichage de l'image du produit -->
        <img src="uploads/<?= $product['image'] ? $product['image'] : 'default_product_image.jpg' ?>" 
             alt="<?= htmlspecialchars($product['name']) ?>" width="200">

        <!-- Formulaire d'ajout au panier -->
        <form action="add_to_cart.php" method="post">
            <input type="hidden" name="product_id" value="<?= $product['id'] ?>">
            <button type="submit">Add to Cart</button>
        </form>
    </div>
<?php endforeach; ?>

<?php require 'footer.php'; ?>

