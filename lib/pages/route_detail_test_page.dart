import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;

class RouteDetailTestPage extends StatefulWidget {
  const RouteDetailTestPage({Key? key}) : super(key: key);

  @override
  State<RouteDetailTestPage> createState() => _RouteDetailTestPageState();
}

class _RouteDetailTestPageState extends State<RouteDetailTestPage> {
  List<NMultipartPathOverlay> pathOverlays = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRouteData();
  }

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

  Future<void> fetchRouteData() async {
    const String url =
        'http://default-test-deployment-21d4e-100106193-2d0c9fdd6415.kr.lb.naverncp.com/map/test-route';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> itineraries =
            data['metaData']['plan']['itineraries'];
        List<NMultipartPathOverlay> overlays = [];

        // 임시로 3번쨰로 고정
        if (itineraries.length > 2) {
          var itinerary = itineraries[2];
          List<NMultipartPath> paths = [];

          for (var leg in itinerary['legs']) {
            if (leg.containsKey('passShape')) {
              String lineString = leg['passShape']['linestring'];
              List<NLatLng> coordinates = parseLineString(lineString);

              paths.add(
                NMultipartPath(
                  coords: coordinates,
                  color: getLegColor(leg['mode']),
                ),
              );
            }
          }

          NMultipartPathOverlay multipartPathOverlay = NMultipartPathOverlay(
            id: 'route',
            paths: paths,
            width: 6,
          );

          overlays.add(multipartPathOverlay);
        }

        setState(() {
          pathOverlays = overlays;
          isLoading = false;
        });

        log('[성공] 경로 데이터 파싱 완료');
      } else {
        log('[오류] 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      log('[오류] 내용: $e');
    }
  }

  Color getLegColor(String mode) {
    switch (mode) {
      case 'WALK':
        return Colors.green;
      case 'SUBWAY':
        return Colors.blue;
      case 'BUS':
        return Colors.orange;
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
                  onMapReady: (controller) async {
                    for (var overlay in pathOverlays) {
                      controller.addOverlay(overlay);
                    }
                  },
                ),
              ],
            ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RouteDetailTestPage(),
  ));
}
