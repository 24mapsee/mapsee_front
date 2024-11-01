import 'package:flutter/material.dart';

class DateInputForm extends StatefulWidget {
  final TextEditingController yearController;
  final TextEditingController monthController;
  final TextEditingController dayController;

  const DateInputForm({
    Key? key,
    required this.yearController,
    required this.monthController,
    required this.dayController,
  }) : super(key: key);

  @override
  _DateInputFormState createState() => _DateInputFormState();
}

class _DateInputFormState extends State<DateInputForm> {
  String? yearError;
  String? monthError;
  String? dayError;

  void validateDate() {
    setState(() {
      int? year = int.tryParse(widget.yearController.text);
      int? month = int.tryParse(widget.monthController.text);
      int? day = int.tryParse(widget.dayController.text);

      yearError = null;
      monthError = null;
      dayError = null;

      if (year == null || year < 1) {
        yearError = '유효한 연도를 입력하세요';
      }
      if (month == null || month < 1 || month > 12) {
        monthError = '1에서 12 사이의 월을 입력하세요';
      }
      if (day == null || day < 1 || day > 31) {
        dayError = '1에서 31 사이의 일을 입력하세요';
      }

      if (year != null && month != null && day != null) {
        if (!isValidDate(year, month, day)) {
          dayError = '유효한 날짜가 아닙니다';
        }
      }
    });
  }

  bool isValidDate(int year, int month, int day) {
    // Check for leap year
    if (month == 2) {
      bool isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      if (day > (isLeap ? 29 : 28)) return false;
    }
    // Check for months with 30 days
    if ([4, 6, 9, 11].contains(month) && day > 30) {
      return false;
    }
    // General check for valid days in months
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // YYYY 필드
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.yearController,
                    maxLength: 4,
                    decoration: InputDecoration(
                      hintText: 'YYYY',
                      counterText: "",
                      contentPadding: const EdgeInsets.all(8),
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      errorText: yearError,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => validateDate(),
                  ),
                ),
                SizedBox(width: 4), // 여백
                Text('년'),
              ],
            ),
          ),
          SizedBox(width: 8),
          // MM 필드
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.monthController,
                    maxLength: 2,
                    decoration: InputDecoration(
                      hintText: 'MM',
                      counterText: "",
                      contentPadding: const EdgeInsets.all(8),
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      errorText: monthError,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => validateDate(),
                  ),
                ),
                SizedBox(width: 4), // 여백
                Text('월'),
              ],
            ),
          ),
          SizedBox(width: 8),
          // DD 필드
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.dayController,
                    maxLength: 2,
                    decoration: InputDecoration(
                      hintText: 'DD',
                      counterText: "",
                      contentPadding: const EdgeInsets.all(8),
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      errorText: dayError,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => validateDate(),
                  ),
                ),
                SizedBox(width: 4), // 여백
                Text('일'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
