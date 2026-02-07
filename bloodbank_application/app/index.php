<!DOCTYPE html>
<html>
<head>
    <title>BloodLife</title>
    <meta charset="utf-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>

<body class="d-flex flex-column min-vh-100">

<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <span class="navbar-brand fw-bold">🩸 BloodLife</span>
        <div>
            <a href="login.php" class="btn btn-outline-light btn-sm">Login</a>
            <a href="register.php" class="btn btn-danger btn-sm ms-2">Register</a>
        </div>
    </div>
</nav>

<main class="flex-fill d-flex justify-content-center align-items-center">
    <div class="container">
        <div class="card p-5 text-center mx-auto" style="max-width:720px;">

            <!-- UPDATED WELCOME TEXT -->
            <h1 class="fw-bold mb-3">Welcome to 🩸 BloodLife</h1>
            <p class="lead">
                BloodLife connects donors and patients securely.
                Your donation can save lives.
            </p>

            <div class="mt-4">
                <a href="register.php" class="btn btn-danger me-2">
                    Become a Donor
                </a>
                <a href="login.php" class="btn btn-outline-danger">
                    Login
                </a>
            </div>

        </div>
    </div>
</main>

<footer class="text-center py-3 text-muted">
    <small>
        For more queries contact Customer Support :
        <a href="mailto:admin@bloodlife.com">admin@bloodlife.com</a>
    </small>
</footer>

</body>
</html>
