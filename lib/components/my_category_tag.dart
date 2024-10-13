import 'package:flutter/material.dart';

class MyCategoryTag extends StatefulWidget {
  const MyCategoryTag({super.key});

  @override
  _MyCategoryTagState createState() => _MyCategoryTagState();
}

class _MyCategoryTagState extends State<MyCategoryTag> {
  final List<Map<String, dynamic>> categories = [
    {'iconPath': 'assets/images/png/home.png', 'label': '집'},
    {'iconPath': 'assets/images/png/cutlery.png', 'label': '음식점'},
    {'iconPath': 'assets/images/png/coffee.png', 'label': '카페'},
    {'iconPath': 'assets/images/png/mart.png', 'label': '마트'},
    {'iconPath': 'assets/images/png/convenience.png', 'label': '편의점'},
    {'iconPath': 'assets/images/png/parking.png', 'label': '주차'},
    {'iconPath': 'assets/images/png/gas.png', 'label': '주유소'},
    {'iconPath': 'assets/images/png/medical.png', 'label': '병원'},
    {'iconPath': 'assets/images/png/bank.png', 'label': '은행'},
  ];

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20.0;
    const double spacing = 5.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: categories.asMap().entries.map((entry) {
            int index = entry.key;
            var category = entry.value;

            bool isSelected = index == _selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (_selectedIndex == index) {
                    _selectedIndex = -1;
                  } else {
                    _selectedIndex = index;
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: spacing),
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.secondary,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(category['iconPath']),
                      ),
                    ),
                    SizedBox(width: 3),
                    Text(
                      category['label'],
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
