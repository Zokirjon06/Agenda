import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/presentation/pages/hive/home_screen_hive_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TaskTypeHivePage extends StatefulWidget {
  final String language;
  final bool lightMode;
  const TaskTypeHivePage({super.key, required this.language, required this.lightMode});

  @override
  State<TaskTypeHivePage> createState() => _TaskTypeHivePageState();
}

class _TaskTypeHivePageState extends State<TaskTypeHivePage> {
  List<TaskTypeModelHive> _taskTypes = [];
  List<TaskModelHive> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _initializeBoxes();
      _refreshData();
    } catch (e) {
      _showSnackBar("Error loading data: ${e.toString()}");
    }
  }

  Future<void> _initializeBoxes() async {
    await Hive.openBox<TaskTypeModelHive>('taskTypesHiveBox');
    await Hive.openBox<TaskModelHive>('tasksHiveBox');
  }

  void _refreshData() {
    final taskTypeBox = Hive.box<TaskTypeModelHive>('taskTypesHiveBox');
    final taskBox = Hive.box<TaskModelHive>('tasksHiveBox');

    setState(() {
      _taskTypes = taskTypeBox.values.toList();
      _tasks = taskBox.values.toList();
      _taskTypes.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  Future<void> _addTaskType(String name, String? description) async {
    try {
      final box = Hive.box<TaskTypeModelHive>('taskTypesHiveBox');
      const uuid = Uuid();

      final taskType = TaskTypeModelHive(
        name: name,
        date: DateTime.now(),
        description: description,
        docId: uuid.v4(),
      );

      await box.add(taskType);
      _refreshData();
      _showSnackBar(
        widget.language == 'eng'
            ? 'Task type added successfully'
            : widget.language == 'rus'
                ? 'Тип задачи успешно добавлен'
                : 'Vazifa turi muvaffaqiyatli qo\'shildi',
      );
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
    }
  }

  Future<void> _updateTaskType(TaskTypeModelHive taskType, String newName, String? newDescription) async {
    try {
      taskType.name = newName;
      taskType.description = newDescription;
      await taskType.save();
      _refreshData();
      _showSnackBar(
        widget.language == 'eng'
            ? 'Task type updated successfully'
            : widget.language == 'rus'
                ? 'Тип задачи успешно обновлен'
                : 'Vazifa turi muvaffaqiyatli yangilandi',
      );
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
    }
  }

  Future<void> _deleteTaskType(TaskTypeModelHive taskType) async {
    try {
      await taskType.delete();
      _refreshData();
      _showSnackBar(
        widget.language == 'eng'
            ? 'Task type deleted successfully'
            : widget.language == 'rus'
                ? 'Тип задачи успешно удален'
                : 'Vazifa turi muvaffaqiyatli o\'chirildi',
      );
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  int _getTaskCountForType(String typeName) {
    return _tasks.where((task) => task.priority == typeName && task.status == 0).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.lightMode
          ? AppColors.homeBackgroundColor
          : AppColors.standartColor,
      appBar: AppBar(
        title: Text(
          widget.language == 'eng'
              ? 'Task Lists'
              : widget.language == 'rus'
                  ? 'Список категорий'
                  : "Vazifalar Ro'yxati",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddTaskTypeDialog(),
            icon: Icon(
              Icons.format_list_bulleted_add,
              size: 30.sp,
              color: Colors.white,
            ),
          ),
        
        ],
        backgroundColor: widget.lightMode ? AppColors.primary : AppColors.appBar,
        elevation: 3,
        shadowColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.standartColor,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Column(
        children: [
          Gap(5.h),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_taskTypes.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.list_alt,
                size: 80.sp,
                color: Colors.white30,
              ),
              Gap(20.h),
              Text(
                widget.language == 'eng'
                    ? 'No task types yet'
                    : widget.language == 'rus'
                        ? 'Пока нет типов задач'
                        : 'Hozircha vazifa turlari yo\'q',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white60,
                ),
              ),
              Gap(10.h),
              Text(
                widget.language == 'eng'
                    ? 'Tap + to add your first task type'
                    : widget.language == 'rus'
                        ? 'Нажмите +, чтобы добавить первый тип задачи'
                        : 'Birinchi vazifa turini qo\'shish uchun + tugmasini bosing',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white38,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _taskTypes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: _buildItem(_taskTypes[index]),
          );
        },
      ),
    );
  }

  Widget _buildItem(TaskTypeModelHive type) {
    final taskCount = _getTaskCountForType(type.name);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white12,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 16.w, right: 0.w),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0),
          minTileHeight: 30.h,
          minVerticalPadding: 0,
          title: Text(
            type.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.language == 'eng'
                    ? "Tasks: $taskCount"
                    : widget.language == 'rus'
                        ? "Задачи: $taskCount"
                        : "Vazifa: $taskCount",
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (type.description?.isNotEmpty == true)
                Text(
                  type.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                  ),
                ),
            ],
          ),
          trailing: type.name != 'Standart'
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showEditTaskTypeDialog(type),
                      icon: const Icon(Icons.edit, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => _showDeleteTaskTypeDialog(type),
                      icon: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }

  void _showAddTaskTypeDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.language == 'eng'
              ? 'New Task Type'
              : widget.language == 'rus'
                  ? 'Новый тип задачи'
                  : 'Yangi vazifa turi',
          style: const TextStyle(color: Colors.tealAccent, fontSize: 24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TaskField(
              controller: nameController,
              language: widget.language,
              validator: false,
              sufix: false,
              labelText: widget.language == 'eng'
                  ? 'Type name'
                  : widget.language == 'rus'
                      ? 'Название типа'
                      : 'Tur nomi',
              isDense: true,
              minLin: 1,
              maxLin: 1,
              conPad: 5.h,
              color: Colors.white30,
            ),
            Gap(15.h),
            TaskField(
              controller: descriptionController,
              language: widget.language,
              validator: false,
              sufix: false,
              labelText: widget.language == 'eng'
                  ? 'Description (optional)'
                  : widget.language == 'rus'
                      ? 'Описание (необязательно)'
                      : 'Tavsif (ixtiyoriy)',
              isDense: true,
              minLin: 1,
              maxLin: 2,
              conPad: 5.h,
              color: Colors.white30,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              nameController.dispose();
              descriptionController.dispose();
            },
            child: Text(
              widget.language == 'eng'
                  ? 'Cancel'
                  : widget.language == 'rus'
                      ? 'Отмена'
                      : 'Bekor qilish',
              style: TextStyle(fontSize: 18.sp, color: Colors.tealAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _addTaskType(
                  nameController.text.trim(),
                  descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                );
                Navigator.of(context).pop();
              }
              nameController.dispose();
              descriptionController.dispose();
            },
            child: Text(
              widget.language == 'eng'
                  ? 'Save'
                  : widget.language == 'rus'
                      ? 'Сохранить'
                      : 'Saqlash',
              style: TextStyle(fontSize: 18.sp, color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditTaskTypeDialog(TaskTypeModelHive taskType) {
    final nameController = TextEditingController(text: taskType.name);
    final descriptionController = TextEditingController(text: taskType.description ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.language == 'eng'
              ? 'Edit Task Type'
              : widget.language == 'rus'
                  ? 'Редактировать тип задачи'
                  : 'Vazifa turini tahrirlash',
          style: const TextStyle(color: Colors.tealAccent, fontSize: 24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TaskField(
              controller: nameController,
              language: widget.language,
              validator: false,
              sufix: false,
              labelText: widget.language == 'eng'
                  ? 'Type name'
                  : widget.language == 'rus'
                      ? 'Название типа'
                      : 'Tur nomi',
              isDense: true,
              minLin: 1,
              maxLin: 1,
              conPad: 5.h,
              color: Colors.white30,
            ),
            Gap(15.h),
            TaskField(
              controller: descriptionController,
              language: widget.language,
              validator: false,
              sufix: false,
              labelText: widget.language == 'eng'
                  ? 'Description (optional)'
                  : widget.language == 'rus'
                      ? 'Описание (необязательно)'
                      : 'Tavsif (ixtiyoriy)',
              isDense: true,
              minLin: 1,
              maxLin: 2,
              conPad: 5.h,
              color: Colors.white30,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              nameController.dispose();
              descriptionController.dispose();
            },
            child: Text(
              widget.language == 'eng'
                  ? 'Cancel'
                  : widget.language == 'rus'
                      ? 'Отмена'
                      : 'Bekor qilish',
              style: TextStyle(fontSize: 18.sp, color: Colors.tealAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _updateTaskType(
                  taskType,
                  nameController.text.trim(),
                  descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                );
                Navigator.of(context).pop();
              }
              nameController.dispose();
              descriptionController.dispose();
            },
            child: Text(
              widget.language == 'eng'
                  ? 'Update'
                  : widget.language == 'rus'
                      ? 'Обновить'
                      : 'Yangilash',
              style: TextStyle(fontSize: 18.sp, color: Colors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteTaskTypeDialog(TaskTypeModelHive taskType) {
    final taskCount = _getTaskCountForType(taskType.name);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.language == 'eng'
              ? 'Are you sure?'
              : widget.language == 'rus'
                  ? 'Вы уверены?'
                  : 'Ishonchingiz komilmi?',
          style: const TextStyle(color: Colors.tealAccent, fontSize: 22),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.language == 'eng'
                  ? 'Delete "${taskType.name}" task type?'
                  : widget.language == 'rus'
                      ? 'Удалить тип задачи "${taskType.name}"?'
                      : '"${taskType.name}" vazifa turini o\'chirish kerakmi?',
              style: TextStyle(color: Colors.white, fontSize: 19.sp),
            ),
            if (taskCount > 0) ...[
              Gap(10.h),
              Text(
                widget.language == 'eng'
                    ? 'Warning: This type has $taskCount active tasks. They will be changed to "Standart" type.'
                    : widget.language == 'rus'
                        ? 'Предупреждение: У этого типа есть $taskCount активных задач. Они будут изменены на тип "Standart".'
                        : 'Ogohlantirish: Bu turda $taskCount ta faol vazifa bor. Ular "Standart" turiga o\'zgartiriladi.',
                style: TextStyle(color: Colors.orange, fontSize: 16.sp),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              widget.language == 'eng'
                  ? 'Cancel'
                  : widget.language == 'rus'
                      ? 'Отмена'
                      : 'BEKOR QILISH',
              style: TextStyle(fontSize: 18.sp, color: Colors.tealAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              // Update tasks with this type to "Standart"
              if (taskCount > 0) {
                _updateTasksToStandartType(taskType.name);
              }
              _deleteTaskType(taskType);
              Navigator.of(context).pop();
            },
            child: Text(
              widget.language == 'eng'
                  ? 'YES'
                  : widget.language == 'rus'
                      ? 'ДА'
                      : 'HA',
              style: TextStyle(fontSize: 18.sp, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateTasksToStandartType(String oldTypeName) async {
    try {
      final taskBox = Hive.box<TaskModelHive>('tasksHiveBox');
      final tasksToUpdate = taskBox.values.where((task) => task.priority == oldTypeName).toList();

      for (final task in tasksToUpdate) {
        task.priority = 'Standart';
        await task.save();
      }

      _refreshData();
    } catch (e) {
      _showSnackBar("Error updating tasks: ${e.toString()}");
    }
  }
}