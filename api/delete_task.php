<?php
require "db.php";
require_post();

$data = read_json();
$task_id = (int)($data["task_id"] ?? 0);
$user_id = (int)($data["user_id"] ?? 0);

if ($task_id <= 0) fail("Missing task_id");
if ($user_id <= 0) fail("Missing user_id");

$stmt = $pdo->prepare("DELETE FROM tasks WHERE id = ? AND user_id = ?");
$stmt->execute([$task_id, $user_id]);

ok(["success" => true]);