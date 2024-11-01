import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 초를 시간 분으로 변환
String formatTimeSToHM(int totalTimeInSeconds) {
  int hours = totalTimeInSeconds ~/ 3600;
  int minutes = (totalTimeInSeconds % 3600) ~/ 60;

  if (hours > 0) {
    return "$hours시간 $minutes분";
  } else {
    return "$minutes분";
  }
}

// hex 색상을 Color로 변환
Color hexToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");

  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }

  return Color(int.parse(hexColor, radix: 16));
}

// 경로 모드에 따른 색상 반환
Color getLegColor(dynamic leg) {
  String mode = leg['mode'];
  switch (mode) {
    case 'WALK':
      return Colors.grey;
    case 'SUBWAY':
      return hexToColor(leg['routeColor'] ?? '00A5DE');
    case 'BUS':
      return hexToColor(leg['routeColor'] ?? '0068B7');
    default:
      return Colors.grey;
  }
}

Icon getIcon(dynamic leg) {
  String mode = leg['mode'];

  switch (mode) {
    case 'WALK':
      return const Icon(Icons.directions_walk, color: Colors.grey);
    case 'SUBWAY':
      return Icon(
        Icons.directions_subway,
        color: hexToColor(leg['routeColor'] ?? '00A5DE'),
      );
    case 'BUS':
      return Icon(Icons.directions_bus,
          color: hexToColor(leg['routeColor'] ?? '0068B7'));
    default:
      return const Icon(Icons.directions_walk);
  }
}

// HTML 태그 제거
String removeHtmlTags(String input) {
  final regex = RegExp(r'<[^>]*>');
  return input.replaceAll(regex, '');
}

// 사용자 UID 가져오기
Future<String?> getUserId() async {
  // FirebaseAuth에서 현재 로그인된 사용자 가져오기
  User? user = FirebaseAuth.instance.currentUser;

  // 사용자가 로그인되어 있으면 UID 반환
  if (user != null) {
    return user.uid; // 사용자 UID
  } else {
    return null; // 로그인된 사용자가 없으면 null 반환
  }
}

// 사용자 객체 가져오기
Future<String?> getUserInfo() async {
  // FirebaseAuth에서 현재 로그인된 사용자 가져오기
  User? user = FirebaseAuth.instance.currentUser;

  // 사용자가 로그인되어 있으면 UID 반환
  if (user != null) {
    return user.toString(); // 사용자 UID
  } else {
    return null; // 로그인된 사용자가 없으면 null 반환
  }
}

//
double convertToDecimalWGS84(String value) {
  return int.parse(value) / 10000000;
}
