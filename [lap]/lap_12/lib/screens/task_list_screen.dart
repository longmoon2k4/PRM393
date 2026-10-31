import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (text.isNotEmpty) {
      context.read<TaskProvider>().addTask(text);
    }

    setState(() {
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Taskly'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập công việc cần làm...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    size: 36,
                    color: Colors.blueAccent,
                  ),
                  onPressed: _submit,
                ),
              ],
            ),
          ),
          Expanded(
              child: Selector<TaskProvider, List<Task>>(
                selector: (context, provider) => provider.tasks,
                shouldRebuild: (previous, next) => true,
                builder: (context, tasks, child) {
                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text('No tasks'),
                    );
                  }
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskTile(
                        key: ValueKey(task.id),
                        task: task,
                      );
                    }
                  );
                }
              )
          )
        ],
      ),
    );
  }
}
