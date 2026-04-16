import 'package:flutter_test/flutter_test.dart';
import 'package:taskmanager/features/tasks/domain/entities/task.dart';

void main() {
  group('AppTask Entity Tests', () {
    test('Task creation sets all fields correctly', () {
      final now = DateTime.now();
      final task = AppTask(
        id: '123',
        title: 'Complete assignment',
        priority: 2,
        isCompleted: false,
        createdAt: now,
      );

      expect(task.id, '123');
      expect(task.title, 'Complete assignment');
      expect(task.priority, 2);
      expect(task.isCompleted, false);
      expect(task.createdAt, now);
    });

    test('copyWith updates specified fields', () {
      final task = AppTask(
        id: '1',
        title: 'A',
        priority: 0,
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final updatedTask = task.copyWith(
        title: 'B',
        isCompleted: true,
      );

      expect(updatedTask.id, '1');
      expect(updatedTask.title, 'B');
      expect(updatedTask.priority, 0); // Unchanged
      expect(updatedTask.isCompleted, true);
    });

    test('toMap converts task correctly', () {
      final now = DateTime.now();
      final task = AppTask(
        id: '123',
        title: 'Apples',
        priority: 1,
        isCompleted: false,
        createdAt: now,
      );

      final map = task.toMap();

      expect(map['title'], 'Apples');
      expect(map['priority'], 1);
      expect(map['isCompleted'], false);
      expect(map['createdAt'], now);
    });

    test('fromMap parses map correctly', () {
      final now = DateTime.now();
      final map = {
        'title': 'Oranges',
        'priority': 2,
        'isCompleted': true,
        // Since we test parsing without Timestamp here, we can mock the toDate logic
        // But AppTask.fromMap expects a dynamic with .toDate() if it exists.
        // Let's test with null createdAt to hit the fallback
        'createdAt': null,
      };

      final task = AppTask.fromMap(map, '777');

      expect(task.id, '777');
      expect(task.title, 'Oranges');
      expect(task.priority, 2);
      expect(task.isCompleted, true);
      // Fallback is DateTime.now(), so let's just make sure it's valid
      expect(task.createdAt, isNotNull);
    });

    // Test 5 (List sorting logic used in providers)
    test('Sorting tasks puts highest priority first', () {
       final tasks = [
         AppTask(id: '1', title: 'Low', priority: 0, isCompleted: false, createdAt: DateTime.now()),
         AppTask(id: '2', title: 'High', priority: 2, isCompleted: false, createdAt: DateTime.now()),
         AppTask(id: '3', title: 'Medium', priority: 1, isCompleted: false, createdAt: DateTime.now()),
       ];

       tasks.sort((a, b) => b.priority.compareTo(a.priority));

       expect(tasks[0].id, '2'); // High
       expect(tasks[1].id, '3'); // Medium
       expect(tasks[2].id, '1'); // Low
    });
  });
}
