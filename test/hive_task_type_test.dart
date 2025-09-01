import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/presentation/pages/hive/helpers/hive_initialization.dart';

void main() {
  group('Hive Task Type System Tests', () {
    setUpAll(() async {
      // Initialize Hive for testing
      await Hive.initFlutter();
      
      // Register adapters
      Hive.registerAdapter(TaskModelHiveAdapter());
      Hive.registerAdapter(TaskTypeModelHiveAdapter());
    });

    tearDownAll(() async {
      // Clean up after tests
      await Hive.deleteFromDisk();
    });

    setUp(() async {
      // Clear all boxes before each test
      if (Hive.isBoxOpen('tasksHiveBox')) {
        await Hive.box('tasksHiveBox').clear();
      }
      if (Hive.isBoxOpen('taskTypesHiveBox')) {
        await Hive.box('taskTypesHiveBox').clear();
      }
    });

    test('Should initialize Hive boxes successfully', () async {
      await HiveInitialization.initializeBoxes();
      
      expect(HiveInitialization.areBoxesOpen(), true);
      expect(Hive.isBoxOpen('tasksHiveBox'), true);
      expect(Hive.isBoxOpen('taskTypesHiveBox'), true);
    });

    test('Should create default task types on initialization', () async {
      await HiveInitialization.initializeBoxes();
      
      final taskTypes = HiveInitialization.getAllTaskTypes();
      
      expect(taskTypes.length, 4);
      expect(taskTypes.any((type) => type.name == 'Standart'), true);
      expect(taskTypes.any((type) => type.name == 'Muhim'), true);
      expect(taskTypes.any((type) => type.name == 'Shoshilinch'), true);
      expect(taskTypes.any((type) => type.name == 'Kam muhim'), true);
    });

    test('Should add new task type successfully', () async {
      await HiveInitialization.initializeBoxes();
      
      final newTaskType = TaskTypeModelHive(
        name: 'Test Type',
        date: DateTime.now(),
        description: 'Test description',
        docId: 'test-id',
      );
      
      await HiveInitialization.addTaskType(newTaskType);
      
      final taskTypes = HiveInitialization.getAllTaskTypes();
      expect(taskTypes.any((type) => type.name == 'Test Type'), true);
    });

    test('Should add and retrieve tasks successfully', () async {
      await HiveInitialization.initializeBoxes();
      
      final task = TaskModelHive(
        task: 'Test Task',
        date: DateTime.now(),
        priority: 'Standart',
        docId: 'test-task-id',
      );
      
      await HiveInitialization.addTask(task);
      
      final tasks = HiveInitialization.getAllTasks();
      expect(tasks.length, 1);
      expect(tasks.first.task, 'Test Task');
      expect(tasks.first.priority, 'Standart');
    });

    test('Should update tasks type when type is changed', () async {
      await HiveInitialization.initializeBoxes();
      
      // Add a task with 'Muhim' type
      final task = TaskModelHive(
        task: 'Important Task',
        date: DateTime.now(),
        priority: 'Muhim',
        docId: 'important-task-id',
      );
      
      await HiveInitialization.addTask(task);
      
      // Update all tasks from 'Muhim' to 'Standart'
      await HiveInitialization.updateTasksType('Muhim', 'Standart');
      
      final tasks = HiveInitialization.getAllTasks();
      expect(tasks.first.priority, 'Standart');
    });

    test('Should count tasks for specific type correctly', () async {
      await HiveInitialization.initializeBoxes();
      
      // Add multiple tasks with different types
      final tasks = [
        TaskModelHive(
          task: 'Task 1',
          date: DateTime.now(),
          priority: 'Standart',
          docId: 'task-1',
          status: 0, // Active
        ),
        TaskModelHive(
          task: 'Task 2',
          date: DateTime.now(),
          priority: 'Standart',
          docId: 'task-2',
          status: 0, // Active
        ),
        TaskModelHive(
          task: 'Task 3',
          date: DateTime.now(),
          priority: 'Standart',
          docId: 'task-3',
          status: 1, // Completed
        ),
        TaskModelHive(
          task: 'Task 4',
          date: DateTime.now(),
          priority: 'Muhim',
          docId: 'task-4',
          status: 0, // Active
        ),
      ];
      
      for (final task in tasks) {
        await HiveInitialization.addTask(task);
      }
      
      // Should count only active tasks
      expect(HiveInitialization.getTaskCountForType('Standart'), 2);
      expect(HiveInitialization.getTaskCountForType('Muhim'), 1);
      expect(HiveInitialization.getTaskCountForType('Nonexistent'), 0);
    });

    test('Should clear all data successfully', () async {
      await HiveInitialization.initializeBoxes();
      
      // Add some data
      final task = TaskModelHive(
        task: 'Test Task',
        date: DateTime.now(),
        priority: 'Standart',
        docId: 'test-task',
      );
      
      await HiveInitialization.addTask(task);
      
      // Verify data exists
      expect(HiveInitialization.getAllTasks().length, 1);
      
      // Clear all data
      await HiveInitialization.clearAllData();
      
      // Verify data is cleared but default types are recreated
      expect(HiveInitialization.getAllTasks().length, 0);
      expect(HiveInitialization.getAllTaskTypes().length, 4); // Default types
    });

    test('Should handle errors gracefully', () async {
      // Test with uninitialized boxes
      final tasks = HiveInitialization.getAllTasks();
      final taskTypes = HiveInitialization.getAllTaskTypes();
      final taskCount = HiveInitialization.getTaskCountForType('Standart');
      
      // Should return empty lists/zero instead of throwing
      expect(tasks, isEmpty);
      expect(taskTypes, isEmpty);
      expect(taskCount, 0);
    });

    test('Should sort task types by date', () async {
      await HiveInitialization.initializeBoxes();
      
      // Clear default types for this test
      final box = HiveInitialization.getTaskTypesBox();
      await box.clear();
      
      // Add types with different dates
      final now = DateTime.now();
      final types = [
        TaskTypeModelHive(
          name: 'Third',
          date: now.add(const Duration(days: 2)),
          docId: 'third',
        ),
        TaskTypeModelHive(
          name: 'First',
          date: now,
          docId: 'first',
        ),
        TaskTypeModelHive(
          name: 'Second',
          date: now.add(const Duration(days: 1)),
          docId: 'second',
        ),
      ];
      
      for (final type in types) {
        await HiveInitialization.addTaskType(type);
      }
      
      final sortedTypes = HiveInitialization.getAllTaskTypes();
      expect(sortedTypes[0].name, 'First');
      expect(sortedTypes[1].name, 'Second');
      expect(sortedTypes[2].name, 'Third');
    });
  });
}
