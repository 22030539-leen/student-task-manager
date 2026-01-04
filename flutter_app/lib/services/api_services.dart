import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://localhost/Student_Task_Manager/api";

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getTasks(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_tasks.php?user_id=$userId"),
    );

    final data = jsonDecode(response.body);
    return data["tasks"] ?? [];
  }

  static Future<void> addTask(
    int userId,
    String title,
    String course,
    String dueDate,
    String priority,
  ) async {
    await http.post(
      Uri.parse("$baseUrl/add_task.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "title": title,
        "course": course,
        "due_date": dueDate,
        "priority": priority,
      }),
    );
  }

  static Future<void> updateTask(
    int taskId,
    int userId,
    String title,
    String course,
    String dueDate,
    String priority,
    bool isDone,
  ) async {
    await http.post(
      Uri.parse("$baseUrl/update_task.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "task_id": taskId,
        "user_id": userId,
        "title": title,
        "course": course,
        "due_date": dueDate,
        "priority": priority,
        "is_done": isDone ? 1 : 0,
      }),
    );
  }

  static Future<void> deleteTask(int taskId, int userId) async {
    await http.post(
      Uri.parse("$baseUrl/delete_task.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "task_id": taskId,
        "user_id": userId,
      }),
    );
  }
}