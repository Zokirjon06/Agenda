import 'package:flutter/material.dart';

showMessage(
    {required BuildContext context,
    required String message,
    bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isError ? Colors.red : Colors.black,
      content: Text(message, style: const TextStyle(color: Colors.white))));
}


  showSnackBar( {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(backgroundColor: Colors.black, content: Text(message,style: TextStyle(color: Colors.grey),)));
  }