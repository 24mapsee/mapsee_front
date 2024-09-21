import 'package:flutter/material.dart';
import 'package:mapsee/auth/auth_service.dart';
// import 'package:mapsee/services/naver_map_widget.dart';

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
      appBar: AppBar(
        title: Text("맵시"),
        actions: [
          // logout button
          IconButton(onPressed: logout, icon: Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(),
      // body: const NaverMapWidget(),
    );
  }
}
