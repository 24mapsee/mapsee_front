import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapsee/auth/login_or_register.dart';
import 'package:mapsee/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkAppVersion(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkAppVersion(context);
    }
  }

  Future<void> checkAppVersion(BuildContext context) async {
    log("앱버전 체크");
    try {
      final response = await http.get(Uri.parse(
          'https://api.github.com/repos/24mapsee/mapsee_front/releases/latest'));

      if (response.statusCode == 200) {
        final latestRelease = jsonDecode(response.body);
        final latestVersion = latestRelease['tag_name'];

        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;
        log('Current version: $currentVersion, Latest version: $latestVersion');
        if (_isOutdated(currentVersion, latestVersion)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showUpdateDialog(context);
          });
        }
      } else {
        log('Failed to fetch latest release from GitHub');
      }
    } catch (e) {
      log('Error checking app version: $e');
    }
  }

  bool _isOutdated(String currentVersion, String latestVersion) {
    List<int> currentParts = currentVersion.split('.').map(int.parse).toList();
    List<int> latestParts = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (currentParts.length <= i || currentParts[i] < latestParts[i]) {
        return true;
      } else if (currentParts[i] > latestParts[i]) {
        return false;
      }
    }
    return false;
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // 뒤로가기 버튼으로 다이얼로그 닫히지 않도록 설정
          child: AlertDialog(
            title: const Text('앱 업데이트 필요'),
            content: const Text('현재 버전은 구버전입니다. 최신 버전을 다운로드하려면 웹사이트로 이동하세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  launchUrl(Uri.parse('http://mapsee.co.kr'));
                },
                child: const Text('웹사이트로 이동'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // 로그인된 경우 HomePage로 이동
              return const HomePage();
            }
            // 로그인되지 않은 경우 LoginOrRegister 페이지로 이동
            else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
