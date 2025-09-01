import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  final String language;
  const Notifications({super.key, required this.language});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 4, 19, 44),
      // appBar: AppBar(
      //   title: Text("Notifications"),
      // ),
    );
  }
}