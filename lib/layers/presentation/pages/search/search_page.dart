import 'package:agenda/layers/domain/models/firebase_model/tasks/task_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/pages/day/tasks/task_detal_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/divders.dart';
import 'package:agenda/layers/presentation/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  const SearchPage(
      {super.key, required this.language, required this.lightMode});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Stream<List<TaskModel>> getAllTaskStream(String query) {
    final db = FirebaseFirestore.instance;
    if (query.isEmpty) {
      return db.collection('tasks').snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data())..docId = doc.id)
            .toList();
      });
    } else {
      return db
          .collection('tasks')
          .where('task', isGreaterThanOrEqualTo: query)
          .where('task', isLessThanOrEqualTo: '$query\uf8ff')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => TaskModel.fromJson(doc.data())..docId = doc.id)
            .toList();
      });
    }
  }

  // Stream<List<DebtorListModel>> getFilteredDebtor(String query) {
  //   final db = FirebaseFirestore.instance;
  //   if (query.isEmpty) {
  //     return db.collection('debtorlist').snapshots().map((snapshot) {
  //       return snapshot.docs
  //           .map((doc) => DebtorListModel.fromJson(doc.data())..docId = doc.id)
  //           .toList();
  //     });
  //   } else {
  //     return db
  //         .collection('debtorlist')
  //         .where('name', isGreaterThanOrEqualTo: query)
  //         .where('name', isLessThanOrEqualTo: '$query\uf8ff')
  //         .snapshots()
  //         .map((snapshot) {
  //       return snapshot.docs
  //           .map((doc) => DebtorListModel.fromJson(doc.data())..docId = doc.id)
  //           .toList();
  //     });
  //   }
  // }

  Stream<List<DebtsListModel>> getFilteredUserDebts(String query) {
    final db = FirebaseFirestore.instance;
    if (query.isEmpty) {
      return db.collection('debtsList').snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => DebtsListModel.fromJson(doc.data())..docId = doc.id)
            .toList();
      });
    } else {
      return db
          .collection('debtsList')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => DebtsListModel.fromJson(doc.data())..docId = doc.id)
            .toList();
      });
    }
  }

  String getHintText() {
    switch (widget.language) {
      case 'eng':
        return 'Search...';
      case 'rus':
        return 'Поиск...';
      case 'uzb':
        return 'Qidirish...';
      default:
        return 'Search...'; // default (ingliz tili)
    }
  }

  String getErrorText() {
    switch (widget.language) {
      case 'eng':
        return 'Error: ';
      case 'rus':
        return 'Ошибка: ';
      case 'uzb':
        return 'Xato: ';
      default:
        return 'Error: '; // default (ingliz tili)
    }
  }

  String getNoResultsText() {
    switch (widget.language) {
      case 'eng':
        return 'No results found.';
      case 'rus':
        return 'Результатов не найдено.';
      case 'uzb':
        return 'Natijalar topilmadi.';
      default:
        return 'No results found.'; // default (ingliz tili)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 4, 19, 44),
      backgroundColor:
          widget.lightMode ? AppColors.primary : AppColors.standartColor,
      appBar: AppBar(
        backgroundColor: widget.lightMode
            ? AppColors.homeBackgroundColor
            : AppColors.standartColor,
        // elevation: widget.lightMode ? null : 1,
        title: Padding(
          padding: EdgeInsets.only(right: 15.w),
          child: TextFormField(
            focusNode: _focusNode,
            textCapitalization: TextCapitalization.words,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: getHintText(),
              hintStyle: const TextStyle(color: Colors.white),
              fillColor: widget.lightMode ? Colors.blue[200] : Colors.blueGrey,

              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0), // Yumshoq burchaklar
                borderSide: BorderSide.none, // Chekka chizig'i yo'q
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 20.0), // Ichki bo'shliqlar
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        titleSpacing: 0,
      ),
      body: searchQuery.isEmpty
          ? const Center(child: null)
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildFilterUserDepts(),
                        _buildFilterTasks(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
 

  Widget _buildFilterUserDepts() {
    return StreamBuilder(
      stream: getFilteredUserDebts(searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: ShimmerExampleDebt(lightMode: false,));
        }
        if (snapshot.hasData || snapshot.data!.isNotEmpty) {
          final userDebts = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userDebts.length,
            itemBuilder: (context, index) {
              final debt = userDebts[index];
              return Column(
                children: [
                  ListTile(
                      // onTap: () => Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => UserDebtsDetalPage(
                      //           language: widget.language,
                      //           debts: debt,
                      //           lightMode: widget.lightMode,
                      //           // userDebts: debt,
                      //         ),
                      //       ),
                      //     ),
                      leading: Icon(
                        Icons.person,
                        size: 50.sp,
                        color: Colors.white70,
                      ),
                      title: Text(
                        debt.name!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${widget.language == 'eng' ? 'Debts' : widget.language == 'rus' ? "" : 'Qarz'}: ${debt.money.toMoney()} so\'m',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            size: 31.sp,
                            color: Colors.red,
                          ),
                          Text(
                              widget.language == 'eng'
                                  ? "Debtors"
                                  : widget.language == 'rus'
                                      ? "Список должников"
                                      : "Qarzdorman",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey))
                        ],
                      )),
                 Dividers(lightMode:widget. lightMode, inden: false,)
                ],
              );
            },
          );
        }
        return const Center(
          child: null,
        );
      },
    );
  }
  Widget _buildFilterTasks() {
    return StreamBuilder(
      stream: getAllTaskStream(searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: ShimmerExampleDebt(lightMode: false,));
        } else if (snapshot.hasData || snapshot.data!.isNotEmpty) {
          final tasks = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetalPage(task: task, language: widget.language, lightMode: widget.lightMode))),
                    leading: Icon(Icons.task_alt_outlined,
                        size: 45.sp, color: Colors.white70),
                    title: Text(
                      task.task,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      widget.language == 'eng'
                          ? DateFormat.yMMMEd('en_US').format(task.date)
                          : widget.language == 'rus'
                              ? DateFormat.yMMMEd('ru_RU').format(task.date)
                              : DateFormat.yMMMEd('uz_UZ').format(task.date),
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        Text(
                          "Vazifa",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                 Dividers(lightMode: widget.lightMode,inden: false,)
                ],
              );
            },
          );
        }
        return const Center(
          child: null,
        );
      },
    );
  }
}
