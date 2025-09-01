import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/helpers/show_task_type_category_hive.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/appBar_leading_icon.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddTaskHivePage extends StatefulWidget {
  final String language;
  const AddTaskHivePage({super.key, required this.language});

  @override
  State<AddTaskHivePage> createState() => _AddTaskHivePageState();
}

class _AddTaskHivePageState extends State<AddTaskHivePage> {
  late final TextEditingController _taskController;
  late final TextEditingController _dateController;
  late final TextEditingController _priorityController;
  DateTime _date = DateTime.now();
  TaskTypeCategory? _selectedCategory;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _taskController = TextEditingController();
    _dateController = TextEditingController(
      text: _formatDate(DateTime.now()),
    );
    _priorityController = TextEditingController();
    super.initState();
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
    _dateController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      final box = await Hive.openBox<TaskModelHive>('tasksHiveBox');
      const uuid = Uuid();
      TaskModelHive task = TaskModelHive(
        task: _taskController.text.trim(),
        date: _date,
        priority:
            _selectedCategory == null ? 'Standart' : _selectedCategory!.name,
        docId: uuid.v4(),
      );

      await box.add(task);
      _showSnackBar("Ma'lumot saqlandi!");
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showSnackBar("Xato: ${e.toString()}");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleDatePicker() async {
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
      backgroundColor: AppColors.standartColor,
      appBar: AppBar(
        leading: const AppbarLeadingIcon(),
        titleSpacing: 0,
        title: Text(
          widget.language == 'eng'
              ? 'Add Task'
              : widget.language == 'rus'
                  ? 'Добавить задачу'
                  : 'Vazifa qo\'shish',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:
              AppColors.standartColor, // Status bar rangini o'zgartirish
          statusBarIconBrightness:
              Brightness.light, // Ikonalar rangini o'zgartirish
        ),
      ),
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_taskController.text.trim().isNotEmpty) {
              _submit();
            } else {
              _showSnackBar(
                widget.language == 'eng'
                    ? 'Please enter a task'
                    : widget.language == 'rus'
                        ? 'Пожалуйста, введите задачу'
                        : 'Iltimos, vazifani kiriting',
              );
            }
          }
        },
        icon: Icons.check,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(30.h),
                Text(
                  widget.language == 'eng'
                      ? 'What is to be done'
                      : widget.language == 'rus'
                          ? 'dsnch'
                          : 'Nima qilish kerak?',
                  style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                ),
                Gap(10.h),
                TaskField(
                  controller: _taskController,
                  language: widget.language,
                  labelText: widget.language == 'eng'
                      ? 'Enter task'
                      : widget.language == 'rus'
                          ? 'Введите задачу'
                          : 'Vazifani kiriting',
                  minLin: 1,
                  maxLin: null,
                  validator: true,
                  sufix: false,
                  isDense: true,
                  conPad: 5.h,
                  // color: Colors.white30,
                ),
                Gap(30.h),
                Text(
                  widget.language == 'eng'
                      ? 'Due date'
                      : widget.language == 'rus'
                          ? 'dsnch'
                          : 'Muddat',
                  style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                ),
                Gap(10.h),
                TaskField(
                  controller: _dateController,
                  onTap: () {
                    _handleDatePicker();
                  },
                  labelText: widget.language == 'eng'
                      ? 'Date'
                      : widget.language == 'rus'
                          ? 'Дата'
                          : "Sana",
                  language: widget.language,
                  keyBordtype: TextInputType.datetime,
                  validator: true,
                  sufix: false,
                  isDense: true,
                  conPad: 5.h,
                  readOnly: true,
                ),
                Gap(30.h),
                Text(
                  widget.language == 'eng'
                      ? 'Due date'
                      : widget.language == 'rus'
                          ? 'dsnch'
                          : 'Ro\'yxatga qo\'shing',
                  style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    final result = await showTaskTypeCategoryHiveDialog(
                      context: context,
                      language: widget.language,
                      lightMode: false,
                      selectedItem: _selectedCategory,
                    );
                    if (result != null) {
                      setState(() {
                        _selectedCategory = result;
                      });
                    }
                  },
                  child: DropdownButtonFormField(
                    iconDisabledColor: Colors.white,
                    isDense: true,
                    decoration:
                        InputDecoration(contentPadding: EdgeInsets.all(0.h)),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    value: _selectedCategory?.name ?? 'Standart',
                    validator: (v) {
                      if (v == null) {
                        return 'Tanlash majburiy';
                      }
                      return null;
                    },
                    hint: _selectedCategory == null
                        ? const Text(
                            'Standart',
                            style: TextStyle(
                                // color: Color(0xffA0A0A0),
                                color: Colors.white),
                          )
                        : SizedBox(
                            width: 300.w,
                            child: Text(
                              _selectedCategory?.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                    items: const [],
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
