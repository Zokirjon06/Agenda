import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/tasks/task_type_model.dart';
import 'package:agenda/layers/presentation/pages/day/helpers/show_task_type_category.dart';
import 'package:agenda/layers/presentation/pages/main/main_screen.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  final bool pop;
  const AddTaskPage(
      {super.key,
      required this.language,
      required this.lightMode,
      required this.pop});

  @override
  State<AddTaskPage> createState() => _AddtaskPageState();
}

class _AddtaskPageState extends State<AddTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _taskController;
  late final TextEditingController _dateController;
  DateTime _date = DateTime.now();
  late final DateFormat _allDate;
  TaskTypeModel? _selectedCategory;
  late final TextEditingController _priorityController;

  @override
  void initState() {
    super.initState();
    _allDate = DateFormat.yMMMMEEEEd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
    _priorityController = TextEditingController();
    _taskController = TextEditingController();
    _dateController =
        TextEditingController(text: _allDate.format(DateTime.now()));
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
      final db = FirebaseFirestore.instance;
      TaskModel task = TaskModel(
        task: _taskController.text.trim(),
        date: _date,
        priority:
            _selectedCategory == null ? 'Standart' : _selectedCategory!.name,
      );

      var myTask = await db.collection('tasks').add(task.toJson());
      await db.collection("tasks").doc(myTask.id).update({"docId": myTask.id});
      _showSnackBar("Ma'lumot saqlandi!");
      
    } catch (e) {
      _showSnackBar("Xato: ${e.toString()}");
    } 
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
        });
    return date;
  }

  _clicked() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final date = await _handleDatePicker(_date);
    if (date != null) {
      _date = date;
      _dateController.text = _allDate.format(date);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.lightMode
          ? AppColors.homeBackgroundColor
          : AppColors.standartColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
           backgroundColor: widget.lightMode ? AppColors.primary : Color(0xff005a80),
           elevation: 3,
           shadowColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.standartColor, // Status bar rangini o'zgartirish
                statusBarIconBrightness: Brightness.light, // Ikonalar rangini o'zgartirish
              ),

        // elevation: 3,
        // shadowColor: Colors.black,
        // backgroundColor:
        //     widget.lightMode ? AppColors.primary : AppColors.standartColor,
        title: Text(
          widget.language == 'eng'
              ? 'New task'
              : widget.language == 'rus'
                  ? 'Добавить задачу'
                  : "Yangi vazifa",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(child: _buildBody(),),
      floatingActionButton: MyFloatinacshinbutton(onPressed: (){
          if (_formKey.currentState!.validate()) {
                  _submit();
                  if (widget.pop) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                }
                
      },icon: Icons.check,),
    );

  }

  Widget _buildBody() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
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
                  style: TextStyle(color: Colors.blue[200],fontSize: 17.sp,fontWeight: FontWeight.bold),
                ),
                Gap(10.h),
                TaskField(
                  controller: _taskController,
                  labelText: widget.language == 'eng'
                      ? 'Task'
                      : widget.language == 'rus'
                          ? 'Задача'
                          : "Vazifa",
                  icon: Icons.task_outlined,
                  language: widget.language,
                  minLin: 1,
                  maxLin: null,
                  validator: true,
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
                  style: TextStyle(color: Colors.blue[200],fontSize: 17.sp,fontWeight: FontWeight.bold),
                ),
                Gap(10.h),
                TaskField(
                  controller: _dateController,
                  onTap: () {
                    _clicked();
                    // FocusScope.of(context).requestFocus(FocusNode());
                    // _handleDatePicker();
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
                  style: TextStyle(color: Colors.blue[200],fontSize: 17.sp,fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    _selectedCategory = await showExpenseCategory(
                        context: context,
                        controller: _priorityController,
                        language: widget.language,
                        lightMode: widget.lightMode,
                        selectedItem: _selectedCategory);
                    if (_selectedCategory != null) {
                      setState(() {});
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
                Gap(20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
