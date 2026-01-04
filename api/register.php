<?php
require "db.php";
require_post();

$data = read_json();
$email = trim($data["email"] ?? "");
$password = $data["password"] ?? "";

if ($email === "" || $password === "") {
    fail("Missing email or password");
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    fail("Invalid email");
}

$hash = password_hash($password, PASSWORD_DEFAULT);

try {
    $stmt = $pdo->prepare("INSERT INTO users (email, password) VALUES (?, ?)");
    $stmt->execute([$email, $hash]);
    ok(["success" => true]);
} catch (Exception $e) {
    fail("Email already exists", 409);
}