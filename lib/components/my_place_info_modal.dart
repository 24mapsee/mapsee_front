import 'package:flutter/material.dart';
import 'package:mapsee/components/my_departure_and_arrival_buttons.dart';
import 'package:mapsee/components/my_gribber.dart';
import 'package:mapsee/components/my_select_modal.dart';
import 'package:mapsee/components/my_vertical_divider.dart';

class MyPlaceInfoModal extends StatefulWidget {
  final String title;
  final String category;
  final String address;
  final String roadAddress;
  final String link;
  final String telephone;
  final String mapx;
  final String mapy;
  final ScrollController? scrollController;

  const MyPlaceInfoModal({
    super.key,
    required this.title,
    required this.category,
    required this.address,
    required this.roadAddress,
    required this.link,
    required this.telephone,
    required this.mapx,
    required this.mapy,
    this.scrollController,
  });

  @override
  State<MyPlaceInfoModal> createState() => _MyPlaceInfoModalState();
}

class _MyPlaceInfoModalState extends State<MyPlaceInfoModal> {
  bool isSaved = false;

  void savePlace() {
    setState(() {
      isSaved = !isSaved;
    });
    showDialog(
      context: context,
      builder: (context) {
        return MySelectModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              MyGribber(),
              Expanded(
                child: ListView(
                  controller: widget.scrollController ?? scrollController,
                  children: <Widget>[
                    _buildTitleSection(),
                    _buildCategoryButtons(),
                    _buildInformationSection(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title.replaceFirst(' ', '\n'),
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 30,
              color: Theme.of(context).colorScheme.onSurface,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.category.split('>').last,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black45,
              decoration: TextDecoration.none,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: savePlace,
                child: Image.asset(
                  isSaved
                      ? 'assets/images/png/filled_heart.png'
                      : 'assets/images/png/unfilled_heart.png',
                  color: Theme.of(context).colorScheme.secondary,
                  width: 30,
                ),
              ),
              Text(
                '저장하기',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          MyVerticalDivider(height: 0.05),
          Column(
            children: [
              Image.asset(
                'assets/images/png/share.png',
                color: Theme.of(context).colorScheme.secondary,
                width: 30,
              ),
              Text(
                '공유하기',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.none,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow('assets/images/png/marker.png', widget.address, widget.roadAddress),
          _buildInfoRow('assets/images/png/clock.png', '09:00 - 20:00 ▽'),
          _buildInfoRow('assets/images/png/call.png', widget.telephone),
          _buildInfoRow('assets/images/png/world.png', widget.link),
          _buildInfoRow('assets/images/png/parking.png', '주차 가능'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String iconPath, String primaryText, [String? secondaryText]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 15,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryText.isNotEmpty ? primaryText : '제공하지 않음',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                    decoration: TextDecoration.none,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (secondaryText != null)
                  Text(
                    secondaryText.isNotEmpty ? secondaryText : '제공하지 않음',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
