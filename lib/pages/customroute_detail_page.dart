import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:mapsee/components/my_route_card.dart';
import 'package:mapsee/utils/common.dart';

class CustomRouteDetailPage extends StatefulWidget {
  final Map<String, dynamic> customRoute;

  const CustomRouteDetailPage({super.key, required this.customRoute});

  @override
  State<CustomRouteDetailPage> createState() => _CustomRouteDetailPageState();
}

class RouteItem {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final String startName;
  final String endName;
  final Map<String, dynamic> data;

  RouteItem({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.startName,
    required this.endName,
    required this.data,
  });
}

class _CustomRouteDetailPageState extends State<CustomRouteDetailPage> {
  List<dynamic>? _itineraries;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRouteData();
  }

  // 경로 데이터 가져오기
  Future<void> fetchRouteData() async {
    setState(() {
      _isLoading = true;
    });

    final url =
        '${dotenv.env["API_BASE_URL"]}/route/get/routesByCustomRouteID?custom_route_id=${widget.customRoute["custom_route_id"]}';
    log(url);
    try {
      log("[시작] 경로 가져오기");

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      // log(response.body.toString());
      // 데이터 성공
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log("[성공] 데이터 패치");

        setState(() {
          _itineraries = data["routes"];
          log(_itineraries.toString());
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

  // 제목과 설명을 입력받는 AlertDialog 띄우기
  Future<void> showSaveDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('경로 저장하기'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: '내용',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                final String title = titleController.text;
                final String description = descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  // saveData(title, description);
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("제목과 내용을 입력해주세요.")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text('${widget.customRoute['title']} 상세보기',
              style: const TextStyle(color: Colors.white)),
        ),
        body: Stack(children: [
          Column(children: [
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
                            return MyRouteCard(
                              index: index,
                              itinerary: itinerary,
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
          ])
        ]));
  }
}
