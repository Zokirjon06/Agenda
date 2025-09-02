import 'package:agenda/layers/domain/models/hive_model/expenses/expense_model.dart';
import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// Initialize all Hive boxes and create default data if needed
class HiveInitialization {
  static const String tasksBoxName = 'tasksHiveBox';
  static const String taskTypesBoxName = 'taskTypesHiveBox';
  static const String debtsBoxName = 'debtsBox';
  static const String debtsDetailBoxName = 'debtsDetailBox';
  static const String expenseBoxName = 'expensesBox';

  /// Initialize all Hive boxes
  static Future<void> initializeBoxes() async {
    try {
      // Open all boxes
      await Hive.openBox<TaskModelHive>(tasksBoxName);
      await Hive.openBox<TaskTypeModelHive>(taskTypesBoxName);
      await Hive.openBox<DebtsModel>(debtsBoxName);
      await Hive.openBox<DebtsDetailModel>(debtsDetailBoxName);
      await Hive.openBox<Expense>(expenseBoxName);

      // Create default task types if none exist
      await _createDefaultTaskTypes();
    } catch (e) {
      throw Exception('Failed to initialize Hive boxes: $e');
    }
  }

  /// Create default task types if the box is empty
  static Future<void> _createDefaultTaskTypes() async {
    try {
      final box = Hive.box<TaskTypeModelHive>(taskTypesBoxName);
      
      if (box.isEmpty) {
        const uuid = Uuid();
        final defaultTypes = [
          TaskTypeModelHive(
            name: 'Standart',
            date: DateTime.now(),
            description: 'Default task type',
            docId: uuid.v4(),
          ),
          TaskTypeModelHive(
            name: 'Muhim',
            date: DateTime.now(),
            description: 'Important tasks',
            docId: uuid.v4(),
          ),
          TaskTypeModelHive(
            name: 'Shoshilinch',
            date: DateTime.now(),
            description: 'Urgent tasks',
            docId: uuid.v4(),
          ),
          TaskTypeModelHive(
            name: 'Kam muhim',
            date: DateTime.now(),
            description: 'Low priority tasks',
            docId: uuid.v4(),
          ),
        ];

        for (final type in defaultTypes) {
          await box.add(type);
        }
      }
    } catch (e) {
      throw Exception('Failed to create default task types: $e');
    }
  }

  /// Get tasks box
  static Box<TaskModelHive> getTasksBox() {
    return Hive.box<TaskModelHive>(tasksBoxName);
  }

  /// Get task types box
  static Box<TaskTypeModelHive> getTaskTypesBox() {
    return Hive.box<TaskTypeModelHive>(taskTypesBoxName);
  }

  /// Get debts box
  static Box<DebtsModel> getDebtsBox() {
    return Hive.box<DebtsModel>(debtsBoxName);
  }

  /// Get debts detail box
  static Box<DebtsDetailModel> getDebtsDetailBox() {
    return Hive.box<DebtsDetailModel>(debtsDetailBoxName);
  }

  /// Check if all boxes are open
  static bool areBoxesOpen() {
    return Hive.isBoxOpen(tasksBoxName) &&
           Hive.isBoxOpen(taskTypesBoxName) &&
           Hive.isBoxOpen(debtsBoxName) &&
           Hive.isBoxOpen(debtsDetailBoxName);
  }

  /// Close all boxes
  static Future<void> closeAllBoxes() async {
    try {
      if (Hive.isBoxOpen(tasksBoxName)) {
        await Hive.box<TaskModelHive>(tasksBoxName).close();
      }
      if (Hive.isBoxOpen(taskTypesBoxName)) {
        await Hive.box<TaskTypeModelHive>(taskTypesBoxName).close();
      }
      if (Hive.isBoxOpen(debtsBoxName)) {
        await Hive.box<DebtsModel>(debtsBoxName).close();
      }
      if (Hive.isBoxOpen(debtsDetailBoxName)) {
        await Hive.box<DebtsDetailModel>(debtsDetailBoxName).close();
      }
    } catch (e) {
      throw Exception('Failed to close Hive boxes: $e');
    }
  }

  /// Clear all data from boxes
  static Future<void> clearAllData() async {
    try {
      final tasksBox = getTasksBox();
      final taskTypesBox = getTaskTypesBox();
      final debtsBox = getDebtsBox();
      final debtsDetailBox = getDebtsDetailBox();

      await tasksBox.clear();
      await taskTypesBox.clear();
      await debtsBox.clear();
      await debtsDetailBox.clear();

      // Recreate default task types
      await _createDefaultTaskTypes();
    } catch (e) {
      throw Exception('Failed to clear all data: $e');
    }
  }

  /// Get all tasks
  static List<TaskModelHive> getAllTasks() {
    try {
      final box = getTasksBox();
      return box.values.toList();
    } catch (e) {
      return [];
    }
  }

  /// Get all task types
  static List<TaskTypeModelHive> getAllTaskTypes() {
    try {
      final box = getTaskTypesBox();
      final taskTypes = box.values.toList();
      taskTypes.sort((a, b) => a.date.compareTo(b.date));
      return taskTypes;
    } catch (e) {
      return [];
    }
  }

  /// Get all debts
  static List<DebtsModel> getAllDebts() {
    try {
      final box = getDebtsBox();
      return box.values.toList();
    } catch (e) {
      return [];
    }
  }

  


  /// Add a new task
  static Future<void> addTask(TaskModelHive task) async {
    try {
      final box = getTasksBox();
      await box.add(task);
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  /// Add a new task type
  static Future<void> addTaskType(TaskTypeModelHive taskType) async {
    try {
      final box = getTaskTypesBox();
      await box.add(taskType);
    } catch (e) {
      throw Exception('Failed to add task type: $e');
    }
  }

  /// Add a new debt
  static Future<void> addDebt(DebtsModel debt) async {
    try {
      final box = getDebtsBox();
      await box.add(debt);
    } catch (e) {
      throw Exception('Failed to add debt: $e');
    }
  }

  /// Update tasks with old type name to new type name
  static Future<void> updateTasksType(String oldTypeName, String newTypeName) async {
    try {
      final box = getTasksBox();
      final tasksToUpdate = box.values.where((task) => task.priority == oldTypeName).toList();
      
      for (final task in tasksToUpdate) {
        task.priority = newTypeName;
        await task.save();
      }
    } catch (e) {
      throw Exception('Failed to update tasks type: $e');
    }
  }

  /// Get task count for a specific type
  static int getTaskCountForType(String typeName) {
    try {
      final tasks = getAllTasks();
      return tasks.where((task) => task.priority == typeName && task.status == 0).length;
    } catch (e) {
      return 0;
    }
  }
}
