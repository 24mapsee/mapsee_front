import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mapsee/auth/auth_gate.dart';
import 'package:mapsee/firebase_options.dart';
import 'package:mapsee/theme/light_mode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
      name: "mapsee", options: DefaultFirebaseOptions.currentPlatform);
  await NaverMapSdk.instance.initialize(
      clientId: 'nt3da0f7bp',
      onAuthFailed: (ex) {
        log("********* 네이버맵 인증오류 : $ex *********");
      });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      home: const Scaffold(
        body: AuthGate(),
      ),
    );
  }
}
