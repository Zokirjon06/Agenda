import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/tasks/task_type_model.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/loading.dart';
import 'package:agenda/layers/presentation/widget/show_dialog/show_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TypePage extends StatefulWidget {
  final String language;
  final bool lightMode;
  const TypePage({super.key, required this.language, required this.lightMode});

  @override
  State<TypePage> createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  Stream<List<TaskTypeModel>> getAllTaskTypesStream() {
    final db = FirebaseFirestore.instance;
    return db.collection('tasktype').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskTypeModel.fromJson(doc.data())..docId = doc.id)
          .toList();
    });
  }

  Stream<List<TaskModel>> getAllTaskStream() {
    final db = FirebaseFirestore.instance;
    return db.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data())..docId = doc.id)
          .toList();
    });
  }

  void _saveChanges(TaskTypeModel taskTypes) {
    final db = FirebaseFirestore.instance;
    taskTypes.name = taskTypes.name;
    db.collection("tasktype").doc(taskTypes.docId).update(taskTypes.toJson());
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
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showAddTaskTypeDialog(context, widget.language);
            },
            icon: Icon(
              Icons.format_list_bulleted_add,
              size: 30.sp,
              color: Colors.white,
            ),
          )
        ],
        // elevation: 0.5,
        // scrolledUnderElevation: 0.5,
        // backgroundColor: widget.lightMode
        //     ? AppColors.homeBackgroundColor
        //     : AppColors.standartColor,
          backgroundColor: widget.lightMode ? AppColors.primary : AppColors.appBar,
           elevation: 3,
           shadowColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.standartColor, // Status bar rangini o'zgartirish
                statusBarIconBrightness: Brightness.light, // Ikonalar rangini o'zgartirish
              ),

      ),
      body: Column(children: [Gap(5.h), _buildBody()]),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<TaskTypeModel>>(
      stream: getAllTaskTypesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Xato: ${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Hozircha ma'lumot mavjud emas."),
          );
        }

        List<TaskTypeModel> typess = snapshot.data!;
        typess.sort((a, b) => a.date.compareTo(b.date));

        return Expanded(
          child: ListView.builder(
            itemCount: typess.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: _buildItem(typess[index]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(TaskTypeModel type) {
    return StreamBuilder<List<TaskModel>>(
      stream: getAllTaskStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Xato: ${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        List<TaskModel> tasks = snapshot.data!;
        List<TaskModel> filteredTasksType = tasks.where((task) {
          return type.name == task.priority && task.status == 0;
        }).toList();

        return Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white12),
          child: InkWell(
            // onTap: () {
            //   Navigator.of(context).pop();
            // },
            child: Padding(
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 16.w, right: 0.w),
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
                subtitle: Text(
                  "Vazifa: ${filteredTasksType.length}",
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (type.name != 'Standart')
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              _saveChanges(type);
                            },
                            icon: const Icon(Icons.edit, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {
                              showDeleteTaskTypeDialog(
                                  context,
                                  widget.language,
                                  widget.language == 'eng'
                                      ? 'Task type'
                                      : widget.language == 'rus'
                                          ? 'sdcsd'
                                          : 'Ushbu ro\'yxatni',
                                  type);
                            },
                            icon: const Icon(Icons.delete, color: Colors.white),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
