import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  final String selectedOption;

  PostPage({required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Page"),
      ),
      body: Center(
        child: Text("Selected Option: $selectedOption"),
      ),
    );
  }
}