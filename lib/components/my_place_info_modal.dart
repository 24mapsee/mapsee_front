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

  const MyPlaceInfoModal({
    super.key,
    required this.title,
    required this.category,
    required this.address,
    required this.roadAddress,
    required this.link,
    required this.telephone,
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
      minChildSize: 0.15,
      maxChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                  controller: scrollController,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
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
                                  widget.title.replaceFirst(' ', '\n'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 30,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    decoration: TextDecoration.none,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                ),
                              ),


                            ],
                          ),
                          SizedBox(width: 8),
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
                          SizedBox(height: 20),
                          MyDepartureAndArrivalButtons(),
                          SizedBox(height: 15),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(top: 10),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 30,
                                      ),
                                    ),
                                    Text(
                                      '저장하기',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      width: 30,
                                    ),
                                    Text('공유하기',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          decoration: TextDecoration.none,
                                        ))
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/png/marker.png',
                                  width: 15,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.address.isNotEmpty
                                            ? widget.address
                                            : '제공하지 않음',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            decoration: TextDecoration.none),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        widget.roadAddress.isNotEmpty
                                            ? widget.roadAddress
                                            : '제공하지 않음',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            decoration: TextDecoration.none),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/png/clock.png',
                                  width: 15,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    '09:00 - 20:00 ▽',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        decoration: TextDecoration.none),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/png/call.png',
                                  width: 15,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    widget.telephone.isNotEmpty
                                        ? widget.telephone
                                        : '제공하지 않음',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        decoration: TextDecoration.none),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/png/world.png',
                                  width: 15,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    widget.link.isNotEmpty
                                        ? widget.link
                                        : '제공하지 않음',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        decoration: TextDecoration.none),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/png/parking.png',
                                  width: 15,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    '주차 가능',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        decoration: TextDecoration.none),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
