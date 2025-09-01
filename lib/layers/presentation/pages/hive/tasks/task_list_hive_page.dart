import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/presentation/helpers/snackbar_message.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/add_task_hive_page.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/task_detail_hive_page.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/type/task_type_hive_page.dart';
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

class TaskListHiveScreenPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  final String? typeval;
  const TaskListHiveScreenPage(
      {super.key,
      required this.language,
      required this.lightMode,
      this.typeval});

  @override
  State<TaskListHiveScreenPage> createState() => _TaskListHiveScreenPageState();
}

class _TaskListHiveScreenPageState extends State<TaskListHiveScreenPage> {
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
    if (_quickInformationController.text.isNotEmpty) {
      try {
        final box = await Hive.openBox<TaskModelHive>('tasksHiveBox');
        const uuid = Uuid();
        TaskModelHive task = TaskModelHive(
            task: _quickInformationController.text.trim(),
            date: DateTime.now(),
            priority: _taskType != 'all_tasks' ? _taskType! : "Standart",
            docId: uuid.v4());

        await box.add(task);
        if (mounted) {
          showMessage(context: context, message: 'Malumot saqlandi');
        }
      } catch (e) {
        if (mounted) {
          showMessage(context: context, message: "Xato: ${e.toString()}");
        }
      } finally {
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  List<TaskModelHive> getAllTasksFromHive() {
    final box = Hive.box<TaskModelHive>('tasksHiveBox');
    return box.values.toList();
  }

  List<TaskTypeModelHive> getAllTaskTypesFromHive() {
    final box = Hive.box<TaskTypeModelHive>('taskTypesHiveBox');
    return box.values.toList();
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
        leading: const AppbarLeadingIcon(),
        title: DropdownButtonHideUnderline(
          child: _buildTaskTypeDropdown(),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TaskTypeHivePage(
                    language: widget.language,
                    lightMode: widget.lightMode,
                  ),
                ),
              );
              _focusNode.unfocus();
            },
            icon: Icon(
              Icons.list_alt,
              size: 30.sp,
              color: Colors.white,
            ),
          ),
         
        ],
        backgroundColor: widget.lightMode ? AppColors.primary : AppColors.appBar,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.standartColor,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Gap(5.h),
          _buildBody(),
        ],
      ),
      floatingActionButton: MyFloatinacshinbutton(onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddTaskHivePage(
                  language: widget.language,
                )));
        _focusNode.unfocus();
      }),
      bottomNavigationBar: _taskType == 'done' ? null : _buildBottomBar(),
    );
  }

  Widget _buildTaskTypeDropdown() {
    List<TaskTypeModelHive> taskTypes = getAllTaskTypesFromHive();

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
            widget.language == 'eng'
                ? "All Lists"
                : widget.language == 'rus'
                    ? "Все списки"
                    : "Barcha ro'yxatlar",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 21.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    ];

    // Add task types from Hive
    final sortedTaskTypes = List<TaskTypeModelHive>.from(taskTypes)
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
              style: TextStyle(
                  fontSize: 21.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      );
    }

    items.add(
      DropdownMenuItem(
        value: "done",
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          minTileHeight: 0,
          minVerticalPadding: 0,
          leading: Icon(Icons.check_box_sharp, color: Colors.white, size: 30.sp),
          title: Text(
            widget.language == 'eng'
                ? "Completed"
                : widget.language == 'rus'
                    ? "Завершено"
                    : "Bajarildi",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 21.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton<String>(
        icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 30.sp),
        isExpanded: true,
        value: _taskType,
        dropdownColor: AppColors.another,
        items: items,
        onChanged: (v) {
          setState(() {
            _taskType = v;
          });
        },
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((DropdownMenuItem<String> item) {
            return ListTile(
              minLeadingWidth: 0,
              minTileHeight: 0,
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                item.value == "all_tasks"
                    ? (widget.language == 'eng'
                        ? "All Lists"
                        : widget.language == 'rus'
                            ? "Все списки"
                            : "Barcha ro'yxatlar")
                    : item.value == "done"
                        ? (widget.language == 'eng'
                            ? "Completed"
                            : widget.language == 'rus'
                                ? "Завершено"
                                : "Bajarildi")
                        : item.value.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 21.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 60.h,
        color: const Color(0xFF005F99),
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
    );
  }

  Widget _buildBody() {
    List<TaskModelHive> tasks = getAllTasksFromHive();

    if (tasks.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("Hozircha ma'lumot mavjud emas.",
                     style: TextStyle(color: Colors.white)),
        ),
      );
    }

    // Sort tasks by date
    tasks.sort((b, a) => a.date.compareTo(b.date));

    List<TaskModelHive> filteredTasks = tasks.where((task) {
      if (_taskType == 'all_tasks' && task.status == 0) return true;
      if (_taskType == 'done' && task.status == 1) return true;
      return false;
    }).toList();

    List<TaskModelHive> filteredTasksType = tasks.where((task) {
      if (_taskType == task.priority && task.status == 0) return true;
      return false;
    }).toList();

    return Expanded(
      child: ListView.builder(
        itemCount: filteredTasks.isEmpty
            ? filteredTasksType.length
            : filteredTasks.length,
        itemBuilder: (context, index) {
          TaskModelHive task = filteredTasks.isEmpty
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

  Widget _buildItem(TaskModelHive task) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white12,
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TaskDetailHivePage(
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
                      task.status = value ? 1 : 0;
                      task.save();
                      setState(() {});
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
                          color: task.status == 0 ? Colors.white : Colors.blueGrey,
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
                          style: TextStyle(fontSize: 15.sp, color: Colors.white),
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
