import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySelectModal extends StatefulWidget {
  final String title;
  final String address;
  final String roadAddress;
  final double latitude;
  final double longitude;
  final String kakaoPlaceId;

  const MySelectModal({
    super.key,
    required this.title,
    required this.address,
    required this.roadAddress,
    required this.latitude,
    required this.longitude,
    required this.kakaoPlaceId,
  });

  @override
  State<MySelectModal> createState() => _MySelectModalState();
}

class _MySelectModalState extends State<MySelectModal> {
  int? selectedIndex;
  final TextEditingController _archiveNameController = TextEditingController();
  List<Map<String, dynamic>> folderData = [];
  String? userId; // Logged-in user's UID

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFolders(); // Load user ID and then fetch folder data
  }

  // Get logged-in user's UID
  Future<void> _loadUserIdAndFolders() async {
    userId = await getUserId();

    print("Currently logged in user's UID: $userId");

    if (userId != null) {
      _getFolders();
    }
  }

  // Retrieve user UID via FirebaseAuth
  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Fetch folder data from API
  Future<void> _getFolders() async {
    final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/folder/getPlaceFolders');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"uid": userId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          folderData = List<Map<String, dynamic>>.from(responseData['folders']);
        });
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (error) {
      print('Error fetching folders: $error');
    }
  }

  // Function to save place information to the database
  Future<void> savePlaceToDatabase(int folderId) async {
    final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/folder/addPlaceToFolder');
    final jsonData = {
      "folder_id": folderId,
      "user_id": userId,
      "name": widget.title,
      "mapX": widget.latitude,
      "mapY": widget.longitude,
      "kakao_place_id": widget.kakaoPlaceId,
    };

    // 전송할 JSON 데이터를 출력
    print("Sending JSON data: $jsonData");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 201) {
        print("Place added to database successfully");
        Navigator.pop(context);
      } else {
        print("Failed to save place: ${response.statusCode}");
      }
    } catch (error) {
      print('Error saving place to database: $error');
    }
  }

  void _confirmSelection() {
    if (selectedIndex != null) {
      final selectedFolder = folderData[selectedIndex!];
      final folderId = selectedFolder['folder_id'];
      print('Selected folder: ${selectedFolder['folder_name']}');

      // Call savePlaceToDatabase with the selected folder ID
      savePlaceToDatabase(folderId);
    }
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
                          "보관함을 선택하세요 ",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _buildNewArchive, // 새 저장소 생성 함수 호출
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
                child: Text('저장'),
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
          '보관함이 없습니다!',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      itemCount: folderData.length,
      itemBuilder: (context, index) {
        final folderName = folderData[index]['folder_name'] ?? 'Unnamed Folder';
        final description = folderData[index]['description'];

        return ListTile(
          leading: Icon(Icons.folder, color: Colors.blue),
          title: Text(folderName),
          subtitle: description != null
              ? Text(
            '$description',
            style: TextStyle(color: Colors.grey[700]),
          )
              : null,
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

  void _buildNewArchive() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                SizedBox(height: 12),
                TextField(
                  controller: _archiveNameController,
                  decoration: InputDecoration(
                    labelText: "새 저장소 이름을 입력하세요.",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 12),
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

  Future<void> _createFolder(String folderName) async {
    final url = Uri.parse('${dotenv.env["API_BASE_URL"]}/folder/createFolder');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "folder_name": folderName,
        }),
      );

      if (response.statusCode == 201) {
        print("Folder created successfully");
        Navigator.pop(context);
        _archiveNameController.clear();
        _getFolders();
      } else {
        print('Failed to create folder');
      }
    } catch (error) {
      print('Error creating folder: $error');
    }
  }
}