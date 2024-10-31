import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mapsee/pages/feed_post_step1_page.dart';
import 'package:mapsee/pages/post_detail_page.dart';
import 'package:mapsee/pages/external_profile_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String selectedFilter = '팔로워만 보기';
  final List<String> filterOptions = ['팔로워만 보기', '전체 보기', '현재 지역 보기'];
  List<dynamic> feedData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFeedsData();
  }

  Future<void> fetchFeedsData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/feed/get-feed');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // 응답 내용을 출력하여 구조를 확인합니다.
        print('Response body: $responseBody');

        setState(() {
          feedData =
              responseBody['feedItems'] ?? []; // feedItems 키에 접근하여 데이터 추출
          isLoading = false;
        });
      } else {
        // 상태 코드 및 오류 메시지를 출력합니다.
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
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
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
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: feedData.length,
              itemBuilder: (context, index) {
                return FeedItem(feedData: feedData[index]);
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

class FeedItem extends StatelessWidget {
  final Map<String, dynamic> feedData;
  const FeedItem({super.key, required this.feedData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(feedData: feedData),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExternalProfilePage(
                        userId: feedData['user_id'],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1.2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(feedData['profile_picture'] ??
                        'assets/images/dummy/katt.png'),
                    radius: 20,
                  ),
                ),
              ),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExternalProfilePage(
                        userId: feedData['user_id'],
                      ),
                    ),
                  );
                },
                child: Text(
                  feedData['name']?.toString() ?? '사용자 이름 없음',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              subtitle: Text(
                feedData['created_at'] ?? '시간 정보 없음',
                style: const TextStyle(
                  color: Color(0xFF606060),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  feedData['image_url'] ??
                      'https://via.placeholder.com/200', // 이미지가 없을 경우 기본 이미지 URL로 대체
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 4.0),
              child: Text(
                feedData['title'] ?? '제목 없음',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 25.0, right: 25.0, top: 4.0, bottom: 12.0),
              child: Text(
                jsonDecode(feedData['description']).join(" ") ?? '설명 없음',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  color: Color(0xff9d9d9d),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
