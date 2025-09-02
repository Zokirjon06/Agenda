import 'package:agenda/layers/domain/models/hive_model/debts/debts_model.dart';
import 'package:agenda/layers/presentation/helpers/input_formatter.dart';
import 'package:agenda/layers/presentation/pages/hive/debts/add_debt_page.dart';
import 'package:agenda/layers/presentation/pages/hive/debts/detail/debt_detail_page.dart';
import 'package:agenda/layers/presentation/widget/appBar_leading_icon.dart';
import 'package:agenda/layers/presentation/widget/divders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agenda/layers/presentation/extension/extension.dart';
import 'package:hive/hive.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class DebtsListPage extends StatefulWidget {
  final String language;
  const DebtsListPage({
    super.key,
    required this.language,
  });

  @override
  State<DebtsListPage> createState() => _DebtsListPageState();
}

class _DebtsListPageState extends State<DebtsListPage> {
  String? _dropMenu = 'debts';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _dropMenu,
            dropdownColor: AppColors.another,
            icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 30.sp),
            items: [
              DropdownMenuItem(
                value: "debts",
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  leading: Icon(Icons.home_outlined,
                      color: Colors.white, size: 32.sp),
                  title: Text("Qarzlar",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              DropdownMenuItem(
                value: "debtors",
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 15.w, right: 0),
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  leading: Icon(Icons.format_list_bulleted_outlined,
                      color: Colors.white, size: 30.sp),
                  title: Text("Qarzdorlar",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              DropdownMenuItem(
                value: "userDebts",
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 15.w, right: 0),
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  leading: Icon(Icons.format_list_bulleted_outlined,
                      color: Colors.white, size: 30.sp),
                  title: Text("Qarzlarim",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
              DropdownMenuItem(
                value: "date",
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  leading: Icon(Icons.calendar_month,
                      color: Colors.white, size: 30.sp),
                  title: Text("Taqvim",
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ],
            onChanged: (v) {
              setState(() {
                _dropMenu = v!;
              });
            },
            selectedItemBuilder: (BuildContext context) {
              return [
                "debts",
                "debtors",
                "userDebts",
                "date",
              ].map<Widget>((value) {
                return Row(
                  children: [
                    Text(
                      value == "debts"
                          ? "Qarzlar"
                          : value == "debtors"
                              ? "Qarzdorlar"
                              : value == "userDebts"
                                  ? "Qarzlarim"
                                  : "Taqvim",
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Gap(20.w),
                  ],
                );
              }).toList();
            },
          ),
        ),
        leading: const AppbarLeadingIcon(),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 30.sp,
              ))
        ],
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 3,
        titleSpacing: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:
              AppColors.standartColor, // Status bar rangini o'zgartirish
          statusBarIconBrightness:
              Brightness.light, // Ikonalar rangini o'zgartirish
        ),
      ),
      body: SingleChildScrollView(
        child: _dropMenu == 'date'
            ? DebtsCalendarHive(language: widget.language, lightMode: false)
            : DebtsItem(
                language: widget.language,
                lightMode: false,
                random: true,
                debt: _dropMenu,
              ),
      ),
      floatingActionButton: MyFloatinacshinbutton(onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => AddDebtPage(
                    language: widget.language,
                  )),
        );
      }),
    );
  }
}


// -----------------------------------------------------------
// Debts Item
// -----------------------------------------------------------
class DebtsItem extends StatelessWidget {
  final String language;
  final bool lightMode;
  final bool random;
  final String? debt;

  const DebtsItem({
    super.key,
    required this.language,
    required this.lightMode,
    required this.random,
    this.debt,
  });

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<DebtsModel>('debtsBox');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<DebtsModel> debtsBox, _) {
        List<DebtsModel> userDebts = debtsBox.values.toList();

        if (userDebts.isEmpty) {
          return const Center(
            child: Text(
              "Ma'lumot yo‘q",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // Tartiblash (yangi qo‘shilganlar yuqorida bo‘lsin)
        userDebts.sort((b, a) => a.date!.compareTo(b.date!));

        List<DebtsModel> filteredDebtGet =
            userDebts.where((d) => d.debt == 'get').toList();
        List<DebtsModel> filteredDebtOwe =
            userDebts.where((d) => d.debt == 'owe').toList();

        List<DebtsModel> displayedDebts = debt == 'debtors'
            ? filteredDebtGet
            : debt == 'userDebts'
                ? filteredDebtOwe
                : userDebts;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedDebts.length,
          itemBuilder: (context, index) {
            return _buildUserDebtsItem(
              context,
              displayedDebts[index],
              index != 0,
            );
          },
        );
      },
    );
  }

  Widget _buildUserDebtsItem(BuildContext context, DebtsModel debts, bool showDivider) {
    final int hash = debts.name.hashCode;
    final randomColor = Colors.primaries[hash % Colors.primaries.length];

    Widget listTile = Dismissible(
      key: ValueKey(debts.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        showDebtDismissibleHive(context, language, debts, debts.key);
        return false;
      },
      background: Container(
        color: Colors.lightBlue,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      child: ListTile(
        minTileHeight: 79.h,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  DebtDetailPage(language: language, debt: debts),
            ),
          );
        },
        leading: CircleAvatar(
          radius: 30.r,
          backgroundColor: randomColor,
          child: Text(
            debts.name!.isNotEmpty ? debts.name![0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        title: Text(
          "${debts.name}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: debts.money != 0
            ? Text(
                '${language == 'eng' ? 'Debt Amount' : language == 'rus' ? "Сумма долга" : 'Qarz Miqdori'}: ${debts.money.toMoney()} so\'m',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white38,
                ),
              )
            : const Text(
                'Qarz: to\'landi',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Colors.green,
                ),
              ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat.MMMMd('uz_UZ').format(debts.date!),
              style: TextStyle(fontSize: 14.sp, color: Colors.white38),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (debts.money == 0)
                  const Icon(Icons.check_circle_outline_outlined,
                      color: Colors.green),
                if (debts.money != 0)
                  Icon(
                    debts.debt == 'get'
                        ? Icons.add_circle_outline_rounded
                        : Icons.remove_circle_outline_sharp,
                    color: debts.debt == 'get'
                        ? Colors.blue[300]
                        : Colors.red[300],
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Dividers(lightMode: lightMode, inden: true),
          ),
        listTile,
      ],
    );
  }
}



// ---------------------------------------------------
// DebtsCalendarHive
// ---------------------------------------------------
class DebtsCalendarHive extends StatefulWidget {
  final String language;
  final bool lightMode;
  const DebtsCalendarHive(
      {super.key, required this.language, required this.lightMode});

  @override
  State<DebtsCalendarHive> createState() => _DebtsCalendarHiveState();
}

class _DebtsCalendarHiveState extends State<DebtsCalendarHive> {
  List<DebtsModel> getDebtsFromHive() {
    final box = Hive.box<DebtsModel>('debtsBox');
    return box.values.toList();
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
    List<DebtsModel> debts = getDebtsFromHive();

    if (debts.isEmpty) {
      return const Center(
          child: Text("Kundalik bo'sh", style: TextStyle(color: Colors.white)));
    }

    // Sanalarga qarab vazifalarni ajratish
    final Map<DateTime, List<DebtsModel>> debtByDate = {};
    for (var debt in debts) {
      final dates = DateTime(debt.date!.year, debt.date!.month, debt.date!.day);
      debtByDate.putIfAbsent(dates, () => []).add(debt);
    }

    final sortedDates = debtByDate.keys.toList()..sort();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final debtsForDate = debtByDate[date]!;
        debtsForDate.sort((a, b) => a.date!.compareTo(b.date!));

        return Card(
          elevation: 0,
          color: Colors.white10,
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
              ...debtsForDate.map((debt) => ListTile(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => DebtDetailPage(
                      //         language: widget.language,
                      //         debt: debt,
                      //         )));
                    },
                    title: Text(
                      debt.name!,
                      style: TextStyle(fontSize: 20.sp, color: Colors.white),
                    ),
                    subtitle: Text(
                      "${debt.debt != 'get' ? _getTextGet() : _getTextOwe()}: ${debt.money} so'm",
                      style: TextStyle(fontSize: 13.sp, color: Colors.white70),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 17.sp,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  String _getTextGet() {
    switch (widget.language) {
      case 'eng':
        return 'I GET';
      case 'rus':
        return 'Я ПОЛУЧАЮ';
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
        return 'Я ДОЛЖЕН';
      case 'uzb':
        return 'QARZDORMAN';
      default:
        return 'I OWE';
    }
  }
}



// ---------------------------------------------------
// DebtDismissibleHive
// ---------------------------------------------------
class DebtDismissibleHive extends StatefulWidget {
  final String language;
  final DebtsModel debts;
  final int index;

  const DebtDismissibleHive({
    super.key,
    required this.language,
    required this.debts,
    required this.index,
  });

  @override
  State<DebtDismissibleHive> createState() => _DebtDismissibleHiveState();
}

class _DebtDismissibleHiveState extends State<DebtDismissibleHive> {
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

 
  
  Future<void> _submit() async {
  final detail = DebtsDetailModel(
    fulName: widget.debts.name,
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
  widget.debts.detail ??= [];

  widget.debts.detail!.add(detail);

  // Keyinchalik Hive’da saqlash uchun
  await widget.debts.save();
}


  Future<void> _saveChanges() async {
    if (_totalMoney == null) return;

    widget.debts.money = _totalMoney!;
    await widget.debts.save(); // mana shu yerda index yoki keyni kerak qilmaydi
  }

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

Future<void> showDebtDismissibleHive(
  BuildContext context,
  String language,
  DebtsModel debt,
  int index,
) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        DebtDismissibleHive(language: language, debts: debt, index: index),
  );
}
