import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
import 'package:agenda/layers/presentation/pages/debts/detals/user_debts_detal_page.dart';
import 'package:agenda/layers/presentation/widget/divders.dart';
import 'package:agenda/layers/presentation/widget/show_dialog/debt_dismissible_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:intl/intl.dart';

class DebtsItem extends StatefulWidget {
  final String language;
  final bool lightMode;
  final bool random;
  final String? debt;

  const DebtsItem(
      {super.key,
      required this.language,
      required this.lightMode,
      required this.random,
      this.debt});

  @override
  State<DebtsItem> createState() => _DebtsItemState();
}

class _DebtsItemState extends State<DebtsItem> {
  Stream<List<DebtsListModel>> getUserDebtsStream() {
    final db = FirebaseFirestore.instance;
    return db.collection('debtsList').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DebtsListModel.fromJson(doc.data())..docId = doc.id)
          .toList();
    });
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
        return 'Error: ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: _buildUserDepts());
  }

Widget _buildUserDepts() {
  return StreamBuilder<List<DebtsListModel>>(
    stream: getUserDebtsStream(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('${getErrorText()}${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("Ma'lumot yo‘q"));
      }

      List<DebtsListModel> userDebts = List.from(snapshot.data!);
      
      // **Tartiblash (yangi qo‘shilgan boshiga chiqadi)**
      userDebts.sort((b, a) => a.date!.compareTo(b.date!));

      List<DebtsListModel> filteredDebtGet = userDebts.where((debt) => debt.debt == 'get').toList();
      List<DebtsListModel> filteredDebtOwe = userDebts.where((debt) => debt.debt == 'owe').toList();

      List<DebtsListModel> displayedDebts = widget.debt == 'debtors'
          ? filteredDebtGet
          : widget.debt == 'userDebts'
              ? filteredDebtOwe
              : userDebts;
              
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayedDebts.length,
        itemBuilder: (context, index) {
          return _builUserDebtsItem1(displayedDebts[index], index != 0);
        },
      );
    },
  );
}


  Widget _builUserDebtsItem1(DebtsListModel userDebts, bool tr) {
    final int hash = userDebts.name.hashCode;
    final randomColor = Colors.primaries[hash % Colors.primaries.length];

    Widget listTile = Dismissible(
      key: ValueKey(userDebts.docId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        showDebtDismissible(context, widget.language, userDebts);
        return false;
      },

      background: Container(
        color: Colors.lightBlue,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      child: ListTile(
          // minTileHeight: 75,
          minTileHeight: 79.h,
          minVerticalPadding: 0, // Keraksiz bo'sh joyni oldini olish
          contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w, vertical: 0), // Ichki bo'sh joyni kamaytirish
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserDebtsDetailPage(
                    language: widget.language,
                    debts: userDebts,
                    lightMode: widget.lightMode,
                  ))),
          leading: CircleAvatar(
            radius: 30.r,
            backgroundColor: randomColor,
            child: Text(
              userDebts.name!.isNotEmpty ? userDebts.name![0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          title: Text(
            "${userDebts.name}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: userDebts.money != 0 ? Text(
            '${widget.language == 'eng' ? 'Debt Amount' : widget.language == 'rus' ? "Сумма долга" : 'Qarz Miqdori'}: ${userDebts.money.toMoney()} so\'m',
            style: TextStyle(
                fontSize: 17.sp, fontWeight: FontWeight.w400, color: Colors.white38),
          ) : Text('Qarz: to\'landi', style: TextStyle(
                fontSize: 17.sp, fontWeight: FontWeight.w400, color: Colors.green),),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat.MMMMd('uz_UZ').format(userDebts.date!),
                style: TextStyle(fontSize: 14.sp, color: Colors.white38),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(userDebts.money == 0)Icon(Icons.check_circle_outline_outlined,color: Colors.green,),
                  if(userDebts.money != 0) Icon(
                    userDebts.debt == 'get'
                        ? Icons.add_circle_outline_rounded
                        : Icons.remove_circle_outline_sharp,
                    color:
                        userDebts.debt == 'get' ? Colors.blue[300] : Colors.red[300],
                  ),
                ],
              ),
            ],
          ),
        ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min, // Bo'sh joy tashlanishining oldini olish
      children: [
        if (tr)
          Padding(
            padding: const EdgeInsets.only(
                bottom: 0), // Divider'ni ListTile'ga yaqinlashtirish
            child: Dividers(lightMode: widget.lightMode, inden: true),
          ),
        listTile,
      ],
    );
  }
}

class DebtsCalendar extends StatefulWidget {
  final String language;
  final bool lightMode;
  const DebtsCalendar(
      {super.key, required this.language, required this.lightMode});

  @override
  State<DebtsCalendar> createState() => _DebtsCalendarState();
}

class _DebtsCalendarState extends State<DebtsCalendar> {
  Stream<List<DebtsListModel>> getUserDebtsStream() {
    final db = FirebaseFirestore.instance;
    return db.collection('debtsList').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => DebtsListModel.fromJson(doc.data())..docId = doc.id)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<DebtsListModel>>(
      stream: getUserDebtsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Xato: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Kundalik bo'sh"));
        }

        // Sanalarga qarab vazifalarni ajratish
        final Map<DateTime, List<DebtsListModel>> debtByDate = {};
        for (var debt in snapshot.data!) {
          final dates =
              DateTime(debt.date!.year, debt.date!.month, debt.date!.day);
          debtByDate.putIfAbsent(dates, () => []).add(debt);
        }

        final sortedDates = debtByDate.keys.toList()..sort();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final debts = debtByDate[date]!;
            debts.sort((a, b) => a.date!.compareTo(b.date!));

            return Card(
              elevation: 0,
              color:
                   Colors.white10,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.r),
                            topRight: Radius.circular(15.r))),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Center(
                      child: Text(
                        widget.language == 'eng'
                            ? DateFormat.yMMMMEEEEd('en_EN').format(date)
                            : widget.language == 'rus'
                                ? DateFormat.yMMMMEEEEd('ru_RU').format(date)
                                : DateFormat.yMMMMEEEEd('uz_UZ').format(date),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                  ),
                  ...debts.map((debt) => ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserDebtsDetailPage(
                                  language: widget.language,
                                  debts: debt,
                                  lightMode: widget.lightMode,)));
                        },
                        title: Text(
                          debt.name!,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        subtitle: Text(
                          "${debt.debt != 'get' ? _getTextGet() : _getTextOwe()}: ${debt.money} so'm",
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 17.sp,
                        ),
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getTextGet() {
    switch (widget.language) {
      case 'eng':
        return 'I GET';
      case 'rus':
        return 'rusTitle';
      case 'uzb':
        return 'QARZDOR';
      default:
        return 'I GET';
    }
  }

  String _getTextOwe() {
    switch (widget.language) {
      case 'eng':
        return 'I OWE';
      case 'rus':
        return 'rusTitle';
      case 'uzb':
        return 'QARZDORMAN';
      default:
        return 'I OWE';
    }
  }
}




// hive uchun kodlar
// import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
// import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
// import 'package:agenda/layers/presentation/pages/debts/detals/user_debts_detal_page.dart';
// import 'package:agenda/layers/presentation/widget/divders.dart';
// import 'package:agenda/layers/presentation/widget/show_dialog/debt_dismissible_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:agenda/layers/presentation/extension/extension.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';

// class DebtsItem extends StatefulWidget {
//   final String language;
//   final bool lightMode;
//   final bool random;
//   final String? debt;

//   const DebtsItem(
//       {super.key,
//       required this.language,
//       required this.lightMode,
//       required this.random,
//       this.debt});

//   @override
//   State<DebtsItem> createState() => _DebtsItemState();
// }

// class _DebtsItemState extends State<DebtsItem> {
 

//   String getErrorText() {
//     switch (widget.language) {
//       case 'eng':
//         return 'Error: ';
//       case 'rus':
//         return 'Ошибка: ';
//       case 'uzb':
//         return 'Xato: ';
//       default:
//         return 'Error: ';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(width: double.infinity, child: _buildUserDepts());
//   }

// Widget _buildUserDepts() {
//   return ValueListenableBuilder(
//    valueListenable: Hive.box<DebtsModel>('debtsBox').listenable(),
//    builder: (context, Box<DebtsModel> box, _) {
//           if (box.isEmpty) {
//             return Center(child: Text('Hali hech qanday qarz yo\'q'));
//           }

//       return ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: box.length,
//         itemBuilder: (context, index) {
//           final debt = box.getAt(index);
//           return _builUserDebtsItem1(debt!, index != 0);
//         },
//       );}
//   );
  
// }


//   Widget _builUserDebtsItem1(DebtsModel userDebts, bool tr) {
//     final int hash = userDebts.name.hashCode;
//     final randomColor = Colors.primaries[hash % Colors.primaries.length];

//     Widget listTile = Dismissible(
//       key: ValueKey(userDebts.docId),
//       direction: DismissDirection.endToStart,
//       confirmDismiss: (direction) async {
//         // showDebtDismissible(context, widget.language, userDebts);
//         return false;
//       },

//       background: Container(
//         color: Colors.lightBlue,
//         alignment: Alignment.centerRight,
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: const Icon(Icons.add, color: Colors.white, size: 30),
//       ),
//       child:  ListTile(
//           // minTileHeight: 75,
//           minTileHeight: 79.h,
//           minVerticalPadding: 0, // Keraksiz bo'sh joyni oldini olish
//           contentPadding: EdgeInsets.symmetric(
//               horizontal: 10.w, vertical: 0), // Ichki bo'sh joyni kamaytirish
//           // onTap: () => Navigator.of(context).push(MaterialPageRoute(
//           //     builder: (context) => UserDebtsDetailPage(
//           //           language: widget.language,
//           //           debts: userDebts,
//           //           lightMode: widget.lightMode,
//           //         ))),
//           leading: CircleAvatar(
//             radius: 30.r,
//             backgroundColor: randomColor,
//             child: Text(
//               userDebts.name!.isNotEmpty ? userDebts.name![0].toUpperCase() : '?',
//               style: const TextStyle(color: Colors.white, fontSize: 24),
//             ),
//           ),
//           title: Text(
//             "${userDebts.name}",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20.sp,
//               fontWeight: FontWeight.w500,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           subtitle: Text(
//             '${widget.language == 'eng' ? 'Debt Amount' : widget.language == 'rus' ? "Сумма долга" : 'Qarz Miqdori'}: ${userDebts.money.toMoney()} so\'m',
//             style: TextStyle(
//                 fontSize: 17.sp, fontWeight: FontWeight.w400, color: Colors.white38),
//           ),
//           trailing: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 DateFormat.MMMd('uz_UZ').format(userDebts.date!),
//                 style: TextStyle(fontSize: 14.sp, color: Colors.white38),
//               ),
//               Icon(
//                 userDebts.debt == 'get'
//                     ? Icons.add_circle_outline_rounded
//                     : Icons.remove_circle_outline_sharp,
//                 color:
//                     userDebts.debt == 'get' ? Colors.blue[300] : Colors.red[300],
//               ),
//             ],
//           ),
//         ),
//     );

//     return Column(
//       mainAxisSize: MainAxisSize.min, // Bo'sh joy tashlanishining oldini olish
//       children: [
//         if (tr)
//           Padding(
//             padding: const EdgeInsets.only(
//                 bottom: 0), // Divider'ni ListTile'ga yaqinlashtirish
//             child: Dividers(lightMode: widget.lightMode, inden: true),
//           ),
//         listTile,
//       ],
//     );
//   }
// }

// class DebtsCalendar extends StatefulWidget {
//   final String language;
//   final bool lightMode;
//   const DebtsCalendar(
//       {super.key, required this.language, required this.lightMode});

//   @override
//   State<DebtsCalendar> createState() => _DebtsCalendarState();
// }

// class _DebtsCalendarState extends State<DebtsCalendar> {
//   Stream<List<DebtsListModel>> getUserDebtsStream() {
//     final db = FirebaseFirestore.instance;
//     return db.collection('debtsList').snapshots().map((snapshot) {
//       return snapshot.docs
//           .map((doc) => DebtsListModel.fromJson(doc.data())..docId = doc.id)
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Column(
//         children: [
//           _buildBody(),
//         ],
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return StreamBuilder<List<DebtsListModel>>(
//       stream: getUserDebtsStream(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text("Xato: ${snapshot.error}"));
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text("Kundalik bo'sh"));
//         }

//         // Sanalarga qarab vazifalarni ajratish
//         final Map<DateTime, List<DebtsListModel>> debtByDate = {};
//         for (var debt in snapshot.data!) {
//           final dates =
//               DateTime(debt.date!.year, debt.date!.month, debt.date!.day);
//           debtByDate.putIfAbsent(dates, () => []).add(debt);
//         }

//         final sortedDates = debtByDate.keys.toList()..sort();

//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: sortedDates.length,
//           itemBuilder: (context, index) {
//             final date = sortedDates[index];
//             final debts = debtByDate[date]!;
//             debts.sort((a, b) => a.date!.compareTo(b.date!));

//             return Card(
//               elevation: 0,
//               color:
//                    Colors.white10,
//               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(15.r),
//                             topRight: Radius.circular(15.r))),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//                     child: Center(
//                       child: Text(
//                         widget.language == 'eng'
//                             ? DateFormat.yMMMMEEEEd('en_EN').format(date)
//                             : widget.language == 'rus'
//                                 ? DateFormat.yMMMMEEEEd('ru_RU').format(date)
//                                 : DateFormat.yMMMMEEEEd('uz_UZ').format(date),
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.lightBlueAccent,
//                         ),
//                       ),
//                     ),
//                   ),
//                   ...debts.map((debt) => ListTile(
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => UserDebtsDetailPage(
//                                   language: widget.language,
//                                   debts: debt,
//                                   lightMode: widget.lightMode,)));
//                         },
//                         title: Text(
//                           debt.name!,
//                           style: TextStyle(fontSize: 20.sp),
//                         ),
//                         subtitle: Text(
//                           "${debt.debt != 'get' ? _getTextGet() : _getTextOwe()}: ${debt.money} so'm",
//                           style: TextStyle(fontSize: 13.sp),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_forward_ios_outlined,
//                           size: 17.sp,
//                         ),
//                       )),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   String _getTextGet() {
//     switch (widget.language) {
//       case 'eng':
//         return 'I GET';
//       case 'rus':
//         return 'rusTitle';
//       case 'uzb':
//         return 'QARZDOR';
//       default:
//         return 'I GET';
//     }
//   }

//   String _getTextOwe() {
//     switch (widget.language) {
//       case 'eng':
//         return 'I OWE';
//       case 'rus':
//         return 'rusTitle';
//       case 'uzb':
//         return 'QARZDORMAN';
//       default:
//         return 'I OWE';
//     }
//   }
// }
