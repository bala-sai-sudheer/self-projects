<?php
$conn = new mysqli("db", "root", "root", "blood_app");
if ($conn->connect_error) {
    die("Database connection failed");
}
