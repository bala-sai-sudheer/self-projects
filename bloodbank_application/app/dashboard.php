<?php
session_start();
include "config/db.php";

if (!isset($_SESSION['user'])) {
    header("Location: login.php");
    exit;
}

$user   = $_SESSION['user'];
$userId = $user['id'];
$isAdmin = ($user['email'] === 'admin@bloodlife.com');

/* Mask phone for search results */
function maskPhone($phone) {
    if (!$phone) return '';
    return str_repeat('X', strlen($phone) - 2) . substr($phone, -2);
}

/* Flash messages */
$success = $_SESSION['success'] ?? '';
$error   = $_SESSION['error'] ?? '';
unset($_SESSION['success'], $_SESSION['error']);

/* Admin pending requests count */
$pendingCount = 0;
if ($isAdmin) {
    $res = $conn->query(
        "SELECT COUNT(*) AS total
         FROM donor_requests
         WHERE status='Pending'"
    );
    $pendingCount = $res->fetch_assoc()['total'];
}

/* Handle search */
$results = null;
$searched = false;
$searchBlood = '';

if (isset($_GET['blood'])) {
    $searched = true;
    $searchBlood = $_GET['blood'];
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['blood'])) {
    $searched = true;
    $searchBlood = $_POST['blood'];
}

if ($searched) {
    $stmt = $conn->prepare(
    "SELECT id, name, blood_group, phone
     FROM users
     WHERE blood_group = ?
       AND id != ?
       AND email != 'admin@bloodlife.com'"
    );
    $stmt->bind_param("si", $searchBlood, $userId);
    $stmt->execute();
    $results = $stmt->get_result();
}

/* Fetch logged-in user's requests */
$reqStmt = $conn->prepare(
    "SELECT
        r.id,
        r.status,
        r.rejection_reason,
        u.id AS donor_id,
        u.name AS donor_name,
        u.email AS donor_email,
        u.phone AS donor_phone,
        u.city AS donor_city,
        u.blood_group
     FROM donor_requests r
     JOIN users u ON r.donor_id = u.id
     WHERE r.requester_id = ?
     ORDER BY r.created_at DESC"
);
$reqStmt->bind_param("i", $userId);
$reqStmt->execute();
$reqResult = $reqStmt->get_result();

/* Map donor_id → latest request */
$requestedDonors = [];
foreach ($reqResult->fetch_all(MYSQLI_ASSOC) as $row) {
    $requestedDonors[$row['donor_id']] = $row;
}
$reqResult->data_seek(0);
?>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard | BloodLife</title>
    <meta charset="utf-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/style.css">
</head>

<body class="d-flex flex-column min-vh-100">

<nav class="navbar navbar-dark bg-dark">
<div class="container">
    <span class="navbar-brand fw-bold">🩸 BloodLife</span>
    <div class="dropdown">
        <button class="btn btn-outline-light btn-sm dropdown-toggle" data-bs-toggle="dropdown">
            Profile
        </button>
        <ul class="dropdown-menu dropdown-menu-end">
            <li><a class="dropdown-item" href="profile.php">Update Profile</a></li>
            <li><a class="dropdown-item text-danger" href="logout.php">Logout</a></li>
        </ul>
    </div>
</div>
</nav>

<?php if ($success): ?>
<div class="container mt-3">
    <div class="alert alert-success text-center"><?= htmlspecialchars($success) ?></div>
</div>
<?php endif; ?>

<?php if ($error): ?>
<div class="container mt-3">
    <div class="alert alert-danger text-center"><?= htmlspecialchars($error) ?></div>
</div>
<?php endif; ?>

<main class="flex-fill container mt-4">

<?php if ($isAdmin): ?>
<div class="card p-3 mb-4 border-danger text-center">
    <h5 class="text-danger">
        Administration
        <?php if ($pendingCount > 0): ?>
            <span class="badge bg-danger"><?= $pendingCount ?></span>
        <?php endif; ?>
    </h5>
    <a href="admin.php" class="btn btn-danger btn-sm">Go to Admin Panel</a>
</div>
<?php endif; ?>

<div class="row">

<!-- LEFT -->
<div class="col-md-8">

<div class="card p-4 mb-4">
<h4 class="text-center mb-3">Find Blood Donor</h4>

<form method="post" class="row justify-content-center g-3">
<div class="col-md-6">
<select name="blood" class="form-select" required>
<option value="">Select Blood Group</option>
<?php
$groups = ['O-','O+','A-','A+','B-','B+','AB-','AB+'];
foreach ($groups as $g) {
    $sel = ($searchBlood === $g) ? 'selected' : '';
    echo "<option $sel>$g</option>";
}
?>
</select>
</div>
<div class="col-md-3">
<button class="btn btn-danger w-100">Search</button>
</div>
</form>
</div>

<?php if ($searched): ?>
<?php if ($results && $results->num_rows > 0): ?>
<div class="card p-4">
<table class="table table-bordered text-center align-middle">
<thead style="background:#f2f2f2;color:#000;">
<tr>
<th>Name</th>
<th>Blood</th>
<th>Phone</th>
<th>Action</th>
</tr>
</thead>
<tbody>

<?php while ($r = $results->fetch_assoc()): ?>
<tr>
<td><?= htmlspecialchars($r['name']) ?></td>
<td><?= htmlspecialchars($r['blood_group']) ?></td>
<td><?= maskPhone($r['phone']) ?></td>
<td>
<?php
$req = $requestedDonors[$r['id']] ?? null;
?>
<?php if ($req && $req['status'] === 'Pending'): ?>
    <button class="btn btn-secondary btn-sm" disabled>Request Pending</button>
<?php else: ?>
    <form action="request.php" method="post" enctype="multipart/form-data" class="d-flex flex-column gap-2">
        <input type="hidden" name="donor_id" value="<?= $r['id'] ?>">
        <input type="file" name="receipt" class="form-control form-control-sm" required>
        <button class="btn btn-danger btn-sm">Request Contact</button>
    </form>
<?php endif; ?>
</td>
</tr>
<?php endwhile; ?>

</tbody>
</table>
</div>
<?php else: ?>
<div class="card p-4 text-center">
<div class="alert alert-warning mb-0">No data found for the selected blood group.</div>
</div>
<?php endif; ?>
<?php endif; ?>

</div>

<!-- RIGHT -->
<div class="col-md-4">
<div class="card p-3">
<h5 class="text-center mb-3">Your Requests</h5>

<div style="max-height:420px; overflow-y:auto;">
<?php if (count($requestedDonors) === 0): ?>
<div class="alert alert-info text-center mb-0">You have not made any requests yet.</div>
<?php else: ?>
<ul class="list-group list-group-flush">

<?php foreach ($requestedDonors as $req): ?>
<li class="list-group-item">
<strong><?= htmlspecialchars($req['donor_name'] ?? '') ?></strong><br>
Blood: <?= htmlspecialchars($req['blood_group'] ?? '') ?><br>
Status:
<span class="fw-bold text-<?=
$req['status']=='Approved'?'success':
($req['status']=='Rejected'?'danger':'warning') ?>">
<?= htmlspecialchars($req['status']) ?>
</span>

<?php if ($req['status'] === 'Approved'): ?>
<div class="mt-2">
<button class="btn btn-success btn-sm" data-bs-toggle="modal"
        data-bs-target="#approved<?= $req['id'] ?>">
View Contact
</button>
</div>
<?php elseif ($req['status'] === 'Rejected'): ?>
<div class="text-danger mt-2">
Reason: <?= htmlspecialchars($req['rejection_reason'] ?? '') ?>
</div>
<a href="dashboard.php?blood=<?= urlencode($req['blood_group']) ?>"
   class="btn btn-outline-danger btn-sm mt-2">
Request Again
</a>
<?php endif; ?>
</li>

<?php if ($req['status'] === 'Approved'): ?>
<div class="modal fade" id="approved<?= $req['id'] ?>" tabindex="-1">
<div class="modal-dialog modal-dialog-centered">
<div class="modal-content">
<div class="modal-header">
<h5 class="modal-title">Donor Contact Details</h5>
<button class="btn-close" data-bs-dismiss="modal"></button>
</div>
<div class="modal-body">
<p><strong>Name:</strong> <?= htmlspecialchars($req['donor_name'] ?? '') ?></p>
<p><strong>Email:</strong> <?= htmlspecialchars($req['donor_email'] ?? 'Not provided') ?></p>
<p><strong>Phone:</strong> <?= htmlspecialchars($req['donor_phone'] ?? 'Not provided') ?></p>
<p><strong>City:</strong> <?= htmlspecialchars($req['donor_city'] ?? 'Not provided') ?></p>
</div>
</div>
</div>
</div>
<?php endif; ?>

<?php endforeach; ?>

</ul>
<?php endif; ?>
</div>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
