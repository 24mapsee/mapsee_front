import 'package:flutter/material.dart';
import 'package:mapsee/auth/auth_service.dart';
import 'package:mapsee/components/my_search_bar.dart';
import 'package:mapsee/services/naver_map_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() {
    //get auth service
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Stack(
          children: [
            const NaverMapWidget(),
            Container(
                child: Positioned(
                    top: 30,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                          Theme.of(context).colorScheme.secondary,
                          child: IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 320,
                          child: SearchBar(
                            trailing: [
                             IconButton(
                                icon: const Icon(Icons.keyboard_voice),

                                onPressed: () {
                                  print('Use voice command');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  print('Use search');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))),
          ],
        ));
  }
}
