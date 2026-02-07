<?php
session_start();
include "config/db.php";

if (!isset($_SESSION['user'])) {
    $_SESSION['error'] = "Please login again.";
    header("Location: login.php");
    exit;
}

if (
    !isset($_POST['donor_id']) ||
    !isset($_FILES['receipt']) ||
    $_FILES['receipt']['error'] !== 0
) {
    $_SESSION['error'] = "Please upload a valid hospital receipt.";
    header("Location: dashboard.php");
    exit;
}

$userId  = $_SESSION['user']['id'];
$donorId = (int) $_POST['donor_id'];

$uploadDir = __DIR__ . "/assets/uploads/";
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0755, true);
}

$original = basename($_FILES['receipt']['name']);
$clean = preg_replace("/[^a-zA-Z0-9\._-]/", "_", $original);
$filename = time() . "_" . $clean;

if (!move_uploaded_file($_FILES['receipt']['tmp_name'], $uploadDir . $filename)) {
    $_SESSION['error'] = "Receipt upload failed.";
    header("Location: dashboard.php");
    exit;
}

$stmt = $conn->prepare(
    "INSERT INTO donor_requests (requester_id, donor_id, receipt)
     VALUES (?, ?, ?)"
);
$stmt->bind_param("iis", $userId, $donorId, $filename);

if ($stmt->execute()) {
    $_SESSION['success'] =
        "Request sent successfully. Support team will verify and contact you.";
} else {
    $_SESSION['error'] = "Failed to submit request.";
}

header("Location: dashboard.php");
exit;
