import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class RouteDetailTestPage extends StatefulWidget {
  final dynamic itinerary; // Pass the itinerary data

  const RouteDetailTestPage({super.key, required this.itinerary});

  @override
  State<RouteDetailTestPage> createState() => _RouteDetailTestPageState();
}

class _RouteDetailTestPageState extends State<RouteDetailTestPage> {
  NaverMapController? _mapController; // ignore: unused_field
  // 경로 오버레이용 리스트
  List<NMultipartPathOverlay> pathOverlays = [];
  // 카메라 바운드 설정을 위한 전체 좌표리스트
  List<NLatLng> allCoordinates = [];
  // 로딩 상태 저장
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRouteData();
  }

  // 위경도 파싱
  List<NLatLng> parseLineString(String lineString) {
    final List<String> coordinates = lineString.split(" ");
    List<NLatLng> latLngList = [];

    for (String coordinate in coordinates) {
      final List<String> latLng = coordinate.split(",");
      if (latLng.length == 2) {
        final double lon = double.parse(latLng[0]);
        final double lat = double.parse(latLng[1]);
        latLngList.add(NLatLng(lat, lon));
      }
    }

    return latLngList;
  }

  // 경로 데이터 가져오기
  Future<void> fetchRouteData() async {
    try {
      List<NMultipartPath> paths = [];

      // 상세 경로 데이터 추출
      for (var leg in widget.itinerary['legs']) {
        if (leg.containsKey('passShape')) {
          String lineString = leg['passShape']['linestring'];
          List<NLatLng> coordinates = parseLineString(lineString);

          allCoordinates.addAll(coordinates);

          paths.add(
            NMultipartPath(
              coords: coordinates,
              color: getLegColor(leg),
            ),
          );
        }
      }

      NMultipartPathOverlay multipartPathOverlay = NMultipartPathOverlay(
        id: 'route',
        paths: paths,
        width: 6,
      );

      setState(() {
        pathOverlays = [multipartPathOverlay];
        isLoading = false;
      });

      log('[성공] 경로 데이터 파싱 완료');
    } catch (e) {
      log('[오류] 내용: $e');
    }
  }

  // 카메라 바운딩 설정
  NCameraUpdate getCameraBounds(List<NLatLng> coordinates) {
    final bounds = NLatLngBounds.from(coordinates);
    return NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(100));
  }

  // 플러터 사용 컬러로 변환
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경로 상세보기'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                NaverMap(
                  options: const NaverMapViewOptions(
                    indoorEnable: true,
                    locationButtonEnable: true,
                    consumeSymbolTapEvents: false,
                    logoClickEnable: false,
                  ),
                  onMapReady: (controller) {
                    _mapController = controller;

                    for (var overlay in pathOverlays) {
                      controller.addOverlay(overlay);
                    }

                    controller.updateCamera(getCameraBounds(allCoordinates));
                  },
                ),
              ],
            ),
    );
  }
}
