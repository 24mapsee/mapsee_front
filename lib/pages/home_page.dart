import 'package:flutter/material.dart';
import 'package:mapsee/auth/auth_service.dart';
import 'package:mapsee/components/my_botton_navigation_bar.dart';
import 'package:mapsee/components/my_category_tag.dart';
import 'package:mapsee/pages/search_page.dart';
import 'package:mapsee/services/naver_map_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout() {
    //get auth service
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth= MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            const NaverMapWidget(),
            Positioned(
              top: screenHeight * 0.05,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Row(
                    children: [
                      Builder(builder: (BuildContext context) {
                        return CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          child: IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            color: Theme.of(context).colorScheme.background,
                          ),
                        );
                      }),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  SearchPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: screenWidth * 0.75,
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.background,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              hintText: '검색',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.transparent)),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/images/png/mic.png',width: 20,color: Theme.of(context).colorScheme.outline,),
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
                  MyCategoryTag()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
