import 'package:flutter_test/flutter_test.dart';
import 'package:lap_11/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Default completed value should be false', () {
      final task = Task(id: '1', title: 'Làm bài tập Lab 11');
      expect(task.completed, isFalse);
    });
    test('toggle() switches completed between true and false', () {
      final task = Task(id: '2', title: 'Kiểm thử toggle');
      task.toggle();
      expect(task.completed, isTrue);
      task.toggle();
      expect(task.completed, isFalse);
    });
  });
}
