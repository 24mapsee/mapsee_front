import 'package:flutter/material.dart';
import 'package:mapsee/pages/post_detail_page.dart';
import 'package:mapsee/pages/place_folder_detail_page.dart';
import 'package:mapsee/pages/following_follower_page.dart';

class ExternalProfilePage extends StatefulWidget {
  final String userId;

  ExternalProfilePage({required this.userId});

  @override
  _ExternalProfilePageState createState() => _ExternalProfilePageState();
}

class _ExternalProfilePageState extends State<ExternalProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFollowing = false; // 팔로우 상태 관리 변수
  int? expandedIndex; // Route 탭의 현재 열려 있는 인덱스 추적

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(externalUserData['user_name']),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildProfileHeader(),
          SizedBox(height: 10),
          _buildProfileStats(),
          SizedBox(height: 10),
          _buildFollowButton(),
          SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Image.asset('assets/images/png/feeds.png', height: 23)),
              Tab(icon: Image.asset('assets/images/png/marker.png', height: 24)),
              Tab(icon: Image.asset('assets/images/png/route.png', height: 25)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFeedsListView(feedsData),
                _buildPlaceListView(placeData),
                _buildRouteListView(routeData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 프로필 상단 정보
  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          backgroundImage: AssetImage(externalUserData['user_image']),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              externalUserData['user_name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(externalUserData['user_id']),
          ],
        ),
      ],
    );
  }

  // 팔로우 버튼
  Widget _buildFollowButton() {
    final buttonWidth = MediaQuery.of(context).size.width * 0.8;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isFollowing = !isFollowing; // 상태 반전
        });
      },
      child: Text(isFollowing ? "팔로우 취소" : "팔로우"),
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing ? Colors.grey : Colors.blue,
        foregroundColor: Colors.white,
        minimumSize: Size(buttonWidth, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // 저장소, 팔로워, 팔로잉 정보
  Widget _buildProfileStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                externalUserData['archive_count'].toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('저장소'),
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
                  externalUserData['follower_count'].toString(),
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
                  externalUserData['following_count'].toString(),
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
    );
  }

  // Feeds 탭의 게시물 리스트뷰
  Widget _buildFeedsListView(List<Map<String, dynamic>> data) {
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
                    "image_url": item['image_url'] ?? 'assets/images/dummy/dummy1.jpg'
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
                          builder: (context) => ExternalProfilePage(userId: item['user_id']),
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
                          builder: (context) => ExternalProfilePage(userId: item['user_id']),
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

  // Place 탭의 리스트뷰
  Widget _buildPlaceListView(List<Map<String, dynamic>> data) {
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
                  placeNames: ['장소1', '장소2', '장소3'],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Route 탭의 토글 리스트뷰
  Widget _buildRouteListView(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: ExpansionTile(
            key: UniqueKey(),
            title: Text(item['archive_name'] ?? '경로 없음'),
            trailing: RotationTransition(
              turns: AlwaysStoppedAnimation(expandedIndex == index ? 0.5 : 0.0),
              child: Icon(Icons.expand_more),
            ),
            initiallyExpanded: expandedIndex == index,
            onExpansionChanged: (isExpanded) {
              setState(() {
                expandedIndex = isExpanded ? index : null;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item['collaborator_name'] ?? '추가 정보 없음'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 더미 데이터
final Map<String, dynamic> externalUserData = {
  "user_image": "assets/images/dummy/katt.png",
  "user_name": "구슬이",
  "user_id": "@cherror",
  "archive_count": 56,
  "follower_count": 472,
  "following_count": 486,
};

final List<Map<String, dynamic>> feedsData = [
  {"user_id": "구슬이", "title": "데일리 카페 방문", "description": "카페에서 공부하는 중", "image_url": "assets/images/dummy/dummy1.jpg"},
  {"user_id": "구슬이", "title": "아름다운 산책로", "description": "산책하기 좋은 날씨", "image_url": "assets/images/dummy/dummy2.jpg"},
];

final List<Map<String, dynamic>> placeData = [
  {"archive_name": "서울의 명소", "collaborator_name": "지인들과 함께", "locked": false},
  {"archive_name": "부산의 숨은 맛집", "collaborator_name": null, "locked": true},
];

final List<Map<String, dynamic>> routeData = [
  {"archive_name": "서울에서 강릉까지의 루트", "collaborator_name": "드라이브 코스", "locked": false},
  {"archive_name": "부산 맛집 투어", "collaborator_name": "미식가의 여정", "locked": true},
];