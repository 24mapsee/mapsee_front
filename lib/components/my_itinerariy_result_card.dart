import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapsee/pages/route_detail_test_page.dart';
import 'package:mapsee/utils/common.dart';

class MyItineraryResultCard extends StatelessWidget {
  final int index;
  final dynamic itinerary;
  final Function(int, dynamic) onAddItinerary;

  const MyItineraryResultCard({
    super.key,
    required this.index,
    required this.itinerary,
    required this.onAddItinerary,
  });

  // Text Span으로 반환
  List<TextSpan> genTimeSToHMTextSpan(int totalTimeInSeconds) {
    int hours = totalTimeInSeconds ~/ 3600;
    int minutes = (totalTimeInSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return [
        TextSpan(
          text: hours.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const TextSpan(
          text: "시간 ",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: minutes.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const TextSpan(
          text: "분",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        )
      ];
    } else {
      return [
        TextSpan(
          text: minutes.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const TextSpan(
            text: "분",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ))
      ];
    }
  }

  // 도보가 아닌 마지막 구간을 찾아 endName을 반환하는 함수
  String findLastNonWalkEndName(List<dynamic> legs) {
    for (int i = legs.length - 1; i >= 0; i--) {
      if (legs[i]['mode'] != 'WALK') {
        return legs[i]['end']['name'] ?? '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    String lastNonWalkEndName = findLastNonWalkEndName(itinerary['legs']);

    // 카드 전체 터치 감지
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RouteDetailTestPage(itinerary: itinerary),
          ),
        );
      },
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                children: [
                  TextSpan(
                    text: '경로 ${index + 1} | ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  ...genTimeSToHMTextSpan(itinerary['totalTime']),
                  TextSpan(
                    text: ' | ${itinerary['fare']['regular']['totalFare']}원',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              )),

              // 공백 추가
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Row(
                      children: itinerary['legs'].map<Widget>((leg) {
                        double ratio =
                            leg['sectionTime'] / itinerary['totalTime'];
                        return Expanded(
                          flex: (ratio * 100).toInt(),
                          child: Container(
                            height: 16,
                            color: getLegColor(leg),
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: itinerary['legs'].map<Widget>((leg) {
                        double ratio =
                            leg['sectionTime'] / itinerary['totalTime'];

                        // 비율이 0.1 이하이면 텍스트를 렌더링하지 않음 (겹침)
                        return Expanded(
                          flex: (ratio * 100).toInt(),
                          child: ratio > 0.1
                              ? Center(
                                  child: Text(
                                    '${(leg['sectionTime'] ~/ 60)}분',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                              : Container(),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // 디바이더 추가
              Divider(
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Colors.grey[200],
              ),

              // 경로 요약 생성, walk 모드는 유일할 경우 포함, 그렇지 않으면 제외
              ...itinerary['legs']
                  .where((leg) =>
                      leg['mode'] != 'WALK' || itinerary['legs'].length == 1)
                  .map<Widget>((leg) {
                int sectionTime = leg['sectionTime'];
                String formattedTime = formatTimeSToHM(sectionTime);
                String routeName = leg['route'] ?? '';
                String startName = leg['start']['name'] ?? '';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              getIcon(leg),
                              const SizedBox(width: 10),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: routeName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: getLegColor(leg),
                                  ),
                                ),
                                TextSpan(
                                  text: ' | $startName',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                )
                              ])),
                            ],
                          ),
                          Text(
                            formattedTime,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),

              if (lastNonWalkEndName.isNotEmpty)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.flag, color: Colors.grey),
                          const SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: '하차 | ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: lastNonWalkEndName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
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

              // 경로 담기 버튼
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // 로그 출력
                        log('경로가 담겼습니다: ${itinerary['totalTime']}');
                        onAddItinerary(index, itinerary);
                      },
                      child: const Text("이 경로 담기"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
