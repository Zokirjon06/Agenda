import 'package:flutter/material.dart';

class AppbarLeadingIcon extends StatefulWidget {
  const AppbarLeadingIcon({super.key});

  @override
  State<AppbarLeadingIcon> createState() => _AppbarLeadingIconState();
}

class _AppbarLeadingIconState extends State<AppbarLeadingIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){
      Navigator.of(context).pop();
    }, icon: Icon(Icons.arrow_back_ios_new,size: MediaQuery.sizeOf(context).width * 0.07,));
    // }, icon: Icon(Icons.arrow_circle_left,size: MediaQuery.sizeOf(context).width * 0.09,));
  }
}