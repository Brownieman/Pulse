import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static const String _tasksFileName = 'tasks.json';

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> get _tasksFile async {
    final path = await _localPath;
    return File('$path/$_tasksFileName');
  }

  Future<List<Map<String, dynamic>>> loadTasks() async {
    try {
      final file = await _tasksFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = json.decode(contents);
        return jsonData.map((e) => e as Map<String, dynamic>).toList();
      }
    } catch (e) {
      // If encountering an error, return empty list
    }
    return [];
  }

  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final file = await _tasksFile;
    final jsonData = json.encode(tasks);
    await file.writeAsString(jsonData);
  }

  Future<Map<String, dynamic>> addTask(Map<String, dynamic> task) async {
    final tasks = await loadTasks();
    // Assign an id if not present
    if (!task.containsKey('id')) {
      task['id'] = DateTime.now().millisecondsSinceEpoch;
    }
    tasks.add(task);
    await saveTasks(tasks);
    return task; // Return the task with the assigned id
  }

  Future<void> updateTask(int id, Map<String, dynamic> updatedTask) async {
    final tasks = await loadTasks();
    final index = tasks.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      tasks[index] = updatedTask;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(int id) async {
    final tasks = await loadTasks();
    tasks.removeWhere((t) => t['id'] == id);
    await saveTasks(tasks);
  }
}
