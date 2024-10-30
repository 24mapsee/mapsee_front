import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapsee/utils/common.dart';

class MyRouteDetailCard extends StatelessWidget {
  final dynamic itinerary;

  const MyRouteDetailCard({
    super.key,
    required this.itinerary,
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
            fontSize: 30,
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
            fontSize: 30,
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
            fontSize: 30,
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
              const SizedBox(height: 6),
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
              ...itinerary['legs'].map<Widget>((leg) {
                int sectionTime = leg['sectionTime'];
                String formattedTime = formatTimeSToHM(sectionTime);
                String routeName = leg['route'] ?? '도보';
                String startName = leg['start']['name'] ?? '';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      // 기본적인 정보 (노선명 | 출발지)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              getIcon(leg),
                              const SizedBox(width: 4),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: routeName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: getLegColor(leg),
                                  ),
                                ),
                                TextSpan(
                                  text: ' | $startName',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                )
                              ])),
                            ],
                          ),
                          Text(
                            formattedTime,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // leg["mode"]에 따른 리스트 뷰 생성
                      ExpansionTile(
                          title: Text(
                            leg['mode'] == 'WALK'
                                ? '세부 경로 (도보)'
                                : '세부 경로 (대중교통)',
                            style: TextStyle(
                                fontSize: 16, color: getLegColor(leg)),
                          ),
                          children: [
                            if (leg['mode'] == 'WALK' && leg['steps'] != null)
                              Column(
                                children: leg['steps'].map<Widget>((step) {
                                  String distance = step['distance'].toString();
                                  String streetName =
                                      step['streetName'] ?? 'Unnamed Street';
                                  String description =
                                      step['description'] ?? 'No Description';
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: 6,
                                            height: 44,
                                            color: getLegColor(leg)),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            '$description $streetName',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[800]),
                                            // overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${distance}m',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )
                            else if (leg['mode'] != 'WALK' &&
                                leg['passStopList'] != null &&
                                leg['passStopList']['stationList'] != null)
                              Column(
                                children: leg['passStopList']['stationList']
                                    .map<Widget>((station) {
                                  String stationName = station['stationName'] ??
                                      'Unnamed Station';
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 6,
                                            height: 44,
                                            color: getLegColor(leg)),
                                        const SizedBox(width: 10),
                                        Text(
                                          stationName,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[800]),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                          ]),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
