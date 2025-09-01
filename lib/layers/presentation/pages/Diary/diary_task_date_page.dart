import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/presentation/widget/standart_padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class DiaryDetalPage extends StatelessWidget {
  final String language;
  final DateTime date;

  const DiaryDetalPage({super.key, required this.language, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 19, 44),
      appBar: AppBar(
        title: Text( language == 'eng'
                                ? DateFormat.yMMMM('en_US').format(date)
                                : language == 'rus'
                                    ? DateFormat.yMMMM('ru_RU')
                                        .format(date)
                                    : DateFormat.yMMMM('uz_UZ')
                                        .format(date),style: const TextStyle(color: Colors.green),),
      ),
      body: SingleChildScrollView(child: _View(language: language, date: date)),
    );
  }
}

// ----------------------------------------------------------------
// View
// ----------------------------------------------------------------
class _View extends StatefulWidget {
  final String language;
  final DateTime date;
  const _View({required this.language, required this.date});

  @override
  State<_View> createState() => __ViewState();
}

class __ViewState extends State<_View> {
  Stream<List<TaskModel>> getTasksListStream() {
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
      stream: getTasksListStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<TaskModel> debtorList = snapshot.data!;

          // Tanlangan oydagi qarzdorlarni filtrlaymiz
          List<TaskModel> monthlyDebtors = debtorList.where((debt) {
            return debt.date.year == widget.date.year &&
                debt.date.month == widget.date.month;
          }).toList();

          if (monthlyDebtors.isEmpty) {
            return const Center(
              child: Text("No debts available for this month",
                  style: TextStyle(color: Colors.white)),
            );
          }

          return Column(
            children: [
              StandartPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: monthlyDebtors
                      .map((task) => ListTile(
                          // onTap: () => Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (context) => DebtorDetalPage(
                          //           language: widget.language,
                          //           debtors: task,
                          //         ),
                          //       ),
                          //     ),
                         
                          title: Text(
                            task.task,
                            style: TextStyle(
                              color: task.status == 0
                                  ? Colors.white
                                  : const Color.fromARGB(45, 158, 158, 158),
                              decoration: task.status == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                              decorationColor:
                                  const Color.fromARGB(255, 86, 83, 83),
                              decorationStyle: TextDecorationStyle.solid,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            task.priority,
                            style: TextStyle(
                              color: task.status == 0
                                  ? Colors.white
                                  : const Color.fromARGB(45, 158, 158, 158),
                              decoration: task.status == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                              decorationColor:
                                  const Color.fromARGB(255, 86, 83, 83),
                              decorationStyle: TextDecorationStyle.solid,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            widget.language == 'eng'
                                ? DateFormat.MMMMd('en_US').format(task.date)
                                : widget.language == 'rus'
                                    ? DateFormat.MMMMd('ru_RU')
                                        .format(task.date)
                                    : DateFormat.MMMMd('uz_UZ')
                                        .format(task.date),
                            style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.bold,
                                color: task.status == 0 ? Colors.green: const Color.fromARGB(45, 158, 158, 158),decoration: task.status == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough, decorationColor:
                                  const Color.fromARGB(255, 86, 83, 83),
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                          )))
                      .toList(),
                ),
              ),
              Gap(20.h),
            ],
          );
        }

        return const Center(
          child:
              Text("No debts available", style: TextStyle(color: Colors.white)),
        );
      },
    );
  }
}
