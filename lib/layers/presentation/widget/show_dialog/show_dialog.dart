import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/tasks/task_type_model.dart';
import 'package:agenda/layers/presentation/pages/day/helpers/show_task_type_category.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DebtsItem extends StatefulWidget {
  final String language;

  const DebtsItem({
    super.key,
    required this.language,
  });

  @override
  State<DebtsItem> createState() => _debtsItemState();
}

class _debtsItemState extends State<DebtsItem> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await addTaskType(controller.text, context);
      controller.clear();
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Ekranni bosganda dialog yopiladi
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Dialog ichida bosishni bloklash
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.only(
                  left: 16.w, right: 16.w, top: 14.h, bottom: 7.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.language == 'eng'
                        ? 'New List'
                        : widget.language == 'rus'
                            ? 'Введите информацию'
                            : 'Yangi ro\'yxat',
                    style:
                        const TextStyle(color: Colors.tealAccent, fontSize: 24),
                  ),
                  Gap(30.h),
                  TaskField(
                    controller: controller,
                    language: widget.language,
                    validator: false,
                    sufix: false,
                    labelText: 'Bu yerga yozing...',
                    isDense: true,
                    minLin: 1,
                    maxLin: 1,
                    conPad: 5.h,
                  ),
                  Gap(30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          controller.clear();
                        },
                        child: Text(
                          widget.language == 'eng'
                              ? 'Cancel'
                              : widget.language == 'rus'
                                  ? 'Отмена'
                                  : 'Bekor qilish',
                          style: TextStyle(
                              fontSize: 18.sp, color: Colors.tealAccent),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            _submit(context);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          widget.language == 'eng'
                              ? 'Save'
                              : widget.language == 'rus'
                                  ? 'Сохранить'
                                  : 'Saqlash',
                          style: TextStyle(
                              fontSize: 18.sp, color: Colors.tealAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showAddTaskTypeDialog(
  BuildContext context,
  String language,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => DebtsItem(language: language),
  );
}



// ---------------------------------------------------------------
// delete informations
// ---------------------------------------------------------------
class DeleteInformations extends StatefulWidget {
  final String language;
  final String label;
  final bool taskDel;
  final TaskModel? task;
  final TaskTypeModel? taskType;
  const DeleteInformations(
      {super.key,
      required this.language,
      required this.label,
      required this.taskDel,
      this.task,
      this.taskType});

  @override
  State<DeleteInformations> createState() => _DeleteInformationsState();
}

class _DeleteInformationsState extends State<DeleteInformations> {
  void _deleteType(TaskTypeModel type) {
    final db = FirebaseFirestore.instance;
    db.collection("tasktype").doc(type.docId).delete();
  }

  void _deleteTask(TaskModel task) {
    final db = FirebaseFirestore.instance;
    db.collection("tasks").doc(task.docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Ekranni bosganda dialog yopiladi
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Dialog ichida bosishni bloklash
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.only(
                  left: 16.w, right: 16.w, top: 14.h, bottom: 7.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.language == 'eng'
                        ? 'Are you sure?'
                        : widget.language == 'rus'
                            ? 'Введите информацию?'
                            : 'Ishonchingiz komilmi?',
                    style: TextStyle(color: Colors.tealAccent, fontSize: 22.sp),
                  ),
                  Gap(20.h),
                  Text(
                    widget.language == 'eng'
                        ? 'Delete ${widget.label}?'
                        : widget.language == 'rus'
                            ? 'scskcnk'
                            : '${widget.label} o\'chirish kerakmi?',
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  ),
                  Gap(20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.language == 'eng'
                              ? 'Cancel'
                              : widget.language == 'rus'
                                  ? 'Отмена'
                                  : 'BEKOR QILISH',
                          style: TextStyle(
                              fontSize: 18.sp, color: Colors.tealAccent),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          if (widget.taskDel == true) {
                            _deleteTask(widget.task!);
                          } else {
                            _deleteType(widget.taskType!);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.language == 'eng'
                              ? 'YES'
                              : widget.language == 'rus'
                                  ? 'Сохранить'
                                  : 'HA',
                          style: TextStyle(
                              fontSize: 18.sp, color: Colors.tealAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showDeleteTaskTypeDialog(BuildContext context, String language,
    String label, TaskTypeModel tasktype) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => DeleteInformations(
      language: language,
      label: label,
      taskDel: false,
      taskType: tasktype,
    ),
  );
}
