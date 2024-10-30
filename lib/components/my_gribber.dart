import 'package:flutter/material.dart';

class MyGribber extends StatelessWidget {
  const MyGribber({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Container(
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
