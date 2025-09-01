import 'dart:async';
import 'dart:io';

import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/tasks/task_type_model.dart';
import 'package:agenda/layers/domain/models/hive_model/vois_recording_model/vois_recording_model.dart';
import 'package:agenda/layers/presentation/pages/add/expenses/add_debts_page.dart';
import 'package:agenda/layers/presentation/pages/day/helpers/show_task_type_category.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/task_list_page.dart';
import 'package:agenda/layers/presentation/pages/debts/debts_list_page.dart';
import 'package:agenda/layers/presentation/pages/main/home_screen_page.dart';
import 'package:agenda/layers/presentation/pages/main/main_screen.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:agenda/layers/presentation/widget/vois_recorder_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ----------------------------------------------------------------
// View
// ----------------------------------------------------------------
class AddPage extends StatefulWidget {
  final String language;
  final String? dropMenu;
  // final bool lightMode;
  const AddPage({super.key, required this.language, this.dropMenu});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? _dropMenu = 'all';
  bool debt = false;
  bool task = false;
  bool voice = false;
  bool setting = false;

  String? _selectedLanguage = 'eng';
  var auth = Hive.box("language");

  @override
  void initState() {
    _dropMenu = widget.dropMenu ?? 'all';
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      _selectedLanguage = prefs.getString('selectedlanguage') ?? 'eng';
    });
  }

  void _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedlanguage', language);
    auth.put("language", language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 3,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.standartColor,
          statusBarIconBrightness: Brightness.light,
        ),
        titleSpacing: 15.w,
        leading: SizedBox(
          width: 0.w,
          height: 0.h,
        ),
        leadingWidth: 0,
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _dropMenu,
            dropdownColor: Colors.blue[900],
            icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 30.sp),
            items: [
              DropdownMenuItem(
                value: "all",
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  leading: Icon(Icons.edit_calendar_sharp,
                      color: Colors.white, size: 30.sp),
                  title: Text("Yangi qayd",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              DropdownMenuItem(
                value: "debt",
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  leading: Icon(Icons.account_balance_wallet_outlined,
                      color: Colors.white, size: 32.sp),
                  title: Text("Yangi qarz",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              
              DropdownMenuItem(
                value: "task",
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  leading: Icon(Icons.task_alt_rounded,
                      color: Colors.white, size: 30.sp),
                  title: Text("Yangi vazifa",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              DropdownMenuItem(
                value: "voice",
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  leading: Icon(Icons.mic, color: Colors.white, size: 30.sp),
                  title: Text("Ovoz yozish",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ],
            onChanged: (v) {
              setState(() {
                _dropMenu = v!;
              });
            },
            selectedItemBuilder: (BuildContext context) {
              return [
                "all",
                "debt",
                "task",
                "voice",
              ].map<Widget>((value) {
                return Row(
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 37.sp,
                      color: Colors.white,
                      weight: 1000.w,
                    ),
                    Gap(10.w),
                    Text(
                      value == "all"
                          ? "Yangi qayd"
                          : value == "debt"
                              ? "Yangi qarz"
                              : value == "task"
                                  ? "Yangi vazifa"
                                  : "Ovoz yozish",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Gap(25.w),
                  ],
                );
              }).toList();
            },
          ),
        ),
        actions: [
          IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreenPage()),
                (route) => false);
          },
          icon: const Icon(
            Icons.home,
          ),
          color: Colors.white,
          iconSize: 30.sp,
        ),
          IconButton(
              onPressed: () {
                if (_dropMenu == 'all') {
                return;
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => _dropMenu == 'debt'
                            ? DebtsListScreenPage(
                                language: widget.language,
                              )
                            : _dropMenu == 'task'
                                ? TaskListScreenPage(
                                    language: _selectedLanguage!,
                                    lightMode: false)
                                : VoisListItem(
                                    language: _selectedLanguage!,
                                    lightMode: false)),
                  );
                }
              },
              icon: Icon(
                _dropMenu == 'all'
                    ? Icons.edit_calendar_sharp
                    : _dropMenu == 'debt'
                        ? Icons.person
                        : _dropMenu == 'task'
                            ? Icons.format_list_bulleted_outlined
                            : Icons.play_arrow,
                size: _dropMenu == 'voice' ? 40.sp : 30.sp,
              )),
        ],
      ),
      body: _dropMenu == 'all'
          ? AddNote(
              language: auth.values.first,
            )
          : _dropMenu == 'debt'
              ? addDebt(
                  language: auth.values.first,
                )
              : _dropMenu == 'task'
                  ? _addTask(language: auth.values.first)
                  : _voiceRecording(language: auth.values.first),
    );
  }
}

// ------------------------------------------------------------
// AddNote
// ------------------------------------------------------------
class AddNote extends StatefulWidget {
  final String language;
  const AddNote({super.key, required this.language});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _noteController;
  late final TextEditingController _dateController;
  final FocusNode _focusNode = FocusNode();
  DateTime _date = DateTime.now();
  late final DateFormat _allDate;

  @override
  void initState() {
    _allDate = DateFormat.yMMMMEEEEd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
    _noteController = TextEditingController();
    _dateController = TextEditingController(text: _allDate.format(_date));
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => TaskListScreenPage(
                        language: widget.language,
                        lightMode: false,
                      )),
            );
          }
        },
        icon: Icons.check,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gap(20.h),
                  TextFormField(
                    controller: _noteController,
                    focusNode: _focusNode,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: widget.language == 'eng'
                            ? 'Notes'
                            : widget.language == 'rus'
                                ? 'Notes'
                                : "Bugun nima qildingiz",
                        hintStyle:
                            TextStyle(color: Colors.white70, fontSize: 18.sp),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white70, width: 1.5.w),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.lightBlueAccent, width: 2.5.w),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r))),
                        disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r))),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)))),
                  ),
                  Gap(20.h),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      final date = await _handleDueDatePicker(_date);
                      if (date != null) {
                        _date = date;
                        _dateController.text = _allDate.format(date);
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: widget.language == 'eng'
                            ? 'Date'
                            : widget.language == 'rus'
                                ? 'Notes'
                                : "Sana",
                        hintStyle:
                            TextStyle(color: Colors.white70, fontSize: 18.sp),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white70, width: 1.5.w),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.lightBlueAccent, width: 2.5.w),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r))),
                        disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white70),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r))),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)))),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future<DateTime?> _handleDueDatePicker(DateTime? initialDate) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(2100),
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
}

// ------------------------------------------------------------
// AddTask
// ------------------------------------------------------------
class _addTask extends StatefulWidget {
  final String language;
  const _addTask({required this.language});

  @override
  State<_addTask> createState() => __addTaskState();
}

class __addTaskState extends State<_addTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _taskController;
  late final TextEditingController _dateController;
  DateTime _date = DateTime.now();
  late final DateFormat _allDate;
  TaskTypeModel? _selectedCategory;
  late final TextEditingController _priorityController;

  // initState and dispose
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

  // function
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

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      body: _buildBody(),
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _submit();
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => TaskListScreenPage(
                        language: widget.language,
                        lightMode: false,
                      )),
            );
          }
        },
        icon: Icons.check,
      ),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                  style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                ),
                Gap(10.h),
                TaskField(
                  controller: _taskController,
                  labelText: widget.language == 'eng'
                      ? 'Task'
                      : widget.language == 'rus'
                          ? 'Задача'
                          : "Vazifa",
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
                  style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
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
                  style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    _selectedCategory = await showExpenseCategory(
                        context: context,
                        controller: _priorityController,
                        language: widget.language,
                        lightMode: true,
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

// --------------------------------------------------------------------
// --------------------------------------------------------------------
// VoiceRecording
// --------------------------------------------------------------------
// --------------------------------------------------------------------

class _voiceRecording extends StatefulWidget {
  final String language;
  const _voiceRecording({
    required this.language,
  });

  @override
  __voiceRecordingState createState() => __voiceRecordingState();
}

// (Yuqoridagi kodlar o'zgarmasdan qoladi)

class __voiceRecordingState extends State<_voiceRecording>
    with SingleTickerProviderStateMixin {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _filePath;
  Timer? _timer;
  int _elapsedSeconds = 0;
  late AnimationController _animationController;
  int _fileSize = 0; // Yozuv fayl hajmini saqlash uchun o'zgaruvchi

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mikrofon uchun ruxsat kerak!')),
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
      _updateFileSize(); // Fayl hajmini yangilash
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
    });
  }

  Future<void> _startRecording() async {
    if (await Permission.microphone.isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      _filePath =
          '${directory.path}/voice_recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder!.startRecorder(toFile: _filePath);
      setState(() {
        _isRecording = true;
      });
      _startTimer();
    }
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    _stopTimer();
    setState(() {
      _isRecording = false;
    });
    await _saveToHive();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  Future<void> _saveToHive() async {
    if (_filePath == null) return;
    try {
      final box = await Hive.openBox<VoiceRecordingModel>('voice_records');
      final voiceRecord = VoiceRecordingModel(
        filePath: _filePath!,
        description: 'Offline Record',
        date: DateTime.now(),
      );
      await box.add(voiceRecord);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ovoz muvaffaqiyatli saqlandi!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik: $e')),
      );
    }
  }

  // Fayl hajmini yangilash uchun metod
  Future<void> _updateFileSize() async {
    if (_filePath != null) {
      final file = File(_filePath!);
      if (await file.exists()) {
        final sizeInBytes = await file.length();
        setState(() {
          _fileSize = sizeInBytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String fileSizeText = _fileSize == 0
        ? 'Ovoz yozishni boshlash uchun tugmani bosing.'
        : _formatFileSize(_fileSize);

    return Scaffold(
      backgroundColor: AppColors.standartColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${(_elapsedSeconds ~/ 3600).toString().padLeft(2, '0')}:${(_elapsedSeconds % 3600 ~/ 60).toString().padLeft(2, '0')}:${(_elapsedSeconds % 60).toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 60.sp, color: Colors.lightBlueAccent),
          ),
          Gap(15.h),
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ElevatedButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15.0),
                    // backgroundColor: _isRecording
                    //     ? Colors.redAccent.withOpacity(
                    //         0.5 + (_animationController.value * 0.5))
                    backgroundColor: Colors.blue
                      ..withOpacity(0.5 + (_animationController.value * 0.5)),
                    elevation: 10,
                  ).copyWith(
                    elevation: WidgetStateProperty.all(
                        10 + (_animationController.value * 5)),
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 45.sp,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            fileSizeText,
            style: TextStyle(fontSize: 18.sp, color: Colors.lightBlueAccent),
          ),
        ],
      ),
    );
  }

  // Fayl hajmini formata keltirish metod
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return 'Yozib olingan: ${bytes}B'; // Baytlar
    } else if (bytes < 1024 * 1024) {
      return 'Yozib olingan: ${(bytes / 1024).toStringAsFixed(1)} KB'; // KB
    } else if (bytes < 1024 * 1024 * 1024) {
      return 'Yozib olingan: ${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB'; // MB
    } else {
      return 'Yozib olingan: ${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB'; // GB
    }
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
