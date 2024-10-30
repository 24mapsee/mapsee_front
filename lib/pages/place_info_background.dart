import 'package:flutter/material.dart';
import 'package:mapsee/components/my_place_info_modal.dart';
import 'package:mapsee/services/naver_map_marker.dart';

class PlaceInfoBackground extends StatefulWidget {
  final String title;
  final String category;
  final String address;
  final String roadAddress;
  final String link;
  final String telephone;
  final String mapx;
  final String mapy;

  const PlaceInfoBackground({
    super.key,
    required this.title,
    required this.category,
    required this.address,
    required this.roadAddress,
    required this.link,
    required this.telephone,
    required this.mapx,
    required this.mapy,
  });

  @override
  State<PlaceInfoBackground> createState() => _PlaceInfoBackgroundState();
}

class _PlaceInfoBackgroundState extends State<PlaceInfoBackground> {
  final DraggableScrollableController _draggableController = DraggableScrollableController();
  double _modalHeightFactor = 0.6;

  @override
  void initState() {
    super.initState();
    _draggableController.addListener(_updateModalHeight);
  }

  @override
  void dispose() {
    _draggableController.removeListener(_updateModalHeight);
    _draggableController.dispose();
    super.dispose();
  }

  void _updateModalHeight() {
    setState(() {
      _modalHeightFactor = _draggableController.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: screenHeight * (1 - _modalHeightFactor + 0.35),
              width: screenWidth,
              child:  NaverMapMarker(title:widget.title,mapx: widget.mapx, mapy: widget.mapy,),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DraggableScrollableSheet(
                controller: _draggableController,
                initialChildSize: _modalHeightFactor,
                minChildSize: 0.15,
                maxChildSize: 0.8,
                builder: (BuildContext context, ScrollController scrollController) {
                  return MyPlaceInfoModal(
                    title: widget.title,
                    category: widget.category,
                    address: widget.address,
                    roadAddress: widget.roadAddress,
                    link: widget.link,
                    telephone: widget.telephone,
                    mapx: widget.mapx,
                    mapy: widget.mapy,
                    scrollController: scrollController,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
