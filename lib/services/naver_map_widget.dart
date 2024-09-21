// import 'dart:async';
// import 'dart:developer' show log;
// import 'package:flutter/material.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
//
// class NaverMapWidget extends StatefulWidget {
//   const NaverMapWidget({Key? key}) : super(key: key);
//
//   @override
//   State<NaverMapWidget> createState() => _NaverMapWidgetState();
// }
//
// class _NaverMapWidgetState extends State<NaverMapWidget> {
//   late NaverMapController _mapController;
//   final Completer<NaverMapController> mapControllerCompleter = Completer();
//
//   @override
//   Widget build(BuildContext context) {
//     return NaverMap(
//       options: const NaverMapViewOptions(
//         indoorEnable: true,
//         locationButtonEnable: false,
//         consumeSymbolTapEvents: false,
//       ),
//       onMapReady: (controller) async {
//         _mapController = controller;
//         mapControllerCompleter.complete(controller);
//         log("맵 준비 완료");
//       },
//     );
//   }
// }