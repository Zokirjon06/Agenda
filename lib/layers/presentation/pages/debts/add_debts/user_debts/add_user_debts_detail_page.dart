


// import 'package:agenda/layers/domain/models/firebase_model/user_debt/debs_detail_model.dart';
// import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
// import 'package:agenda/layers/presentation/extension/extension.dart';
// import 'package:agenda/layers/presentation/helpers/input_formatter.dart';
// import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
// import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
// import 'package:agenda/layers/presentation/widget/standart_padding.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';

// class AddUserDebtsDetailPage extends StatefulWidget {
//   final String language;
//   final bool lightMode;
//   final DebtsListModel debts;
//   final DebtsListDetailModel? debtsdetail;
//   final bool? debt_increase;
//   const AddUserDebtsDetailPage(
//       {super.key,
//       required this.language,
//       required this.lightMode,
//       required this.debts,
//       this.debtsdetail,
//       this.debt_increase});

//   @override
//   State<AddUserDebtsDetailPage> createState() => _AddUserDebtsDetailPageState();
// }

// class _AddUserDebtsDetailPageState extends State<AddUserDebtsDetailPage>
//     with TickerProviderStateMixin {
//   late final TextEditingController _addDebtController;
//   late final TextEditingController _removDebtController;
//   late final TextEditingController _commentController;
//   final DateTime _date = DateTime.now();
//   num? _standartMoney;
//   num? _addMoney;
//   num? _removeMoney;

//   @override
//   void initState() {
//     if (widget.debtsdetail != null) {
//       _addDebtController = TextEditingController(
//           text: widget.debtsdetail!.detailAmount.toMoney().toString());
//       _removDebtController = TextEditingController(
//           text: widget.debtsdetail!.removDetailAmount.toMoney().toString());
//       _commentController = TextEditingController(
//           text: widget.debtsdetail!.detailComment.toString());
//     } else {
//       _addDebtController = TextEditingController();
//       _removDebtController = TextEditingController();
//       _commentController = TextEditingController();
//     }

//     _standartMoney = widget.debts.money;

//     super.initState();
//   }

//   @override
//   void dispose() {
//     // _tabController.dispose();
//     _addDebtController.dispose();
//     _removDebtController.dispose();
//     _commentController.dispose();
//     setState(() {});
//     super.dispose();
//   }

//   _submit1() async {
//     setState(() {
//       if (widget.debt_increase!) {
//         _addMoney = _standartMoney! +
//             (num.tryParse(_addDebtController.text.pickOnlyNumber()) ?? 0);
//       } else {
//         _removeMoney = _standartMoney! -
//             (num.tryParse(_removDebtController.text.pickOnlyNumber()) ?? 0);
//       }
//     });
//   }

//   _submit() async {
//     final db = FirebaseFirestore.instance;
//     try {
//       DebtsListDetailModel debtorDeateil = DebtsListDetailModel(
//           fulName: widget.debts.name,
//           date: _date,
//           detailComment: _commentController.text,
//           detailAmount: num.tryParse(
//             _addDebtController.text.pickOnlyNumber(),
//           ),
//           removDetailAmount:
//               num.tryParse(_removDebtController.text.pickOnlyNumber()));
//       await db.collection('debtslistdetail').add(debtorDeateil.toJson());
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('salom user')));
//     } catch (e) {}
//   }




//   void _saveChanges() {
//     final db = FirebaseFirestore.instance;
//     if (_addMoney != null || _removeMoney != null) {
//       widget.debts.money = widget.debt_increase! ? _addMoney : _removeMoney;
//     }
//     db
//         .collection("debtsList")
//         .doc(widget.debts.docId)
//         .update(widget.debts.toJson())
//         .catchError((e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Xatolik yuz berdi: $e")));
//     });
//   }

//   void _saveChangesDetail() {
//     final db = FirebaseFirestore.instance;
//     widget.debtsdetail!.detailAmount =
//         num.tryParse(_addDebtController.text.pickOnlyNumber());
//     widget.debtsdetail!.removDetailAmount =
//         num.tryParse(_removDebtController.text.pickOnlyNumber());
//     widget.debtsdetail!.detailComment = _commentController.text;

//     db
//         .collection("debtslistdetail")
//         .doc(widget.debtsdetail!.docId)
//         .update(widget.debtsdetail!.toJson())
//         .catchError((e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Xatolik yuz berdi: $e")));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         elevation: 3,
//         shadowColor: Colors.black,
//         backgroundColor:
//             widget.lightMode ? AppColors.primary : AppColors.standartColor,
//         title: Text(
//           "${widget.debts.money.toMoney()} so'm",
//           style:
//               const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         titleSpacing: 0,
//         leadingWidth: null,
//         actions: [
//           IconButton(
//               onPressed: () {
            
//                 setState(() {
//                   if (widget.debtsdetail != null) {
//                     _saveChangesDetail();
//                   } else {
//                     _submit1();
//                     _saveChanges();
//                     _submit();
//                   }

               
//                   Navigator.of(context).pop();
//                 });
//               },
//               icon: const Icon(Icons.check))
//         ],
//       ),
//       backgroundColor:
//           widget.lightMode ? AppColors.primary : AppColors.standartColor,
//       body: Column(
//         children: [
//           Expanded(
//             child: Column(
//               children: [
//                widget.debt_increase! ?  StandartPadding(
//                     child: Column(
//                   children: [
//                     Gap(40.h),
//                     TaskField(
//                         controller: _addDebtController,
//                         labelText: "Miqdor",
//                         language: widget.language,
//                         validator: false,
//                         formatters: [InputFormatters.moneyFormatter],
//                         keyBordtype: TextInputType.number,
//                         sufix: false,
//                         isDense: true,conPad: 5.h,),
//                     Gap(40.h),
//                     TaskField(
//                         controller: _commentController,
//                         minLin: 1,
//                         maxLin: null,
//                         labelText: "Izoh",
//                         hintText: 'Bu yerga yozish majburiy emas',
//                         language: widget.language,
//                         validator: false,
//                         sufix: false,
//                         isDense: true,conPad: 5.h,),
//                   ],
//                 )) :
//                 StandartPadding(
//                     child: Column(
//                   children: [
//                     Gap(40.h),
//                     TaskField(
//                         formatters: [InputFormatters.moneyFormatter],
//                         controller: _removDebtController,
//                         labelText: "Miqdor",
//                         language: widget.language,
//                         validator: false,
//                         keyBordtype: TextInputType.number,
//                         sufix: false,
//                         isDense: true,conPad: 5.h,),
//                     Gap(40.h),
//                     TaskField(
//                         controller: _commentController,
//                         maxLin: null,
//                         minLin: 1,
//                         labelText: "Izoh",
//                         hintText: 'Bu yerga yozish majburiy emas',
//                         language: widget.language,
//                         validator: false,
//                         sufix: false,
//                         isDense: true,conPad: 5.h,),
//                   ],
//                 )),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:agenda/layers/domain/models/firebase_model/user_debt/debs_detail_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/helpers/input_formatter.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:agenda/layers/presentation/widget/standart_padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddUserDebtsDetailPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  final DebtsListModel debts;
  final DebtsListDetailModel? debtsdetail;
  final bool? debtIncrease;
  const AddUserDebtsDetailPage({
    super.key,
    required this.language,
    required this.lightMode,
    required this.debts,
    this.debtsdetail,
    this.debtIncrease,
  });

  @override
  State<AddUserDebtsDetailPage> createState() => _AddUserDebtsDetailPageState();
}

class _AddUserDebtsDetailPageState extends State<AddUserDebtsDetailPage> {
  late final TextEditingController _addDebtController;
  late final TextEditingController _removeDebtController;
  late final TextEditingController _commentController;
  final DateTime _date = DateTime.now();
  num? _standartMoney;
  num? _addMoney;
  num? _removeMoney;

  @override
  void initState() {
    super.initState();

    _addDebtController = TextEditingController(
        text: widget.debtsdetail?.detailAmount.toMoney() ?? '');
    _removeDebtController = TextEditingController(
        text: widget.debtsdetail?.removDetailAmount.toMoney() ?? '');
    _commentController =
        TextEditingController(text: widget.debtsdetail?.detailComment ?? '');

    _standartMoney = widget.debts.money;
  }

  @override
  void dispose() {
    _addDebtController.dispose();
    _removeDebtController.dispose();
    _commentController.dispose();
    setState(() {});
    super.dispose();
  }

  void _calculateMoney() {
    if (widget.debtIncrease ?? false) {
      _addMoney = _standartMoney! +
          (num.tryParse(_addDebtController.text.pickOnlyNumber()) ?? 0);
    } else {
      _removeMoney = _standartMoney! -
          (num.tryParse(_removeDebtController.text.pickOnlyNumber()) ?? 0);
    }
  }

  Future<void> _submit() async {
    final db = FirebaseFirestore.instance;

    try {
      DebtsListDetailModel newDetail = DebtsListDetailModel(
        fulName: widget.debts.name,
        date: _date,
        detailComment: _commentController.text,
        detailAmount: num.tryParse(_addDebtController.text.pickOnlyNumber()),
        removDetailAmount:
            num.tryParse(_removeDebtController.text.pickOnlyNumber()),
      );

      await db
          .collection("debtsList")
          .doc(widget.debts.docId)
          .collection("debtslistdetail")
          .add(newDetail.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Muvaffaqiyatli qo‘shildi!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik yuz berdi: $e")),
      );
    }
  }

  void _saveChanges() {
    final db = FirebaseFirestore.instance;

    if (_addMoney != null || _removeMoney != null) {
      widget.debts.money = widget.debtIncrease ?? false ? _addMoney : _removeMoney;
    }

    db
        .collection("debtsList")
        .doc(widget.debts.docId)
        .update(widget.debts.toJson())
        .catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Xatolik yuz berdi: $e")));
    });
  }

  void _saveChangesDetail() {
    final db = FirebaseFirestore.instance;

    widget.debtsdetail!.detailAmount =
        num.tryParse(_addDebtController.text.pickOnlyNumber());
    widget.debtsdetail!.removDetailAmount =
        num.tryParse(_removeDebtController.text.pickOnlyNumber());
    widget.debtsdetail!.detailComment = _commentController.text;

    db
        .collection("debtsList")
        .doc(widget.debts.docId)
        .collection("debtslistdetail")
        .doc(widget.debtsdetail!.docId)
        .update(widget.debtsdetail!.toJson())
        .catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Xatolik yuz berdi: $e")));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDebtIncrease = widget.debtIncrease ?? false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
      
        foregroundColor: Colors.white,
          backgroundColor: widget.lightMode ? AppColors.primary : AppColors.appBar,
           elevation: 3,
           shadowColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.standartColor, // Status bar rangini o'zgartirish
                statusBarIconBrightness: Brightness.light, // Ikonalar rangini o'zgartirish
              ),
        title: Text(
          "${widget.debts.money.toMoney()} so'm",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 0,
        leadingWidth: 56.0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (widget.debtsdetail != null) {
                  _saveChangesDetail();
                } else {
                  _calculateMoney();
                  _saveChanges();
                  _submit();
                }
                Navigator.of(context).pop();
                
              });
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      backgroundColor:
          widget.lightMode ? AppColors.primary : AppColors.standartColor,
      body: StandartPadding(
        
        child: Column(
          children: [
            Gap(40.h),
            TaskField(
              controller: isDebtIncrease ? _addDebtController : _removeDebtController,
              labelText: "Miqdor",
              language: widget.language,
              validator: false,
              formatters: [InputFormatters.moneyFormatter],
              keyBordtype: TextInputType.number,
              sufix: false,
              isDense: true,
              conPad: 5.h,
            ),
            Gap(40.h),
            TaskField(
              controller: _commentController,
              labelText: "Izoh",
              hintText: 'Bu yerga yozish majburiy emas',
              language: widget.language,
              validator: false,
              sufix: false,
              isDense: true,
              conPad: 5.h,
            ),
          ],
        ),
      ),
    );
  }
}
