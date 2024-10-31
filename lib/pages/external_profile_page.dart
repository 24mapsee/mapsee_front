import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mapsee/pages/post_detail_page.dart';
import 'package:mapsee/pages/place_folder_detail_page.dart';
import 'package:mapsee/pages/following_follower_page.dart';
import '../utils/common.dart';

class ExternalProfilePage extends StatefulWidget {
  final String userId;

  const ExternalProfilePage({super.key, required this.userId});

  @override
  _ExternalProfilePageState createState() => _ExternalProfilePageState();
}

class _ExternalProfilePageState extends State<ExternalProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFollowing = false; // 팔로우 상태 관리 변수
  int? expandedIndex; // Route 탭의 현재 열려 있는 인덱스 추적
   
 Future<void> followUser() async {
  final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/follow/add-follow');
  final userId = await getUserId();
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'followerId': widget.userId,
      'followingId': userId,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 409) {  // 409도 성공 상태로 처리
    setState(() {
      isFollowing = true;
    });
  } else {
    print('Failed to follow user: ${response.statusCode}');
  }
}

Future<void> unfollowUser() async {
  final userId = await getUserId(); // 로그인한 사용자 ID 가져오기
  final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/follow/delete-follow');
  final response = await http.delete(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'followerId': widget.userId,
      'followingId': userId,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 204) {  // 204는 성공적인 삭제
    setState(() {
      isFollowing = false;
    });
  } else {
    print('Failed to unfollow user: ${response.statusCode}');
  }
}

 
   // API로 불러온 데이터 변수
  Map<String, dynamic> externalUserData = {};
  List<Map<String, dynamic>> feedsData = [];
  List<Map<String, dynamic>> placeData = [];
  List<Map<String, dynamic>> routeData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchExternalUserProfile();
    checkFollowStatus();
  }
  Future<void> checkFollowStatus() async {
  final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/follow/check-follow');
  final userId = await getUserId(); // 로그인한 사용자 ID 가져오기

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'followerId': widget.userId,
      'followingId': userId,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    setState(() {
      isFollowing = data['isFollowing'] ?? false;
    });
  } else {
    print('Failed to check follow status: ${response.statusCode}');
  }
}


  // 외부 사용자 프로필 정보 및 활동 데이터 불러오기
  Future<void> fetchExternalUserProfile() async {
    final url = '${dotenv.env["API_BASE_URL"]}/profile/${widget.userId}';
    print("Fetching data from: $url");  // URL을 콘솔에 출력
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
        externalUserData = data['userInfo'] as Map<String, dynamic>;

        // feedsData, placeData, routeData가 리스트인 경우에만 변환
        feedsData = data['feeds'] is List
            ? List<Map<String, dynamic>>.from(data['feeds'])
            : [];
        placeData = data['places'] is List
            ? List<Map<String, dynamic>>.from(data['places'])
            : [];
        routeData = data['routes'] is List
            ? List<Map<String, dynamic>>.from(data['routes'])
            : [];
          isLoading = false; // 로딩 완료
        });
      } else {
        print('Failed to load user profile data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(externalUserData['user_name'] ?? '사용자 이름'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 20),
          _buildProfileHeader(),
          const SizedBox(height: 10),
          _buildProfileStats(),
          const SizedBox(height: 10),
          _buildFollowButton(),
          const SizedBox(height: 10),
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
          backgroundImage: externalUserData['user_image'] != null
              ? NetworkImage(externalUserData['user_image'])
              : const AssetImage('assets/images/dummy/default_user.png') as ImageProvider,
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              externalUserData['name'] ?? '사용자 이름',
              style: const TextStyle(
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
      onPressed: () async {
        if (isFollowing) {
          await unfollowUser();
        } else {
          await followUser();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing ? Colors.grey : Colors.blue,
        foregroundColor: Colors.white,
        minimumSize: Size(buttonWidth, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(isFollowing ? "팔로우 취소" : "팔로우"),
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
                externalUserData['repository']?.toString() ?? '0',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('저장소'),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                      builder: (context) => FollowingFollowerPage(
                        accessUserId: externalUserData['user_id'],
                        initialTabIndex: 0),
                    )
              );
            },
            child: Column(
              children: [
                Text(
                  externalUserData['follower']?.toString() ?? '0',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('팔로워'),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                      builder: (context) => FollowingFollowerPage(
                        accessUserId: externalUserData['user_id'],
                        initialTabIndex: 1),
                    )
              );
            },
            child: Column(
              children: [
                Text(
                  externalUserData['following']?.toString() ?? '0',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('팔로잉'),
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
                builder: (context) => PostDetailPage(feedData: item),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: item['user_image'] != null
                        ? NetworkImage(item['user_image'])
                        : const AssetImage('assets/images/dummy/default_user.png'),
                  ),
                  title: Text(item['user_id'] ?? '사용자 이름'),
                  subtitle: Text(item['created_at'] ?? '시간 정보 없음'),
                ),
                if (item['image_url'] != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(item['image_url']),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    item['title'] ?? '제목 없음',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
          leading: const Icon(Icons.place, color: Colors.blue),
          title: Text(item['name'] ?? '장소 없음'),  // 'name'을 사용
          subtitle: Text(item['description'] ?? '공동 작업자 없음'), // 'description'을 사용
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceFolderDetailPage(
                  title: item['name'],  // 받아온 데이터를 사용하여 동적 제목 설정
                placeNames: item['places'] != null ? List<String>.from(item['places']) : [],  // 데이터의 'places' 배열을 활용
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
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: ExpansionTile(
            key: UniqueKey(),
            title: Text(item['title'] ?? '경로 없음'), // 'title'을 사용
            trailing: RotationTransition(
              turns: AlwaysStoppedAnimation(expandedIndex == index ? 0.5 : 0.0),
              child: const Icon(Icons.expand_more),
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
                child: Text(item['description'] ?? '추가 정보 없음'), // 'description'을 사용
              ),
            ],
          ),
        );
      },
    );
  }
}

// // 더미 데이터
// final Map<String, dynamic> externalUserData = {
//   "user_image": "assets/images/dummy/katt.png",
//   "user_name": "구슬이",
//   "user_id": "@cherror",
//   "archive_count": 56,
//   "follower_count": 472,
//   "following_count": 486,
// };

// final List<Map<String, dynamic>> feedsData = [
//   {"user_id": "구슬이", "title": "데일리 카페 방문", "description": "카페에서 공부하는 중", "image_url": "assets/images/dummy/dummy1.jpg"},
//   {"user_id": "구슬이", "title": "아름다운 산책로", "description": "산책하기 좋은 날씨", "image_url": "assets/images/dummy/dummy2.jpg"},
// ];

// final List<Map<String, dynamic>> placeData = [
//   {"archive_name": "서울의 명소", "collaborator_name": "지인들과 함께", "locked": false},
//   {"archive_name": "부산의 숨은 맛집", "collaborator_name": null, "locked": true},
// ];

// final List<Map<String, dynamic>> routeData = [
//   {"archive_name": "서울에서 강릉까지의 루트", "collaborator_name": "드라이브 코스", "locked": false},
//   {"archive_name": "부산 맛집 투어", "collaborator_name": "미식가의 여정", "locked": true},
// ];