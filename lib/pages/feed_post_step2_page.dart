import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picker
import 'package:mapsee/components/my_route_card.dart';
import 'package:mapsee/pages/feed_page.dart';
import 'package:mapsee/utils/common.dart';
import 'package:path/path.dart'; // To get file name

class FeedPostStep2Page extends StatefulWidget {
  final Map<String, dynamic> customRoute;

  const FeedPostStep2Page({super.key, required this.customRoute});

  @override
  State<FeedPostStep2Page> createState() => _FeedPostStep2PageState();
}

class _FeedPostStep2PageState extends State<FeedPostStep2Page> {
  int? expandedIndex; // 현재 확장된 인덱스 추적
  List<dynamic>? _itineraries;
  bool _isLoading = false;
  List<TextEditingController> _textControllers = []; // 텍스트 컨트롤러 배열
  List<String> _textFieldValues = []; // 각 텍스트 필드의 값을 저장하는 배열
  TextEditingController _titleController = TextEditingController(); // 제목 컨트롤러
  File? _selectedImage; // 이미지 파일

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
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log("[성공] 데이터 패치");

        setState(() {
          _itineraries = data["routes"];
          _isLoading = false;
          // 텍스트 컨트롤러 배열 초기화
          _textControllers = List.generate(
              _itineraries!.length, (index) => TextEditingController());
          _textFieldValues = List.generate(_itineraries!.length, (index) => '');
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

  // 피드 데이터 전송 (멀티파트 폼 데이터 방식으로 이미지 포함)
  Future<void> postFeedData(context) async {
    setState(() {
      _isLoading = true;
    });

    String? userId = await getUserId();
    final url = '${dotenv.env["API_BASE_URL"]}/feed/share';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['user_id'] = userId!;
    request.fields['route_id'] =
        widget.customRoute["custom_route_id"].toString();
    request.fields['title'] = _titleController.text;
    request.fields['description'] = jsonEncode(_textFieldValues);
    request.fields['image_url'] = _selectedImage!.path;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _selectedImage!.path,
        filename: basename(_selectedImage!.path),
      ));
    }

    try {
      log("[시작] 피드 게시하기");
      log(request.fields.toString());
      // debugPrint(request.files.);

      var response = await request.send();
      if (response.statusCode == 201) {
        log("[성공] 데이터 게시");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FeedPage(),
          ),
        );

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          log("[실패] 데이터 게시${response.statusCode}");
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        log("[오류] 데이터 게시 ${e.toString()}");
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    _titleController.dispose();
    super.dispose();
  }

  // 이미지 선택 함수
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitPost(context) {
    postFeedData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "피드 내용 작성",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                _submitPost(context);
              },
              child: const Text(
                '게시하기',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Stack(children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '제목을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
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
                            final itinerary = _itineraries![index]['data'];
                            return Column(
                              children: [
                                MyRouteCard(
                                  index: index,
                                  itinerary: itinerary,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    controller: _textControllers[index],
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '내용 입력...',
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _textFieldValues[index] = value;
                                      });
                                    },
                                  ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("사진 추가하기"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(
                  _selectedImage!,
                  height: 100,
                ),
              ),
          ])
        ]));
  }
}
