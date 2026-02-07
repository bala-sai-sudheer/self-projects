<?php
session_start();
include "config/db.php";

if (!isset($_SESSION['user'])) {
    header("Location: login.php");
    exit;
}

$user = $_SESSION['user'];
$success = $error = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $name  = trim($_POST['name']);
    $phone = $_POST['phone'] ?? '';
    $city  = trim($_POST['city']);
    $id    = $user['id'];

    if (!empty($_POST['password'])) {
        $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
        $stmt = $conn->prepare(
            "UPDATE users SET name=?, phone=?, city=?, password=? WHERE id=?"
        );
        $stmt->bind_param("ssssi", $name, $phone, $city, $password, $id);
    } else {
        $stmt = $conn->prepare(
            "UPDATE users SET name=?, phone=?, city=? WHERE id=?"
        );
        $stmt->bind_param("sssi", $name, $phone, $city, $id);
    }

    if ($stmt->execute()) {
        $res = $conn->query("SELECT * FROM users WHERE id=$id");
        $_SESSION['user'] = $res->fetch_assoc();
        $user = $_SESSION['user'];
        $success = "Profile updated successfully.";
    } else {
        $error = "Update failed.";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
<title>Update Profile</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="assets/style.css">
</head>
<body class="d-flex flex-column min-vh-100">

<nav class="navbar navbar-dark bg-dark">
<div class="container">
<span class="navbar-brand fw-bold">🩸 BloodLife</span>
<a href="dashboard.php" class="btn btn-outline-light btn-sm">← Back to Dashboard</a>
</div>
</nav>

<main class="flex-fill d-flex justify-content-center align-items-center">
<div class="card p-4" style="width:450px">

<h4 class="text-center mb-3">Update Profile</h4>

<?php if ($success): ?><div class="alert alert-success"><?= $success ?></div><?php endif; ?>
<?php if ($error): ?><div class="alert alert-danger"><?= $error ?></div><?php endif; ?>

<form method="post">
<input class="form-control mb-2" name="name" value="<?= $user['name'] ?>" required>
<input class="form-control mb-2" value="<?= $user['email'] ?>" disabled>
<input class="form-control mb-2" value="<?= $user['blood_group'] ?>" disabled>
<input class="form-control mb-2" name="phone" value="<?= $user['phone'] ?? '' ?>" placeholder="Phone">
<input class="form-control mb-2" name="city" value="<?= $user['city'] ?>">
<input class="form-control mb-3" name="password" type="password" placeholder="New Password (optional)">
<button class="btn btn-danger w-100">Update</button>
</form>

</div>
</main>

<footer class="text-center py-3 text-muted">
<small>For more queries contact Customer Support :
<a href="mailto:admin@bloodlife.com">admin@bloodlife.com</a>
</small>
</footer>

</body>
</html>
