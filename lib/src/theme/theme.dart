import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  datePickerTheme: const DatePickerThemeData(
    backgroundColor: Color.fromARGB(255, 222, 225, 240),
  ),
  useMaterial3: true,
  primaryColorLight: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 11,
    ),
  ),
  colorScheme: ColorScheme(
    background: Colors.blueGrey.shade50,
    onBackground: Colors.blueGrey.shade200,
    primary: Colors.lightBlue.shade400,
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.blue.shade300,
    brightness: Brightness.light,
    error: Colors.red.shade100,
    onError: Colors.red.shade300,
    surface: Colors.blueGrey.shade50,
    onSurface: Colors.black54,
  ),
);
