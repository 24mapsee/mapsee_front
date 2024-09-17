import 'package:flutter/material.dart';
import 'package:mapsee/auth/login_or_register.dart';
import 'package:mapsee/pages/login_page.dart';
import 'package:mapsee/pages/register_page.dart';
import 'package:mapsee/theme/light_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginOrRegister(),
      theme: lightMode,
    );
  }
}
