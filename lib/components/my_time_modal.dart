import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTimeModal extends StatefulWidget {
  const MyTimeModal({super.key});

  @override
  State<MyTimeModal> createState() => _MyTimeModalState();
}

class _MyTimeModalState extends State<MyTimeModal> {
  DateTime _departureDateTime = DateTime.now(); // 출발 날짜 및 시간
  DateTime _arrivalDateTime = DateTime.now(); // 도착 날짜 및 시간

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: [
          DefaultTabController(
            length: 2,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TabBar(
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: const [
                      Tab(text: '출발 시간'),
                      Tab(text: '도착 시간'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildDepartureTimePicker(),
                        _buildArrivalTimePicker(),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).pop({
                          'departure': _departureDateTime,
                          'arrival': _arrivalDateTime,
                        });
                      });
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartureTimePicker() {
    return Column(
      children: [
        Expanded(
          child: CupertinoDatePicker(
            initialDateTime: _departureDateTime,
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _departureDateTime = newDateTime;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArrivalTimePicker() {
    return Column(
      children: [
        Expanded(
          child: CupertinoDatePicker(
            initialDateTime: _arrivalDateTime,
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _arrivalDateTime = newDateTime;
              });
            },
          ),
        ),
      ],
    );
  }
}
