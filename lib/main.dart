import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mapsee/auth/auth_gate.dart';
import 'package:mapsee/firebase_options.dart';
import 'package:mapsee/pages/home_page.dart';
import 'package:mapsee/theme/light_mode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NaverMapSdk.instance.initialize(
      clientId: 'nt3da0f7bp',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(  // MaterialApp 추가
      home: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(),
          onMapReady: (controller) {
            print("네이버 맵 로딩됨!");
          },
        ),
      ),
    );
  }
}