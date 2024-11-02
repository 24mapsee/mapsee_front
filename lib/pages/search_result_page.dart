import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:mapsee/components/my_itinerariy_result_card.dart';
import 'package:mapsee/components/my_public_trans_button.dart';
import 'package:mapsee/components/my_search_bar_route_place.dart';
import 'package:mapsee/components/my_vertical_divider.dart';
import 'package:mapsee/utils/common.dart';

class SearchResultPage extends StatefulWidget {
  final Map<String, dynamic> selectedDeparture;
  final Map<String, dynamic> selectedDestination;

  const SearchResultPage({
    super.key,
    this.selectedDeparture = const {},
    this.selectedDestination = const {},
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
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

class _SearchResultPageState extends State<SearchResultPage> {
  final TextEditingController _departureSearchController =
      TextEditingController();
  final TextEditingController _destinationSearchController =
      TextEditingController();

  Map<String, dynamic> _selectedDeparture = {};
  Map<String, dynamic> _selectedDestination = {};
  List<dynamic>? _itineraries;
  Map<String, dynamic>? _requestParameters;

  final List<RouteItem> _addedItineraries = [];
  bool _isLoading = false;

  // 경로 데이터 가져오기
  Future<void> fetchRouteData() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> json_data = {
      'startX': (_selectedDeparture['mapx']),
      'startY': (_selectedDeparture['mapy']),
      'endX': (_selectedDestination['mapx']),
      'endY': (_selectedDestination['mapy']),
      'count': 10,
      'lang': 0,
      'format': 'json'
    };

    String url = '${dotenv.env["API_BASE_URL"]}/map/route/publictransport';
    try {
      log("[시작] 경로 가져오기");
      log(jsonEncode(json_data));
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(json_data));
      // log(response.body.toString());
      // 데이터 성공
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log("[성공] 데이터 패치");

        setState(() {
          _itineraries = data['metaData']['plan']['itineraries'];
          _requestParameters = data['metaData']['requestParameters'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _itineraries = [];
          _requestParameters = {};
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _itineraries = [];
        _requestParameters = {};
        _isLoading = false;
        log("[오류] 데이터 패치 ${e.toString()}");
      });
    }
  }

  // 장바구니 아이템 삭제
  void _removeItinerary(int index) {
    setState(() {
      _addedItineraries.removeAt(index); // Remove the selected itinerary
    });
  }

  // 장바구니에 아이템 추가
  void _addItinerary(int index, dynamic itinerary) {
    var route = RouteItem(
      startX: double.parse(_requestParameters!['startX'].toString()),
      startY: double.parse(_requestParameters!['startY'].toString()),
      endX: double.parse(_requestParameters!['endX'].toString()),
      endY: double.parse(_requestParameters!['endY'].toString()),
      startName: removeHtmlTags(_selectedDeparture["title"]),
      endName: removeHtmlTags(_selectedDestination["title"]),
      data: itinerary, // dynamic 타입의 리스트
    );

    setState(() {
      log("경로 추가: ${itinerary['totalTime']}");
      if (itinerary != null) {
        _addedItineraries.add(route);
      }
    });
  }

  // 데이터 저장 함수
  Future<void> saveData(String title, String description) async {
    String? userId = await getUserId();
    // 서버에 POST 요청 보낼 데이터 구성
    List<Map<String, dynamic>> stringifiedItineraries =
        _addedItineraries.map((item) {
      return {
        "startX": item.startX,
        "startY": item.startY,
        "endX": item.endX,
        "endY": item.endY,
        "startName": item.startName,
        "endName": item.endName,
        "data": jsonEncode(item.data)
      };
    }).toList();

    Map<String, dynamic> postData = {
      "title": title,
      "description": description,
      "user_id": userId,
      "routes": stringifiedItineraries
    };

    String url = '${dotenv.env["API_BASE_URL"]}/route/create';
    log('[시작] 경로 저장 ${url}');
    // log(jsonEncode(postData).toString());
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(postData),
      );

      if (response.statusCode == 201) {
        log("[성공] 데이터 저장 완료");
        setState(() {
          _addedItineraries.clear(); // 장바구니 비우기
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("경로가 성공적으로 저장되었습니다.")),
          );
        }
      } else {
        log("[오류] 서버 응답 실패: ${response.statusCode} ${response.body}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("저장 중 오류가 발생했습니다.")),
          );
        }
      }
    } catch (e) {
      log("[오류] 서버 요청 실패: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("저장 중 오류가 발생했습니다.")),
        );
      }
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
                  saveData(title, description);
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
    double screenHeight = MediaQuery.of(context).size.height;

    // 출도착지 검증함수
    void checkAndFetchRouteData() {
      // 출도착지 모두 있어야 유효성 검사 통과
      if (_selectedDeparture.isNotEmpty && _selectedDestination.isNotEmpty) {
        fetchRouteData();
      }
    }

    // 출도착지 Swap
    void exchangeText() {
      setState(() {
        String temp = _departureSearchController.text;
        _departureSearchController.text = _destinationSearchController.text;
        _destinationSearchController.text = temp;

        Map<String, dynamic> temp2 = _selectedDeparture;
        _selectedDeparture = _selectedDestination;
        _selectedDestination = temp2;
      });
      checkAndFetchRouteData();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: screenHeight * 0.22,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: exchangeText,
                          icon: const Icon(
                            Icons.import_export,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SizedBox(
                                        height: screenHeight * 0.05,
                                        child: MySearchBarRoutePlace(
                                          controller:
                                              _departureSearchController,
                                          hintText: "출발지",
                                          onItemSelected: (Map<String, dynamic>
                                              selectedItem) {
                                            setState(() {
                                              _selectedDeparture = selectedItem;
                                              checkAndFetchRouteData();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    iconSize: 24,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SizedBox(
                                        height: screenHeight * 0.05,
                                        child: MySearchBarRoutePlace(
                                          controller:
                                              _destinationSearchController,
                                          hintText: "도착지",
                                          onItemSelected: (Map<String, dynamic>
                                              selectedItem) {
                                            setState(() {
                                              _selectedDestination =
                                                  selectedItem;
                                              checkAndFetchRouteData();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.white,
                                    ),
                                    iconSize: 24,
                                    onPressed: () {},
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    MyPublicTransButton(
                      onTap: () {},
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildTransportOption("전체", screenHeight),
                        const MyVerticalDivider(height: 0.02),
                        _buildTransportOption("버스", screenHeight),
                        const MyVerticalDivider(height: 0.02),
                        _buildTransportOption("지하철", screenHeight),
                        const MyVerticalDivider(height: 0.02),
                        _buildTransportOption("버스 + 지하철", screenHeight),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _itineraries != null && _itineraries!.isNotEmpty
                        ? ListView.separated(
                            itemCount: _itineraries!.length,
                            itemBuilder: (context, index) {
                              final itinerary = _itineraries![index];
                              return MyItineraryResultCard(
                                index: index,
                                itinerary: itinerary,
                                onAddItinerary: _addItinerary,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              color: Colors.grey[100],
                              thickness: 8,
                            ),
                          )
                        : const Center(
                            child: Text("검색 결과가 없습니다."),
                          ),
              ),
            ],
          ),
          if (_addedItineraries.isNotEmpty)
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 핸들
                      Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // 제목
                      const Text(
                        "내 장바구니",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 하단 여백
                      const SizedBox(height: 10),
                      // 장바구니 리스트
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: _addedItineraries.length,
                          itemBuilder: (context, index) {
                            final itinerary = _addedItineraries[index];
                            return Card(
                              child: ListTile(
                                title: Text('추가된 경로 ${index + 1}'),
                                subtitle: Text(
                                    '경로 정보: ${itinerary.startName} -> ${itinerary.endName}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _removeItinerary(index);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              log("경로 저장하기 버튼 클릭");
                              _addedItineraries.isNotEmpty
                                  ? showSaveDialog()
                                  : null;
                            },
                            child: const Text(
                              "경로 저장하기",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTransportOption(String label, double screenHeight) {
    return InkWell(
      onTap: () {
        log("$label 클릭");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        height: screenHeight * 0.03,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
