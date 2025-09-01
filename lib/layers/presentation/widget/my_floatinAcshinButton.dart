import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyFloatinacshinbutton extends StatefulWidget {
  final Function onPressed;
  final IconData? icon;
  const MyFloatinacshinbutton({super.key, required this.onPressed, this.icon});

  @override
  State<MyFloatinacshinbutton> createState() => _MyFloatinacshinbuttonState();
}

class _MyFloatinacshinbuttonState extends State<MyFloatinacshinbutton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => widget.onPressed(),
      foregroundColor: Colors.blue,
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      child: widget.icon != null ? Icon(widget.icon, size: 30.sp,) : Icon(Icons.add,size: 30.sp,),
    );
  }
}
