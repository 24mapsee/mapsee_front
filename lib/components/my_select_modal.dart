import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth import

class MySelectModal extends StatefulWidget {
  const MySelectModal({super.key});

  @override
  State<MySelectModal> createState() => _MySelectModalState();
}

class _MySelectModalState extends State<MySelectModal> {
  int? selectedIndex;
  final TextEditingController _archiveNameController = TextEditingController();
  List<Map<String, dynamic>> folderData = [];
  String? userId; // 로그인된 유저의 UID 저장

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFolders(); // 유저 ID를 불러온 후 폴더 데이터 가져오기
  }

  // 로그인된 유저의 UID 불러오기
  Future<void> _loadUserIdAndFolders() async {
    userId = await getUserId();

    // userId를 터미널에 출력하여 확인
    print("현재 로그인된 유저 UID: $userId");

    if (userId != null) {
      _getFolders();
    }
  }

  // FirebaseAuth를 통해 유저의 UID 가져오는 함수
  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // 폴더 데이터 가져오기
  Future<void> _getFolders() async {
    final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/get-folders?uid=$userId');
    print("Requesting folders with UID: $userId");

    try {
      final response = await http.get(url); // GET 요청 사용

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          folderData = List<Map<String, dynamic>>.from(responseData['folders']);
        });
      } else {
        print("Error: ${response.reasonPhrase}");
        throw Exception('Failed to load folders');
      }
    } catch (error) {
      print('Error fetching folders: $error');
    }
  }

  // 새로운 폴더 생성
  Future<void> _createFolder(String folderName) async {
    final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/create-folder');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId, // 현재 로그인된 유저의 UID 전달
          "folder_name": folderName,
        }),
      );

      if (response.statusCode == 201) {
        print("Folder created successfully");
        Navigator.pop(context);
        _archiveNameController.clear();
        _getFolders(); // 폴더 목록 새로고침
      } else {
        throw Exception('Failed to create folder');
      }
    } catch (error) {
      print('Error creating folder: $error');
    }
  }

  void _confirmSelection() {
    if (selectedIndex != null) {
      final selectedItem = folderData[selectedIndex!];
      print('선택된 아이템: ${selectedItem['folder_name']}');
      Navigator.pop(context, selectedItem);
    }
  }

  void _buildNewArchive() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25, // 높이 줄이기
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 여백 줄이기
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "새 저장소",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 12), // 여백 줄이기
                TextField(
                  controller: _archiveNameController,
                  decoration: InputDecoration(
                    labelText: "저장소 이름",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 12), // 여백 줄이기
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_archiveNameController.text.isNotEmpty) {
                        _createFolder(_archiveNameController.text);
                      }
                    },
                    child: Text("저장"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: [
          Container(
            height: screenHeight * 0.4,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    CloseButton(),
                    Expanded(
                      child: Center(
                        child: Text(
                          "저장 목록",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _buildNewArchive,
                      child: Image.asset(
                        'assets/images/png/add.png',
                        width: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Expanded(
                  child: _buildListView(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 16,
            child: SizedBox(
              height: screenHeight * 0.035,
              child: FloatingActionButton(
                onPressed: _confirmSelection,
                child: Text('선택'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    if (folderData.isEmpty) {
      return Center(
        child: Text(
          '아직 데이터가 없습니다!',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      itemCount: folderData.length,
      itemBuilder: (context, index) {
        final folderName =
            folderData[index]['folder_name'] ?? '아카이브 없음';
        final description = folderData[index]['description'];

        return ListTile(
          leading: Icon(Icons.favorite, color: Colors.pink),
          title: Text(folderName),
          subtitle: description != null
              ? Text(
            '$description',
            style: TextStyle(color: Colors.grey[700]),
          )
              : null,
          trailing:
          folderData[index]['locked'] ? Icon(Icons.lock) : null,
          selected: selectedIndex == index,
          selectedTileColor: Colors.blue[100],
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
        );
      },
    );
  }
}