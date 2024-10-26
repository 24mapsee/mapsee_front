import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mapsee/components/my_itinerariy_result_card.dart';
import 'package:mapsee/components/my_public_trans_button.dart';
import 'package:mapsee/components/my_search_bar_route_place.dart';
import 'package:mapsee/components/my_vertical_divider.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final TextEditingController _departureSearchController =
      TextEditingController();
  final TextEditingController _destinationSearchController =
      TextEditingController();

  String _selectedDeparture = '';
  String _selectedDestination = '';
  List<dynamic>? _itineraries;
  final List<dynamic> _addedItineraries = [];
  bool _isLoading = false;

  // 경로 데이터 가져오기
  Future<void> fetchRouteData() async {
    setState(() {
      _isLoading = true;
    });

    const String url =
        'http://default-test-deployment-21d4e-100106193-2d0c9fdd6415.kr.lb.naverncp.com/map/test-route';
    try {
      final response = await http.get(Uri.parse(url));

      // 데이터 성공
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log("[성공] 데이터 패치");

        setState(() {
          _itineraries = data['metaData']['plan']['itineraries'];
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

  // 장바구니 아이템 삭제
  void _removeItinerary(int index) {
    setState(() {
      _addedItineraries.removeAt(index); // Remove the selected itinerary
    });
  }

  // 장바구니에 아이템 추가
  void _addItinerary(int index, dynamic itinerary) {
    setState(() {
      log("경로 추가: ${itinerary['totalTime']}");
      if (itinerary != null) {
        _addedItineraries.add(itinerary);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // 출도착지 Swap
    void exchangeText() {
      setState(() {
        String temp = _departureSearchController.text;
        _departureSearchController.text = _destinationSearchController.text;
        _destinationSearchController.text = temp;
      });
    }

    // 출도착지 검증함수
    void checkAndFetchRouteData() {
      // 출도착지 모두 있어야 유효성 검사 통과
      if (_selectedDeparture.isNotEmpty && _selectedDestination.isNotEmpty) {
        fetchRouteData();
      }
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
                                          onItemSelected:
                                              (String selectedItem) {
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
                                          onItemSelected:
                                              (String selectedItem) {
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
                                subtitle:
                                    Text('경로 정보: ${itinerary['totalTime']}'),
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
