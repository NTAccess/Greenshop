<?php
require 'db.php';
error_reporting(E_ALL);
ini_set('display_errors', 1);


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $confirm_password = $_POST['confirm_password'];

    // Vérifier que les mots de passe correspondent
    if ($password != $confirm_password) {
        echo "Passwords do not match!";
        exit;
    }

    // Hash du mot de passe
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // Vérifier si l'email existe déjà
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if ($user) {
        echo "Email already exists!";
        exit;
    }

    // Insérer l'utilisateur dans la base de données
    $stmt = $pdo->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
    $stmt->execute([$name, $email, $hashed_password]);

    echo "User registered successfully!";
    // Redirection ou autre action après l'inscription réussie

    // Redirection vers la page de connexion ou la page d'accueil
    header('Location: login.php'); // Redirige l'utilisateur vers la page de connexion
    exit; // Toujours appeler exit après header pour arrêter l'exécution du script
}
?>

