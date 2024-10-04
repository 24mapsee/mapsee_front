import 'package:flutter/material.dart';


class MySearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const MySearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onSubmitted,
  });

  void search(){

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        enabled: true,
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.background,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.outline),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: IconButton(
            icon: Image.asset(
              'assets/images/png/mic.png',
              width: 20,
              color: Theme.of(context).colorScheme.outline,
            ),
            onPressed: () {
              print('Use voice command');
            },
          ),
        ),
        onSubmitted: (value){

        },
      ),
    );
  }
}
