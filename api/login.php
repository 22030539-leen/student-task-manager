<?php
require "db.php";
require_post();

$data = read_json();
$email = trim($data["email"] ?? "");
$password = $data["password"] ?? "";

if ($email === "" || $password === "") {
    fail("Missing email or password");
}

$stmt = $pdo->prepare("SELECT id, email, password FROM users WHERE email = ?");
$stmt->execute([$email]);
$user = $stmt->fetch();

if (!$user || !password_verify($password, $user["password"])) {
    fail("Invalid login", 401);
}

ok([
    "success" => true,
    "user_id" => (int)$user["id"],
    "email"   => $user["email"]
]);