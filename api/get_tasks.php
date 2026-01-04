<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");

require "db.php";

$user_id = isset($_GET["user_id"]) ? intval($_GET["user_id"]) : 0;

if ($user_id <= 0) {
  echo json_encode([]);
  exit;
}

$stmt = $pdo->prepare("SELECT id, title, course, priority, due_date, is_done, created_at
                       FROM tasks
                       WHERE user_id = ?
                       ORDER BY created_at DESC");
$stmt->execute([$user_id]);

$tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);

// ALWAYS return JSON array
echo json_encode($tasks);