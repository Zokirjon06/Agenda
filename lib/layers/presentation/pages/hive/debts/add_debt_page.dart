import 'dart:async';

import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/helpers/input_formatter.dart';
import 'package:agenda/layers/presentation/helpers/snackbar_message.dart';
import 'package:agenda/layers/presentation/pages/add/expenses/add_expense_page.dart';
import 'package:agenda/layers/presentation/widget/appBar_leading_icon.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:flutter/material.dart';

import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

// ------------------------------------------------------------
// AddDebtPage
// ------------------------------------------------------------
class AddDebtPage extends StatefulWidget {
  final String language;
  const AddDebtPage({
    super.key,
    required this.language,
  });

  @override
  State<AddDebtPage> createState() => _AddDebtPageState();
}

class _AddDebtPageState extends State<AddDebtPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeComment = FocusNode();
  late final TextEditingController _nameController;
  late final TextEditingController _amountMoneyController;
  late final TextEditingController _goalController;
  late final TextEditingController _dateController;
  final DateTime _date = DateTime.now();
  DateTime _dueDate = DateTime.now();
  late final DateFormat _allDate;
  bool debtor = true;
  bool expense = false;

  // initState and dispose
  @override
  void initState() {
    super.initState();
    _allDate = DateFormat.yMMMMEEEEd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
    _dueDate = DateTime(_date.year, _date.month, _date.day + 1);
    _dateController = TextEditingController(text: _allDate.format(_dueDate));
    _nameController = TextEditingController();
    _goalController = TextEditingController();
    _amountMoneyController = TextEditingController();
    // _TaskType;
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _focusNodeName.dispose();
    _focusNodeComment.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _amountMoneyController.dispose();
    _goalController.dispose();
  }

  // function
 Future<void> _submit() async {
  try {
    // Hive.openBox<DebtsModel>('debtsBox');
    final debtsBox = Hive.box<DebtsModel>('debtsBox');

    final debt = DebtsModel(
      name: _nameController.text.trim(),
      date: _date,
      goal: _goalController.text.trim(),
      money: num.tryParse(_amountMoneyController.text.pickOnlyNumber()) ?? 0,
      debt: debtor ? 'get' : 'owe',
    );

    await debtsBox.add(debt); // Hive-ga qo‘shish

    if (context.mounted) {
      showMessage(message: "Saqlash muvaffaqiyatli bajarildi!", context: context);
      Navigator.pop(context); // Orqaga qaytish
    }
  } catch (e) {
    if (context.mounted) {
      showMessage(message: "Xato: ${e.toString()}", context: context);
      debugPrint("Xato: ${e.toString()}",);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 3,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.standartColor,
          statusBarIconBrightness: Brightness.light,
        ),
        titleSpacing: 0,
       leading: const AppbarLeadingIcon(),
        title: Text(
              "Yangi qarz",
              style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
        ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Gap(20.h),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              border: debtor
                                  ? null
                                  : Border.all(color: Colors.white70),
                              color: debtor ? Colors.amber[900] : null),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                debtor = true;
                                expense = false;
                              });
                            },
                            child: Center(
                                child: Text(
                              widget.language == 'eng'
                                  ? 'I get'
                                  : widget.language == 'rus'
                                      ? 'Ujkn knwe'
                                      : "Qarzdor",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.sp),
                            )),
                          ),
                        )),
                        Gap(10.w),
                        Expanded(
                            child: Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              border: debtor || expense
                                  ? Border.all(color: Colors.white70)
                                  : null,
                              color:
                                  debtor || expense ? null : Colors.amber[900]),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                debtor = false;
                                expense = false;
                              });
                            },
                            child: Center(
                                child: Text(
                              widget.language == 'eng'
                                  ? 'I owe'
                                  : widget.language == 'rus'
                                      ? 'Wdhjndjfn'
                                      : "Qarzdorman",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.sp),
                            )),
                          ),
                        )),
                        Gap(10.w),
                        Expanded(
                            child: Container(
                          height: 35.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(color: Colors.white70)),
                          child: InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddExpensePage(
                                          language: widget.language,
                                        ))),
                            child: Center(
                                child: Text(
                              widget.language == 'eng'
                                  ? 'Expense'
                                  : widget.language == 'rus'
                                      ? 'Wdhjndjfn'
                                      : "Xarajat",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.sp),
                            )),
                          ),
                        )),
                      ],
                    ),
                    Gap(30.h),
                    TextFormField(
                      controller: _amountMoneyController,
                      focusNode: _focusNode,
                      inputFormatters: [InputFormatters.moneyFormatter],
                      decoration: InputDecoration(
                          hintText: widget.language == 'eng'
                              ? 'Amount of debts'
                              : widget.language == 'rus'
                                  ? 'Сумма денег'
                                  : "Qarz miqdori",
                          hintStyle:
                              TextStyle(color: Colors.white70, fontSize: 18.sp),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white70, width: 1.5.w),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.r))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.lightBlueAccent, width: 2.5.w),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.r))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white70),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.r))),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.r)))),
                      keyboardType: TextInputType.number,
                    ),
                    Gap(10.h),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepOrange,
                        radius: 20.r,
                        child: const Center(
                            child: Icon(
                          Icons.person,
                          color: Colors.white,
                        )),
                      ),
                      title: Text(
                        widget.language == 'eng'
                            ? 'Name'
                            : widget.language == 'rus'
                                ? 'Имя'
                                : "Ism",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: TextFormField(
                        controller: _nameController,
                        focusNode: _focusNodeName,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0),
                            isDense: true,
                            hintText: widget.language == 'eng'
                                ? 'Name'
                                : widget.language == 'rus'
                                    ? 'Имя'
                                    : "To'liq ism kiriting",
                            hintStyle: TextStyle(
                                color: Colors.white30, fontSize: 18.sp),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    Gap(5.h),
                    const Divider(
                      color: Colors.white30,
                      height: 1,
                    ),
                    Gap(5.h),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 20.r,
                        child: const Center(
                            child: Icon(
                          Icons.comment,
                          color: Colors.white,
                        )),
                      ),
                      title: Text(
                        widget.language == 'eng'
                            ? 'Comment'
                            : widget.language == 'rus'
                                ? 'Цель заимствования'
                                : "Izoh",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: TaskField(
                        controller: _goalController,
                        focusNode: _focusNodeComment,
                        language: widget.language,
                        maxLin: null,
                        minLin: 1,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.all(0),
                          hintText: widget.language == 'eng'
                              ? 'Purpose of borrowing'
                              : widget.language == 'rus'
                                  ? 'Цель заимствования'
                                  : "Qarz olish maqsadi",
                          hintStyle:
                              TextStyle(color: Colors.white30, fontSize: 18.sp),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                        validator: false,
                        sufix: false,
                        isDense: true,
                        conPad: 5.h,
                      ),
                    ),
                    Gap(5.h),
                    const Divider(
                      color: Colors.white30,
                      height: 1,
                    ),
                    Gap(5.h),
                    ListTile(
                        onTap: () async {
                          final dueDate = await _handleDueDatePicker(_dueDate);
                          if (dueDate != null) {
                            _dueDate = dueDate;
                            _dateController.text = _allDate.format(dueDate);
                          }
                          setState(() {});
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                        leading: Icon(
                          Icons.date_range,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                        title: Text(
                          widget.language == 'eng'
                              ? 'Due date'
                              : widget.language == 'rus'
                                  ? 'Csdhbjhbjh'
                                  : "Muddat",
                          style:
                              TextStyle(fontSize: 15.sp, color: Colors.white70),
                        ),
                        subtitle: Text(
                          _dateController.text.toString(),
                          style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )),
                    Gap(5.h),
                    const Divider(
                      color: Colors.white30,
                      height: 1,
                    ),
                  ],
                )),
          ),
        ),
      ),
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () {
          if (_amountMoneyController.text.isNotEmpty &&
              _nameController.text.isNotEmpty) {
            _submit();
            _amountMoneyController.clear();
            _nameController.clear();
            _goalController.clear();
            _focusNode.unfocus();
            _focusNodeName.unfocus();
            _focusNodeComment.unfocus();
            showMessage(context: context, message: 'Qarzdor saqlandi');
           
          } else {
            return showMessage(
                message: 'Iltimos bo\'sh kataklarni to\'ldiring',
                context: context);
          }
        },
        icon: Icons.check,
      ),
    );
  }

  Future<DateTime?> _handleDueDatePicker(DateTime? initialDate) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
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
