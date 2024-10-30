import 'package:flutter/material.dart';
import 'package:mapsee/pages/edit_profile_page.dart';
import 'post_detail_page.dart';
import 'place_folder_detail_page.dart';
import 'external_profile_page.dart';
import 'package:mapsee/pages/following_follower_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          _buildProfileInfo(screenWidth),
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
              Tab(icon: Image.asset('assets/images/png/feeds.png', height: 23)),
              Tab(icon: Image.asset('assets/images/png/marker.png', height: 24)),
              Tab(icon: Image.asset('assets/images/png/route.png', height: 25)),
              Tab(icon: Image.asset('assets/images/png/filled_heart.png', height: 22)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPostCardView(Feeds), // feeds 탭
                _buildListView(Place_Folders), // place 탭
                _buildToggleListView(Custom_Routes), // route 탭
                _buildPostCardView(Saved_Feeds), // filled_heart 탭
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 프로필 정보 위젯
  Widget _buildProfileInfo(double screenWidth) {
    return Column(
      children: [
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
                      builder: (context) => FollowingFollowerPage(initialTabIndex: 0),
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
                      builder: (context) => FollowingFollowerPage(initialTabIndex: 1),
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
      ],
    );
  }

  // 게시물 카드 형태의 리스트 (feeds와 filled_heart 탭에서 사용)
  Widget _buildPostCardView(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(
                  feedData: {
                    "user_id": item['user_id'] ?? '사용자 이름',
                    "title": item['title'] ?? '제목 없음',
                    "description": item['description'] ?? '설명 없음',
                    "created_at": item['created_at'] ?? '시간 정보 없음',
                    "image_url": item['image_url'] ?? 'assets/images/dummy/dummy1.jpg',
                    "user_image": item['user_image'] ?? 'assets/images/dummy/default_user.png'
                  },
                ),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExternalProfilePage(userId: item['user_id'] ?? 'unknown'),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage(item['user_image'] ?? 'assets/images/dummy/default_user.png'),
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExternalProfilePage(userId: item['user_id'] ?? 'unknown'),
                        ),
                      );
                    },
                    child: Text(item['user_id'] ?? '사용자 이름'),
                  ),
                  subtitle: Text(item['created_at'] ?? '시간 정보 없음'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(item['image_url'] ?? 'assets/images/dummy/dummy1.jpg'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    item['title'] ?? '제목 없음',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    item['description'] ?? '설명 없음',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 일반 리스트 (place 탭에서 사용)
  Widget _buildListView(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return ListTile(
          leading: Icon(Icons.place, color: Colors.blue),
          title: Text(item['archive_name'] ?? '장소 없음'),
          subtitle: Text(item['collaborator_name'] ?? '공동 작업자 없음'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceFolderDetailPage(
                  title: item['archive_name'],
                  placeNames: ['장소1', '장소2', '장소3'], // 임시 장소 목록
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 토글 가능한 리스트 (route 탭에서 사용)
  Widget _buildToggleListView(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return ExpansionTile(
          title: Text(item['archive_name'] ?? '경로 없음'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item['collaborator_name'] ?? '추가 정보 없음'),
            ),
          ],
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
  List<Map<String, dynamic>> Feeds = [
    {"user_id": "구슬이", "title": "데이트 코스", "description": "멋진 데이트 장소", "created_at": "1일 전", "image_url": "assets/images/dummy/dummy1.jpg", "user_image": "assets/images/dummy/katt.png"},
    {"user_id": "철수", "title": "고독한 미식가", "description": "미식가의 여정", "created_at": "2일 전", "image_url": "assets/images/dummy/dummy2.jpg"},
    {"user_id": "민수", "title": "동아리 정기 모임 장소", "description": "모임 장소", "created_at": "3일 전"},
    {"user_id": "영희", "title": "클라이밍", "description": "즐거운 클라이밍", "created_at": "5일 전"},
  ];

  List<Map<String, dynamic>> Place_Folders = [
    {"archive_name": "강릉 초당길 맛집 투어", "archive_collaborator": "6개의 장소", "locked": false},
    {"archive_name": "경주 가볼 곳", "archive_collaborator": "18개의 장소", "locked": true},
  ];

  List<Map<String, dynamic>> Custom_Routes = [
    {"archive_name": "서울 인생샷 스팟", "archive_collaborator": "20개의 장소", "locked": false},
    {"archive_name": "남산 벚꽃 구경", "archive_collaborator": "8개의 장소", "locked": true},
  ];

  List<Map<String, dynamic>> Saved_Feeds = [
    {"user_id": "지현", "title": "Saved Post 1", "description": "멋진 풍경", "created_at": "1주 전", "image_url": "assets/images/dummy/dummy3.jpg"},
    {"user_id": "지수", "title": "Saved Post 2", "description": "멋진 사진", "created_at": "2주 전"},
    {"user_id": "상민", "title": "Saved Post 3", "description": "즐거운 여행", "created_at": "3주 전"},
    {"user_id": "하늘", "title": "Saved Post 4", "description": "아름다운 풍경", "created_at": "4주 전"},
  ];
}