<?php
require "db.php";
require_post();

$data = read_json();

$user_id  = (int)($data["user_id"] ?? 0);
$title    = trim($data["title"] ?? "");
$course   = trim($data["course"] ?? "");
$due_date = trim($data["due_date"] ?? "");
$priority = trim($data["priority"] ?? "");

if ($user_id <= 0) fail("Missing user_id");
if ($title === "" || $course === "" || $due_date === "" || $priority === "") fail("Missing fields");

$stmt = $pdo->prepare("
    INSERT INTO tasks (user_id, title, course, due_date, priority, is_done)
    VALUES (?, ?, ?, ?, ?, 0)
");
$stmt->execute([$user_id, $title, $course, $due_date, $priority]);

$task_id = (int)$pdo->lastInsertId();

ok(["success" => true, "task_id" => $task_id]);
