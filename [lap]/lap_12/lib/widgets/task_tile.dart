import 'package:flutter/material.dart';
import 'package:lap_12/models/task.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({required ValueKey<String> key, required this.task})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
          color: task.completed ? Colors.grey : Colors.black87,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              task.completed ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              context.read<TaskProvider>().toggleTask(task.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<TaskProvider>().deleteTask(task.id);
            },
          ),
        ],
      ),
    );
  }
}
