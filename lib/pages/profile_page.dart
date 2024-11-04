import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mapsee/components/my_route_card.dart';
import 'package:mapsee/pages/edit_profile_page.dart';
import 'package:mapsee/pages/following_follower_page.dart';
import 'package:mapsee/pages/place_folder_detail_page.dart';
import 'package:mapsee/pages/place_info_background.dart';
import 'package:mapsee/pages/post_detail_page.dart';
import 'package:mapsee/services/search/searchRepository.dart';
import '../utils/common.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> Feeds = [];
  List<Map<String, dynamic>> Place_Folders = [];
  List<Map<String, dynamic>> Place_Folders_Details = [];
  List<Map<String, dynamic>> placeFolderDetails = [];
  List<Map<String, dynamic>> Custom_Routes = [];
  List<Map<String, dynamic>> Saved_Feeds = [];
  Map<int, List<dynamic>> routeDetails = {}; // 각 경로의 세부 정보를 저장
  bool isLoading = true;
  bool isFoldersDetailsLoading = true;
  int? expandedIndex; // 현재 열려 있는 인덱스 추적

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        // 플레이스 탭을 눌렀을 때 (index: 1)
        fetchPlaceFolders(userData['user_id']);
      }
    });
    fetchProfileData();
    _fetchRoutes();
  }

  void refreshData() {
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final userId = await getUserId();
      if (userId == null) return;

      // 사용자 프로필 및 관련 데이터 가져오기
      final profileUrl = '${dotenv.env["API_BASE_URL"]}/profile/$userId';
      final profileResponse = await http.get(Uri.parse(profileUrl));

      if (profileResponse.statusCode == 200) {
        final profileData = jsonDecode(profileResponse.body);

        setState(() {
          userData = profileData['userInfo'] ?? {};
          Place_Folders =
              List<Map<String, dynamic>>.from(profileData['places'] ?? []);
          Feeds = List<Map<String, dynamic>>.from(profileData['feeds'] ?? []);
          Saved_Feeds =
              List<Map<String, dynamic>>.from(profileData['savedFeeds'] ?? []);
        });
      }

      // Custom_Routes 데이터 가져오기
      final routesUrl =
          '${dotenv.env["API_BASE_URL"]}/route/get/customRoutesByUserID?user_id=$userId';
      final routesResponse = await http.get(Uri.parse(routesUrl));

      if (routesResponse.statusCode == 200) {
        final routesData = jsonDecode(routesResponse.body);

        setState(() {
          // 서버에서 받은 Custom_Routes 데이터를 사용
          Custom_Routes = List<Map<String, dynamic>>.from(routesData['routes']);
          isLoading = false;
        });
      }
    } catch (e) {
      print('오류 발생: $e');
      setState(() {
        userData = {}; // 오류 발생 시 빈 값으로 설정
        isLoading = false;
      });
    }
  }

  Future<void> fetchPlaceFolders(String userId) async {
    final placeFoldersUrl =
        '${dotenv.env["API_BASE_URL"]}/folder/getPlaceFolders';

    final placeFoldersResponse = await http.post(
      Uri.parse(placeFoldersUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"uid": userId}),
    );

    if (placeFoldersResponse.statusCode == 200) {
      final placeFoldersData = jsonDecode(placeFoldersResponse.body);

      setState(() {
        // description 필드 제거
        Place_Folders = List<Map<String, dynamic>>.from(
            placeFoldersData['folders'].map((folder) => {
                      'folder_id': folder['folder_id'],
                      'folder_name': folder['folder_name'],
                    }) ??
                []);
      });
    } else {
      log('Failed to load place folders: ${placeFoldersResponse.body}');
      log('Request URL: $placeFoldersUrl');
    }
  }

  Future<void> _fetchRoutes() async {
    try {
      final userId = await getUserId();
      final url =
          '${dotenv.env["API_BASE_URL"]}/route/get/customRoutesByUserID?user_id=$userId';
      log('Fetching Routes with URL: $url');

      final response = await http.get(Uri.parse(url));

      // 서버 응답 로그 확인
      log('fetchRoutes Response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          Custom_Routes =
              List<Map<String, dynamic>>.from(jsonResponse['routes']);
          log('Custom_Routes after _fetchRoutes: $Custom_Routes');
          isLoading = false;
        });
      } else {
        log('Failed to load routes with status: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error in _fetchRoutes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchRouteDetails(int index, int customRouteId) async {
    if (routeDetails.containsKey(index)) return;

    final url =
        '${dotenv.env["API_BASE_URL"]}/route/get/routesByCustomRouteID?custom_route_id=$customRouteId';
    log('Fetching Route Details with URL: $url');

    try {
      final response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      log('Route Details Response for ID $customRouteId: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log('Parsed Data: $data');

        setState(() {
          routeDetails[index] = data["routes"] ?? [];
        });
      } else {
        log('Failed to load route details for custom_route_id: $customRouteId');
      }
    } catch (e) {
      log('Error fetching route details: $e');
    }
  }

  Future<void> _fetchPlaceFolderDetails(int index, int folderId) async {
    final url =
        '${dotenv.env["API_BASE_URL"]}/folder/getPlacesInFolder?folder_id=$folderId';

    setState(() {
      isFoldersDetailsLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"folder_id": folderId}),
      );
      log('Place Folder Details Response for folder_id $folderId: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          placeFolderDetails =
              List<Map<String, dynamic>>.from(data["places"] ?? []);
          isFoldersDetailsLoading = false;
        });

        log('placeFolderDetails: $placeFolderDetails');
      } else {
        log('Failed to load place folder details for folder_id: $folderId');
        setState(() {
          isFoldersDetailsLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching place folder details: $e');
      setState(() {
        isFoldersDetailsLoading = false;
      });
    }
  }

  Future<void> movePlaceInfo(String name, String kakaoPlaceId) async {
    List<Map<String, dynamic>> newData = await getKakaoPlaceSearchWithPlaceID(
        query: name, kakaoPlaceId: kakaoPlaceId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceInfoBackground(
          kakaoPlaceId: kakaoPlaceId,
          title: newData[0]["title"],
          category: newData[0]["category"] ?? "정보 없음",
          roadAddress: newData[0]["roadAddress"] ?? "정보 없음",
          address: newData[0]["address"] ?? "정보 없음",
          link: newData[0]["link"] ?? "정보 없음",
          telephone: newData[0]["telephone"] ?? "정보 없음",
          mapx: newData[0]["mapx"],
          mapy: newData[0]["mapy"],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Custom_Routes 데이터 로드 확인
    log("Custom_Routes 데이터 확인:");
    for (int i = 0; i < Custom_Routes.length; i++) {
      log("Index $i: ${Custom_Routes[i]}");
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/mapsee_logo.png', height: 40),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45, // 화면 너비의 40%로 설정
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(onRefresh: refreshData),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.grey[200], // 검은색 글씨
                            shadowColor: Colors.black.withOpacity(0.5), // 옅은 그림자
                            elevation: 2, // 그림자 크기
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // 모서리 각도 조절
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10), // 세로 여백 줄이기
                          ),
                          child: const Text('내 정보 수정'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45, // 화면 너비의 40%로 설정
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.grey[200], // 검은색 글씨
                            shadowColor: Colors.black.withOpacity(0.5), // 옅은 그림자
                            elevation: 2, // 그림자 크기
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // 모서리 각도 조절
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10), // 세로 여백 줄이기
                          ),
                          child: const Text('내 프로필 공유'),
                        ),
                      ),
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
                      _buildPostCardView(Feeds),
                      _buildPlaceFoldersView(Place_Folders),
                      _buildToggleListView(Custom_Routes),
                      _buildPostCardView(Saved_Feeds),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

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
                backgroundImage: userData['profile_picture'] != null
                    ? NetworkImage(userData['profile_picture'])
                    : const AssetImage('assets/images/dummy/default_user.png'),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData['name'] ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text('저장소'),
                ],
              ),
              Column(
                children: [
                  Text(
                    userData['saved_feeds'].toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
                              initialTabIndex: 0)));
                },
                child: Column(
                  children: [
                    Text(
                      userData['follower'].toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
                              initialTabIndex: 1)));
                },
                child: Column(
                  children: [
                    Text(
                      userData['following'].toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
                    builder: (context) => PostDetailPage(feedData: item)));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: userData['profile_picture'] != null
                        ? NetworkImage(userData['profile_picture'])
                        : const AssetImage(
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

  Widget _buildPlaceFoldersView(List<Map<String, dynamic>> placeFolders) {
    if (placeFolders.isEmpty) {
      return const Center(
        child: Text(
          '저장된 장소 폴더가 없습니다!',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: placeFolders.length,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemBuilder: (context, index) {
        final folder = placeFolders[index];
        final folderName = folder['folder_name'] ?? '폴더 이름 없음';
        final folderId = folder['folder_id'];

        return Padding(
          padding: EdgeInsets.only(
            bottom: 18.0,
            top: index == 0 ? 18.0 : 0.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey[300]!, width: 0.5),
            ),
            child: Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: EdgeInsets.zero,
              child: ExpansionTile(
                key: UniqueKey(),
                title: Text(
                  folderName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                initiallyExpanded: expandedIndex == index,
                onExpansionChanged: (isExpanded) {
                  setState(() {
                    expandedIndex = isExpanded ? index : null;
                    if (isExpanded && folderId != null) {
                      _fetchPlaceFolderDetails(index, folderId);
                    }
                  });
                },
                children: !isFoldersDetailsLoading
                    ? placeFolderDetails.isNotEmpty
                        ? List.generate(
                            placeFolderDetails.length,
                            (placeIndex) => ListTile(
                              title:
                                  Text(placeFolderDetails[placeIndex]['name']),
                              onTap: () {
                                movePlaceInfo(
                                    placeFolderDetails[placeIndex]['name'],
                                    placeFolderDetails[placeIndex]
                                        ['kakao_place_id']);
                              },
                            ),
                          )
                        : [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('이 폴더에 저장된 장소가 없습니다.'),
                            )
                          ]
                    : [const Center(child: CircularProgressIndicator())],
              ),
            ),
          ),
        );
      },
    );
  }

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
                        placeNames: const ['장소1', '장소2', '장소3'])));
          },
        );
      },
    );
  }

  Widget _buildToggleListView(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return const Center(
          child: Text('저장된 경로 데이터가 없습니다!',
              style: TextStyle(color: Colors.grey, fontSize: 16)));
    }

    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemBuilder: (context, index) {
        final title = data[index]['title'] ?? 'No Title';
        final description = data[index]['description'] ?? 'No Description';
        final customRouteId = data[index]['custom_route_id'];

        return Padding(
          padding: EdgeInsets.only(
            bottom: 18.0, // Space between items
            top: index == 0 ? 18.0 : 0.0, // Add margin only to the first item
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey[300]!, width: 0.5),
            ),
            child: Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              margin: EdgeInsets.zero,
              child: ExpansionTile(
                key: UniqueKey(),
                title: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(description,
                    style: TextStyle(color: Colors.grey[600])),
                initiallyExpanded: expandedIndex == index,
                onExpansionChanged: (isExpanded) {
                  setState(() {
                    expandedIndex = isExpanded ? index : null;
                    if (isExpanded && customRouteId != null) {
                      log('Opening ExpansionTile for customRouteId: $customRouteId');
                      _fetchRouteDetails(index, customRouteId);
                    } else if (customRouteId == null) {
                      log('customRouteId is null for index $index');
                    }
                  });
                },
                children: [
                  if (routeDetails.containsKey(index) &&
                      routeDetails[index]!.isNotEmpty)
                    ...routeDetails[index]!.map((itinerary) {
                      final data = jsonDecode(itinerary['data'] ?? '{}');
                      return MyRouteCard(index: index, itinerary: data);
                    }).toList()
                  else if (routeDetails.containsKey(index) &&
                      routeDetails[index]!.isEmpty)
                    const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('세부 경로 정보가 없습니다.',
                            style: TextStyle(color: Colors.grey)))
                  else
                    const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
