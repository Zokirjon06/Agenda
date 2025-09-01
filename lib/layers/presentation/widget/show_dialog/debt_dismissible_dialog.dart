import 'package:agenda/layers/domain/models/firebase_model/user_debt/debs_detail_model.dart';
import 'package:agenda/layers/domain/models/firebase_model/user_debt/debts_list_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/helpers/input_formatter.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class DebtDismissible extends StatefulWidget {
  final String language;
  final DebtsListModel debts;

  const DebtDismissible(
      {super.key, required this.language, required this.debts});

  @override
  State<DebtDismissible> createState() => _DebtDismissibleState();
}

class _DebtDismissibleState extends State<DebtDismissible> {
  late final TextEditingController _amountController;
  late final TextEditingController _commentController;
  late final TextEditingController _dateController;
  DateTime _date = DateTime.now();
  final DateFormat _dateFormat = DateFormat.yMMMMEEEEd('en_US');
  final DateFormat _dateFormatRu = DateFormat.yMMMMEEEEd('ru_RU');
  final DateFormat _dateFormatUz = DateFormat.yMMMMEEEEd('uz_UZ');
  String selectedAction = 'increase';
  num? _totalMoney;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
        text: widget.language == 'eng'
            ? DateFormat.yMMMMEEEEd('en_US').format(DateTime.now())
            : widget.language == 'rus'
                ? DateFormat.yMMMMEEEEd('ru_RU').format(DateTime.now())
                : DateFormat.yMMMMEEEEd('uz_UZ').format(DateTime.now()));
    _amountController = TextEditingController();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _calculateMoney() {
    if (selectedAction == 'increase') {
      _totalMoney = widget.debts.money! +
          (num.tryParse(_amountController.text.pickOnlyNumber()) ?? 0);
    } else {
      _totalMoney = widget.debts.money! -
          (num.tryParse(_amountController.text.pickOnlyNumber()) ?? 0);
    }
  }

  void _saveChanges() {
    final db = FirebaseFirestore.instance;

    if (_totalMoney != null) {
      widget.debts.money = _totalMoney;
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

  _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = widget.language == 'eng'
          ? _dateFormat.format(date)
          : widget.language == 'rus'
              ? _dateFormatRu.format(date)
              : _dateFormatUz.format(date);
    }
  }

  Future<void> _submit() async {
    final db = FirebaseFirestore.instance;

    try {
      DebtsListDetailModel newDetail = DebtsListDetailModel(
        fulName: widget.debts.name,
        date: _date,
        detailComment: _commentController.text,
        detailAmount: selectedAction == 'increase'
            ? num.tryParse(_amountController.text.pickOnlyNumber())
            : 0,
         removDetailAmount: selectedAction != 'increase'
            ? num.tryParse(_amountController.text.pickOnlyNumber())
            : 0,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.only(
                  left: 22.w, right: 22.w, top: 22.h, bottom: 10.h),
              decoration: BoxDecoration(
                color: AppColors.another,
                borderRadius: BorderRadius.circular(5.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.debts.debt == 'get' ? (widget.language == 'eng' ? 'Debtor' : 'Qarzdor') : (widget.language == 'eng' ? 'I owe' : 'Qarzdorman')}: ${widget.debts.name}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Umumiy Qarz: ${widget.debts.money.toMoney()} so'm",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Gap(30.h),
                  _buildTextField(
                    _amountController,
                    widget.language == 'eng'
                        ? 'Enter Amount'
                        : 'Yangi qarz kiriting',
                    TextInputType.number,
                    [InputFormatters.moneyFormatter]
                  ),
                  Gap(7.h),
                  TextButton(
                      onPressed: () {
                        _handleDatePicker();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 25.sp,
                            color: Colors.white,
                          ),
                          Gap(5.w),
                          Text(
                            _dateController.text.toString(),
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )
                        ],
                      )),
                  Gap(7.h),
                  _buildTextField(
                    _commentController,
                    widget.language == 'eng' ? 'Comment' : 'Izoh',
                    TextInputType.text,
                    null
                  ),
                  Gap(30.h),
                  _buildRadioButtons(),
                  SizedBox(height: 20.h),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
       TextInputType keyBordtype, List<TextInputFormatter>? formatters) {
    return TextField(
      controller: controller,
      keyboardType: keyBordtype,
      inputFormatters: formatters,
      // formatters: [InputFormatters.moneyFormatter],
      style: TextStyle(fontSize: 16.sp, color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: Colors.white12,
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRadioButtons() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
                widget.language == 'eng'
                    ? 'Increase'
                    : widget.language == 'rus'
                        ? 'Увеличить'
                        : 'Oshirish',
                style: const TextStyle(color: Colors.white)),
            value: 'increase',
            groupValue: selectedAction,
            onChanged: (value) =>
                setState(() => selectedAction = value.toString()),
          ),
        ),
        Expanded(
          child: RadioListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
                widget.language == 'eng'
                    ? 'Decrease'
                    : widget.language == 'rus'
                        ? 'Уменьшить'
                        : 'Kamaytirish',
                style: const TextStyle(color: Colors.white)),
            value: 'decrease',
            groupValue: selectedAction,
            onChanged: (value) =>
                setState(() => selectedAction = value.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.language == 'eng' ? 'Cancel' : 'Bekor qilish',
              style: TextStyle(fontSize: 19.sp, color: Colors.white)),
        ),
        SizedBox(width: 10.w),
        TextButton(
          onPressed: () {
            setState(() {
              _submit();
              _calculateMoney();
              _saveChanges();

              Navigator.of(context).pop();
            });
          },
          child: Text(widget.language == 'eng' ? 'Save' : 'Saqlash',
              style: TextStyle(fontSize: 19.sp, color: Colors.white)),
        ),
      ],
    );
  }
}

Future<void> showDebtDismissible(
    BuildContext context, String language, DebtsListModel debt) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => DebtDismissible(language: language, debts: debt),
  );
}
