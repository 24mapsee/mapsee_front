import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
  background: Colors.white,
  primary: Color(0xFFFF8200),
  secondary: Color(0xFF002E5D),
  outline: Color(0xFFD9D9D9),
  onSurface: Colors.black,
),
fontFamily: 'Pretendard',
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 32),
    titleLarge: TextStyle(fontSize: 18),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
  ),
);
