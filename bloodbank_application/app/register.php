<?php
session_start();
include "config/db.php";

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $name  = trim($_POST['name']);
    $email = strtolower(trim($_POST['email']));
    $phone = trim($_POST['phone']);
    $blood = trim($_POST['blood']);
    $city  = trim($_POST['city']);
    $password = $_POST['password'];

    if (!$name || !$email || !$phone || !$blood || !$city || !$password) {
        $_SESSION['error'] = "All fields are mandatory.";
        header("Location: register.php");
        exit;
    }

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $_SESSION['error'] = "Invalid email format.";
        header("Location: register.php");
        exit;
    }

    if (!preg_match('/^[6-9][0-9]{9}$/', $phone)) {
        $_SESSION['error'] = "Enter valid 10-digit Indian mobile number.";
        header("Location: register.php");
        exit;
    }

    $check = $conn->prepare("SELECT id FROM users WHERE email=?");
    $check->bind_param("s", $email);
    $check->execute();
    $check->store_result();

    if ($check->num_rows > 0) {
        $_SESSION['error'] = "Email already exists.";
        header("Location: register.php");
        exit;
    }

    $hash = password_hash($password, PASSWORD_DEFAULT);

    $stmt = $conn->prepare(
        "INSERT INTO users (name,email,phone,password,blood_group,city)
         VALUES (?,?,?,?,?,?)"
    );
    $stmt->bind_param("ssssss",
        $name, $email, $phone, $hash, $blood, $city
    );

    if ($stmt->execute()) {
        $_SESSION['success'] = "Account created successfully. Please login.";
        header("Location: login.php");
        exit;
    }

    $_SESSION['error'] = "Registration failed.";
    header("Location: register.php");
    exit;
}

$error = $_SESSION['error'] ?? '';
unset($_SESSION['error']);
?>
<!DOCTYPE html>
<html>
<head>
<title>Register | BloodLife</title>
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

<h4 class="text-center mb-3">Create Account</h4>

<?php if ($error): ?>
<div class="alert alert-danger text-center"><?= htmlspecialchars($error) ?></div>
<?php endif; ?>

<form method="post">

<input class="form-control mb-2" name="name" placeholder="Full Name" required>
<input class="form-control mb-2" name="email" type="email" placeholder="Email" required>

<div class="input-group mb-2">
<span class="input-group-text">🇮🇳 +91</span>
<input class="form-control" name="phone" pattern="[6-9][0-9]{9}" maxlength="10" required>
</div>

<select class="form-select mb-2" name="blood" required>
<option value="">Select Blood Group</option>
<option>O-</option><option>O+</option>
<option>A-</option><option>A+</option>
<option>B-</option><option>B+</option>
<option>AB-</option><option>AB+</option>
</select>

<input class="form-control mb-2" name="city" placeholder="City" required>
<input class="form-control mb-3" name="password" type="password" placeholder="Password" required>

<button class="btn btn-danger w-100">Register</button>

</form>
</div>
</main>

<footer class="text-center py-3 text-muted">
<small>Customer Support :
<a href="mailto:admin@bloodlife.com">admin@bloodlife.com</a></small>
</footer>

</body>
</html>
