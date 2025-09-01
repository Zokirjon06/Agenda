import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreditListPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  const CreditListPage({super.key, required this.language, required this.lightMode});

  @override
  State<CreditListPage> createState() => _CreditListPageState();
}

class _CreditListPageState extends State<CreditListPage> {

  String? _dropMenu = 'credit';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.lightMode
            ? AppColors.homeBackgroundColor
            : AppColors.standartColor,
            appBar: AppBar(
                 title: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: _dropMenu,
            dropdownColor: AppColors.another,
            items: [
              DropdownMenuItem(
                value: "credit",
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.area_chart_outlined,size: 30.sp,),
                    Gap(10.w),
                    Text(
                      "Kreditlar",
                      style: TextStyle(fontSize: 22.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: "date",
                child: Row(
                  children: [
                    Icon(Icons.calendar_month,size: 30.sp,),
                    Gap(10.w),
                    Text(
                      "Taqvim",
                      style: TextStyle(fontSize: 22.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (v) {
              setState(() {
                _dropMenu = v!;
              });
            },
          ),
        ),
        
        // title: Text(
        //   language == 'eng'
        //       ? "Credit"
        //       : language == 'rus'
        //           ? "Долги"
        //           : "Kreditlar",
        // ),

        actions: [
          IconButton(
              onPressed: () {
              
              },
              icon: Icon(Icons.add,size: 30.sp,color: Colors.white,))
        ],
        elevation: 3,
        shadowColor: Colors.black,
         backgroundColor: widget.lightMode
            ? AppColors.homeBackgroundColor
            : AppColors.standartColor,
      ),
    );
  }
}