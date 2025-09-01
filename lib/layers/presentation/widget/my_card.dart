import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function onTap;
  const MyCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: const Color.fromARGB(246, 1, 28, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        elevation: 6,
        child: InkWell(
          onTap: () => widget.onTap(),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Gap(10.h),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 20.sp, color: Colors.white),
                ),
                Gap(5.h),
                Text(
                  widget.subtitle,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
