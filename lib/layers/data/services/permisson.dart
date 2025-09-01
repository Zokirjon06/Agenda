import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions(BuildContext context) async {
  final micPermission = await Permission.microphone.request();
  if (micPermission != PermissionStatus.granted) {
    // Ruxsat olinmagan holat
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Mikrofon uchun ruxsat talab qilinadi")),
    );
  }
  
}


