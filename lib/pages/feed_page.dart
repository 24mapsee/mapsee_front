import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/common.dart';
import 'package:mapsee/pages/feed_post_step1_page.dart';
import 'package:mapsee/pages/post_detail_page.dart';
import 'package:mapsee/pages/external_profile_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapsee/pages/profile_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String? loginUserId;
  String selectedFilter = '전체 보기';
  final List<String> filterOptions = ['전체 보기', '팔로잉만 보기'];
  List<dynamic> feedData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    final id = await getUserId();
    setState(() {
      loginUserId = id;
    });
    fetchFeedsData();
  }

  Future<void> fetchFeedsData() async {
    if (loginUserId == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final followingOnly = selectedFilter == '팔로잉만 보기';
      print("Sending user_id: $loginUserId");
      print("Following Only Option: $followingOnly");
      final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/feed/get-feed');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': loginUserId,
          'followingOnly': followingOnly,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('Response body: $responseBody');

        setState(() {
          feedData = responseBody['feedItems'] ?? [];
          isLoading = false;
        });
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        throw Exception('Failed to load feed data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveFeed(String feedId) async {
    final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/feed/save-feed');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': loginUserId, 'feed_id': feedId}),
      );

      if (response.statusCode == 201) {
        print("Success to save post");
      } else {
        print('Failed to save post with status code: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (error) {
      print('Error saving post: $error');
    }
  }

  Future<void> deleteSavedFeed(String feedId) async {
    final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/feed/save-feed-del');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': loginUserId, 'feed_id': feedId}),
      );

      if (response.statusCode == 201) {
        print("Success to delete post");
      } else {
        print(
            'Failed to delete saved post with status code: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (error) {
      print('Error saving post: $error');
    }
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 132,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedFilter,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  items: filterOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                      fetchFeedsData();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FeedPostStep1Page()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: feedData.length,
              itemBuilder: (context, index) {
                return FeedItem(
                  feedData: feedData[index],
                  loginUserId: loginUserId,
                  onSave: saveFeed,
                  onDelete: deleteSavedFeed,
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Color(0xFFE5E5E5),
                  thickness: 0.7,
                  indent: 15,
                  endIndent: 15,
                );
              },
            ),
    );
  }
}

class FeedItem extends StatefulWidget {
  final Map<String, dynamic> feedData;
  final String? loginUserId;
  final Future<void> Function(String feedId) onSave;
  final Future<void> Function(String feedId) onDelete;

  const FeedItem({
    super.key,
    required this.feedData,
    required this.loginUserId,
    required this.onSave,
    required this.onDelete,
  });
  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    isLiked = widget.feedData['isLiked'] ?? false;
    likeCount = widget.feedData['likeCount'] ?? 0;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
    String feedId = widget.feedData['feed_id'].toString();

    if (isLiked) {
      widget.onSave(feedId);
    } else {
      widget.onDelete(feedId);
    }
  }

  void _navigateToPostDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(feedData: widget.feedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: GestureDetector(
              onTap: () {
                if (widget.loginUserId == widget.feedData['user_id']) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExternalProfilePage(
                          userId: widget.feedData['user_id']),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1.2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      widget.feedData['profile_picture'] ??
                          'assets/images/dummy/katt.png'),
                  radius: 20,
                ),
              ),
            ),
            title: GestureDetector(
              onTap: () {
                if (widget.loginUserId == widget.feedData['user_id']) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExternalProfilePage(
                          userId: widget.feedData['user_id']),
                    ),
                  );
                }
              },
              child: Text(
                widget.feedData['name']?.toString() ?? '사용자 이름 없음',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            subtitle: Text(
              widget.feedData['created_at'] ?? '시간 정보 없음',
              style: const TextStyle(
                color: Color(0xFF606060),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
              ),
            ),
          ),
          GestureDetector(
            onTap: _navigateToPostDetail,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.feedData['image_url'] ??
                          'https://via.placeholder.com/200',
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25.0, top: 4.0),
                  child: Text(
                    widget.feedData['title'] ?? '제목 없음',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25.0, top: 4.0),
                  child: Text(
                    jsonDecode(widget.feedData['description']).join(" ") ??
                        '설명 없음',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      color: Color(0xff9d9d9d),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$likeCount',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff9d9d9d),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
