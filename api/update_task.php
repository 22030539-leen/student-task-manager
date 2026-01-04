<?php
require "db.php";
require_post();

$data = read_json();

$task_id  = (int)($data["task_id"] ?? 0);
$user_id  = (int)($data["user_id"] ?? 0);

$title    = trim($data["title"] ?? "");
$course   = trim($data["course"] ?? "");
$due_date = trim($data["due_date"] ?? "");
$priority = trim($data["priority"] ?? "");
$is_done  = (int)($data["is_done"] ?? 0);

if ($task_id <= 0) fail("Missing task_id");
if ($user_id <= 0) fail("Missing user_id");
if ($title === "" || $course === "" || $due_date === "" || $priority === "") fail("Missing fields");

$stmt = $pdo->prepare("
    UPDATE tasks
    SET title = ?, course = ?, due_date = ?, priority = ?, is_done = ?
    WHERE id = ? AND user_id = ?
");
$stmt->execute([$title, $course, $due_date, $priority, $is_done, $task_id, $user_id]);

ok(["success" => true]);