import 'package:flutter/material.dart';
import 'package:mapsee/pages/search_filter_page.dart';
import 'package:mapsee/pages/home_page.dart';
import 'package:mapsee/pages/search_page.dart';
import 'package:mapsee/pages/search_page2.dart';
import 'package:mapsee/pages/search_result_page.dart';
import 'package:mapsee/pages/feed_page.dart'; // 추가: FeedPage import

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.secondary,
      type: BottomNavigationBarType.fixed,
      onTap: (int idx) {
        setState(() {
          _currentIndex = idx;
        });

        switch (idx) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchResultPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedPage()), // FeedPage로 변경
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage2()),
            );
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/png/home.png',
            color: _currentIndex == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            width: 20,
          ),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.route),
          label: 'Route',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/png/star.png',
            color: _currentIndex == 2
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            width: 20,
          ),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/png/world.png',
            color: _currentIndex == 3
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            width: 20,
          ),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/png/user.png',
            color: _currentIndex == 4
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            width: 20,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}