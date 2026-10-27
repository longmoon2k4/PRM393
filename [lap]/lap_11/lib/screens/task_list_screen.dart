import 'package:flutter/material.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({super.key, required this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _textController.text.trim();
    if (title.isNotEmpty) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
      );
      setState(() {
        widget.repository.addTask(newTask);
      });
      _textController.clear();
    }
  }

  Future<void> _navigateToDetail(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TaskDetailScreen(task: task, repository: widget.repository),
      ),
    );
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.repository.tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Taskly')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('addTaskField'),
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  key: const Key('addTaskButton'),
                  icon: const Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No tasks yet. Add one!'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        key: Key('taskItem_${task.id}'),
                        title: Text(task.title),
                        trailing: Checkbox(
                          value: task.completed,
                          onChanged: (val) {
                            setState(() {
                              task.toggle();
                            });
                          },
                        ),
                        onTap: () => _navigateToDetail(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
