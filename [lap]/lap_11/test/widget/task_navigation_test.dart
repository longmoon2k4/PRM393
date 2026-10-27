import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/models/task.dart';
import 'package:lap_11/repositories/task_repository.dart';
import 'package:lap_11/screens/task_list_screen.dart';

void main() {
  group('Task Navigation Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets('navigates to TaskDetailScreen with correct elements on tap', (
      WidgetTester tester,
    ) async {
      repository.addTask(Task(id: 'nav_1', title: 'Navigation Task'));

      await tester.pumpWidget(
        MaterialApp(home: TaskListScreen(repository: repository)),
      );

      await tester.tap(find.text('Navigation Task'));
      await tester.pumpAndSettle();

      expect(find.text('Task Detail'), findsOneWidget);
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
    });
  });
}
