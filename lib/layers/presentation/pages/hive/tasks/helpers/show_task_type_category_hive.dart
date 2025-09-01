import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/type/task_type_hive_page.dart';
import 'package:agenda/layers/presentation/pages/hive/helpers/hive_initialization.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';

// Simple class to represent task categories for Hive implementation
class TaskTypeCategory {
  final String name;
  final String? description;
  final String? docId;

  TaskTypeCategory({required this.name, this.description, this.docId});

  // Create from Hive model
  factory TaskTypeCategory.fromHiveModel(TaskTypeModelHive model) {
    return TaskTypeCategory(
      name: model.name,
      description: model.description,
      docId: model.docId,
    );
  }
}

/// Get all task types from Hive
List<TaskTypeModelHive> getAllTaskTypesFromHive() {
  return HiveInitialization.getAllTaskTypes();
}

/// Add a new task type to Hive
Future<void> addTaskTypeToHive(String name, String? description) async {
  try {
    final box = await Hive.openBox<TaskTypeModelHive>('taskTypesHiveBox');
    final taskType = TaskTypeModelHive(
      name: name,
      date: DateTime.now(),
      description: description,
      docId: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    await box.add(taskType);
  } catch (e) {
    throw Exception('Failed to add task type: $e');
  }
}

/// Show task type selection modal with navigation to management page
Future<TaskTypeCategory?> showTaskTypeCategoryHiveDialog({
  required BuildContext context,
  required String language,
  required bool lightMode,
  TaskTypeCategory? selectedItem,
}) async {
  TaskTypeCategory? result;

  await showModalBottomSheet(
    useSafeArea: true,
    showDragHandle: true,
    context: context,
    backgroundColor: AppColors.primary,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final taskTypes = getAllTaskTypesFromHive();

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    language == 'eng'
                        ? "Task Types"
                        : language == 'rus'
                            ? "Типы задач"
                            : "Vazifalar Ro'yxati",
                    style: TextStyle(fontSize: 25.sp, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () async {
                      // Navigate to task type management page
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TaskTypeHivePage(
                            language: language,
                            lightMode: lightMode,
                          ),
                        ),
                      );
                      // Refresh the list when returning
                      setState(() {});
                    },
                    icon: const Icon(Icons.list_alt),
                    color: Colors.white,
                    iconSize: 30.sp,
                  ),
                ],
              ),
              Gap(10.h),

              // Add quick add button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ElevatedButton.icon(
                  onPressed: () => _showQuickAddDialog(context, language, setState),
                  icon: const Icon(Icons.add),
                  label: Text(
                    language == 'eng'
                        ? 'Add New Type'
                        : language == 'rus'
                            ? 'Добавить новый тип'
                            : 'Yangi tur qo\'shish',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.another,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              Gap(10.h),

              Expanded(
                child: taskTypes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.list_alt,
                              size: 60.sp,
                              color: Colors.white30,
                            ),
                            Gap(16.h),
                            Text(
                              language == 'eng'
                                  ? 'No task types yet'
                                  : language == 'rus'
                                      ? 'Пока нет типов задач'
                                      : 'Hozircha vazifa turlari yo\'q',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: taskTypes.length,
                        itemBuilder: (context, index) {
                          final item = taskTypes[index];
                          final isSelected = selectedItem?.name == item.name;

                          return ListTile(
                            tileColor: isSelected ? Colors.white24 : Colors.transparent,
                            onTap: () {
                              result = TaskTypeCategory.fromHiveModel(item);
                              Navigator.of(context).pop();
                            },
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 16.w,
                            ),
                            leading: Icon(
                              Icons.list,
                              size: 30.sp,
                              color: isSelected ? Colors.tealAccent : Colors.white,
                            ),
                            title: Text(
                              item.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: isSelected ? Colors.tealAccent : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            subtitle: item.description?.isNotEmpty == true
                                ? Text(
                                    item.description!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: isSelected ? Colors.tealAccent.withValues(alpha: 0.7) : Colors.white70,
                                    ),
                                  )
                                : null,
                            trailing: Icon(
                              isSelected ? Icons.check_circle : Icons.keyboard_arrow_right,
                              color: isSelected ? Colors.tealAccent : Colors.white,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      );
    },
  );

  return result;
}

void _showQuickAddDialog(BuildContext context, String language, StateSetter setState) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.another,
      title: Text(
        language == 'eng'
            ? 'Quick Add Type'
            : language == 'rus'
                ? 'Быстро добавить тип'
                : 'Tezkor tur qo\'shish',
        style: const TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: language == 'eng'
              ? 'Type name'
              : language == 'rus'
                  ? 'Название типа'
                  : 'Tur nomi',
          hintStyle: const TextStyle(color: Colors.white60),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white60),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            controller.dispose();
          },
          child: Text(
            language == 'eng'
                ? 'Cancel'
                : language == 'rus'
                    ? 'Отмена'
                    : 'Bekor qilish',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (controller.text.trim().isNotEmpty) {
              try {
                await addTaskTypeToHive(controller.text.trim(), null);
                setState(() {}); // Refresh the parent dialog
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        language == 'eng'
                            ? 'Task type added successfully'
                            : language == 'rus'
                                ? 'Тип задачи успешно добавлен'
                                : 'Vazifa turi muvaffaqiyatli qo\'shildi',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            }
            controller.dispose();
          },
          child: Text(
            language == 'eng'
                ? 'Add'
                : language == 'rus'
                    ? 'Добавить'
                    : 'Qo\'shish',
            style: const TextStyle(color: Colors.tealAccent),
          ),
        ),
      ],
    ),
  );
}
