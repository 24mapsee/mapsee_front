import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
          )),
    );
  }
}
