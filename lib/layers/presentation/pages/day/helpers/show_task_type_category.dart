import 'package:agenda/layers/domain/models/firebase_model/tasks/task_type_model.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/type/type_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/show_dialog/show_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Firebase'dan barcha vazifa turlarini olish uchun Stream
Stream<List<TaskTypeModel>> getAllTaskTypesStream() {
  final db = FirebaseFirestore.instance;
  return db.collection('tasktype').snapshots().map((snapshot) {
    return snapshot.docs
        .map((doc) => TaskTypeModel.fromJson(doc.data())..docId = doc.id)
        .toList();
  });
}

/// Yangi vazifa turini qo'shish funksiyasi
Future<void> addTaskType(String name, BuildContext context) async {
  DateTime date = DateTime.now();
  final db = FirebaseFirestore.instance;
  try {
    TaskTypeModel taskType = TaskTypeModel(name: name, date: date);
    await db.collection('tasktype').add(taskType.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vazifa turi muvaffaqiyatli qo\'shildi')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Xato yuz berdi: $e')),
    );
  }
}

/// Vazifa turlarini ko'rsatuvchi modal oynani ochish
Future<TaskTypeModel?> showExpenseCategory({
  required BuildContext context,
  required TextEditingController controller,
  required String language,
  required bool lightMode,
  required TaskTypeModel? selectedItem,
}) async {
  await showModalBottomSheet(
    useSafeArea: true,
    showDragHandle: true,
    // isScrollControlled: true,
    // scrollControlDisabledMaxHeightRatio: 0.6,    
    context: context,
    backgroundColor: AppColors.primary,
    builder: (context) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Vazifalar Ro'yxati",
                style: TextStyle(fontSize: 25.sp, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          TypePage(language: language, lightMode: lightMode)));
                },
                icon: const Icon(Icons.list_alt),
                color: Colors.white,
                iconSize: 30.sp,
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<TaskTypeModel>>(
              stream: getAllTaskTypesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text('Ma\'lumotlarni yuklashda xatolik'),
                  );
                }

                final taskTypes = snapshot.data!;
                taskTypes.sort((a, b) => a.date.compareTo(b.date));
                return ListView.builder(
                  itemCount: taskTypes.length,
                  itemBuilder: (context, index) {
                    final item = taskTypes[index];
                    // final isSelected = item.docId == selectedItem!.docId;
                    return ListTile(
                      // tileColor: isSelected == true ? Colors.white : Colors.transparent,
                      onTap: () {
                        selectedItem = item;
                        Navigator.of(context).pop();
                      },
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 10.w,
                      ),
                      leading: Icon(
                        Icons.list,
                        size: 30.sp,
                        color: Colors.white,
                      ),
                      title: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    },
  );
  return selectedItem;
}
