import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/repositories/task_repository.dart';
import 'package:lap_11/screens/task_list_screen.dart';

void main() {
  group('Task Full Flow Integration Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets(
      'full flow: add task, navigate, edit title, save, verify list',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: TaskListScreen(repository: repository)),
        );

        await tester.enterText(
          find.byKey(const Key('addTaskField')),
          'Original title',
        );
        await tester.tap(find.byKey(const Key('addTaskButton')));
        await tester.pump();

        expect(find.text('Original title'), findsOneWidget);

        await tester.tap(find.text('Original title'));
        await tester.pumpAndSettle();

        expect(find.text('Task Detail'), findsOneWidget);

        final titleField = find.byKey(const Key('detailTitleField'));
        await tester.enterText(titleField, 'Updated title');

        await tester.tap(find.byKey(const Key('saveTaskButton')));
        await tester.pumpAndSettle();

        expect(find.text('Updated title'), findsOneWidget);
        expect(find.text('Original title'), findsNothing);
      },
    );
  });
}
