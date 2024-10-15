import 'package:flutter/material.dart';
import 'package:mapsee/components/my_departure_and_arrival_buttons.dart';
import 'package:mapsee/components/my_vertical_divider.dart';

class PlaceInfoPage extends StatefulWidget {
  final String title;
  final String category;
  final String address;
  final String roadAddress;
  final String link;
  final String telephone;

  const PlaceInfoPage({
    super.key,
    required this.title,
    required this.category,
    required this.address,
    required this.roadAddress,
    required this.link,
    required this.telephone,
  });

  @override
  State<PlaceInfoPage> createState() => _PlaceInfoPageState();
}

class _PlaceInfoPageState extends State<PlaceInfoPage> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset('assets/images/place_example.jpeg'),
          Container(
            margin: EdgeInsets.all(6),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).colorScheme.outline))),
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.title,
                        style: TextStyle(fontWeight: FontWeight.w200, fontSize: 30),
                        maxLines: null,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Text(widget.category.split('>').last, style: TextStyle(color: Colors.black45)),
                SizedBox(height: 20),
                MyDepartureAndArrivalButtons(),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Theme.of(context).colorScheme.outline))),
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSaved = !isSaved;
                              });
                            },
                            child: Image.asset(
                              isSaved
                                  ? 'assets/images/png/filled_heart.png'
                                  : 'assets/images/png/unfilled_heart.png',
                              color: Theme.of(context).colorScheme.secondary,
                              width: 30,
                            ),
                          ),
                          Text('저장하기')
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
                          Text('공유하기')
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/png/marker.png',
                      width: 15,
                    ),
                    SizedBox(width: 5),
                    Text(widget.address.isNotEmpty ? widget.address : '제공하지 않음'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/png/clock.png',
                      width: 15,
                    ),
                    SizedBox(width: 5),
                    Text('09:00 - 20:00 ▽'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/png/call.png',
                      width: 15,
                    ),
                    SizedBox(width: 5),
                    Text(widget.telephone.isNotEmpty ? widget.telephone : '제공하지 않음'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/png/world.png',
                      width: 15,
                    ),
                    SizedBox(width: 5),
                    Text(widget.link.isNotEmpty ? widget.link : '제공하지 않음'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/png/parking.png',
                      width: 15,
                    ),
                    SizedBox(width: 5),
                    Text('주차 가능'),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
