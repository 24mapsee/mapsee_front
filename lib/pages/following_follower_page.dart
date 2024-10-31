import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../utils/common.dart';



class FollowingFollowerPage extends StatefulWidget {
  final int initialTabIndex;
  final String accessUserId;
  

  const FollowingFollowerPage({super.key, required this.initialTabIndex,required this.accessUserId});

  @override
  State<FollowingFollowerPage> createState() => _FollowingFollowerPageState();
}

class _FollowingFollowerPageState extends State<FollowingFollowerPage>

    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<Map<String, dynamic>> followerData = [];
  List<Map<String, dynamic>> followingData = [];
  bool isLoading = true;
  String? loginUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
      // Fetch loginUserId asynchronously
  getUserId().then((id) {
    setState(() {
      loginUserId = id;
    });
  });
    print("accessUserId: ${widget.accessUserId}");
    fetchFollowerAndFollowingData();
  }
   Future<void> fetchFollowerAndFollowingData() async {

  final followerUrl = '${dotenv.env["API_BASE_URL"]}/follow/follower/${widget.accessUserId}';
  final followingUrl = '${dotenv.env["API_BASE_URL"]}/follow/following/${widget.accessUserId}';
  

  try {
    final followerResponse = await http.get(Uri.parse(followerUrl));
    final followingResponse = await http.get(Uri.parse(followingUrl));
    

    if (followerResponse.statusCode == 200 && followingResponse.statusCode == 200) {
      final followerJson = json.decode(followerResponse.body);
      final followingJson = json.decode(followingResponse.body);

      setState(() {
        // 중첩된 followers와 following 리스트를 추출하여 할당
        followerData = List<Map<String, dynamic>>.from(followerJson['followers']);
        followingData = List<Map<String, dynamic>>.from(followingJson['following']);
        isLoading = false;
      });

      print("Follower Data: $followerData");
      print("Following Data: $followingData");
    } else {
      print('Failed to load data');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
}
// 팔로우 삭제 함수
 Future<void> deleteFollower(String userId) async {
  final url = '${dotenv.env["API_BASE_URL"]}/follow/delete-follow';
  print("요청 URL: $url");
  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'followerId': userId,
        'followingId': widget.accessUserId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Successfully unfollowed user: $userId');
      fetchFollowerAndFollowingData();  // 업데이트된 팔로잉 데이터 가져오기
    } else {
      print('Failed to unfollow user: ${response.statusCode}');
    }
  } catch (e) {
    print('Error unfollowing user: $e');
  }
}


// 팔로우 요청 보내는 함수
  Future<void> doFollowing(String userId) async {
  final url = '${dotenv.env["API_BASE_URL"]}/follow/add-follow';
  print("요청 URL: $url");
  try {
    final loginUserId = await getUserId();
    if (loginUserId == null) {
    print('로그인된 사용자가 없습니다.');
    return;
  }
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'followerId': userId,
        'followingId': loginUserId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Successfully followed user: $userId');
      fetchFollowerAndFollowingData();  // 업데이트된 팔로잉 데이터 가져오기
    } else {
      print('Failed to follow user: ${response.statusCode}');
    }
  } catch (e) {
    print('Error following user: $e');
  }
}





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
                    const Text(
                      '팔로워 ',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      followerData.length.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const Text(
                      '명',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '팔로잉 ',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      followingData.length.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const Text(
                      '명',
                      style: TextStyle(
                        fontSize: 15,
                      ),
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
              _buildListView(
                context,followerData,"팔로잉", doFollowing
              ),
              _buildListView(
                context, 
                followingData, 
                (loginUserId == widget.accessUserId) ? "삭제" : "팔로잉", 
                (loginUserId == widget.accessUserId) ? deleteFollower : doFollowing
              ),
            ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildListView(BuildContext context, List<Map<String, dynamic>> data,
    String buttonText, Future<void> Function(String) onButtonPressed) { // 1. onButtonPressed 타입 수정
  final double screenWidth = MediaQuery.of(context).size.width;

  print("Data in _buildListView: $data"); // 리스트 데이터 확인

  if (data.isEmpty) {
    return const Center(
      child: Text(
        '아직 데이터가 없습니다!',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }
  return ListView.builder(
    itemCount: data.length,
     itemBuilder: (context, index) {
      final userName = data[index]['name'] ?? 'Unknown User'; // 기본값 설정
      final userId = data[index]['user_id'] ?? 'Unknown ID'; // 기본값 설정
      final profileImg = data[index]['profile_picture'] ?? 'assets/images/dummy/default_user.png';

      print("Rendering item: $userName, $userId"); // 각 아이템 데이터 확인

      return ListTile(
         leading: profileImg.startsWith('http')
            ? Image.network(profileImg, width: 40, height: 40)  // URL인 경우 Image.network 사용
            : Image.asset(profileImg, width: 40, height: 40),   // 로컬 파일인 경우 Image.asset 사용
        title: Text(userName),
        subtitle: Text(userId),
        trailing: ElevatedButton(
          onPressed: () =>onButtonPressed(userId),
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

// Map<String, dynamic> userData = {
//   "user_image": "assets/images/dummy/katt.png",
//   "user_name": "구슬이",
//   "user_id": "@cherror",
//   "archive_cnt": 56,
//   "like_cnt": 27,
//   "follower_cnt": 472,
//   "following_cnt": 486
// };

// List<Map<String, dynamic>> follwing_data = [
//   {
//     "userName": "민수",
//     "userId": "@minsoo123",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
//   {
//     "userName": "유나",
//     "userId": "@yuna_456",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
//   {
//     "userName": "지호",
//     "userId": "@jiho789",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
//   {
//     "userName": "해린",
//     "userId": "@haerin_lovely",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
//   {
//     "userName": "도영",
//     "userId": "@doyoung_world",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
// ];

// List<Map<String, dynamic>> follwer_data = [
//   {
//     "userName": "수빈",
//     "userId": "@subin_the_best",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
//   {
//     "userName": "준영",
//     "userId": "@junyoung_999",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
//   {
//     "userName": "예지",
//     "userId": "@yeji_star",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
//   {
//     "userName": "찬희",
//     "userId": "@chanhee_go",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
//   {
//     "userName": "지수",
//     "userId": "@jisoo_light",
//     "profileImg": "assets/images/dummy/katt.png"
//   },
// ];