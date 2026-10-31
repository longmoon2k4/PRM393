import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);
  void addTask(String title) {
    if (title.trim().isEmpty) return;
    _tasks.add(
      Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
      ),
    );
    notifyListeners();
  }

  void toggleTask(String id) {
    final task = _tasks.firstWhere((e) => e.id == id);
    task.toggle();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
