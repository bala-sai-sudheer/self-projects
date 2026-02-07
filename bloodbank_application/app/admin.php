<?php
session_start();
include "config/db.php";

if (!isset($_SESSION['user']) || $_SESSION['user']['email'] !== 'admin@bloodlife.com') {
    die("Access denied");
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $id = (int)$_POST['request_id'];

    if ($_POST['action'] === 'approve') {
        $stmt = $conn->prepare(
            "UPDATE donor_requests SET status='Approved', rejection_reason=NULL WHERE id=?"
        );
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $_SESSION['success'] = "Request approved successfully.";
    }

    if ($_POST['action'] === 'reject') {
        $reason = trim($_POST['reason']);
        $stmt = $conn->prepare(
            "UPDATE donor_requests SET status='Rejected', rejection_reason=? WHERE id=?"
        );
        $stmt->bind_param("si", $reason, $id);
        $stmt->execute();
        $_SESSION['success'] = "Request rejected successfully.";
    }

    header("Location: admin.php");
    exit;
}

$success = $_SESSION['success'] ?? '';
unset($_SESSION['success']);

$requests = $conn->query(
    "SELECT r.id,r.receipt,
            u1.name requester,
            u2.name donor
     FROM donor_requests r
     JOIN users u1 ON r.requester_id=u1.id
     JOIN users u2 ON r.donor_id=u2.id
     WHERE r.status='Pending'"
);
?>
<!DOCTYPE html>
<html>
<head>
<title>Admin | BloodLife</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="assets/style.css">
</head>

<body class="d-flex flex-column min-vh-100">

<nav class="navbar navbar-dark bg-dark">
<div class="container">
<span class="navbar-brand fw-bold">🩸 BloodLife Admin</span>
<a href="dashboard.php" class="btn btn-outline-light btn-sm">Back to Dashboard</a>
</div>
</nav>

<?php if ($success): ?>
<div class="container mt-3">
<div class="alert alert-success text-center"><?= htmlspecialchars($success) ?></div>
</div>
<?php endif; ?>

<main class="flex-fill container mt-4">
<div class="card p-4">

<h4 class="text-center mb-3">Pending Donor Requests</h4>

<table class="table table-bordered text-center align-middle">
<thead style="background:#f2f2f2;color:#000;">
<tr>
<th>Requester</th>
<th>Donor</th>
<th>Receipt</th>
<th>Action</th>
</tr>
</thead>
<tbody>

<?php while ($r = $requests->fetch_assoc()): ?>
<tr>
<td><?= htmlspecialchars($r['requester']) ?></td>
<td><?= htmlspecialchars($r['donor']) ?></td>
<td>
<a href="assets/uploads/<?= htmlspecialchars($r['receipt']) ?>" target="_blank">View</a>
</td>
<td>
<form method="post" class="d-inline">
<input type="hidden" name="request_id" value="<?= $r['id'] ?>">
<button name="action" value="approve" class="btn btn-success btn-sm">Approve</button>
</form>

<button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#rej<?= $r['id'] ?>">
Reject
</button>
</td>
</tr>

<div class="modal fade" id="rej<?= $r['id'] ?>" tabindex="-1">
<div class="modal-dialog modal-dialog-centered">
<div class="modal-content">
<form method="post">
<div class="modal-header">
<h5 class="modal-title">Reject Request</h5>
<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
</div>
<div class="modal-body">
<input type="hidden" name="request_id" value="<?= $r['id'] ?>">
<textarea name="reason" class="form-control" placeholder="Enter reason" required></textarea>
</div>
<div class="modal-footer">
<button name="action" value="reject" class="btn btn-danger">Reject</button>
<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
</div>
</form>
</div>
</div>
</div>

<?php endwhile; ?>

</tbody>
</table>

</div>
</main>

<footer class="text-center py-3 text-muted">
<small>For more queries contact Customer Support :
<a href="mailto:admin@bloodlife.com">admin@bloodlife.com</a>
</small>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

