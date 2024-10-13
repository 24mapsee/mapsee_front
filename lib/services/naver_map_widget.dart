import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mapsee/services/getCurrentLocation.dart';
import 'package:mapsee/services/getGPSPermission.dart';

class NaverMapWidget extends StatefulWidget {
  const NaverMapWidget({Key? key}) : super(key: key);

  @override
  State<NaverMapWidget> createState() => _NaverMapWidgetState();
}

class _NaverMapWidgetState extends State<NaverMapWidget> {
  late NaverMapController _mapController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
    getGPSPermission().then((granted) {
      if (granted) {
        log("GPS 권한이 허용되었습니다.");
      } else {
        log("GPS 권한이 거부되었습니다.");
      }
    });
  }

  Future<void> moveCurrentLocation() async {
    if (!mapControllerCompleter.isCompleted) {
      log("맵 컨트롤러가 아직 준비되지 않았습니다.");
      return;
    }

    try {
      _mapController = await mapControllerCompleter.future;
      final currentLocation = await getCurrentLocation();
      if (currentLocation != null) {
        double latitude = currentLocation['latitude']!;
        double longitude = currentLocation['longitude']!;

        log("현재 위치로 이동 중...");
        await _mapController.updateCamera(
          NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(latitude, longitude),
            zoom: 18,
          ),
        );
        log("카메라가 현재 위치로 이동되었습니다.");
      }
    } catch (e) {
      log("현재 위치로 이동할 수 없습니다: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: true,
            consumeSymbolTapEvents: false,
            logoClickEnable: true,
          ),
          onMapReady: (controller) async {
            _mapController = controller;
            if (!mapControllerCompleter.isCompleted) {
              mapControllerCompleter.complete(controller);
            }
            log("맵 준비 완료");
          },
        ),
        // Positioned(
        //   top: 500,
        //   right: 20,
        //   child: GestureDetector(
        //     onTap: () async {
        //       await moveCurrentLocation();
        //     },
        //     child: Icon(
        //       Icons.location_on_rounded,
        //       color: Colors.deepOrange,
        //       size: 40,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
