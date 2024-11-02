import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mapsee/pages/edit_profile_page.dart';
import 'post_detail_page.dart';
import 'place_folder_detail_page.dart';
import 'external_profile_page.dart';
import 'package:mapsee/pages/following_follower_page.dart';
import '../utils/common.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> Feeds = [];
  List<Map<String, dynamic>> Place_Folders = [];
  List<Map<String, dynamic>> Custom_Routes = [];
  List<Map<String, dynamic>> Saved_Feeds = [];
  bool isLoading = true;
  int? expandedIndex; // 현재 열려 있는 인덱스 추적

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    fetchProfileData();
    print(userData); // userData에 어떤 데이터가 들어오는지 확인
  }

  Future<void> fetchProfileData() async {
    try {
      print(await getUserInfo());

      final userId = await getUserId();
      if (userId == null) {
        print('로그인된 사용자가 없습니다.');
        return;
      }

      final url = '${dotenv.env["API_BASE_URL"]}/profile/$userId';
      print("API URL: $url"); // URL 확인
      final response = await http.get(Uri.parse(url));
      print("Response: ${response.body}"); // 응답 확인

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userData = data['userInfo'] as Map<String, dynamic>;

          // 리스트 형태가 아니면 빈 리스트 할당
          Place_Folders = (data['places'] is List)
              ? List<Map<String, dynamic>>.from(data['places'])
              : [];
          Custom_Routes = (data['routes'] is List)
              ? List<Map<String, dynamic>>.from(data['routes'])
              : [];
          Feeds = (data['feeds'] is List)
              ? List<Map<String, dynamic>>.from(data['feeds'])
              : [];
          Saved_Feeds = (data['savedFeeds'] is List)
              ? List<Map<String, dynamic>>.from(data['savedFeeds'])
              : [];
          isLoading = false;
        });
        print('userData: $userData'); // userData 출력
        print('Place_Folders: $Place_Folders'); // Place_Folders 데이터 출력
        print('Custom_Routes: $Custom_Routes'); // Custom_Routes 데이터 출력
        print('Feeds: $Feeds'); // Feeds 데이터 출력
        print('Saved_Feeds: $Saved_Feeds'); // Saved_Feeds 데이터 출력
      } else {
        print('사용자 정보 불러오기 실패: ${response.statusCode}');
        setState(() {
          userData = {}; // 오류가 발생해도 userData를 빈 값으로 설정
        });
      }
    } catch (e) {
      print('오류 발생: $e');
      setState(() {
        userData = {}; // 오류가 발생해도 userData를 빈 값으로 설정
      });
    }
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
      body: userData.isNotEmpty
          ? Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileInfo(screenWidth),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()),
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
                      child: const Text('내 정보 수정'),
                    ),
                    const SizedBox(width: 10),
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
                      child: const Text('내 프로필 공유'),
                    ),
                  ],
                ),
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
                    Tab(
                        icon: Image.asset('assets/images/png/filled_heart.png',
                            height: 22)),
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
            )
          : const Center(child: CircularProgressIndicator()),
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
                backgroundImage: NetworkImage(userData['profile_picture'] ??
                    'assets/images/dummy/default_user.png'),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    userData['repository'].toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('저장소'),
                ],
              ),
              Column(
                children: [
                  Text(
                    userData['saved_feeds'].toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('찜'),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowingFollowerPage(
                          accessUserId: userData['user_id'],
                          initialTabIndex: 0),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      userData['follower'].toString(),
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
                          accessUserId: userData['user_id'],
                          initialTabIndex: 1),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(
                      userData['following'].toString(),
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
                  feedData: item,
                ),
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
                    backgroundImage: NetworkImage(userData['profile_picture'] ??
                        'assets/images/dummy/default_user.png'),
                  ),
                  title: Text(userData['name'] ?? '사용자 이름'),
                  subtitle: Text(item['created_at'] ?? '시간 정보 없음'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                      item['image_url'] ?? 'assets/images/dummy/dummy1.jpg'),
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

  // 일반 리스트 (place 탭에서 사용)
  Widget _buildListView(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return ListTile(
          leading: const Icon(Icons.place, color: Colors.blue),
          title: Text(item['name'] ?? '장소 없음'),
          subtitle: Text(item['description'] ?? '공동 작업자 없음'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceFolderDetailPage(
                  title: item['name'],
                  placeNames: const ['장소1', '장소2', '장소3'], // 임시 장소 목록
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
          title: Text(item['title'] ?? '경로 없음'),
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
        );
      },
    );
  }
}
