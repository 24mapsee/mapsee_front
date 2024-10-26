import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapsee/pages/route_detail_test_page.dart';

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

  // 초를 시간 분으로 변환
  String formatTimeSToHM(int totalTimeInSeconds) {
    int hours = totalTimeInSeconds ~/ 3600;
    int minutes = (totalTimeInSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return "$hours시간 $minutes분";
    } else {
      return "$minutes분";
    }
  }

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

  @override
  Widget build(BuildContext context) {
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
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              // Text(
              //   '경로 ${index + 1} | ${formatTimeSToHM(itinerary['totalTime'])}',
              //   style: const TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 10),

              // 경로 요약 생성, walk 모드는 유일할 경우 포함, 그렇지 않으면 제외
              ...itinerary['legs']
                  .where((leg) =>
                      leg['mode'] != 'WALK' || itinerary['legs'].length == 1)
                  .map<Widget>((leg) {
                String mode = leg['mode'];
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
                          Text(
                            '$mode | $routeName | $startName',
                            style: const TextStyle(fontSize: 14),
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

              // Expanded를 사용하여 버튼을 카드 너비에 맞춤
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
