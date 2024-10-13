import 'package:flutter/material.dart';

class DateInputForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // YYYY 필드
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: yearController,
                    decoration: InputDecoration(
                      hintText: 'YYYY',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    keyboardType: TextInputType.number,
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
                    controller: monthController,
                    decoration: InputDecoration(
                      hintText: 'MM',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    keyboardType: TextInputType.number,
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
                    controller: dayController,
                    decoration: InputDecoration(
                      hintText: 'DD',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 4), // 여백
                Text(
                  '일',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
