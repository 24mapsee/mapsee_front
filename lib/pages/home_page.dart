import 'package:flutter/material.dart';
import 'package:mapsee/auth/auth_service.dart';
import 'package:mapsee/components/my_botton_navigation_bar.dart';
import 'package:mapsee/components/my_route_tab_modal.dart';
import 'package:mapsee/components/my_bottom_modal_sheet.dart';
import 'package:mapsee/pages/search_page.dart';
import 'package:mapsee/services/naver_map_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout() {
    //get auth service
    final auth = AuthService();
    auth.signOut();
  }

  int _selectedTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _launchLicenseUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                '메뉴',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                logout();
              },
            ),
            Divider(),
            ListTile(
                title: Text(
                  '방법 아이콘 제작자: Freepik - Flaticon',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () => _launchLicenseUrl('https://www.flaticon.com/kr/')),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(onTabSelected: _onTabSelected),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            const NaverMapWidget(),
            Positioned(
              top: screenHeight * 0.07,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          return CircleAvatar(
                            backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                            child: IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchPage(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: screenWidth * 0.75,
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.surface,
                              filled: true,
                              hintText: '검색',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/png/mic.png',
                                    width: 20,
                                    color:
                                    Theme.of(context).colorScheme.outline,
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.search),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _selectedTabIndex == 2
                  ? const MyRouteTabModal()
                  : const MyBottomModalSheet(),
            ),
          ],
        ),
      ),
    );
  }
}