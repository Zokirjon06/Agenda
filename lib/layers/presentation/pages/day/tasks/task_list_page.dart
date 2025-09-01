import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/tasks/task_type_model.dart';
import 'package:agenda/layers/presentation/helpers/snackbar_message.dart';
import 'package:agenda/layers/presentation/pages/add/add_page.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/add_task_page.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/task_detal_page.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/type/type_page.dart';
import 'package:agenda/layers/presentation/pages/main/home_screen_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/loading.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:agenda/layers/presentation/widget/show_dialog/show_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
class TaskListScreenPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  final String? typeval;
  const TaskListScreenPage(
      {super.key,
      required this.language,
      required this.lightMode,
      this.typeval});

  @override
  State<TaskListScreenPage> createState() => _TaskListScreenPageState();
}

class _TaskListScreenPageState extends State<TaskListScreenPage> {
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<String> _checkButtonQuery = ValueNotifier<String>("");
  bool _enable = false;
  late final TextEditingController _quickInformationController;
  String? _taskType = 'all_tasks';
  late final DateFormat _allDate;

  @override
  void initState() {
    _allDate = DateFormat.yMMMMEEEEd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
    _quickInformationController = TextEditingController();
    super.initState();
  }

 

  Future<void> _submit1() async {
    if (_quickInformationController.value.text.isNotEmpty) {
      try {
        final db = FirebaseFirestore.instance;
        TaskModel task = TaskModel(
            task: _quickInformationController.text.trim(),
            date: DateTime.now(),
            priority: _taskType != 'all_tasks' ? _taskType! : "Standart");

        var myTask = await db.collection('tasks').add(task.toJson());
        await db
            .collection("tasks")
            .doc(myTask.id)
            .update({"docId": myTask.id});
        showMessage(context: context, message: 'Malumot saqlandi');
      } catch (e) {
        showMessage(context: context, message: "Xato: ${e.toString()}");
      } finally {
        setState(() {});
      }
    }
  }

  Stream<List<TaskModel>> getAllTaskStream() {
    final db = FirebaseFirestore.instance;
    return db.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data())..docId = doc.id)
          .toList();
    });
  }

  Stream<List<TaskTypeModel>> getAllTaskTypesStream() {
    final db = FirebaseFirestore.instance;
    return db.collection('tasktype').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskTypeModel.fromJson(doc.data())..docId = doc.id)
          .toList();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _quickInformationController.dispose();
    _checkButtonQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.lightMode
          ? AppColors.homeBackgroundColor
          : AppColors.standartColor,
      appBar: AppBar(
         leading: SizedBox(width: 0.w,height: 0.h,),
        leadingWidth: 0,
        title: DropdownButtonHideUnderline(
          
          child: StreamBuilder<List<TaskTypeModel>>(
            
            stream: getAllTaskTypesStream(),
            builder: (context, snapshot) {
              
              List<DropdownMenuItem<String>> items = [
                DropdownMenuItem(
                  value: "all_tasks",
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    minVerticalPadding: 0,
                    minTileHeight: 0,
                    leading: Icon(
                      Icons.home_outlined,
                      size: 32.sp,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Barcha ro'yxatlar",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 21.sp,fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ];

              if (snapshot.hasData) {
                final sortedTaskTypes = List<TaskTypeModel>.from(snapshot.data!)
                  ..sort((a, b) => a.date.compareTo(b.date));

                for (var taskType in sortedTaskTypes) {
                  items.add(
                    DropdownMenuItem(
                      value: taskType.name,
                      child: ListTile(
                        minTileHeight: 0,
                        minLeadingWidth: 0,
                        contentPadding: EdgeInsets.only(left: 15.w, right: 0),
                        minVerticalPadding: 0,
                        leading: Icon(
                          Icons.format_list_bulleted_outlined,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                        title: Text(
                          taskType.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 21.sp,fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }
              }

              items.add(
                DropdownMenuItem(
                  value: "done",
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    minTileHeight: 0,
                    minVerticalPadding: 0,
                    leading: Icon(Icons.check_box_sharp,color: Colors.white, size: 30.sp),
                    title: Text(
                      "Bajarildi",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 21.sp,fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              );
              items.add(DropdownMenuItem(
                  value: "addList",
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    minTileHeight: 0,
                    minVerticalPadding: 0,
                    leading: Icon(
                      Icons.format_list_bulleted_add,
                      size: 30.sp,color: Colors.white,
                    ),
                    title: Text('Yangi ro\'yxat',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                  )));

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DropdownButton<String>(
            icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 30.sp),
                  isExpanded: true,
                  value: _taskType,
                  dropdownColor: AppColors.another,
                  items: items,
                  onChanged: (v) {
                    if (v != 'addList') {
                      setState(() {
                        _taskType = v;
                      });
                    } else {
                      // Navigator.of(context).pop();
                      showAddTaskTypeDialog(context, widget.language);
                    }
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return items.map<Widget>((DropdownMenuItem<String> item) {
                      return ListTile(
                        minLeadingWidth: 0,
                        minTileHeight: 0,
                        contentPadding: const EdgeInsets.all(0),

                        leading:  Icon(
                            Icons.check_circle_rounded,
                            size: 38.sp,
                            color: Colors.white,
                            weight: 1000.w,
                          ),
                        title: Text(
                          item.value == "all_tasks"
                              ? "Barcha ro'yxatlar"
                              : item.value == "done"
                                  ? "Bajarildi"
                                  : item.value.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 21.sp,fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      );
                    }).toList();
                  },
                ),
              );
            },
          ),
        ),
        titleSpacing: 18.sp,
        actions: [
           IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreenPage(
              )), (route) => false);
              _focusNode.unfocus();
            },
            icon: Icon(
              Icons.home,
              size: 30.sp,
              color: Colors.white,
            ),
          ),
       
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TypePage(
                        language: widget.language,
                        lightMode: widget.lightMode)));
              },
              icon: Icon(
                Icons.list_alt,
                size: 30.sp,
                color: Colors.white,
              )),
          ],
     
           backgroundColor: widget.lightMode ? AppColors.primary : AppColors.appBar,
        foregroundColor: Colors.white,
           elevation: 3,
           shadowColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.standartColor, // Status bar rangini o'zgartirish
                statusBarIconBrightness: Brightness.light, // Ikonalar rangini o'zgartirish
              ),


      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Gap(5.h),
          _buildBody(),
        ],
      ),
      floatingActionButton: MyFloatinacshinbutton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPage(
                language: widget.language,
                dropMenu: 'task',
              )));
              _focusNode.unfocus();
      }),
      bottomNavigationBar: _taskType == 'done' ? null : Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 60.h,
          // color: Colors.blue[800],
          color: Color(0xfff005f99),
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt,
                color: Colors.white,
                size: 30.sp,
              ),
              Gap(10.w),
              Expanded(
                child: TaskField(
                  focusNode: _focusNode,
                  controller: _quickInformationController,
                  language: widget.language,
                  labelText: "Tezkor Vazifalarni Kiriting",
                  validator: false,
                  sufix: false,
                  maxLin: 1,
                  isDense: true,
                  color: Colors.white30,
                  onChanged: (v) {
                    _checkButtonQuery.value = v;
                    _enable = true;
                  },
                ),
              ),
              ValueListenableBuilder<String>(
                valueListenable: _checkButtonQuery,
                builder: (context, value, child) {
                  return _enable
                      ? value.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                _enable = false;
                                _submit1();
                                _quickInformationController.clear();
                                value.isEmpty;
                                _focusNode.unfocus();
                              },
                              iconSize: 30.sp,
                              color: Colors.white,
                            )
                          : const SizedBox(width: 0, height: 0)
                      : const SizedBox(width: 0, height: 0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
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
        if (snapshot.hasData) {
          List<TaskModel> tasks = snapshot.data!;
          if (tasks.isEmpty) {
            return const Center(
              child: Text("Hozircha ma'lumot mavjud emas."),
            );
          }

          // Tasklarni vaqt bo'yicha saralash
          tasks.sort((b, a) => a.date.compareTo(b.date));

          List<TaskModel> filteredTasks = tasks.where((task) {
            if (_taskType == 'all_tasks' && task.status == 0) return true;
            if (_taskType == 'done' && task.status == 1) return true;
            return false;
          }).toList();

          List<TaskModel> filteredTasksType = tasks.where((task) {
            if (_taskType == task.priority && task.status == 0) return true;
            return false;
          }).toList();

          return Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.isEmpty
                  ? filteredTasksType.length
                  : filteredTasks.length,
              itemBuilder: (context, index) {
                TaskModel task = filteredTasks.isEmpty
                    ? filteredTasksType[index]
                    : filteredTasks[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: _buildItem(task),
                );
              },
            ),
          );
        }

        return const Center(
          child: Text("Ma'lumot yuklanmoqda..."),
        );
      },
    );
  }

  Widget _buildItem(TaskModel task) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white12,
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TaskDetalPage(
                task: task,
                language: widget.language,
                lightMode: widget.lightMode))),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: task.status == 1,
                  onChanged: (bool? value) {
                    if (value != null) {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(task.docId)
                          .update({'status': value ? 1 : 0}).then((_) {
                        task.status = value ? 1 : 0;
                      });
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.task,
                        style: TextStyle(
                          color:
                              task.status == 0 ? Colors.white : Colors.blueGrey,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                       _allDate.format(task.date),
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_taskType == "all_tasks" || _taskType == 'done')
                        Text(
                          task.priority,
                          style:
                              TextStyle(fontSize: 15.sp, color: Colors.white),
                        )
                    ],
                  ),
                ),
                Gap(10.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
