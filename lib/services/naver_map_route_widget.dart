import 'dart:async';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapRouteWidget extends StatefulWidget {
  final List<NLatLng> routeCoordinates; // 경로 좌표 배열

  const NaverMapRouteWidget({Key? key, required this.routeCoordinates})
      : super(key: key);

  @override
  State<NaverMapRouteWidget> createState() => _NaverMapRouteWidgetState();
}

class _NaverMapRouteWidgetState extends State<NaverMapRouteWidget> {
  late NaverMapController _mapController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
  }

  Future<void> moveToRouteStart() async {
    if (!mapControllerCompleter.isCompleted) {
      log("맵 컨트롤러가 아직 준비되지 않았습니다.");
      return;
    }

    try {
      _mapController = await mapControllerCompleter.future;

      if (widget.routeCoordinates.isNotEmpty) {
        final firstPoint = widget.routeCoordinates.first;
        log("경로 시작 지점으로 카메라 이동 중...");
        await _mapController.updateCamera(
          NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(firstPoint.latitude, firstPoint.longitude),
            zoom: 15, // 원하는 줌 레벨로 조정
          ),
        );
        log("카메라가 경로 시작 지점으로 이동되었습니다.");
      }
    } catch (e) {
      log("경로 시작 지점으로 이동할 수 없습니다: $e");
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

            // 경로 폴리라인 그리기
            if (widget.routeCoordinates.isNotEmpty) {
              final polylineOverlay = NPolylineOverlay(
                id: "route", // 폴리라인의 ID
                coords: widget.routeCoordinates,
                color: Colors.blue,
                width: 5,
              );

              _mapController.addOverlay(polylineOverlay);
              log("경로가 지도에 표시되었습니다.");

              await moveToRouteStart(); // 경로 시작 지점으로 카메라 이동
            }
          },
        ),
      ],
    );
  }
}
