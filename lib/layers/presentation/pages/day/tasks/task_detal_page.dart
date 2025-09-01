import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/tasks/task_type_model.dart';
import 'package:agenda/layers/presentation/pages/day/helpers/show_task_type_category.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:agenda/layers/presentation/widget/standart_padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TaskDetalPage extends StatefulWidget {
  final TaskModel task;
  final TaskTypeModel? taskType;
  final String language;
  final bool lightMode;
  const TaskDetalPage(
      {required this.task,
      super.key,
      required this.language,
      required this.lightMode,
      this.taskType});

  @override
  State<TaskDetalPage> createState() => _TaskDetalPageState();
}

class _TaskDetalPageState extends State<TaskDetalPage> {
  // ----------------------------------------------------------------
  // Widget builders and controllers
  // ----------------------------------------------------------------
  late final TextEditingController _taskController;
  late final TextEditingController _dateController;
  late final TextEditingController _pryorityController;
  DateTime _date = DateTime.now();
  late final DateFormat _allDate;
  TaskTypeModel? _selectedCategory;
  late final TextEditingController _showDialodController;

  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    _allDate = DateFormat.yMMMMEEEEd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
    _taskController = TextEditingController(
      text: widget.task.task,
    );
    _dateController =
        TextEditingController(text: _allDate.format(widget.task.date));
    _pryorityController = TextEditingController(
      text: widget.task.priority,
    );

    _showDialodController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _dateController.dispose();
    _pryorityController.dispose();
    _showDialodController.dispose();
    super.dispose();
  }

  Future<DateTime?> _handleDatePicker(DateTime? initialDate) async {
    final now = DateTime.now();
    final sixMonthsFromNow = DateTime(
      now.year,
      now.month + 6,
      now.day,
    );
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: sixMonthsFromNow,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    return date;
  }

  void _deleteTask(TaskModel task) {
    final db = FirebaseFirestore.instance;
    db.collection("tasks").doc(task.docId).delete();
  }

  void _saveChanges(TaskModel task) {
    final db = FirebaseFirestore.instance;
    task.task = _taskController.text.trim();
    task.date = _date;
    task.priority = _selectedCategory == null
        ? task.priority
        : _selectedCategory?.name ?? '';

    db.collection("tasks").doc(task.docId).update(widget.task.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.lightMode
          ? AppColors.homeBackgroundColor
          : AppColors.standartColor,
      appBar: AppBar(
        // backgroundColor:
        //     widget.lightMode ? AppColors.primary : AppColors.standartColor,
        // elevation: 3,
        // shadowColor: Colors.black,
        backgroundColor:
            widget.lightMode ? AppColors.primary : AppColors.appBar,
        elevation: 3,
        shadowColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              AppColors.standartColor, // Status bar rangini o'zgartirish
          statusBarIconBrightness:
              Brightness.light, // Ikonalar rangini o'zgartirish
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                  size: 25.sp,
                  color: Colors.white,
                ),
              ),
              IconButton(
                  onPressed: () {
                    _deleteTask(widget.task);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: Colors.white,
                  ))
            ],
          ),
        ],
      ),
      body: StandartPadding(
        child: SingleChildScrollView(
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
                validator: false,
                sufix: false,
                isDense: true,
                conPad: 5.h,
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
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final date = await _handleDatePicker(_date);
                  if (date != null) {
                    _date = date;
                    _dateController.text = _allDate.format(date);
                  }
                },
                language: widget.language,
                validator: false,
                sufix: false,
                isDense: true,
                conPad: 5.h,
              ),

              Gap(30.h),
              Text(
                widget.language == 'eng'
                    ? 'Status'
                    : widget.language == 'rus'
                        ? 'dsnch'
                        : 'Vazifalar ro\'yxati',
                style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold),
              ),

              //  TextFormField(controller: _pryorityController,),
              InkWell(
                onTap: () async {
                  _selectedCategory = await showExpenseCategory(
                      context: context,
                      controller: _showDialodController,
                      language: widget.language,
                      lightMode: widget.lightMode,
                      selectedItem: _selectedCategory);
                  if (_selectedCategory != null) {
                    setState(() {});
                  }
                },
                child: DropdownButtonFormField(
                  isDense: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      const InputDecoration(contentPadding: EdgeInsets.all(0)),
                  iconDisabledColor: Colors.white,
                  value: _selectedCategory?.name,
                  validator: (v) {
                    if (v == null) {
                      return 'Tanlash majburiy';
                    }
                    return null;
                  },
                  hint: _selectedCategory == null
                      ? SizedBox(
                          width: 300.w,
                          child: Text(
                            widget.task.priority,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 300.w,
                          child: Text(
                            _selectedCategory?.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                  items: const [], // Toifa ma'lumotlari uchun bo'sh list, tanlash imkoniyati mavjud bo'lishi kerak
                  onChanged: (value) {
                    // Tanlangan qiymatni o'zlashtirish
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () {
          _saveChanges(widget.task);
          Navigator.of(context).pop();
        },
        icon: Icons.check,
      ),
    );
  }

//   void _showEditDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: _buildDialogTitle(),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         content: _buildDialogContent(),
//         actions: [
//           _buildDialogButton(
//               widget.language == 'eng'
//                   ? "Cancel"
//                   : widget.language == 'rus'
//                       ? 'Отмена'
//                       : 'Bekor qilish',
//               Colors.red, () {
//             Navigator.of(context).pop();
//           }),
//           _buildDialogButton(
//               widget.language == 'eng'
//                   ? "Save"
//                   : widget.language == 'rus'
//                       ? 'Сохранять'
//                       : 'Saqlash',
//               Colors.deepPurpleAccent, () {
//             setState(() {
//               _saveChanges(widget.task);
//             });
//             Navigator.of(context).pop();
//           }),
//         ],
//       ),
//     );
//   }

//   Row _buildDialogTitle() {
//     return Row(
//       children: [
//         Icon(Icons.edit, color: Colors.purple, size: 28.sp),
//         Gap(10.w),
//         Expanded(
//           child: Text(
//             widget.language == 'eng'
//                 ? 'Add Image'
//                 : widget.language == 'rus'
//                     ? 'Добавить изображение'
//                     : "Rasm qo'shish",
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold, color: Colors.deepPurple),
//           ),
//         ),
//       ],
//     );
//   }

//   SizedBox _buildDialogContent() {
//     return SizedBox(
//       width: double.maxFinite,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           PlanField(
//               controller: _imageController,
//               hintText: widget.language == 'eng'
//                   ? "Image"
//                   : widget.language == 'rus'
//                       ? 'Изображение'
//                       : 'Rasm',
//               icon: Icons.image_outlined,
//               language: widget.language),
//           Gap(10.h),
//         ],
//       ),
//     );
//   }

//   ElevatedButton _buildDialogButton(
//       String label, Color color, VoidCallback onPressed) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//       ),
//       onPressed: onPressed,
//       child: Text(label, style: const TextStyle(color: Colors.white)),
//     );
//   }
// }
}
