 import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/api_services.dart';

class TasksScreen extends StatefulWidget {
  final int userId;

  const TasksScreen({super.key, required this.userId});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List tasks = [];
  bool loading = true;

  final titleController = TextEditingController();
  final courseController = TextEditingController();
  final priorityController = TextEditingController();
  final dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
  try {
    final url = Uri.parse("${ApiService.baseUrl}/get_tasks.php?user_id=${widget.userId}");

    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("HTTP ${response.statusCode}: ${response.body}");
    }

    final decoded = jsonDecode(response.body);

    setState(() {
      tasks = (decoded is List) ? decoded : [];
    });
  } catch (e) {
    // Show error instead of infinite loading
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to load tasks: $e")),
    );

    setState(() {
      tasks = [];
    });
  } finally {
    if (mounted) {
      setState(() => loading = false);
    }
  }
}

  Future<void> addTask() async {
    await http.post(
      Uri.parse("${ApiService.baseUrl}/add_task.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": widget.userId,
        "title": titleController.text,
        "course": courseController.text,
        "priority": priorityController.text,
        "due_date": dueDateController.text,
      }),
    );

    titleController.clear();
    courseController.clear();
    priorityController.clear();
    dueDateController.clear();

    if (!mounted) return;

    Navigator.pop(context);
    loadTasks();
  }

  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Task"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: courseController,
                decoration: const InputDecoration(labelText: "Course"),
              ),
              TextField(
                controller: priorityController,
                decoration: const InputDecoration(labelText: "Priority"),
              ),
              TextField(
                controller: dueDateController,
                decoration:
                    const InputDecoration(labelText: "Due date (YYYY-MM-DD)"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: addTask,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddTaskDialog,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(child: Text("No tasks yet"))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, i) {
                    final task = tasks[i];
                    return Card(
                      child: ListTile(
                        title: Text(task["title"]),
                        subtitle: Text(
                          "${task["course"]} | ${task["priority"]} | ${task["due_date"]}",
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}