import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/task_detal_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
class DayPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  final bool random;
  const DayPage(
      {super.key,
      required this.language,
      required this.lightMode,
      required this.random});

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final DateFormat _allDate;


  final List<String> items = [
    'Barcha ro\'yxatlar',
    'Vazifalar',
    'Rejalar',
    'Option 3',
    'Option 4'
  ];

  String? selectedValue = 'Barcha ro\'yxatlar';

  @override
  void initState() {
    _allDate = DateFormat.yMMMMEEEEd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Stream<List<TaskModel>> getAllTaskStream() {
    final db = FirebaseFirestore.instance;
    return db.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data())..docId = doc.id)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
        stream: getAllTaskStream(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center();
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            if (selectedValue == "Barcha ro'yxatlar") {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTaskCard(),
                  ],
                ),
              );
            }
          }
          return const Center();
        });
  }

  
  Widget _buildTaskCard() {
    return StreamBuilder<List<TaskModel>>(
      stream: getAllTaskStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: null);
        }
        if (snapshot.data == null) {
          return const Center();
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<TaskModel> tasks = snapshot.data!;

          tasks.sort((b, a) => a.date.compareTo(b
              .date)); 

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
            itemCount: tasks.length,
            itemBuilder: (context, index) => _buildTaskCardItem(tasks[index]),
          );
        }
        return const Center(child: null);
      },
    );
  }

  Widget _buildTaskCardItem(
    TaskModel task,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Gap(12.h),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(12.r), 
            color: Colors.white12
                ),
           
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              minVerticalPadding: 0,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TaskDetalPage(
                          task: task,
                          language: widget.language,
                          lightMode: widget.lightMode,
                        )));
              },
              leading:
                  Icon(Icons.task_alt_outlined, size: 45.sp, color: Colors.white),
              title: Text(
                task.task,
                style: TextStyle(
                  color: task.status == 0 ? Colors.white : Colors.blueGrey,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
              _allDate.format(task.date)  ,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }

}



