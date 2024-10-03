import 'package:flutter/material.dart';

class MyVerticalDivider extends StatelessWidget {
  const MyVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: 1,
      height: screenHeight * 0.02,
      color: Colors.grey,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
    );
  }
}
