import 'package:flutter/material.dart';
import 'package:mapsee/components/my_public_trans_button.dart';
import 'package:mapsee/components/my_search_bar_route_place.dart';
import 'package:mapsee/components/my_time_modal.dart';
import 'package:mapsee/components/my_vertical_divider.dart';

import 'route_detail_test_page.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final TextEditingController _departureSearchController =
      TextEditingController();
  final TextEditingController _destinationSearchController =
      TextEditingController();

  String _selectedDeparture = '';
  String _selectedDestination = '';

  // DateTime _selectedDepartureDateTime = DateTime.now(); // 선택한 출발 날짜 및 시간
  // DateTime _selectedArrivalDateTime = DateTime.now(); // 선택한 도착 날짜 및 시간
  // String _departureOrArrivalLabel = '';

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void selectTransport() {}

    void exchangeText() {
      setState(() {
        String temp = _departureSearchController.text;
        _departureSearchController.text = _destinationSearchController.text;
        _destinationSearchController.text = temp;
      });
    }
    // String _formatDateTime(DateTime dateTime, String label) {
    //   return "${_selectedDepartureDateTime.year}-${_selectedDepartureDateTime.month.toString().padLeft(2, '0')}-${_selectedDepartureDateTime.day.toString().padLeft(2, '0')} ${_selectedDepartureDateTime.hour.toString().padLeft(2, '0')}:${_selectedDepartureDateTime.minute.toString().padLeft(2, '0')} $label";
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: screenHeight * 0.22,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: exchangeText,
                      icon: const Icon(
                        Icons.import_export,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SizedBox(
                                        height: screenHeight * 0.05,
                                        child: MySearchBarRoutePlace(
                                          controller:
                                              _departureSearchController,
                                          hintText: "출발지",
                                          onItemSelected:
                                              (String selectedItem) {
                                            setState(() {
                                              _selectedDeparture = selectedItem;
                                            });
                                          },
                                        ),
                                      ))),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                iconSize: 24,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SizedBox(
                                        height: screenHeight * 0.05,
                                        child: MySearchBarRoutePlace(
                                          controller:
                                              _destinationSearchController,
                                          hintText: "도착지",
                                          onItemSelected:
                                              (String selectedItem) {
                                            setState(() {
                                              _selectedDestination =
                                                  selectedItem;
                                            });
                                          },
                                        ),
                                      ))),
                              IconButton(
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                  color: Colors.white,
                                ),
                                iconSize: 24,
                                onPressed: () {},
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MyPublicTransButton(
                  onTap: selectTransport,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildTransportOption("전체", screenHeight),
                    MyVerticalDivider(
                      height: 0.02,
                    ),
                    _buildTransportOption("버스", screenHeight),
                    MyVerticalDivider(
                      height: 0.02,
                    ),
                    _buildTransportOption("지하철", screenHeight),
                    MyVerticalDivider(
                      height: 0.02,
                    ),
                    _buildTransportOption("버스 + 지하철", screenHeight),
                  ],
                ),
                // InkWell(
                //   onTap: () async {
                //     Map<String, DateTime>? selectedDateTime = await _dialogBuilder(context);
                //     if (selectedDateTime != null) {
                //       setState(() {
                //         _selectedDepartureDateTime = selectedDateTime['departure']!;
                //         _selectedArrivalDateTime = selectedDateTime['arrival']!;
                //         _departureOrArrivalLabel = selectedDateTime['arrival'] == _selectedArrivalDateTime
                //             ? _formatDateTime(_selectedArrivalDateTime, "도착 ▼")
                //             : _formatDateTime(_selectedDepartureDateTime, "출발 ▼");
                //       });
                //     }
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //     height: screenHeight * 0.03,
                //     child: Center(
                //       child: Text(
                //         _departureOrArrivalLabel.isNotEmpty
                //             ? _departureOrArrivalLabel
                //             : "${_selectedDepartureDateTime.year}-${_selectedDepartureDateTime.month.toString().padLeft(2, '0')}-${_selectedDepartureDateTime.day.toString().padLeft(2, '0')} ${_selectedDepartureDateTime.hour.toString().padLeft(2, '0')}:${_selectedDepartureDateTime.minute.toString().padLeft(2, '0')} 출발 ▼",
                //         style: const TextStyle(fontSize: 12),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RouteDetailTestPage()),
                        );
                      },
                      child: Text("테스트 경로"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTransportOption(String label, double screenHeight) {
  return InkWell(
    onTap: () {
      print("$label 클릭");
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      height: screenHeight * 0.03,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ),
  );
}

Future<Map<String, DateTime>?> _dialogBuilder(BuildContext context) {
  return showDialog<Map<String, DateTime>>(
    context: context,
    builder: (BuildContext context) {
      return const MyTimeModal();
    },
  );
}
