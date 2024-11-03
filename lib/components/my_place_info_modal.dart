import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapsee/components/my_departure_and_arrival_buttons.dart';
import 'package:mapsee/components/my_gribber.dart';
import 'package:mapsee/components/my_select_modal.dart';
import 'package:mapsee/components/my_vertical_divider.dart';

class MyPlaceInfoModal extends StatefulWidget {
  final String title;
  final String category;
  final String address;
  final String roadAddress;
  final String link;
  final String telephone;
  final String mapx;
  final String mapy;
  final String kakaoPlaceId;
  final ScrollController? scrollController;

  const MyPlaceInfoModal({
    super.key,
    required this.title,
    required this.category,
    required this.address,
    required this.roadAddress,
    required this.link,
    required this.telephone,
    required this.mapx,
    required this.mapy,
    required this.kakaoPlaceId,
    this.scrollController,
  });

  @override
  State<MyPlaceInfoModal> createState() => _MyPlaceInfoModalState();
}

class _MyPlaceInfoModalState extends State<MyPlaceInfoModal> {
  bool isSaved = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  // 로그인된 사용자 ID 초기화
  Future<void> _initializeUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid;
    });
    if (userId != null) {
      checkIfPlaceSaved();
    }
  }

  // 장소 저장 여부 확인 함수
  Future<void> checkIfPlaceSaved() async {
    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/folder/checkIsPlaceSaved');
    try {
      print("Checking if place is saved with kakaoPlaceId: ${widget.kakaoPlaceId} and userId: $userId");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'kakao_place_id': widget.kakaoPlaceId,
          'user_id': userId,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          isSaved = data['is_saved'] ?? false;
        });
      } else {
        print("Failed to check if place is saved: ${response.body}");
      }
    } catch (error) {
      print("Error checking if place is saved: $error");
    }
  }

  // 장소 저장/삭제 기능
  // 장소 저장/삭제 기능
  Future<void> savePlace() async {
    if (!isSaved) {
      // 저장되지 않은 상태일 때 MySelectModal을 열어 폴더를 선택하게 함
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MySelectModal(
            title: widget.title,
            address: widget.address,
            roadAddress: widget.roadAddress,
            latitude: double.parse(widget.mapx),
            longitude: double.parse(widget.mapy),
            kakaoPlaceId: widget.kakaoPlaceId,
          );
        },
      ).then((_) {
        // 다이얼로그 닫힌 후 장소 저장 여부를 다시 확인하여 상태 업데이트
        checkIfPlaceSaved();
      });
    } else {
      // 이미 저장된 상태라면 삭제 요청
      await _deletePlaceFromFolder();
      await checkIfPlaceSaved(); // 상태 재확인하여 UI 업데이트
    }
  }

// 장소 삭제 기능
  Future<void> _deletePlaceFromFolder() async {
    final url = Uri.parse('${dotenv.env['API_BASE_URL']}/folder/deletePlaceFromFolder');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'kakao_place_id': widget.kakaoPlaceId,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isSaved = false;
        });
      } else {
        print("Failed to delete place: ${response.body}");
      }
    } catch (error) {
      print("Error deleting place: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              const MyGribber(),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  controller: widget.scrollController ?? scrollController,
                  children: <Widget>[
                    _buildTitleSection(),
                    _buildCategoryButtons(),
                    _buildInformationSection(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title.replaceFirst(' ', '\n'),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 32,
              color: Theme.of(context).colorScheme.onSurface,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.category.split('>').last,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black45,
              decoration: TextDecoration.none,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: savePlace,
                child: Image.asset(
                  isSaved
                      ? 'assets/images/png/filled_heart.png'
                      : 'assets/images/png/unfilled_heart.png',
                  color: Theme.of(context).colorScheme.secondary,
                  width: 30,
                ),
              ),
              Text(
                isSaved ? '저장 취소' : '저장하기',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          const MyVerticalDivider(height: 0.05),
          Column(
            children: [
              Image.asset(
                'assets/images/png/share.png',
                color: Theme.of(context).colorScheme.secondary,
                width: 30,
              ),
              Text(
                '공유하기',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.none,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow('assets/images/png/marker.png', widget.address,
              widget.roadAddress),
          _buildInfoRow('assets/images/png/clock.png', '정보 없음'),
          _buildInfoRow('assets/images/png/call.png', widget.telephone),
          _buildInfoRow('assets/images/png/world.png', widget.link),
          _buildInfoRow('assets/images/png/parking.png', '주차 가능'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String iconPath, String primaryText,
      [String? secondaryText]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryText.isNotEmpty ? primaryText : '제공하지 않음',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                    decoration: TextDecoration.none,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (secondaryText != null)
                  Text(
                    secondaryText.isNotEmpty ? secondaryText : '제공하지 않음',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                      decoration: TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}