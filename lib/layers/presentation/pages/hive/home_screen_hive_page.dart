import 'package:agenda/layers/domain/models/hive_model/tasks/task_model_hive.dart';
import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/pages/hive/debts/add_debt_page.dart';
import 'package:agenda/layers/presentation/pages/hive/debts/detail/debt_detail_page.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/add_task_hive_page.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/task_detail_hive_page.dart';
import 'package:agenda/layers/presentation/pages/hive/tasks/task_list_hive_page.dart';
import 'package:agenda/layers/presentation/pages/hive/debts/debts_list_page.dart';
import 'package:agenda/layers/presentation/pages/hive/search/search_hive_page.dart';
import 'package:agenda/layers/presentation/pages/hive/settings/settings_hive_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreenHivePage extends StatefulWidget {
  final String language;
  const HomeScreenHivePage({super.key, required this.language});

  @override
  State<HomeScreenHivePage> createState() => _HomeScreenHivePageState();
}

class _HomeScreenHivePageState extends State<HomeScreenHivePage> {
  String langItem = 'uzb'; // Default language
  String selectedValue = "Barcha ro'yxatlar";

  @override
  void initState() {
    super.initState();
    // _initializeHiveBoxes();
  }

  // Future<void> _initializeHiveBoxes() async {
  //   try {
  //     await Hive.openBox<TaskModelHive>('tasksHiveBox');
  //     await Hive.openBox<TaskTypeModelHive>('taskTypesHiveBox');
  //     await Hive.openBox<DebtsModel>('debtsBox');
  //     await Hive.openBox<DebtsDetailModel>('debtsDetailBox');
  //   } catch (e) {
  //     debugPrint('Error initializing Hive boxes: $e');
  //   }
  // }

  List<DebtsModel> getUserDebtsFromHive() {
    try {
      final box = Hive.box<DebtsModel>('debtsBox');
      return box.values.toList();
    } catch (e) {
      debugPrint('Error getting debts from Hive: $e');
      return [];
    }
  }

  List<TaskModelHive> getAllTasksFromHive() {
    try {
      final box = Hive.box<TaskModelHive>('tasksHiveBox');
      return box.values.toList();
    } catch (e) {
      debugPrint('Error getting tasks from Hive: $e');
      return [];
    }
  }

  String getErrorText() {
    switch (langItem) {
      case 'eng':
        return 'Error: ';
      case 'rus':
        return 'Ошибка: ';
      case 'uzb':
        return 'Xato: ';
      default:
        return 'Error: ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      appBar: AppBar(
        title: Text(
          "Agenda - Hive",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchHivePage(
                    language: langItem,
                    lightMode: false,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.search,
              size: 30.sp,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsHivePage(
                    language: langItem,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.settings,
              size: 30.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.h),
              _dairyCard(),
              Gap(5.h),
              _debtsCard(),
              Gap(5.h),
              _taskCard(),
              Gap(5.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dairyCard() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 3,
            color: const Color.fromARGB(255, 2, 92, 165),
            shadowColor: Colors.black,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.edit_calendar_sharp,
                      size: 40.sp,
                      color: Colors.white,
                    ),
                    Gap(5.h),
                    Text(
                      "Qayd daftari",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Gap(5.h),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[900]),
                        child: Text(
                          "Yangi qayd",
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            elevation: 3,
            color: const Color.fromARGB(255, 2, 92, 165),
            shadowColor: Colors.black,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 40.sp,
                      color: Colors.white,
                    ),
                    Gap(5.h),
                    Text(
                      "Kunlik xarajatlar",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Gap(5.h),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[900]),
                        child: Text(
                          "Yangi xarajat",
                          style: TextStyle(
                              fontSize: 17.sp, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _debtsCard() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<DebtsModel>('debtsBox').listenable(),
        builder: (context, Box<DebtsModel> box, _) {
          List<DebtsModel> debts = box.values.toList();
          debts.sort((b, a) => a.date!.compareTo(b.date!));
          return Column(
            children: [
              if (debts.isEmpty)
                Card(
                  elevation: 3,
                  color: const Color.fromARGB(255, 2, 92, 165),
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qarzlar ro\'yxati',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddDebtPage(
                                            language: langItem,
                                          )));
                                },
                                icon: Icon(
                                  Icons.person_add_alt_1,
                                  color: Colors.white,
                                  size: 30.sp,
                                )),
                          ],
                        ),
                        const Divider(
                          color: Colors.black12,
                          height: 1,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // Prevent scrolling
                          itemCount: 2,
                          itemBuilder: (context, index) => ListTile(
                              leading: Container(
                                width: 55.w,
                                height: 55.h,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 13.h,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                              subtitle: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    height: 13.h,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8.r),
                                    )),
                              ),

                              // Gap(10.w),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 13.h,
                                    width: MediaQuery.of(context).size.width *
                                        0.12,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  Gap(8.h),
                                  Container(
                                    height: 13.h,
                                    width: MediaQuery.of(context).size.width *
                                        0.12,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ],
                              )
                              // ],
                              ),
                        ),
                        const Divider(
                          color: Colors.black12,
                          height: 1,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DebtsListPage(
                                      language: langItem,
                                    )));
                          },
                          child: Text(
                            "Hammasini ko'rish",
                            style: TextStyle(
                                color: Colors.blue[100],
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (debts.isNotEmpty)
                Card(
                  elevation: 3,
                  color: const Color.fromARGB(255, 2, 92, 165),
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qarzlar ro\'yxati',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddDebtPage(
                                            language: langItem,
                                          )));
                                },
                                icon: Icon(
                                  Icons.person_add_alt_1,
                                  color: Colors.white,
                                  size: 30.sp,
                                )),
                          ],
                        ),
                        Gap(10.h),
                        const Divider(
                          color: Colors.black12,
                          height: 1,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: debts.length < 5 ? debts.length : 5,
                          itemBuilder: (context, index) {
                            return _builUserDebtsItem(
                              debts[index],
                            );
                          },
                        ),
                        const Divider(
                          color: Colors.black12,
                          height: 1,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DebtsListPage(
                                      language: langItem,
                                    )));
                          },
                          child: Text(
                            "Hammasini ko'rish",
                            style: TextStyle(
                                color: Colors.blue[100],
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          );
        });
  }

  Widget _builUserDebtsItem(
    DebtsModel debt,
  ) {
    final int hash = debt.name.hashCode;
    final randomColor = Colors.primaries[hash % Colors.primaries.length];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            minTileHeight: 85.h,
            minVerticalPadding: 0, // Keraksiz bo'sh joyni oldini olish
            contentPadding: EdgeInsets.symmetric(
                horizontal: 0.w, vertical: 0), // Ichki bo'sh joyni kamaytirish
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DebtDetailPage(
                        language: widget.language,
                        debt: debt,
                      )));
            },
            leading: CircleAvatar(
              radius: 30.r,
              backgroundColor: randomColor,
              child: Text(
                debt.name!.isNotEmpty ? debt.name![0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            title: Text(
              "${debt.name}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              debt.debt == 'get' ? 'Qarzdor' : 'Qarzdorman',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${debt.money.toMoney()} so'm",
                  style: TextStyle(
                      color: debt.debt == 'get' ? Colors.green : Colors.red,
                      fontSize: 20.sp),
                ),
                Text(
                  DateFormat.MMMMd('uz_UZ').format(debt.date!),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget _taskCard() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<TaskModelHive>('tasksHiveBox').listenable(),
        builder: (context, Box<TaskModelHive> box, _) {
          List<TaskModelHive> tasks = box.values.toList();
          tasks.sort((b, a) => a.date.compareTo(b.date));
          return Column(
            children: [
              if (tasks.isEmpty)
                Card(
                  elevation: 3,
                  color: const Color.fromARGB(255, 2, 92, 165),
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vazifalar ro\'yxati',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddTaskHivePage(
                                            language: langItem,
                                          )));
                                },
                                icon: Icon(
                                  Icons.playlist_add_rounded,
                                  color: Colors.white,
                                  size: 40.sp,
                                )),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // Prevent scrolling
                          itemCount: 2,
                          itemBuilder: (context, index) => Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border:
                                    Border.all(color: Colors.grey, width: 3.w)),
                            margin: EdgeInsets.symmetric(vertical: 7.h),
                            child: ListTile(
                              leading: Container(
                                width: 55.w,
                                height: 55.h,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 13.h,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                              subtitle: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    height: 13.h,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8.r),
                                    )),
                              ),
                              trailing: Icon(
                                Icons.circle,
                                color: Colors.grey,
                                size: 23.sp,
                              ),
                            ),
                          ),
                        ),
                        Gap(10.h),
                        const Divider(
                          color: Colors.black12,
                          height: 1,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TaskListHiveScreenPage(
                                      language: langItem,
                                      lightMode: false,
                                    )));
                          },
                          child: Text(
                            "Hammasini ko'rish",
                            style: TextStyle(
                                color: Colors.blue[100],
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (tasks.isNotEmpty)
                Card(
                  elevation: 3,
                  color: const Color.fromARGB(255, 2, 92, 165),
                  shadowColor: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vazifalar ro\'yxati',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AddTaskHivePage(
                                            language: langItem,
                                          )));
                                },
                                icon: Icon(
                                  Icons.playlist_add_rounded,
                                  color: Colors.white,
                                  size: 40.sp,
                                )),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // Prevent scrolling
                          itemCount: tasks.length < 5 ? tasks.length : 5,
                          itemBuilder: (context, index) {
                            return _buildTaskCardItem(tasks[index]);
                          },
                        ),
                        Gap(12.h),
                        const Divider(
                          color: Colors.black12,
                          height: 1,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TaskListHiveScreenPage(
                                      language: langItem,
                                      lightMode: false,
                                    )));
                          },
                          child: Text(
                            "Hammasini ko'rish",
                            style: TextStyle(
                                color: Colors.blue[100],
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        });
  }

  Widget _buildTaskCardItem(
    TaskModelHive task,
  ) {
    return Column(
      children: [
        Gap(12.h),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white12),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
            minVerticalPadding: 0,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TaskDetailHivePage(
                        task: task,
                        language: langItem,
                        lightMode: false,
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
              DateFormat.yMMMd().format(task.date),
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
