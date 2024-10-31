import 'package:flutter/material.dart';
import 'package:mapsee/pages/external_profile_page.dart';

class FollowingFollowerPage extends StatefulWidget {
  final int initialTabIndex;

  const FollowingFollowerPage({super.key, required this.initialTabIndex});

  @override
  State<FollowingFollowerPage> createState() => _FollowingFollowerPageState();
}

class _FollowingFollowerPageState extends State<FollowingFollowerPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
  }

  void deleteFollower() {}

  void cancelFollowing() {}

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/mapsee_logo.png',
          height: 40,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '팔로워 ',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      userData['follower_cnt'].toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '명',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '팔로잉 ',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      userData['following_cnt'].toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '명',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(context, follwer_data, "삭제", deleteFollower),
                _buildListView(context, follwing_data, "팔로잉", cancelFollowing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildListView(BuildContext context, List<Map<String, dynamic>> data,
    String buttonText, VoidCallback onButtonPressed) {
  final double screenWidth = MediaQuery.of(context).size.width;

  if (data.isEmpty) {
    return Center(
      child: Text(
        '아직 데이터가 없습니다!',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }

  return ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index) {
      final userName = data[index]['userName'];
      final userId = data[index]['userId'];
      final profileImg = data[index]['profileImg'];

      return ListTile(
        onTap: () {
          // 사용자 프로필 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExternalProfilePage(userId: userId),
            ),
          );
        },
        leading: Image.asset(profileImg, width: 40, height: 40),
        title: Text(userName),
        subtitle: Text(userId),
        trailing: ElevatedButton(
          onPressed: onButtonPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.12,
              vertical: 6,
            ),
          ),
          child: Text(buttonText),
        ),
      );
    },
  );
}

Map<String, dynamic> userData = {
  "user_image": "assets/images/dummy/katt.png",
  "user_name": "구슬이",
  "user_id": "@cherror",
  "archive_cnt": 56,
  "like_cnt": 27,
  "follower_cnt": 472,
  "following_cnt": 486
};

List<Map<String, dynamic>> follwing_data = [
  {
    "userName": "민수",
    "userId": "@minsoo123",
    "profileImg": "assets/images/dummy/katt.png"
  },
  {
    "userName": "유나",
    "userId": "@yuna_456",
    "profileImg": "assets/images/dummy/katt.png"
  },
  {
    "userName": "지호",
    "userId": "@jiho789",
    "profileImg": "assets/images/dummy/katt.png"
  },
  {
    "userName": "해린",
    "userId": "@haerin_lovely",
    "profileImg": "assets/images/dummy/katt.png"
  },
  {
    "userName": "도영",
    "userId": "@doyoung_world",
    "profileImg": "assets/images/dummy/katt.png"
  },
];

List<Map<String, dynamic>> follwer_data = [
  {
    "userName": "수빈",
    "userId": "@subin_the_best",
    "profileImg": "assets/images/dummy/katt.png"
  },
  {
    "userName": "준영",
    "userId": "@junyoung_999",
    "profileImg": "assets/images/dummy/katt.png"
  },
  {
    "userName": "예지",
    "userId": "@yeji_star",
    "profileImg": "assets/images/dummy/katt.png"
  },
  {
    "userName": "찬희",
    "userId": "@chanhee_go",
    "profileImg": "assets/images/dummy/katt.png"
  },
  {
    "userName": "지수",
    "userId": "@jisoo_light",
    "profileImg": "assets/images/dummy/katt.png"
  },
];