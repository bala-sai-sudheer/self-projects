<?php
session_start();

/* IMPORTANT FIX */
if (isset($_SESSION['success'])) {
    unset($_SESSION['success']);
}

include "config/db.php";

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $email = strtolower(trim($_POST['email']));
    $password = $_POST['password'];

    if (!$email || !$password) {
        $_SESSION['error'] = "Email and password required.";
        header("Location: login.php");
        exit;
    }

    $stmt = $conn->prepare("SELECT * FROM users WHERE email=?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $res = $stmt->get_result();

    if ($res->num_rows === 1) {
        $user = $res->fetch_assoc();

        if (password_verify($password, $user['password'])) {
            $_SESSION['user'] = $user;
            header("Location: dashboard.php");
            exit;
        }
    }

    $_SESSION['error'] = "Invalid email or password.";
    header("Location: login.php");
    exit;
}

$error = $_SESSION['error'] ?? '';
unset($_SESSION['error']);
?>
<!DOCTYPE html>
<html>
<head>
<title>Login | BloodLife</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="assets/style.css">
</head>
<body class="d-flex flex-column min-vh-100">

<nav class="navbar navbar-dark bg-dark">
<div class="container">
<span class="navbar-brand fw-bold">🩸 BloodLife</span>
</div>
</nav>

<main class="flex-fill d-flex justify-content-center align-items-center">
<div class="card p-4" style="max-width:420px;width:100%;">

<h4 class="text-center mb-3">Login</h4>

<?php if ($error): ?>
<div class="alert alert-danger text-center"><?= htmlspecialchars($error) ?></div>
<?php endif; ?>

<form method="post">

<input class="form-control mb-2" name="email" type="email" placeholder="Email" required>
<input class="form-control mb-3" name="password" type="password" placeholder="Password" required>

<button class="btn btn-danger w-100">Login</button>

</form>
</div>
</main>

<footer class="text-center py-3 text-muted">
<small>Customer Support :
<a href="mailto:admin@bloodlife.com">admin@bloodlife.com</a></small>
</footer>

</body>
</html>
