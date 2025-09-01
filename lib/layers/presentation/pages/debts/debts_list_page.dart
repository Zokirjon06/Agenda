import 'package:agenda/layers/presentation/pages/add/add_page.dart';
import 'package:agenda/layers/presentation/pages/debts/add_debts/add_debts_home_page.dart';
import 'package:agenda/layers/presentation/pages/main/home_screen_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:agenda/layers/presentation/widget/debts_item.dart';
import 'package:agenda/layers/presentation/widget/my_floatinAcshinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DebtsListScreenPage extends StatefulWidget {
  final String language;
  const DebtsListScreenPage(
      {super.key, required this.language, });

  @override
  _DebtsListScreenPageState createState() => _DebtsListScreenPageState();
}

class _DebtsListScreenPageState extends State<DebtsListScreenPage> {
  String? _dropMenu = 'debts';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor
          : AppColors.standartColor,
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
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue[900],
                      radius: 16.r,
                      child: Icon(
                        Icons.attach_money_sharp,
                        size: 28.sp,
                        weight: 1000.w,
                      ),
                    ),
                    Gap(18.w),
                    Text(
                      value == "debts"
                          ? "Qarzlar"
                          : value == "debtors"
                              ? "Qarzdorlar"
                              : value == "userDebts"
                                  ? "Qarzlarim"
                                  : "Taqvim",
                      style: TextStyle(fontSize: 22.sp, color: Colors.white),
                    ),
                    Gap(20.w),
                  ],
                );
              }).toList();
            },
          ),
        ),
        leading: SizedBox(width: 0.w,height: 0.h,),
        leadingWidth: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => HomeScreenPage(
                            )),
                    (route) => false);
              },
              icon: Icon(
                Icons.home,
                size: 30.sp,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 30.sp,
              ))
        ],
        backgroundColor:
             AppColors.appBar,
        foregroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 3,
        titleSpacing: 18.w,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:
              AppColors.standartColor, // Status bar rangini o'zgartirish
          statusBarIconBrightness:
              Brightness.light, // Ikonalar rangini o'zgartirish
        ),
      ),
      body: SingleChildScrollView(
        child: _dropMenu == 'date'
            ? DebtsCalendar(
                language: widget.language, lightMode: false)
            : DebtsItem(
                language: widget.language,
                lightMode:false,
                random: true,
                debt: _dropMenu,
              ),
      ),
      floatingActionButton: MyFloatinacshinbutton(onPressed: (){
          Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AddPage(
                              language: widget.language,
                              dropMenu: 'debt',
                            )),
                   );
      }),
    );
  }
}
