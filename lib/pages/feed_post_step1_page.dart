import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapsee/components/my_route_card.dart';
import 'package:mapsee/pages/feed_post_step2_page.dart';
import 'package:mapsee/utils/common.dart';

class FeedPostStep1Page extends StatefulWidget {
  const FeedPostStep1Page({super.key});

  @override
  State<FeedPostStep1Page> createState() => _FeedPostStep1PageState();
}

class _FeedPostStep1PageState extends State<FeedPostStep1Page> {
  List<Map<String, dynamic>> routes = [];
  Map<int, List<dynamic>> routeDetails = {};
  bool isLoading = true;
  int? expandedIndex; // 현재 열려 있는 ExpansionTile의 인덱스

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  Future<void> _fetchRoutes() async {
    try {
      String? userId = await getUserId();
      final url = '${dotenv.env["API_BASE_URL"]}/route/get/customRoutesByUserID?user_id=$userId';
      log('Fetching Routes with URL: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          routes = List<Map<String, dynamic>>.from(jsonResponse['routes']);
          isLoading = false;
        });
      } else {
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

  Future<void> _fetchRouteDetails(int index, int customRouteId) async {
    if (routeDetails.containsKey(index)) return;

    final url = '${dotenv.env["API_BASE_URL"]}/route/get/routesByCustomRouteID?custom_route_id=$customRouteId';
    log('Fetching Route Details with URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
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
          Expanded(child: _buildListView()),
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

    return ListView.builder(
      itemCount: routes.length,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemBuilder: (context, index) {
        final title = routes[index]['title'] ?? 'No Title';
        final description = routes[index]['description'] ?? 'No Description';
        final customRouteId = routes[index]['custom_route_id'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 18.0), // 토글 사이 간격을 늘리려면 이 값을 조정하세요
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
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  description,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                initiallyExpanded: expandedIndex == index,
                onExpansionChanged: (isExpanded) {
                  setState(() {
                    expandedIndex = isExpanded ? index : null;
                    if (isExpanded) {
                      _fetchRouteDetails(index, customRouteId);
                    }
                  });
                },
                children: [
                  if (routeDetails.containsKey(index) && routeDetails[index]!.isNotEmpty)
                    ...routeDetails[index]!.map((itinerary) {
                      final data = jsonDecode(itinerary['data'] ?? '{}');
                      return MyRouteCard(
                        index: index,
                        itinerary: data,
                      );
                    }).toList()
                  else if (routeDetails.containsKey(index) && routeDetails[index]!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('세부 경로 정보가 없습니다.', style: TextStyle(color: Colors.grey)),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedPostStep2Page(customRoute: routes[index]),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          '선택',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}