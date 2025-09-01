import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/pages/add/add_page.dart';
import 'package:agenda/layers/presentation/pages/add/expenses/add_expense_page.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/task_detal_page.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/task_list_page.dart';
import 'package:agenda/layers/presentation/pages/debts/debts_list_page.dart';
import 'package:agenda/layers/presentation/pages/debts/detals/user_debts_detal_page.dart';
import 'package:agenda/layers/presentation/pages/hive/debts/debts_list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomePageHive extends StatefulWidget {
  const HomePageHive({super.key});

  @override
  State<HomePageHive> createState() => _HomePageHiveState();
}

class _HomePageHiveState extends State<HomePageHive> {
  late final DateFormat _allDate;
  var lang = Hive.box("language");
  // late String langItem = lang.values.first;
  late String langItem = 'uzb';
  @override
  void initState() {
    _allDate = DateFormat.yMMMMEEEEd(langItem == 'eng'
        ? 'en_US'
        : langItem == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DebtsListPage(language: langItem.toString(),),
      // backgroundColor: AppColors.standartColor,
      // appBar: AppBar(
      //   backgroundColor: AppColors.appBar,
      //   foregroundColor: Colors.white,
      //   shadowColor: Colors.black,
      //   elevation: 3,
      //   title: Text(
      //     langItem == 'eng'
      //         ? 'Agenda'
      //         : langItem == 'rus'
      //             ? 'Повестка дня'
      //             : 'Kun tartibi',
      //     style: TextStyle(
      //         fontSize: 22.sp,
      //         fontWeight: FontWeight.bold,
      //         color: Colors.white),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.of(context).push(
      //           MaterialPageRoute(
      //               builder: (context) => SearchPage(
      //                     language: langItem,
      //                     lightMode: false,
      //                   )),
      //         );
      //       },
      //       icon: const Icon(Icons.search),
      //       iconSize: 30.sp,
      //       color: Colors.white,
      //     ),
      //     PopupMenuButton<String>(
      //       color: AppColors.appBar,
      //       icon: Icon(
      //         Icons.more_vert_rounded,
      //         color: Colors.white,
      //         size: 30.sp,
      //       ),
      //       onSelected: (value) {
      //         if (value == 'more') {
      //           //
      //         } else if (value == 'follow') {
      //           //
      //         } else if (value == 'share') {
      //           //
      //         } else if (value == 'setting') {
      //           Navigator.of(context).push(
      //             MaterialPageRoute(
      //                 builder: (context) =>
      //                     SettingsPage(language: langItem, lightMode: false)),
      //           );
      //         }
      //       },
      //       itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      //         PopupMenuItem<String>(
      //           value: 'more',
      //           child: Text(
      //             'Ko\'proq ilovalar',
      //             style: TextStyle(
      //                 fontSize: 19.sp,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.white),
      //           ),
      //         ),
      //         PopupMenuItem<String>(
      //           value: 'follow',
      //           child: Text('Ortimizdan yuring',
      //               style: TextStyle(
      //                   fontSize: 19.sp,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.white)),
      //         ),
      //         PopupMenuItem<String>(
      //           value: 'share',
      //           child: Text('Do\'stlar bilan ulashing',
      //               style: TextStyle(
      //                   fontSize: 19.sp,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.white)),
      //         ),
      //         PopupMenuItem<String>(
      //           value: 'setting',
      //           child: Text('Sozlamalar',
      //               style: TextStyle(
      //                   fontSize: 19.sp,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.white)),
      //         ),
      //       ],
      //     ),

      //     // IconButton(
      //     //     onPressed: () {
      //     // Navigator.of(context).push(
      //     //   MaterialPageRoute(
      //     //       builder: (context) =>
      //     //           SettingsPage(language: langItem, lightMode: false)),
      //     // );
      //     //     },
      //     //     icon: Icon(
      //     //       Icons.settings,
      //     //       size: 25.sp,
      //     //     ))
      //   ],
      // ),
      // body: _buildBody(),
      // floatingActionButton: MyFloatinacshinbutton(onPressed: () {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //         builder: (context) => AddPage(
      //               language: langItem,
      //               dropMenu: 'all',
      //             )),
      //   );
      // }),
    );
  }

  Stream<List<DebtsListModel>> getUserDebtsStream() {
    final db = FirebaseFirestore.instance;
    return db.collection('debtsList').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DebtsListModel.fromJson(doc.data())..docId = doc.id)
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

  Widget _buildBody() {
    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.h),
              _dairyCard(),
              Gap(10.h),
              _debtsCard(),
              Gap(10.h),
              _taskCard(),
              Gap(10.h),
            ],
          ),
        ),
      ),
    ]);
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
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddPage(
                                    language: langItem,
                                    dropMenu: 'all',
                                  )));
                        },
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
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AddExpensePage(language: langItem)));
                        },
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
    return StreamBuilder(
        stream: getUserDebtsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center();
          }
          if (snapshot.hasError) {
            return Center(child: Text('${getErrorText()}${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Card(
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
                                  builder: (context) => AddPage(
                                        language: langItem,
                                        dropMenu: 'debt',
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
                              width: MediaQuery.of(context).size.width * 0.2,
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
                                width: MediaQuery.of(context).size.width * 0.4,
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
                                width: MediaQuery.of(context).size.width * 0.12,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              Gap(8.h),
                              Container(
                                height: 13.h,
                                width: MediaQuery.of(context).size.width * 0.12,
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
                            builder: (context) => DebtsListScreenPage(
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
            );
          }

          List<DebtsListModel> debt = List.from(snapshot.data!);
          debt.sort((b, a) => a.date!.compareTo(b.date!));

          return Card(
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
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => DebtsListScreenPage(
                      //               language: langItem,
                      //             )));
                      //   },
                      //   child: Text(
                      //     "Hammasini ko'rish",
                      //     style: TextStyle(
                      //         color: Colors.blue[300],
                      //         fontSize: 18.sp,
                      //         fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddPage(
                                      language: langItem,
                                      dropMenu: 'debt',
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
                    itemCount: debt.length < 5 ? debt.length : 5,
                    itemBuilder: (context, index) {
                      return _builUserDebtsItem(
                        debt[index],
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
                          builder: (context) => DebtsListScreenPage(
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
          );
        });
  }

  Widget _builUserDebtsItem(
    DebtsListModel debt,
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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserDebtsDetailPage(
                      language: langItem,
                      debts: debt,
                      lightMode: false,
                    ))),
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
    return StreamBuilder<List<TaskModel>>(
      stream: getAllTaskStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        }
        if (snapshot.data == null) {
          return const Center();
        }
        if (snapshot.data!.isEmpty) {
          return Card(
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
                                builder: (context) => AddPage(
                                      language: langItem,
                                      dropMenu: 'task',
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
                          border: Border.all(color: Colors.grey, width: 3.w)),
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
                            width: MediaQuery.of(context).size.width * 0.4,
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
                              width: MediaQuery.of(context).size.width * 0.2,
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
                          builder: (context) => TaskListScreenPage(
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
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<TaskModel> tasks = snapshot.data!;

          tasks.sort((b, a) => a.date.compareTo(b.date));

          return Card(
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
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => TaskListScreenPage(
                      //               language: langItem,
                      //               lightMode: false,
                      //             )));
                      //   },
                      //   child: Text(
                      //     "Hammasini ko'rish",
                      //     style: TextStyle(
                      //         color: Colors.blue[300],
                      //         fontSize: 18.sp,
                      //         fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddPage(
                                      language: langItem,
                                      dropMenu: 'task',
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
                          builder: (context) => TaskListScreenPage(
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
          );
        }
        return const Center(child: null);
      },
    );
  }

  Widget _buildTaskCardItem(
    TaskModel task,
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
                  builder: (context) => TaskDetalPage(
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
              _allDate.format(task.date),
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
