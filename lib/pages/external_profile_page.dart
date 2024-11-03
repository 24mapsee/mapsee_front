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

class _ExternalProfilePageState extends State<ExternalProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFollowing = false;
  int? expandedIndex;
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
    final userId = await getUserId();
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'followerId': widget.userId, 'followingId': userId}),
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

  Future<void> doFollowing(String followerId, String followingId) async {
    final url = '${dotenv.env["API_BASE_URL"]}/follow/add-follow';
    final userId = await getUserId();

    if (userId == null) {
      print("로그인된 사용자가 없습니다.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'followerId': widget.userId, 'followingId': userId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully followed user: ${widget.userId}');
        setState(() {
          isFollowing = true;
        });
      } else {
        print('Failed to follow user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error following user: $e');
    }
  }

  Future<void> deleteFollower(String followerId, String followingId) async {
    final url = '${dotenv.env["API_BASE_URL"]}/follow/delete-follow';
    final userId = await getUserId();

    if (userId == null) {
      print("로그인된 사용자가 없습니다.");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'followerId': widget.userId, 'followingId': userId}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Successfully unfollowed user: ${widget.userId}');
        setState(() {
          isFollowing = false;
        });
      } else {
        print('Failed to unfollow user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error unfollowing user: $e');
    }
  }

  // 팔로우 및 언팔로우 버튼에 따라 doFollowing 및 deleteFollower 호출
  Future<void> toggleFollow() async {
    print("toggleFollow 호출됨"); // 디버그 출력
    final userId = await getUserId();
    if (userId == null) {
      print("로그인된 사용자가 없습니다.");
      return;
    }

    if (isFollowing) {
      print("DELETE 요청: /follow/delete-follow"); // 언팔로우 엔드포인트 출력
      print("Calling deleteFollower...");
      await deleteFollower(userId, widget.userId);
      setState(() {
        isFollowing = false;
      });
    } else {
      print("Calling doFollowing...");
      print("POST 요청: /follow/add-follow"); // 팔로우 엔드포인트 출력
      await doFollowing(userId, widget.userId);
      setState(() {
        isFollowing = true;
      });
    }
  }

  // 외부 사용자 프로필 정보 및 활동 데이터 불러오기
  Future<void> fetchExternalUserProfile() async {
    final url = '${dotenv.env["API_BASE_URL"]}/profile/${widget.userId}';
    print("Fetching data from: $url"); // URL을 콘솔에 출력
    try {
      final response = await http.get(Uri.parse(url));

      print("Response: ${response.body}"); // 응답 확인
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
        title: Text(externalUserData['name'] ?? '사용자 이름'),
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
                    Tab(
                        icon: Image.asset('assets/images/png/feeds.png',
                            height: 23)),
                    Tab(
                        icon: Image.asset('assets/images/png/marker.png',
                            height: 24)),
                    Tab(
                        icon: Image.asset('assets/images/png/route.png',
                            height: 25)),
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
          backgroundImage: externalUserData['profile_picture'] != null
              ? NetworkImage(externalUserData['profile_picture'])
              : const AssetImage('assets/images/dummy/default_user.png')
                  as ImageProvider,
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
          ],
        ),
      ],
    );
  }

  // 팔로우 버튼
  Widget _buildFollowButton() {
    final buttonWidth = MediaQuery.of(context).size.width * 0.8;
    print("팔로우 버튼 생성됨. 현재 상태: ${isFollowing ? '팔로우 중' : '팔로우 안 함'}"); // 디버그 출력
    return ElevatedButton(
      onPressed: () {
        print("팔로우 버튼 클릭됨"); // 버튼 클릭 디버그 출력
        toggleFollow();
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
                  ));
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
                  ));
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
                    backgroundImage: externalUserData['profile_picture'] != null
                        ? NetworkImage(externalUserData['profile_picture'])
                        : const AssetImage(
                            'assets/images/dummy/default_user.png'),
                  ),
                  title: Text(externalUserData['name'] ?? '사용자 이름'),
                  subtitle: Text(item['created_at'] ?? '시간 정보 없음'),
                ),
                if (item['image_url'] != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(item['image_url']),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    item['title'] ?? '제목 없음',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
          title: Text(item['name'] ?? '장소 없음'), // 'name'을 사용
          subtitle:
              Text(item['description'] ?? '공동 작업자 없음'), // 'description'을 사용
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceFolderDetailPage(
                  title: item['name'], // 받아온 데이터를 사용하여 동적 제목 설정
                  placeNames: item['places'] != null
                      ? List<String>.from(item['places'])
                      : [], // 데이터의 'places' 배열을 활용
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
                child: Text(
                    item['description'] ?? '추가 정보 없음'), // 'description'을 사용
              ),
            ],
          ),
        );
      },
    );
  }
}
