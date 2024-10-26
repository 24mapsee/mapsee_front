import 'package:flutter/material.dart';

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
        Icons.subway,
        color: hexToColor(leg['routeColor'] ?? '00A5DE'),
      );
    case 'BUS':
      return Icon(Icons.directions_bus,
          color: hexToColor(leg['routeColor'] ?? '0068B7'));
    default:
      return const Icon(Icons.directions_walk);
  }
}
