<?php
session_start(); // Démarre la session pour gérer la connexion

require 'db.php';

// Vérifier si l'utilisateur est déjà connecté (s'il y a une session active)
if (isset($_SESSION['user_id'])) {
    header('Location: index.php'); // Redirige vers la page d'accueil si déjà connecté
    exit;
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Préparer la requête pour vérifier l'email
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    // Si l'utilisateur existe et que le mot de passe est correct
    if ($user && password_verify($password, $user['password'])) {
        // Stocker l'ID de l'utilisateur dans la session pour indiquer qu'il est connecté
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['username'] = $user['username']; // On peut aussi stocker le nom d'utilisateur

        // Rediriger vers la page d'accueil ou autre page après la connexion
        header('Location: index.php');
        exit;
    } else {
        // Afficher un message d'erreur si les informations sont incorrectes
        $error_message = "Invalid email or password!";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>

        <?php if (isset($error_message)): ?>
            <p style="color: red;"><?= $error_message ?></p>
        <?php endif; ?>

        <form action="login.php" method="POST">
            <label for="email">Email:</label>
            <input type="email" name="email" id="email" required>

            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required>

            <button type="submit">Login</button>
        </form>

        <p>Don't have an account? <a href="register.php">Register here</a></p>
    </div>
</body>
</html>

