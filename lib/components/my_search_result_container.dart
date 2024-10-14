import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySearchResultContainer extends StatelessWidget {
  final String text;
  final VoidCallback onDelete;

  const MySearchResultContainer({
    super.key,
    required this.text,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 2,
          ),
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/png/marker.png',
            width: 20,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(width: 10),
          Text(text),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.outline,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
