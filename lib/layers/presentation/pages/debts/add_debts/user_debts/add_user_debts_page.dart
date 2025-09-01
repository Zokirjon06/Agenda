import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
import 'package:agenda/layers/presentation/helpers/input_formatter.dart';
import 'package:agenda/layers/presentation/pages/main/main_screen.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AddUserDebtsPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  final bool pop;
  const AddUserDebtsPage(
      {super.key,
      required this.language,
      required this.lightMode,
      required this.pop});

  @override
  State<AddUserDebtsPage> createState() => _AddUserDebtsPageState();
}

class _AddUserDebtsPageState extends State<AddUserDebtsPage> {
  //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountMoneyController;
  late final TextEditingController _goalController;
  late final TextEditingController _dateController;
  late final TextEditingController _dueDateController;
  String _selectedRadioValue = "debtor";
  DateTime _date = DateTime.now();
  DateTime _dueDate = DateTime.now();
  late DateFormat dated = DateFormat.yMMMEd();
  late final DateFormat _allDate;

  @override
  void initState() {
    super.initState();
    _allDate = DateFormat.yMMMEd(widget.language == 'eng' ? 'en_US' : widget.language == 'rus' ? 'ru_RU' : 'uz_UZ');
    _dueDate = DateTime(_date.year, _date.month + 1, _date.day + 1);
    _dueDateController = TextEditingController(text: _allDate.format(_dueDate));
    _nameController = TextEditingController();
    _dateController = TextEditingController(text: _allDate.format(_date));
    _goalController = TextEditingController();
    _amountMoneyController = TextEditingController();
    // _TaskType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _amountMoneyController.dispose();
    super.dispose();
    _goalController.dispose();
    _dueDateController.dispose();
  }

  Future<void> _submit() async {
    try {
      final db = FirebaseFirestore.instance;
      DebtsListModel task = DebtsListModel(
          name: _nameController.text.trim(),
          date: _date,
          dueDate: _dueDate,
          goal: _goalController.text.trim(),
          money:
              num.tryParse(_amountMoneyController.text.pickOnlyNumber()) ?? 0,
          debt: _selectedRadioValue == 'debtor' ? 'get' : 'owe');

      var myTask = await db.collection('debtsList').add(task.toJson());
      await db
          .collection("debtsList")
          .doc(myTask.id)
          .update({"docId": myTask.id});
      _showSnackBar("Ma'lumot saqlandi!");
    } catch (e) {
      _showSnackBar("Xato: ${e.toString()}");
    } 
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.lightMode
          ? AppColors.homeBackgroundColor
          : AppColors.standartColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gap(5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RadioListTile.adaptive(
                            // contentPadding: EdgeInsets.zero,
                            title: Text(widget.language == 'eng'
                                ? 'I get'
                                : widget.language == 'rus'
                                    ? 'Получу'
                                    : 'Olaman'),
                            value: "debtor",
                            groupValue: _selectedRadioValue,
                            onChanged: (v) {
                              setState(() {
                                _selectedRadioValue = v!;
                              });
                            }),
                      ),
                      Expanded(
                        child: RadioListTile.adaptive(
                            // contentPadding: EdgeInsets.zero,
                            title: Text(widget.language == 'eng'
                                ? 'I owe'
                                : widget.language == 'rus'
                                    ? 'Дам'
                                    : 'Beraman'),
                            value: "i_owe",
                            groupValue: _selectedRadioValue,
                            onChanged: (v) {
                              setState(() {
                                _selectedRadioValue = v!;
                              });
                            }),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  TaskField(
                    controller: _nameController,
                    labelText: widget.language == 'eng'
                        ? 'Name'
                        : widget.language == 'rus'
                            ? 'Имя'
                            : "Ism",
                    icon: Icons.person_outline,
                    language: widget.language,
                    keyBordtype: TextInputType.name,
                    maxLin: 1,
                    validator: true,
                    sufix: false,
                    isDense: true,
                    conPad: 5.h,
                  ),
                  Gap(40.h),
                  TaskField(
                    controller: _amountMoneyController,
                    formatters: [InputFormatters.moneyFormatter],
                    labelText: widget.language == 'eng'
                        ? 'Amount of debts'
                        : widget.language == 'rus'
                            ? 'Сумма денег'
                            : "Qarz miqdori",
                    language: widget.language,
                    keyBordtype: TextInputType.number,
                    maxLin: 1,
                    validator: true,
                    sufix: false,
                    isDense: true,
                    conPad: 5.h,
                  ),
                  Gap(40.h),
                  TaskField(
                    controller: _goalController,
                    labelText: widget.language == 'eng'
                        ? 'Purpose of borrowing'
                        : widget.language == 'rus'
                            ? 'Цель заимствования'
                            : "Izoh...",
                    hintText: widget.language == 'eng'
                        ? 'This field is optional!'
                        : widget.language == 'rus'
                            ? 'Это поле не обязательно для заполнения!'
                            : "Bu yerga yozish majburiy emas !",
                    language: widget.language,
                    maxLin: 3,
                    minLin: 1,
                    validator: false,
                    sufix: false,
                    isDense: true,
                    conPad: 5.h,
                  ),
                  Gap(40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TaskField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () async {
                            final date = await _handleDatePicker(_date);
                            if (date != null) {
                              _date = date;
                              _dateController.text = _allDate.format(date);
                            }
                          },
                          labelText: widget.language == 'eng'
                              ? 'Date'
                              : widget.language == 'rus'
                                  ? 'Дата'
                                  : "Sana",
                          language: widget.language,
                          keyBordtype: TextInputType.datetime,
                          validator: true,
                          sufix: false,
                          isDense: true,
                          conPad: 5.h,
                        ),
                      ),
                      Gap(20.w),
                      Expanded(
                        child: TaskField(
                          controller: _dueDateController,
                          readOnly: true,
                          onTap: () async {
                            final date = await _handleDueDatePicker(_dueDate);
                            if (date != null) {
                              _dueDate = date;
                              _dueDateController.text = _allDate.format(date);
                            }
                          },
                          labelText: widget.language == 'eng'
                              ? 'Date'
                              : widget.language == 'rus'
                                  ? 'Дата'
                                  : "Sana",
                          language: widget.language,
                          keyBordtype: TextInputType.datetime,
                          validator: true,
                          sufix: false,
                          isDense: true,
                          conPad: 5.h,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _submit();
            if (widget.pop) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              );
            }
          }
        },
        icon: Icons.check,
      ),
    );
  }

  Future<DateTime?> _handleDatePicker(DateTime? initialDate) async {
    final now = DateTime.now();
    final sixMonthsFromNow = DateTime(
      now.year,
      now.month + 6,
      now.day,
    );
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: sixMonthsFromNow,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    return date;
  }

  Future<DateTime?> _handleDueDatePicker(DateTime? initialDate) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      locale: Locale('en'),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    return date;
  }
}

// // hive uchun kodlar
// import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
// import 'package:agenda/layers/presentation/extension/extension.dart';
// import 'package:agenda/layers/presentation/helpers/input_formatter.dart';
// import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
// import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
// import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:intl/intl.dart';
// import 'package:hive/hive.dart';

// class AddUserDebtsPage extends StatefulWidget {
//   final String language;
//   final bool lightMode;
//   final bool pop;
//   const AddUserDebtsPage({
//     super.key,
//     required this.language,
//     required this.lightMode,
//     required this.pop,
//   });

//   @override
//   State<AddUserDebtsPage> createState() => _AddUserDebtsPageState();
// }

// class _AddUserDebtsPageState extends State<AddUserDebtsPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late final TextEditingController _nameController;
//   late final TextEditingController _amountMoneyController;
//   late final TextEditingController _goalController;
//   late final TextEditingController _dateController;
//   String _selectedRadioValue = "debtor";
//   DateTime _date = DateTime.now();
//   final DateFormat _dateFormat = DateFormat.yMMMMEEEEd('en_US');
//   final DateFormat _dateFormatRu = DateFormat.yMMMMEEEEd('ru_RU');
//   final DateFormat _dateFormatUz = DateFormat.yMMMMEEEEd('uz_UZ');
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _dateController = TextEditingController(
//       text: widget.language == 'eng'
//           ? _dateFormat.format(DateTime.now())
//           : widget.language == 'rus'
//               ? _dateFormatRu.format(DateTime.now())
//               : _dateFormatUz.format(DateTime.now()),
//     );
//     _goalController = TextEditingController();
//     _amountMoneyController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _dateController.dispose();
//     _amountMoneyController.dispose();
//     _goalController.dispose();
//     super.dispose();
//   }

//   _handleDatePicker() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: _date,
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2050),
//     );
//     if (date != null && date != _date) {
//       setState(() {
//         _date = date;
//       });
//       _dateController.text = widget.language == 'eng'
//           ? _dateFormat.format(date)
//           : widget.language == 'rus'
//               ? _dateFormatRu.format(date)
//               : _dateFormatUz.format(date);
//     }
//   }

//   Future<void> _submit() async {
//     try {
//       final debtsBox = Hive.box<DebtsModel>('debtsList');
//       final task = DebtsModel(
//         name: _nameController.text.trim(),
//         date: _date,
//         goal: _goalController.text.trim(),
//         money: num.tryParse(_amountMoneyController.text.pickOnlyNumber()) ?? 0,
//         debt: _selectedRadioValue == 'debtor' ? 'get' : 'owe',
//       );

//       debtsBox.add(task);
//       _showSnackBar("Ma'lumot saqlandi!");
//     } catch (e) {
//       _showSnackBar("Xato: ${e.toString()}");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: widget.lightMode
//           ? AppColors.homeBackgroundColor
//           : AppColors.standartColor,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Gap(5.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: RadioListTile.adaptive(
//                       title: Text(widget.language == 'eng' ? 'I get' : widget.language == 'rus' ? 'Получу' : 'Olaman'),
//                       value: "debtor",
//                       groupValue: _selectedRadioValue,
//                       onChanged: (v) {
//                         setState(() {
//                           _selectedRadioValue = v!;
//                         });
//                       },
//                     ),
//                   ),
//                   Expanded(
//                     child: RadioListTile.adaptive(
//                       title: Text(widget.language == 'eng' ? 'I owe' : widget.language == 'rus' ? 'Дам' : 'Beraman'),
//                       value: "i_owe",
//                       groupValue: _selectedRadioValue,
//                       onChanged: (v) {
//                         setState(() {
//                           _selectedRadioValue = v!;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               Gap(20.h),
//                 TaskField(
//                     controller: _nameController,
//                     labelText: widget.language == 'eng'
//                         ? 'Name'
//                         : widget.language == 'rus'
//                             ? 'Имя'
//                             : "Ism",
//                     icon: Icons.person_outline,
//                     language: widget.language,
//                     keyBordtype: TextInputType.name,
//                     maxLin: 1,
//                     validator: true,
//                     sufix: false,
//                     isDense: true,
//                     conPad: 5.h,
//                   ),
//               Gap(40.h),
//              TaskField(
//                     controller: _amountMoneyController,
//                     formatters: [InputFormatters.moneyFormatter],
//                     labelText: widget.language == 'eng'
//                         ? 'Amount of debts'
//                         : widget.language == 'rus'
//                             ? 'Сумма денег'
//                             : "Qarz miqdori",
//                     language: widget.language,
//                     keyBordtype: TextInputType.number,
//                     maxLin: 1,
//                     validator: true,
//                     sufix: false,
//                     isDense: true,
//                     conPad: 5.h,
//                   ),
//               Gap(40.h),
//                  TaskField(
//                     controller: _goalController,
//                     labelText: widget.language == 'eng'
//                         ? 'Purpose of borrowing'
//                         : widget.language == 'rus'
//                             ? 'Цель заимствования'
//                             : "Izoh...",
//                     hintText: widget.language == 'eng'
//                         ? 'This field is optional!'
//                         : widget.language == 'rus'
//                             ? 'Это поле не обязательно для заполнения!'
//                             : "Bu yerga yozish majburiy emas !",
//                     language: widget.language,
//                     maxLin: 3,
//                     minLin: 1,
//                     validator: false,
//                     sufix: false,
//                     isDense: true,
//                     conPad: 5.h,
//                   ),
//                   Gap(40.h),
//               TaskField(
//                     controller: _dateController,
//                     onTap: () {
//                       FocusScope.of(context).requestFocus(FocusNode());
//                       _handleDatePicker();
//                     },
//                     labelText: widget.language == 'eng'
//                         ? 'Date'
//                         : widget.language == 'rus'
//                             ? 'Дата'
//                             : "Sana",
//                     language: widget.language,
//                     keyBordtype: TextInputType.datetime,
//                     validator: true,
//                     sufix: false,
//                     isDense: true,
//                     conPad: 5.h,
//                   ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: MyFloatinacshinbutton(
//         onPressed: () {
//           if (_formKey.currentState!.validate()) {
//             _submit();
//             if (widget.pop) Navigator.of(context).pop();
//           }
//         },
//         icon: Icons.check,
//       ),
//     );
//   }
// }
