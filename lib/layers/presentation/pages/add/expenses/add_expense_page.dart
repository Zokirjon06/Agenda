// import 'dart:js_interop';

import 'package:agenda/layers/presentation/helpers/input_formatter.dart';
import 'package:agenda/layers/presentation/helpers/snackbar_message.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/appBar_leading_icon.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:agenda/layers/presentation/widget/my_textFormFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  final String language;
  const AddExpensePage({super.key, required this.language});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  //
  final List<Map<String, dynamic>> _data = [
    {
      "name": "Hech qachon",
      "value": "never",
    },
    {
      "name": "Har kuni",
      "value": "every",
    },
    {
      "name": "Har 2 kunda",
      "value": "two",
    },
    {
      "name": "Har bir ish kuni",
      "value": "workDay",
    },
    {
      "name": "Har haftda",
      "value": "week",
    },
    {
      "name": "Har 2 haftada",
      "value": "twoWeek",
    },
    {
      "name": "Har 4 haftada",
      "value": "fourWeek",
    },
    {
      "name": "Har oyda",
      "value": "month",
    },
    {
      "name": "Har 2 oyda",
      "value": "twoMonth",
    },
    {
      "name": "Har 3 oyda",
      "value": "threeMonth",
    },
    {
      "name": "Har 6 oyda",
      "value": "sixMonth",
    },
    {
      "name": "Har yilda",
      "value": "year",
    },
  ];
  final List<Map<String, dynamic>> _expence = [
    {
      "name": "Oziq ovqat",
      'color': Colors.orange,
      "icon": Icons.restaurant,
      "value": "food",
    },
    {
      "name": "Xarid qilish",
      'color': Colors.pink,
      'icon': Icons.shopping_bag,
      "value": "shopping",
    },
    {
      "name": "Transport",
      'color': Colors.amber,
      'icon': Icons.directions_bus,
      "value": "transport",
    },
    {
      "name": "Uy",
      'color': Colors.yellow[900],
      'icon': Icons.home,
      "value": "home",
    },
    {
      "name": "Ko'ngil ochish",
      'color': Colors.purple,
      'icon': Icons.theater_comedy,
      "value": "game",
    },
    {
      "name": "Avtomobil",
      'color': Colors.blue,
      'icon': Icons.directions_car,
      "value": "car",
    },
    {
      "name": "Sayohat",
      'color': Colors.redAccent,
      'icon': Icons.flight,
      "value": "travel",
    },
    {
      "name": "Oila",
      'color': Colors.orangeAccent,
      'icon': Icons.person,
      "value": "famely",
    },
    {
      "name": "Sog'liqni saqlash",
      'color': Colors.red,
      'icon': Icons.local_hospital,
      "value": "doc",
    },
    {
      "name": "Ta'lim",
      'color': Colors.deepPurple,
      'icon': Icons.school,
      "value": "school",
    },
    {
      "name": "Sovg'a",
      'color': Colors.indigo,
      'icon': Icons.card_giftcard,
      "value": "gifts",
    },
    {
      "name": "Sport",
      'color': Colors.green[900],
      'icon': Icons.sports_soccer,
      "value": "sport",
    },
    {
      "name": "Go'zallik",
      'color': Colors.purpleAccent,
      'icon': Icons.spa,
      "value": "beautiful",
    },
    {
      "name": "Ish",
      'color': Colors.teal,
      'icon': Icons.work,
      "value": "work",
    },
    {
      "name": "Boshqa",
      'color': Colors.black12,
      'icon': Icons.help_outline,
      "value": "other",
    },
  ];

  //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountMoneyController;
  late final TextEditingController _goalController;
  late final TextEditingController _dateController;
  late final TextEditingController _endsController;
  // final PageController _pageController = PageController(initialPage: DateTime.now().month - 1);

  DateTime _date = DateTime.now();
  DateTime _dueDate = DateTime.now();
  late final DateFormat _allDate;
  final FocusNode _focusNode = FocusNode();
  Map<String, dynamic>? _ends;
  Map<String, dynamic>? _expenceType;

  //
  @override
  void initState() {
    _allDate = DateFormat.yMMMMd(widget.language == 'eng'
        ? 'en_US'
        : widget.language == 'rus'
            ? 'ru_RU'
            : 'uz_UZ');

    _dueDate = DateTime(_date.year, _date.month, _date.day + 1);
    _dateController = TextEditingController();
    _endsController = TextEditingController();
    _nameController = TextEditingController();
    _goalController = TextEditingController();
    _amountMoneyController = TextEditingController();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _endsController.dispose();
    _amountMoneyController.dispose();
    _goalController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      appBar: AppBar(
        leading: AppbarLeadingIcon(),
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        title: Text(
          "Yangi xarajat",
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 3,
        shadowColor: Colors.black,
        titleSpacing: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.standartColor,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(10.h),
                TextFormField(
                  controller: _amountMoneyController,
                  inputFormatters: [InputFormatters.moneyFormatter],
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    suffix: Text(widget.language == 'eng' ? 'USD' : widget.language == 'rus'? 'RUB' : 'UZS'),
                      hintText: widget.language == 'eng'
                          ? 'Amount of expense'
                          : widget.language == 'rus'
                              ? 'Сумма денег'
                              : "Xarajat miqdori",
                      hintStyle:
                          TextStyle(color: Colors.white70, fontSize: 18.sp),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70,width: 1.5.w),
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2.5.w),
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    onTap: () async {
                      _expenceType =
                          await _showCurrencyBottomSheet(context: context);
                    },
                    leading: CircleAvatar(
                      backgroundColor: _expenceType == null
                          ? Colors.deepOrange
                          : _expenceType!['color'],
                      radius: 20.r,
                      child: Center(
                          child: Icon(
                        _expenceType == null
                            ? Icons.category
                            : _expenceType!['icon'],
                        color: Colors.white,
                      )),
                    ),
                    title: Text(
                      _expenceType == null
                          ? 'Xarajat toifasini tanlang'
                          : _expenceType!['name'],
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20.sp,
                      color: Colors.white,
                    )),
                Gap(10.h),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  onTap: () async {
                    final dueDate = await _handleDueDatePicker(_dueDate);
                    if (dueDate != null) {
                      _dueDate = dueDate;
                      _dateController.text = _allDate.format(dueDate);
                    }
                    setState(() {});
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 20.r,
                    child: const Center(
                        child: Icon(
                      Icons.date_range,
                      color: Colors.white,
                    )),
                  ),
                  title: Text(
                    _dateController.text.isEmpty
                        ? 'Muddat'
                        : _dateController.text.trim(),
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  // trailing: Text('Muddat',style: TextStyle(fontSize: 18.sp),),
                ),
                Gap(10.h),
                if (_dateController.text.isNotEmpty)
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      onTap: () {
                        _showReminderBottomSheet(context: context);
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 20.r,
                        child: const Center(
                            child: Icon(
                          Icons.timer,
                          color: Colors.white,
                        )),
                      ),
                      title: Text(
                        'Eslatish',
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hech qachon',
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                          Gap(5.w),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ],
                      )),
                if (_dateController.text.isNotEmpty) Gap(10.h),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 20.r,
                    child: const Center(
                        child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                  ),
                  title: TaskField(
                    controller: _goalController,
                    language: widget.language,
                    maxLin: null,
                    minLin: 1,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                      hintText: widget.language == 'eng'
                          ? 'Write a note'
                          : widget.language == 'rus'
                              ? 'Цель заимствования'
                              : "Eslatma yozing",
                      hintStyle:
                          TextStyle(color: Colors.white, fontSize: 18.sp),
                      enabledBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    validator: false,
                    sufix: true,
                    isDense: true,
                  ),
                ),
                Gap(10.h),
                ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    onTap: () async {
                      _ends =
                          await _showRecurrenceBottomSheet(context: context);

                      if (_ends != null && _dateController.text.isNotEmpty) {
                        final result = _dueDate.difference(_date);
                        print('qolgan kun: ${result.inDays}');
                      }
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 20.r,
                      child: const Center(
                          child: Icon(
                        Icons.sync,
                        color: Colors.white,
                      )),
                    ),
                    title: Text(
                      widget.language == 'eng'
                          ? 'Recurrence'
                          : widget.language == 'rus'
                              ? 'Цель заимствования'
                              : "Takrorlanish",
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _ends == null ? 'Hech qachon' : _ends!['name'],
                          style:
                              TextStyle(color: Colors.white, fontSize: 15.sp),
                        ),
                        Gap(5.w),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ],
                    )),
                Gap(10.h),
                if (_ends != null && _ends!['value'] != 'never')
                  ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      onTap: () async {
                        final date = await _handleDueDatePicker(
                             _date);
                        if (date != null) {
                          _date = date;
                          _endsController.text = _allDate.format(date);
                        }
                        setState(() {});
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20.r,
                        child: const Center(
                            child: Icon(
                          Icons.hourglass_bottom,
                          color: Colors.white,
                        )),
                      ),
                      title: Text(
                        'To\'xtatish',
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _endsController.text.isEmpty
                                ? 'Hech qachon'
                                : _endsController.text,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                          Gap(5.w),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ],
                      )),
                if (_ends != null && _ends!['value'] != 'never') Gap(10.h),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: MyFloatinacshinbutton(
        onPressed: () {
          showMessage(context: context, message: 'Ma\'lumot saqlandi');
        },
        icon: Icons.check,
      ),
    );
  }

  Future<Map<String, dynamic>?> _showCurrencyBottomSheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      // showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.another,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.h),
              Text(
                "Xarajat toifalari",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              Gap(20.h),
              Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0),
                      itemCount: _expence.length,
                      itemBuilder: (context, index) {
                        final item = _expence[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _expenceType = item;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Column(children: [
                            CircleAvatar(
                              backgroundColor: item['color'],
                              child: Center(
                                child: Icon(
                                  item['icon'],
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Gap(5.h),
                            Text(
                              item['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                        );
                      })),
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.orange,
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.restaurant,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Oziq ovqat",
              //                     maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.pink,
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.shopping_bag,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Xarid qilish",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.amber,
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.directions_bus,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Transport",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   CircleAvatar(
              //                     backgroundColor: Colors.yellow[900],
              //                     child: const Center(
              //                       child: Icon(Icons.home),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Uy",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //           ],
              //         ),
              //         Gap(15.h),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.purple,
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.theater_comedy,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Ko'ngil ochish",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.blue,
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.directions_car,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Avtomobil",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.redAccent,
              //                     child: Center(
              //                       child: Icon(Icons.flight),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Sayoxat",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.orangeAccent,
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.person,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Oila",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //           ],
              //         ),
              //         Gap(15.h),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.red,
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.local_hospital,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "So'g'liqni saqlash",
              //                     maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.deepPurple,
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.school,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Ta'lim",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.indigo,
              //                     child: Center(
              //                       child: Icon(Icons.card_giftcard),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Sovg'a",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   CircleAvatar(
              //                     backgroundColor: Colors.green[900],
              //                     child: const Center(
              //                       child: Icon(Icons.sports_soccer),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Sport",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //           ],
              //         ),
              //         Gap(15.h),
              //         Row(
              //           children: [
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.purpleAccent,
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.spa,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Go'zallik",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.teal,
              //                     child: Center(
              //                       child: Icon(Icons.work),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Ish",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Navigator.of(context).pop();
              //                 },
              //                 child: Column(children: [
              //                   const CircleAvatar(
              //                     backgroundColor: Colors.black12,
              //                     child: Center(
              //                       child: Icon(Icons.help_outline),
              //                     ),
              //                   ),
              //                   Gap(5.h),
              //                   const Text(
              //                     "Boshqa",
              //                      maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: TextStyle(color: Colors.white),
              //                   ),
              //                 ]),
              //               ),
              //             ),
              //             const Expanded(
              //               child: Column(),
              //             ),
              //           ],
              //         ),
              //         Gap(20.h)
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
    return null;
  }

  Future<Map<String, dynamic>?> _showReminderBottomSheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      // showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.another,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.h),
              Text(
                "Eslatish",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              Gap(20.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          'Hech qachon',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          'Belgilangan sana kuni',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '1 kun oldin',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '2 kun oldin',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '3 kun oldin',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '4 kun oldin',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '5 kun oldin',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '6 kun oldin',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '7 kun oldin',
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return null;
  }

  Future<Map<String, dynamic>?> _showRecurrenceBottomSheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      // showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.another,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.h),
              Text(
                "Takrorlash",
                style: TextStyle(
                    fontSize: 21.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              Gap(20.h),
              Expanded(
                child: ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      final item = _data[index];
                      // final isSelected = item['value'] == _ends?['value'];
                      return ListTile(
                        onTap: () async {
                        
                            setState(() {
                              _ends = item;
                            });
                          
                          Navigator.of(context).pop();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          item['name'],
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color:
                                  Colors.white),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
    return null;
  }

  // Future<DateTime?> _showEndsBottomSheet(
  //     {required BuildContext context, required DateTime? initialDate}) async {
  //   showModalBottomSheet(
  //     context: context,
  //     useSafeArea: true,
  //     // showDragHandle: true,
  //     isScrollControlled: true,
  //     backgroundColor: AppColors.another,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.zero)),
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height * 0.45,
  //         padding: EdgeInsets.symmetric(horizontal: 16.w),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Gap(20.h),
  //             Text(
  //               "Sanani tanlang",
  //               style: TextStyle(
  //                   fontSize: 20.sp,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w500),
  //             ),
  //             Gap(20.h),
  //             // Expanded(child: SingleChildScrollView(child: PageView.builder(scrollDirection: Axis.vertical,controller: _pageController,itemCount: 12, itemBuilder: (context, index) {
  //             //   DateTime month = DateTime(DateTime.now().year, index + 1);
  //             //   return Center(child: Text(_allDate.format(month),style: TextStyle(fontSize: 24.sp,fontWeight: fw),),);
  //             // }),)),
  //             Expanded(
  //               child: ListView(
  //                 shrinkWrap: true,
  //                 physics: AlwaysScrollableScrollPhysics(),
  //                 children: [
  //                   CalendarDatePicker(
  //                     currentDate: initialDate,
  //                     initialDate: initialDate,
  //                     firstDate: _date,
  //                     lastDate: DateTime(2100),
  //                     onDateChanged: (date) {
  //                       setState(() {
  //                         _endsController.text =
  //                             _allDate.format(date).toString();
  //                       });
  //                       Navigator.of(context).pop();
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //   return null;
  // }

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
