import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final String hintText;

  const MySearchBar({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
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
              icon: const Icon(Icons.keyboard_voice),
              onPressed: () {
                print('Use voice command');
              },
            )),
      ),
    );
  }
}
