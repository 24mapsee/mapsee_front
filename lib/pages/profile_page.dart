import 'package:flutter/material.dart';
import 'package:mapsee/pages/edit_profile_page.dart';
import 'package:mapsee/pages/following_follwer_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage: AssetImage(userData['user_image']),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['user_name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(userData['user_id']),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      userData['archive_cnt'].toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('저장소'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      userData['like_cnt'].toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('찜'),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowingFollwerPage(
                          initialTabIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        userData['follower_cnt'].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('팔로워'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FollowingFollwerPage(initialTabIndex: 1),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        userData['following_cnt'].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('팔로잉'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
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
                child: Text('내 정보 수정'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.11,
                    vertical: 6,
                  ),
                ),
                child: Text('내 프로필 공유'),
              ),
            ],
          ),
          SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                  icon: Image.asset(
                'assets/images/png/marker.png',
                height: 24,
              )),
              Tab(
                  icon: Image.asset(
                'assets/images/png/route.png',
                height: 25,
              )),
              Tab(
                  icon: Image.asset(
                'assets/images/png/filled_heart.png',
                height: 22,
              )),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(dummyProfileData1),
                _buildListView(dummyProfileData2),
                _buildListView(dummyProfileData3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> data) {
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
        final archiveName = data[index]['archive_name'] ?? '아카이브 없음';
        final collaboratorName = data[index]['collaborator_name'];

        return ListTile(
          leading: Icon(Icons.favorite, color: Colors.pink),
          title: Text(archiveName),
          subtitle: collaboratorName != null
              ? Text(
                  '${collaboratorName} 님과 함께',
                  style: TextStyle(color: Colors.grey[700]),
                )
              : null,
          trailing: data[index]['locked'] ? Icon(Icons.lock) : null,
        );
      },
    );
  }

// 더미 유저 데이터
  Map<String, dynamic> userData = {
    "user_image": "assets/images/dummy/katt.png",
    "user_name": "구슬이",
    "user_id": "@cherror",
    "archive_cnt": 56,
    "like_cnt": 27,
    "follower_cnt": 472,
    "following_cnt": 486
  };

// 더미 아카이브 데이터들
  List<Map<String, dynamic>> dummyProfileData1 = [
    {"archive_name": "데이트 코스", "collaborator_name": "김현진", "locked": true},
    {"archive_name": "고독한 미식가", "collaborator_name": null, "locked": false},
    {
      "archive_name": "동아리 정기 모임 장소",
      "collaborator_name": "민수",
      "locked": false
    },
    {"archive_name": "클라이밍", "collaborator_name": null, "locked": false},
  ];

  List<Map<String, dynamic>> dummyProfileData2 = [
    {
      "archive_name": "강릉 초당길 맛집 투어",
      "archive_collaborator": "6개의 장소",
      "locked": false
    },
    {
      "archive_name": "경주 가볼 곳",
      "archive_collaborator": "18개의 장소",
      "locked": true
    },
  ];

  List<Map<String, dynamic>> dummyProfileData3 = [
    {
      "archive_name": "서울 인생샷 스팟",
      "archive_collaborator": "20개의 장소",
      "locked": false
    },
    {
      "archive_name": "남산 벚꽃 구경",
      "archive_collaborator": "8개의 장소",
      "locked": true
    },
  ];
}
