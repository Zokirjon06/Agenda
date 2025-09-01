import 'package:flutter/material.dart';

class AppTheme {
  static final _theme = ThemeData(
    useMaterial3: true,
                textTheme: const TextTheme(
                    displaySmall: TextStyle(
                      fontSize: 18.0,
                        color: Colors.white, fontWeight: FontWeight.bold)),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                ),
                appBarTheme: const AppBarTheme(
                   elevation: 0,
                ),
                );

                static ThemeData get theme => _theme;

}