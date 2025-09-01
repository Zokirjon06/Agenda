import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dividers extends StatelessWidget {
  final bool lightMode;
  final bool inden;
  const Dividers({super.key, required this.lightMode, required this.inden});

  @override
  Widget build(BuildContext context) {
    return Divider(
          thickness: 1,
          indent:86.w ,
          // height: 5.h,
          height: 1.h,
          color:  AppColors.deviderDark,
          // color: AppColors.deviderColorSearch,
        );
  }
}