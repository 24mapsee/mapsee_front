import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mapsee/utils/common.dart';

class NaverMapMarker extends StatefulWidget {
  final String title;
  final String mapx;
  final String mapy;

  const NaverMapMarker({
    super.key,
    required this.title,
    required this.mapx,
    required this.mapy,
  });

  @override
  State<NaverMapMarker> createState() => _NaverMapMarkerState();
}

class _NaverMapMarkerState extends State<NaverMapMarker> {
  late Map<String, dynamic> jsonData;
  late NaverMapController _mapController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();

    latitude = double.parse(widget.mapy);
    longitude = double.parse(widget.mapx);

    jsonData = {
      'X': latitude,
      'Y': longitude,
      'count': 10,
      'lang': 0,
      'format': 'json',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NaverMap(
          options: NaverMapViewOptions(
            indoorEnable: true,
            locationButtonEnable: true,
            consumeSymbolTapEvents: false,
            logoClickEnable: true,
            initialCameraPosition: NCameraPosition(
              target: NLatLng(latitude, longitude),
              zoom: 15,
              bearing: 0,
              tilt: 0,
            ),
          ),
          onMapReady: (controller) async {
            _mapController = controller;
            if (!mapControllerCompleter.isCompleted) {
              mapControllerCompleter.complete(controller);
            }

            final marker = NMarker(
              id: 'test',
              position: NLatLng(latitude, longitude),
              // icon: await NOverlayImage.fromAssetImage('assets/images/png/marker.png'),
            );
            controller.addOverlayAll({
              marker,
            });
            marker.setIcon(
              NOverlayImage.fromAssetImage('assets/images/png/marker.png'),
            );
            marker.setIconTintColor(Theme.of(context).colorScheme.primary);
            marker.setSize(Size(30, 30));

            final show_marker = NInfoWindow.onMarker(
              id: marker.info.id,
              text: widget.title,
            );
            marker.openInfoWindow(show_marker);
          },
        ),
      ],
    );
  }
}
