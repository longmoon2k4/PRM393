import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/models/task.dart';
import 'package:lap_11/repositories/task_repository.dart';

void main() {
  group('TaskRepository Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask adds a task to repository', () {
      final task = Task(id: '1', title: 'Task 1');

      repository.addTask(task);

      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Task 1');
    });

    test('deleteTask removes task by id', () {
      final task = Task(id: '1', title: 'Task 1');
      repository.addTask(task);

      repository.deleteTask('1');

      expect(repository.tasks.isEmpty, isTrue);
    });

    test('updateTask modifies existing task data', () {
      final task = Task(id: '1', title: 'Task 1');
      repository.addTask(task);

      final updatedTask = Task(
        id: '1',
        title: 'Updated Task 1',
        completed: true,
      );
      repository.updateTask(updatedTask);

      final retrieved = repository.getTaskById('1');
      expect(retrieved?.title, 'Updated Task 1');
      expect(retrieved?.completed, isTrue);
    });
  });
}
