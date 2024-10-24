import 'package:flutter/material.dart';

class MyDepartureAndArrivalButtons extends StatefulWidget {
  const MyDepartureAndArrivalButtons({super.key});

  @override
  State<MyDepartureAndArrivalButtons> createState() => _MyDepartureAndArrivalButtonsState();
}

class _MyDepartureAndArrivalButtonsState extends State<MyDepartureAndArrivalButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => {},
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondary)),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/png/startpoint.png',
                      width: 15,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '출발',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              )),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () => {},
          child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/png/marker.png',
                      width: 15,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '도착',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
