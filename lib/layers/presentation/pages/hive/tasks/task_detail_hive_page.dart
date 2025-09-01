import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/task_list_hive_page.dart';
import 'package:agenda/layers/presentation/pages/hive/home_screen_hive_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TaskDetailHivePage extends StatefulWidget {
  final TaskModelHive task;
  final String language;
  final bool lightMode;

  const TaskDetailHivePage({
    super.key,
    required this.task,
    required this.language,
    required this.lightMode,
  });

  @override
  State<TaskDetailHivePage> createState() => _TaskDetailHivePageState();
}

class _TaskDetailHivePageState extends State<TaskDetailHivePage> {
  late final TextEditingController _taskController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  DateTime _date = DateTime.now();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task.task);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    _date = widget.task.date;
    _dateController = TextEditingController(text: _formatDate(_date));
  }

  String _formatDate(DateTime date) {
    if (widget.language == 'eng') {
      return DateFormat.yMMMMEEEEd('en_US').format(date);
    } else if (widget.language == 'rus') {
      return DateFormat.yMMMMEEEEd('ru_RU').format(date);
    } else {
      return DateFormat.yMMMMEEEEd('uz_UZ').format(date);
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      widget.task.task = _taskController.text.trim();
      widget.task.description = _descriptionController.text.trim();
      widget.task.date = _date;

      await widget.task.save();

      _showSnackBar(
        widget.language == 'eng'
            ? 'Task updated successfully'
            : widget.language == 'rus'
                ? 'Задача успешно обновлена'
                : 'Vazifa muvaffaqiyatli yangilandi',
      );

      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      _showSnackBar("Xato: ${e.toString()}");
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.another,
        title: Text(
          widget.language == 'eng'
              ? 'Delete Task'
              : widget.language == 'rus'
                  ? 'Удалить задачу'
                  : 'Vazifani o\'chirish',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          widget.language == 'eng'
              ? 'Are you sure you want to delete this task?'
              : widget.language == 'rus'
                  ? 'Вы уверены, что хотите удалить эту задачу?'
                  : 'Haqiqatan ham bu vazifani o\'chirmoqchimisiz?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              widget.language == 'eng'
                  ? 'Cancel'
                  : widget.language == 'rus'
                      ? 'Отмена'
                      : 'Bekor qilish',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              widget.language == 'eng'
                  ? 'Delete'
                  : widget.language == 'rus'
                      ? 'Удалить'
                      : 'O\'chirish',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.task.delete();
        _showSnackBar(
          widget.language == 'eng'
              ? 'Task deleted successfully'
              : widget.language == 'rus'
                  ? 'Задача успешно удалена'
                  : 'Vazifa muvaffaqiyatli o\'chirildi',
        );

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TaskListHiveScreenPage(
                language: widget.language,
                lightMode: widget.lightMode,
              ),
            ),
          );
        }
      } catch (e) {
        _showSnackBar("Xato: ${e.toString()}");
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleDatePicker() async {
    if (!_isEditing) return;

    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _date = date;
        _dateController.text = _formatDate(date);
      });
    }
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
              ? 'Task Details'
              : widget.language == 'rus'
                  ? 'Детали задачи'
                  : 'Vazifa tafsilotlari',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.lightMode ? AppColors.primary : AppColors.appBar,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
              size: 25.sp,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: _deleteTask,
            icon: Icon(
              Icons.delete,
              size: 25.sp,
              color: Colors.red,
            ),
          ),
          
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20.h),

            // Task status checkbox
            Row(
              children: [
                Checkbox(
                  value: widget.task.status == 1,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        widget.task.status = value ? 1 : 0;
                      });
                      widget.task.save();
                    }
                  },
                ),
                Gap(10.w),
                Text(
                  widget.language == 'eng'
                      ? 'Mark as completed'
                      : widget.language == 'rus'
                          ? 'Отметить как выполненное'
                          : 'Bajarilgan deb belgilash',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            Gap(30.h),

            // Task title
            TaskField(
              controller: _taskController,
              language: widget.language,
              labelText: widget.language == 'eng'
                  ? 'Task'
                  : widget.language == 'rus'
                      ? 'Задача'
                      : 'Vazifa',
              validator: false,
              sufix: false,
              maxLin: 3,
              isDense: false,
              color: Colors.white30,
              // enabled: _isEditing,
            ),

            Gap(20.h),

            // Date
            TextButton(
              onPressed: _handleDatePicker,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 25.sp,
                      color: Colors.white,
                    ),
                    Gap(10.w),
                    Text(
                      _dateController.text,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Gap(20.h),

            // Priority
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.priority_high,
                    size: 25.sp,
                    color: Colors.white,
                  ),
                  Gap(10.w),
                  Text(
                    '${widget.language == 'eng' ? 'Priority' : widget.language == 'rus' ? 'Приоритет' : 'Muhimlik'}: ${widget.task.priority}',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Gap(20.h),

            // Description
            TaskField(
              controller: _descriptionController,
              language: widget.language,
              labelText: widget.language == 'eng'
                  ? 'Description (optional)'
                  : widget.language == 'rus'
                      ? 'Описание (необязательно)'
                      : 'Tavsif (ixtiyoriy)',
              validator: false,
              sufix: false,
              maxLin: 5,
              isDense: false,
              color: Colors.white30,
              // enabled: _isEditing,
            ),

            if (_isEditing) ...[
              Gap(40.h),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    widget.language == 'eng'
                        ? 'Save Changes'
                        : widget.language == 'rus'
                            ? 'Сохранить изменения'
                            : 'O\'zgarishlarni saqlash',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
