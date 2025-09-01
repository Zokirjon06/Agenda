// import 'package:agenda/layers/domain/models/firebase_model/user_debt/debs_detail_model.dart';
// import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
// import 'package:agenda/layers/presentation/extension/extension.dart';
// import 'package:agenda/layers/presentation/pages/debts/add_debts/user_debts/add_user_debts_detail_page.dart';
// import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
// import 'package:agenda/layers/presentation/widget/divders.dart';
// import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
// import 'package:agenda/layers/presentation/widget/standart_padding.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:intl/intl.dart';

// class UserDebtsDetalPage extends StatefulWidget {
//   final String language;
//   final DebtsListModel debts;
//   final bool lightMode;

//   const UserDebtsDetalPage(
//       {super.key,
//       required this.language,
//       required this.debts,
//       required this.lightMode});

//   @override
//   State<UserDebtsDetalPage> createState() => _UserDebtsDetalPageState();
// }

// class _UserDebtsDetalPageState extends State<UserDebtsDetalPage> {
//   Stream<List<DebtsListDetailModel>> getDebtorsDetailStream() {
//     final db = FirebaseFirestore.instance;
//     return db.collection('debtslistdetail').snapshots().map((snapshot) {
//       return snapshot.docs
//           .map((doc) =>
//               DebtsListDetailModel.fromJson(doc.data())..docId = doc.id)
//           .toList();
//     });
//   }

//   Stream<List<DebtsListModel>> getDebtorsListStream() {
//     final db = FirebaseFirestore.instance;
//     return db.collection('debtslist').snapshots().map((snapshot) {
//       return snapshot.docs
//           .map((doc) => DebtsListModel.fromJson(doc.data())..docId = doc.id)
//           .toList();
//     });
//   }

//   void _deleteDebtor(DebtsListModel debtlist) {
//     final db = FirebaseFirestore.instance;
//     db.collection("debtsList").doc(debtlist.docId).delete();
//   }

//   void _deleteDebtorDetail(DebtsListDetailModel debts) async {
//     final db = FirebaseFirestore.instance;

//     // `debtor.docId` bo'sh yoki null emasligini tekshiramiz
//     if (widget.debts.name == debts.fulName) {
//       try {
//         await db.collection("debtsdetail").doc(debts.docId).delete();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Qarzdorlik muvaffaqiyatli o'chirildi")),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Xatolik yuz berdi: $e")),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Ma'lumotni o‘chirish imkonsiz")),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(

//         title: Text(widget.debts.name!.trim(),
//             style: const TextStyle(color: Colors.white)),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // if (widget.delete != null) {
//                 // widget.delete!(
//                 //     widget.debts); // delete funksiyasini debts bilan chaqirish

//               // }
//               _deleteDebtor(widget.debts);
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(
//               Icons.delete,
//               color: Colors.red,
//             ),
//           ),
//         ],
//         backgroundColor:
//             widget.lightMode ? AppColors.primary : AppColors.standartColor,
//         elevation: 3,
//         shadowColor: Colors.black,
//       ),
//       floatingActionButton: MyFloatinacshinbutton(onPressed: () {
//         _showBottomSheet(context);
//       }),
//       backgroundColor: widget.lightMode
//           ? AppColors.homeBackgroundColor
//           : AppColors.standartColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Gap(10.h),
//              StandartPadding(
//                     child: Expanded(
//                         child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           widget.language == 'eng'
//                               ? "Total debtors"
//                               : widget.language == 'rus'
//                                   ? ''
//                                   : 'Umumiy qarz',
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           widget.language == 'eng'
//                               ? DateFormat.yMMMMd('en_US')
//                                   .format(widget.debts.date!)
//                               : widget.language == 'rus'
//                                   ? DateFormat.yMMMMd('ru_RU')
//                                       .format(widget.debts.date!)
//                                   : DateFormat.yMMMMd('uz_UZ')
//                                       .format(widget.debts.date!),
//                           style: TextStyle(
//                               color: Colors.green,
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                     Gap(15.h),
//                     Center(
//                       child: Text(
//                         "${widget.debts.money.toMoney()} so'm",
//                         style: TextStyle(
//                             fontSize: 28.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ))),
//                 const Divider(),
//             StreamBuilder(
//                 stream: getDebtorsDetailStream(),
//                 builder: (context, snapshot) {
//                   if (snapshot.data == null && snapshot.data == null) {
//                     return const Center();
//                   }
//                   if (snapshot.hasData && snapshot.data!.isNotEmpty ||
//                       snapshot.hasData && snapshot.data!.isNotEmpty) {
//                     return SizedBox(
//                       width: double.infinity,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           _buildDeptors(widget.debts),
//                         ],
//                       ),
//                     );
//                   }
//                   return const Center(
//                     child: null,
//                   );
//                 })
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeptors(DebtsListModel debtor) {
//     return StreamBuilder<List<DebtsListDetailModel>>(
//       stream: getDebtorsDetailStream(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: SizedBox.shrink());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Xato: ${snapshot.error}'));
//         }
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center();
//         }

//         // Ma'lumotlarni filtrlaymiz
//         List<DebtsListDetailModel> debts = snapshot.data!
//             .where((detail) => detail.fulName == debtor.name)
//             .toList();

//         if (debts.isEmpty) {
//           return const Center();
//         }

//         return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: debts.length,
//             itemBuilder: (context, index) {
//               if (debts[index].detailAmount! > 0) {
//                 return _buildDebtorsItem(debts[index]);
//               } else if (debts[index].removDetailAmount! > 0) {
//                 return _buildDebtorsItem1(debts[index]);
//               }
//               return const SizedBox();
//             });
//       },
//     );
//   }

//   Widget _buildDebtorsItem(DebtsListDetailModel debt) {
//     return Column(
//       children: [
//         ListTile(
//           minVerticalPadding: 0,
//           minTileHeight: 70.h,
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => AddUserDebtsDetailPage(
//                 language: widget.language,
//                 debts: widget.debts,
//                 lightMode: widget.lightMode,
//                 debtIncrease: true,
//                 debtsdetail: debt,
//               ),
//             ));
//           },
//           leading: Icon(
//             Icons.attach_money,
//             size: 45.sp,
//             color: Colors.white70,
//           ),
//           title: Text(
//             'Qarzning oshishi',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 17.sp,
//               fontWeight: FontWeight.w500,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis, // Matnni kesish va "..." qo'shish
//           ),
//           subtitle: Text(
//             debt.detailComment.toString().trim(),
//             style: TextStyle(
//               color: Colors.blue,
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           trailing: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "${debt.detailAmount.toMoney()} so'm",
//                 style: TextStyle(color: Colors.green, fontSize: 22.sp),
//               ),
//               Text(
//                 widget.language == 'eng'
//                     ? DateFormat.yMMMEd('en_US').format(DateTime.now())
//                     : widget.language == 'rus'
//                         ? DateFormat.yMMMEd('ru_RU').format(DateTime.now())
//                         : DateFormat.yMMMEd('uz_UZ').format(DateTime.now()),
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.blue,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Dividers(lightMode:widget. lightMode,inden: false,)
//       ],
//     );
//   }

//   Widget _buildDebtorsItem1(DebtsListDetailModel debt) {
//     return Column(
//       children: [
//         ListTile(
//           minVerticalPadding: 0,
//           minTileHeight: 70.h,
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => AddUserDebtsDetailPage(
//                 language: widget.language,
//                 debts: widget.debts,
//                 lightMode: widget.lightMode,
//                 debtIncrease: false,
//                 debtsdetail: debt,
//               ),
//             ));
//           },
//           leading: Icon(
//             Icons.attach_money,
//             size: 45.sp,
//             color: Colors.white70,
//           ),
//           title: Text(
//             'Qarzning kamayishi',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 17.sp,
//               fontWeight: FontWeight.w500,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis, // Matnni kesish va "..." qo'shish
//           ),
//           subtitle: Text(
//             debt.detailComment.toString(),
//             style: TextStyle(
//               color: Colors.blue,
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           trailing: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "${debt.removDetailAmount.toMoney()} so'm",
//                 style: TextStyle(color: Colors.red, fontSize: 22.sp),
//               ),
//               Text(
//                 widget.language == 'eng'
//                     ? DateFormat.yMMMEd('en_US').format(DateTime.now())
//                     : widget.language == 'rus'
//                         ? DateFormat.yMMMEd('ru_RU').format(DateTime.now())
//                         : DateFormat.yMMMEd('uz_UZ').format(DateTime.now()),
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.blue,
//                 ),
//               ),
//             ],
//           ),
//         ),
//        Dividers(lightMode: widget.lightMode,inden: false,)
//       ],
//     );
//   }
//   // --------------------------------------------------
//   // --------------------------------------------------
//   // --------------------------------------------------
//   // _showBottomSheet---------------------------------
//   // --------------------------------------------------
//   // --------------------------------------------------
//   // --------------------------------------------------
//   void _showBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
//       ),
//       backgroundColor: AppColors.homeBackgroundColor,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Gap(15.h),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => AddUserDebtsDetailPage(
//                               language: widget.language,
//                               lightMode: widget.lightMode,
//                               debtIncrease: true,
//                               debts: widget.debts,
//                             )));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 16.h),
//                     // backgroundColor: const Color(0xffF5F5F5),
//                     backgroundColor: Colors.green
//                   ),
//                   child: Text(
//                     'Qarzning oshishi',
//                     style: TextStyle(
//                       color: Colors.white,
//                       // color: const Color(0xff0C75AF),
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               Gap(15.h),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => AddUserDebtsDetailPage(
//                               language: widget.language,
//                               lightMode: widget.lightMode,
//                               debtIncrease: false,
//                               debts: widget.debts,
//                             )));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 16.h),
//                     // backgroundColor: const Color(0xff0C75AF),
//                     backgroundColor: Colors.red
//                   ),
//                   child: Text(
//                     'Qarzning kamayishi',
//                     style: TextStyle(
//                       color: const Color(0xffF5F5F5),
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               Gap(10.h),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:agenda/layers/domain/models/firebase_model/user_debt/debs_detail_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/pages/debts/add_debts/user_debts/add_user_debts_detail_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/divders.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/standart_padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class UserDebtsDetailPage extends StatefulWidget {
  final String language;
  final DebtsListModel debts;
  final bool lightMode;
  const UserDebtsDetailPage({
    super.key,
    required this.language,
    required this.debts,
    required this.lightMode,
  });

  @override
  State<UserDebtsDetailPage> createState() => _UserDebtsDetailPageState();
}

class _UserDebtsDetailPageState extends State<UserDebtsDetailPage> {
  late final DateFormat _allDate;

  Stream<List<DebtsListDetailModel>> getDebtorsListStream() {
    return FirebaseFirestore.instance
        .collection("debtsList")
        .doc(widget.debts.docId)
        .collection("debtslistdetail")
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DebtsListDetailModel.fromJson(doc.data()))
            .toList());
  }

  @override
  void initState() {
    _allDate = DateFormat.yMMMMd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
    setState(() {});
    super.initState();
  }

  void _deleteDebtor() {
    FirebaseFirestore.instance
        .collection("debtsList")
        .doc(widget.debts.docId)
        .delete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.debts.name!.trim(),
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                color: Colors.white,
              )),
          IconButton(
            onPressed: _deleteDebtor,
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
        foregroundColor: Colors.white,
         backgroundColor: widget.lightMode ? AppColors.primary : AppColors.appBar,
           elevation: 3,
           shadowColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.standartColor, // Status bar rangini o'zgartirish
                statusBarIconBrightness: Brightness.light, // Ikonalar rangini o'zgartirish
              ),

      ),
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () => _showBottomSheet(context),
      ),
      backgroundColor: widget.lightMode
          ? AppColors.homeBackgroundColor
          : AppColors.standartColor,
      body: Column(
          children: [
            Gap(10.h),
            StandartPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.language == 'eng'
                            ? "Total debtors"
                            : widget.language == 'rus'
                                ? ''
                                : 'Umumiy qarz',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Olingan: ${_allDate.format(widget.debts.date!)}',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Gap(15.h),
                  Center(
                    child: Text(
                      "${widget.debts.money.toMoney()} so'm",
                      style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Gap(15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Izoh: ${widget.debts.goal!.isEmpty ? 'Mavjud emas' : widget.debts.goal}",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Muddat: ${_allDate.format(widget.debts.dueDate!)}',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 1.h,
              color: AppColors.deviderDark,
            ),
             
            StreamBuilder<List<DebtsListDetailModel>>(
              stream: getDebtorsListStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center();
                }
                final debtsDetailList = snapshot.data!;
                debtsDetailList.sort((a, b) => a.date!.compareTo(b.date!));
                return Expanded(
                  child: ListView.builder(
            
                    itemCount: debtsDetailList.length,
                    itemBuilder: (context, index) {
                      final detail = debtsDetailList[index];
                      return detail.detailAmount! > 0
                          ? _buildDebtorsItem(detail, index == 0)
                          : _buildDebtorsItem1(detail, index == 0);
                    },
                  ),
                );
              },
            ),
          ],
        ),
  
    );
  }

  Widget _buildDebtorsItem(DebtsListDetailModel debt, bool text) {
    return Column(
      children: [
        if(text) Text('Qo\'shimcha qarzlar',style: TextStyle(color: Colors.white,fontSize: 17.sp),),
        ListTile(
          minVerticalPadding: 0,
          minTileHeight: 70.h,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddUserDebtsDetailPage(
                language: widget.language,
                debts: widget.debts,
                lightMode: widget.lightMode,
                debtIncrease: true,
                debtsdetail: debt,
              ),
            ));
          },
          leading: CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.attach_money,
              size: 45.sp,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Qarzning oshishi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Matnni kesish va "..." qo'shish
          ),
          subtitle: Text(
            debt.detailComment.toString().trim(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${debt.detailAmount.toMoney()} so'm",
                style: TextStyle(color: Colors.green, fontSize: 22.sp),
              ),
              Text(
                _allDate.format(debt.date!),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        Dividers(
          lightMode: widget.lightMode,
          inden: true,
        )
      ],
    );
  }

  Widget _buildDebtorsItem1(DebtsListDetailModel debt, bool text) {
    return Column(
      children: [
        if(text) Text('Qo\'shimcha qarzlar',style: TextStyle(color: Colors.white,fontSize: 17.sp),),
        ListTile(
          minVerticalPadding: 0,
          minTileHeight: 70.h,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w,),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddUserDebtsDetailPage(
                language: widget.language,
                debts: widget.debts,
                lightMode: widget.lightMode,
                debtIncrease: false,
                debtsdetail: debt,
              ),
            ));
          },
          leading: CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.red,
            child: Icon(
              Icons.attach_money,
              size: 45.sp,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Qarzning kamayishi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Matnni kesish va "..." qo'shish
          ),
          subtitle: Text(
            debt.detailComment.toString(),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${debt.removDetailAmount.toMoney()} so'm",
                style: TextStyle(color: Colors.red, fontSize: 22.sp),
              ),
              Text(
                _allDate.format(debt.date!),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        Dividers(
          lightMode: widget.lightMode,
          inden: true,
        )
      ],
    );
  }

  // --------------------------------------------------
  // --------------------------------------------------
  // --------------------------------------------------
  // _showBottomSheet---------------------------------
  // --------------------------------------------------
  // --------------------------------------------------
  // --------------------------------------------------
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // showDragHandle: true,
      shape: RoundedRectangleBorder(
        // borderRadius: BorderRadius.all(Radius.zero),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      backgroundColor: AppColors.homeBackgroundColor,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(15.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddUserDebtsDetailPage(
                              language: widget.language,
                              lightMode: widget.lightMode,
                              debtIncrease: true,
                              debts: widget.debts,
                            )));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      // backgroundColor: const Color(0xffF5F5F5),
                      backgroundColor: Colors.green),
                  child: Text(
                    'Qarzning oshishi',
                    style: TextStyle(
                      color: Colors.white,
                      // color: const Color(0xff0C75AF),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Gap(15.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddUserDebtsDetailPage(
                              language: widget.language,
                              lightMode: widget.lightMode,
                              debtIncrease: false,
                              debts: widget.debts,
                            )));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      // backgroundColor: const Color(0xff0C75AF),
                      backgroundColor: Colors.red),
                  child: Text(
                    'Qarzning kamayishi',
                    style: TextStyle(
                      color: const Color(0xffF5F5F5),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Gap(10.h),
            ],
          ),
        );
      },
    );
  }
}
