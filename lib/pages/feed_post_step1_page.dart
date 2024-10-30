import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:mapsee/pages/feed_post_step2_page.dart';
import 'package:mapsee/utils/common.dart';

class FeedPostStep1Page extends StatefulWidget {
  @override
  State<FeedPostStep1Page> createState() => _FeedPostStep1PageState();
}

class _FeedPostStep1PageState extends State<FeedPostStep1Page>
    with TickerProviderStateMixin {
  List<OptionItem> options = [];
  int? expandedIndex; // 현재 확장된 인덱스 추적
  int? selectedIndex;
  List<Map<String, dynamic>> routes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  Future<void> _fetchRoutes() async {
    try {
      String? userId = await getUserId();
      final url =
          '${dotenv.env["API_BASE_URL"]}/route/get/customRoutesByUserID?user_id=$userId';
      final response = await http.get(Uri.parse(url));
      log(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          routes = List<Map<String, dynamic>>.from(jsonResponse['routes']);
          isLoading = false;
        });
      } else {
        // Handle error
        log('Failed to load routes');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching routes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadCustomRoutesData(List<Map<String, String>> data) {
    setState(() {
      options = data
          .map((item) => OptionItem(item['title']!, item['description']!))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "경로를 선택해 주세요",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildListView()), // Use Expanded to constrain ListView
          // ListView.builder(
          //   itemCount: options.length,
          //   itemBuilder: (context, index) {
          //     return AnimatedSize(
          //       duration: Duration(milliseconds: 300),
          //       curve: Curves.easeInOut,
          //       child: ExpansionTile(
          //         key: UniqueKey(),
          //         title: Text(options[index].title),
          //         initiallyExpanded: expandedIndex == index,
          //         trailing: RotationTransition(
          //           turns: expandedIndex == index
          //               ? AlwaysStoppedAnimation(0.5)
          //               : AlwaysStoppedAnimation(0.0),
          //           child: Icon(Icons.expand_more),
          //         ),
          //         onExpansionChanged: (isExpanded) {
          //           setState(() {
          //             expandedIndex = isExpanded ? index : null;
          //           });
          //         },
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //             child: Text(
          //               options[index].description,
          //               style: TextStyle(color: Colors.grey[600]),
          //             ),
          //           ),
          //           SizedBox(height: 10),
          //           Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //             child: ElevatedButton(
          //               onPressed: () {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => PostPage(
          //                         selectedOption: options[index].title),
          //                   ),
          //                 );
          //               },
          //               child: Text('선택'),
          //               style: ElevatedButton.styleFrom(
          //                 minimumSize: Size(double.infinity, 40),
          //               ),
          //             ),
          //           ),
          //           SizedBox(height: 10),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    if (routes.isEmpty) {
      return const Center(
        child: Text(
          '저장된 경로 데이터가 없습니다!',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemCount: routes.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.white,
          thickness: 16,
        ),
        itemBuilder: (context, index) {
          final title = routes[index]['title'] ?? 'No Title';
          final description = routes[index]['description'] ?? 'No Description';

          return Container(
            color: Colors.grey[100],
            child: ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: Text(title),
              subtitle: Text(description),
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FeedPostStep2Page(customRoute: routes[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 옵션 데이터 모델 클래스
class OptionItem {
  final String title;
  final String description;

  OptionItem(this.title, this.description);
}

// 더미 데이터
List<Map<String, String>> Custom_Routes = [
  {"title": "부산가는 방법 공유합니다", "description": "대충 내용"},
  {"title": "국민대로 이코", "description": "국민대 가기 진심 햄들다"},
  {"title": "한초희의 투썸 가는 길 룰루", "description": "내일 또 알바 가야 됨"},
  {"title": "추가된 경로", "description": "추가된 설명"},
  {"title": "추가된 경로예욤", "description": "추가된 설명"},
];
