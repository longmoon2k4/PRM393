import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/repositories/task_repository.dart';
import 'package:lap_11/screens/task_list_screen.dart';

void main() {
  group('TaskListScreen Widget Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: TaskListScreen(repository: repository),
      );
    }

    testWidgets('displays empty state when there are no tasks', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('adds a task and updates UI', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byKey(const Key('addTaskField')), 'First Task');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      expect(find.text('First Task'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('adds multiple tasks and verifies both are visible', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byKey(const Key('addTaskField')), 'Task One');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      await tester.enterText(find.byKey(const Key('addTaskField')), 'Task Two');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      expect(find.text('Task One'), findsOneWidget);
      expect(find.text('Task Two'), findsOneWidget);
    });
  });
}