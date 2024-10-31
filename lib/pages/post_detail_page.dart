import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

import 'package:mapsee/components/my_route_card.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> feedData;

  const PostDetailPage({super.key, required this.feedData});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int? expandedIndex; // 현재 확장된 인덱스 추적
  List<dynamic>? _itineraries;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRouteData();
  }

  Future<void> fetchRouteData() async {
    setState(() {
      _isLoading = true;
    });

    final url =
        '${dotenv.env["API_BASE_URL"]}/route/get/routesByCustomRouteID?custom_route_id=${widget.feedData["route_id"]}';
    log(url);
    try {
      log("[시작] 경로 가져오기");

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log("[성공] 데이터 패치");

        setState(() {
          _itineraries = data["routes"];
          _isLoading = false;
        });
      } else {
        setState(() {
          _itineraries = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _itineraries = [];
        _isLoading = false;
        log("[오류] 데이터 패치 ${e.toString()}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List descList = jsonDecode(widget.feedData['description']);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feedData['title'] ?? '제목 없음'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.feedData['image_url'] ??
                      'https://via.placeholder.com/200', // 이미지가 없을 경우 기본 이미지 URL로 대체
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                )),
            const SizedBox(height: 16),
            Text(
              widget.feedData['title'] ?? '제목 없음',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Text(
            //   widget.feedData['description'],
            //   style: TextStyle(fontSize: 16),
            // ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _itineraries != null && _itineraries!.isNotEmpty
                      ? ListView.separated(
                          itemCount: _itineraries!.length,
                          itemBuilder: (context, index) {
                            final itinerary =
                                jsonDecode(_itineraries![index]['data']);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyRouteCard(
                                  index: index,
                                  itinerary: itinerary,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(descList[index],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(
                            color: Colors.grey[100],
                            thickness: 8,
                          ),
                        )
                      : const Center(
                          child: Text("검색 결과가 없습니다."),
                        ),
            ),
// MyRouteCard(index: index, itinerary: itinerary)
            // 필요한 다른 정보들도 표시 가능
          ],
        ),
      ),
    );
  }
}
