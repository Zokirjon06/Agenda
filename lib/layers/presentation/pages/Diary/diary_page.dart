import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/presentation/pages/Diary/diary_task_date_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/standart_padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart'; // For date formatting

class DiaryPage extends StatefulWidget {
  final String language; // Add language field
  final bool lightMode;
  const DiaryPage({super.key, required this.language, required this.lightMode});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  // Stream for all tasks
  Stream<List<TaskModel>> getAllTaskStream() {
    final db = FirebaseFirestore.instance;
    return db.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data())..docId = doc.id)
          .toList();
    });
  }

 
  void _deleteTask(TaskModel task) {
    final db = FirebaseFirestore.instance;
    db.collection("tasks").doc(task.docId).delete();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.lightMode
          ? AppColors.homeBackgroundColor
          : const Color(0xFF112132),
      appBar: AppBar(
        backgroundColor: widget.lightMode
            ? AppColors.homeBackgroundColor
            : const Color(0xFF112132),
        title: const Text("kundalik"),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: StandartPadding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTasksByDateSection(),
              Gap(20.h),
              // _buildPlansSection(), // Plans bo'limi
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksByDateSection() {
    return StreamBuilder<List<TaskModel>>(
      stream: getAllTaskStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<TaskModel> tasks = snapshot.data!;

          Map<DateTime, List<TaskModel>> tasksByDate = {};
          for (var task in tasks) {
            DateTime taskDate = DateTime(
              task.date.year,
              task.date.month,
            );
            if (!tasksByDate.containsKey(taskDate)) {
              tasksByDate[taskDate] = [];
            }
            tasksByDate[taskDate]!.add(task);
          }

          List<DateTime> sortedDates = tasksByDate.keys.toList();
          sortedDates.sort();

          List<Widget> taskWidgets = [];
          for (var date in sortedDates) {
            String formattedDate = widget.language == 'eng'
                ? DateFormat.yMMMM('en_US').format(date)
                : widget.language == 'rus'
                    ? DateFormat.yMMMM('ru_RU').format(date)
                    : DateFormat.yMMMM('uz_UZ').format(date); // Format the date

            taskWidgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DiaryDetalPage(
                              language: widget.language, date: date)));
                      print("Date tapped: $formattedDate");
                    },
                    child: Text(
                      formattedDate, // Display the date
                      style: TextStyle(
                        fontSize: 23.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Date header color
                      ),
                    ),
                  ),
                  Gap(10.h),
                  ...tasksByDate[date]!.map((task) => _buildTaskCardItem(task)),
                  Gap(20.h),
                  const Divider()
                ],
              ),
            );
          }

          return Column(children: taskWidgets);
        }

        return const Center(
            child: Text("No tasks available",
                style: TextStyle(color: Colors.white)));
      },
    );
  }

  // Task card widget
  Widget _buildTaskCardItem(TaskModel task) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 0,
      color: widget.lightMode
          ? Colors.white10 // Light modeda oq fon
          : Color(0xFF112942), // Darker card background
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        title: Text(
          task.task,
          style: TextStyle(
            color: task.status == 0
                ? Colors.white
                : const Color.fromARGB(45, 158, 158, 158),
            decoration: task.status == 0
                ? TextDecoration.none
                : TextDecoration.lineThrough,
            decorationColor: const Color.fromARGB(255, 86, 83, 83),
            decorationStyle: TextDecorationStyle.solid,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          task.priority,
          style: TextStyle(
              color: task.status == 0
                  ? Colors.grey
                  : const Color.fromARGB(45, 158, 158, 158),
              decoration: task.status == 0
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
              decorationColor: const Color.fromARGB(255, 86, 83, 83),
              decorationStyle: TextDecorationStyle.solid),
        ),
        trailing: IconButton(
            onPressed: () {
              _deleteTask(task);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            )),
      ),
    );
  }

}
