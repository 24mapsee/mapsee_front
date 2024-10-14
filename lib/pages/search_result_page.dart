import 'package:flutter/material.dart';
import 'package:mapsee/components/my_public_trans_button.dart';
import 'package:mapsee/components/my_textfield.dart';
import 'package:mapsee/components/my_time_modal.dart';
import 'package:mapsee/components/my_vertical_divider.dart';

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

  DateTime _selectedDepartureDateTime = DateTime.now(); // 선택한 출발 날짜 및 시간
  DateTime _selectedArrivalDateTime = DateTime.now(); // 선택한 도착 날짜 및 시간
  String _departureOrArrivalLabel = '';

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
    String _formatDateTime(DateTime dateTime, String label) {
      return "${_selectedDepartureDateTime.year}-${_selectedDepartureDateTime.month.toString().padLeft(2, '0')}-${_selectedDepartureDateTime.day.toString().padLeft(2, '0')} ${_selectedDepartureDateTime.hour.toString().padLeft(2, '0')}:${_selectedDepartureDateTime.minute.toString().padLeft(2, '0')} $label";
    }

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
                      icon: Icon(
                        Icons.change_circle_outlined,
                        color: Theme.of(context).colorScheme.background,
                        size: 30,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: screenWidth * 0.65,
                                  height: screenHeight * 0.05,
                                  child: MyTextfield(
                                    hintText: '',
                                    obscureText: false,
                                    controller: _departureSearchController,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image.asset('assets/images/png/cancel.png', width: 15, color: Theme.of(context).colorScheme.background,),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: screenWidth * 0.65,
                                  height: screenHeight * 0.05,
                                  child: MyTextfield(
                                    hintText: '',
                                    obscureText: false,
                                    controller: _destinationSearchController,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.more_vert_rounded,
                                color: Theme.of(context).colorScheme.background,
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
                    MyVerticalDivider(),
                    _buildTransportOption("버스", screenHeight),
                    MyVerticalDivider(),
                    _buildTransportOption("지하철", screenHeight),
                    MyVerticalDivider(),
                    _buildTransportOption("버스 + 지하철", screenHeight),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    Map<String, DateTime>? selectedDateTime = await _dialogBuilder(context);
                    if (selectedDateTime != null) {
                      setState(() {
                        _selectedDepartureDateTime = selectedDateTime['departure']!;
                        _selectedArrivalDateTime = selectedDateTime['arrival']!;
                        _departureOrArrivalLabel = selectedDateTime['arrival'] == _selectedArrivalDateTime
                            ? _formatDateTime(_selectedArrivalDateTime, "도착 ▼")
                            : _formatDateTime(_selectedDepartureDateTime, "출발 ▼");
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: screenHeight * 0.03,
                    child: Center(
                      child: Text(
                        _departureOrArrivalLabel.isNotEmpty
                            ? _departureOrArrivalLabel
                            : "${_selectedDepartureDateTime.year}-${_selectedDepartureDateTime.month.toString().padLeft(2, '0')}-${_selectedDepartureDateTime.day.toString().padLeft(2, '0')} ${_selectedDepartureDateTime.hour.toString().padLeft(2, '0')}:${_selectedDepartureDateTime.minute.toString().padLeft(2, '0')} 출발 ▼",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
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
