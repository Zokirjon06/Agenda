import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:agenda/layers/presentation/helpers/input_formatter.dart';
import 'package:agenda/layers/presentation/helpers/snackbar_message.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/appBar_leading_icon.dart';
import 'package:agenda/layers/presentation/widget/divders.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/standart_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class DebtDetailPage extends StatefulWidget {
  final String language;
  final DebtsModel debt;
  const DebtDetailPage({super.key, required this.language, required this.debt});

  @override
  State<DebtDetailPage> createState() => _DebtDetailPageState();
}

class _DebtDetailPageState extends State<DebtDetailPage> {
  late final DateFormat _allDate;
  final bool change = false;


  // Init state
  @override
  void initState() {
    change == false;
    _allDate = DateFormat.yMMMMd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');
    setState(() {});
    super.initState();
  }

  // Delete
  Future<void> _deleteDebtor() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.another,
        title: Text(
          widget.language == 'eng'
              ? 'Delete Debt'
              : widget.language == 'rus'
                  ? 'Удалить задачу'
                  : 'Qarzni o\'chirish',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          widget.language == 'eng'
              ? 'Are you sure you want to delete this debt?'
              : widget.language == 'rus'
                  ? 'Вы уверены, что хотите удалить эту задачу?'
                  : 'Haqiqatan ham bu qarzni o\'chirmoqchimisiz?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              widget.language == 'eng'
                  ? 'Cancel'
                  : widget.language == 'rus'
                      ? 'Отмена'
                      : 'Bekor qilish',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              widget.language == 'eng'
                  ? 'Delete'
                  : widget.language == 'rus'
                      ? 'Удалить'
                      : 'O\'chirish',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    

    // If the user confirmed the deletion
    if (confirmed == true) {
      try {
        await widget.debt.delete();
        showMessage(context: context,
         message: widget.language == 'eng'
              ? 'Task deleted successfully'
              : widget.language == 'rus'
                  ? 'Задача успешно удалена'
                  : 'Vazifa muvaffaqiyatli o\'chirildi',
        );

        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        showMessage(message: e.toString(), context: context);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppbarLeadingIcon(),
        titleSpacing: 0,
        title: Text(widget.debt.name!.trim(),
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
        backgroundColor: AppColors.appBar,
        elevation: 3,
        shadowColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:
              AppColors.standartColor, // Status bar rangini o'zgartirish
          statusBarIconBrightness:
              Brightness.light, // Ikonalar rangini o'zgartirish
        ),
      ),
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () => showShowDialogHive(context, widget.language, widget.debt),
      ),
      backgroundColor: AppColors.standartColor,
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
                      'Olingan: ${_allDate.format(widget.debt.date!)}',
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
                    "${widget.debt.money.toMoney()} so'm",
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
                      "Izoh: ${widget.debt.goal!.isEmpty ? 'Mavjud emas' : widget.debt.goal}",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Muddat: ${_allDate.format(widget.debt.date!)}',
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
         change == false? _getDebtorDetail() : _getDebtorDetailChange()
        ],
      ),
    );
  }

  Widget _getDebtorDetail() {
    List<DebtsDetailModel> debt = widget.debt.detail ?? [];
    if (debt.isEmpty) {
      return const Center();
    }
    debt.sort((a, b) => a.date!.compareTo(b.date!));
    return Expanded(
      child: ListView.builder(
        itemCount: debt.length,
        itemBuilder: (context, index) {
          final item = debt[index];
          return item.detailAmount! > 0
              ? _buildDebtorsItem(item, index == 0)
              : _buildDebtorsItem1(item, index == 0);
        },
      ),
    );
  }
 Widget _getDebtorDetailChange() {
  return ValueListenableBuilder(
    valueListenable: Hive.box<DebtsDetailModel>('debtsDetailBox').listenable(),
    builder: (context, Box<DebtsDetailModel> box, _) {
      List<DebtsDetailModel> debt = box.values.toList();

      if (debt.isEmpty) {
        return const Center();
      }

      // Sana bo‘yicha sort
      debt.sort((a, b) => a.date!.compareTo(b.date!));

      return Expanded(
        child: ListView.builder(
          itemCount: debt.length,
          itemBuilder: (context, index) {
            final item = debt[index];
            return item.detailAmount! > 0
                ? _buildDebtorsItem(item, index == 0)
                : _buildDebtorsItem1(item, index == 0);
          },
        ),
      );
    },
  );
}


  Widget _buildDebtorsItem(DebtsDetailModel debt, bool text) {
    return Column(
      children: [
        if (text)
          Text(
            'Qo\'shimcha qarzlar',
            style: TextStyle(color: Colors.white, fontSize: 17.sp),
          ),
        ListTile(
          minVerticalPadding: 0,
          minTileHeight: 70.h,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          onTap: () {},
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
        const Dividers(
          lightMode: true,
          inden: true,
        )
      ],
    );
  }
  

  // -------------------------------------------------------
  // _buildDebtorsItem1
  // -------------------------------------------------------
  Widget _buildDebtorsItem1(DebtsDetailModel debt, bool text) {
    return Column(
      children: [
        if (text)
          Text(
            'Qo\'shimcha qarzlar',
            style: TextStyle(color: Colors.white, fontSize: 17.sp),
          ),
        ListTile(
          minVerticalPadding: 0,
          minTileHeight: 70.h,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          onTap: () {},
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
        const Dividers(
          lightMode: true,
          inden: true,
        )
      ],
    );
  }
}




class ShowDialog extends StatefulWidget {
  final String language;
  final DebtsModel debts;
  // final int index;

  const ShowDialog({
    super.key,
    required this.language,
    required this.debts,
    // required this.index,
  });

  @override
  State<ShowDialog> createState() => _DebtDismissibleHiveState();
}

class _DebtDismissibleHiveState extends State<ShowDialog> {
  late final TextEditingController _amountController;
  late final TextEditingController _commentController;
  late final TextEditingController _dateController;
  DateTime _date = DateTime.now();
  String selectedAction = 'increase';
  num? _totalMoney;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _commentController = TextEditingController();
    _dateController = TextEditingController(
      text: _formatDate(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    if (widget.language == 'eng') {
      return DateFormat.yMMMMEEEEd('en_US').format(date);
    } else if (widget.language == 'rus') {
      return DateFormat.yMMMMEEEEd('ru_RU').format(date);
    } else {
      return DateFormat.yMMMMEEEEd('uz_UZ').format(date);
    }
  }

  void _calculateMoney() {
    final inputAmount =
        num.tryParse(_amountController.text.pickOnlyNumber()) ?? 0;
    _totalMoney = selectedAction == 'increase'
        ? widget.debts.money! + inputAmount
        : widget.debts.money! - inputAmount;
  }

 
  //
  Future<void> _submit() async {
  final detail = DebtsDetailModel(
    id: widget.debts.id,
    date: _date,
    detailComment: _commentController.text,
    detailAmount: selectedAction == 'increase'
        ? num.tryParse(_amountController.text.pickOnlyNumber())
        : 0,
    removDetailAmount: selectedAction == 'decrease'
        ? num.tryParse(_amountController.text.pickOnlyNumber())
        : 0,
  );

  // Agar detail null bo‘lsa, yangi ro‘yxat yaratamiz
  // widget.debts.detail ??= [];

 if(_amountController.text.isNotEmpty){
  setState(() {
    widget.debts.detail!.add(detail);
 });
 }

  // Keyinchalik Hive’da saqlash uchun
  await widget.debts.save();
}

  // _saveChanges
  Future<void> _saveChanges() async {
    if (_totalMoney == null) return;

    widget.debts.money = _totalMoney!;
    await widget.debts.save(); // mana shu yerda index yoki keyni kerak qilmaydi
  }
  

  // _handleDatePicker
  Future<void> _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
    if (date != null) {
      setState(() {
        _date = date;
        _dateController.text = _formatDate(date);
      });
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
              padding: EdgeInsets.all(22.w),
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
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Umumiy Qarz: ${widget.debts.money.toMoney()} so'm",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  Gap(30.h),
                  _buildTextField(
                      _amountController,
                      widget.language == 'eng'
                          ? 'Enter Amount'
                          : 'Yangi qarz kiriting',
                      TextInputType.number,
                      [InputFormatters.moneyFormatter]),
                  Gap(7.h),
                  TextButton(
                    onPressed: _handleDatePicker,
                    child: Row(
                      children: [
                        Icon(Icons.date_range,
                            size: 25.sp, color: Colors.white),
                        Gap(5.w),
                        Text(_dateController.text,
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  Gap(7.h),
                  _buildTextField(
                      _commentController,
                      widget.language == 'eng' ? 'Comment' : 'Izoh',
                      TextInputType.text,
                      null),
                  Gap(30.h),
                  _buildRadioButtons(),
                  SizedBox(height: 20.h),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      TextInputType keyboardType, List<TextInputFormatter>? formatters) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
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

  Widget _buildActionButtons() {
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
          onPressed: () async {
            _calculateMoney();
            await _submit();
            await _saveChanges();
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.language == 'eng' ? 'Save' : 'Saqlash',
              style: TextStyle(fontSize: 19.sp, color: Colors.white)),
        ),
      ],
    );
  }
}

Future<void> showShowDialogHive(
  BuildContext context,
  String language,
  DebtsModel debt,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        ShowDialog(language: language, debts: debt,),
  );
}
