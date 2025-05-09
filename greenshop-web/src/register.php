<?php
// register.php
require 'header.php';
?>

<div class="register-container">
    <h2>Create Your Account</h2>
    <form action="register_action.php" method="post" class="register-form">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" name="username" id="username" required placeholder="Enter your username">
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" name="email" id="email" required placeholder="Enter your email">
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" name="password" id="password" required placeholder="Enter your password">
        </div>

        <div class="form-group">
            <label for="confirm_password">Confirm Password</label>
            <input type="password" name="confirm_password" id="confirm_password" required placeholder="Confirm your password">
        </div>

        <button type="submit" class="btn-submit">Register</button>
    </form>

    <p class="login-link">Already have an account? <a href="login.php">Login here</a></p>
</div>

<?php
require 'footer.php';
?>

