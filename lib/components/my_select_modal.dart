import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySelectModal extends StatefulWidget {
  const MySelectModal({super.key});

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
    print("Requesting folders with UID: $userId");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"uid": userId}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          folderData = List<Map<String, dynamic>>.from(responseData['folders']);
        });
        // Log folder data to console for verification
        print("Fetched folders: $folderData");
      } else {
        print("Error: ${response.reasonPhrase}");
        throw Exception('Failed to load folders');
      }
    } catch (error) {
      print('Error fetching folders: $error');
    }
  }

  void _confirmSelection() {
    if (selectedIndex != null) {
      final selectedItem = folderData[selectedIndex!];
      print('Selected item: ${selectedItem['folder_name']}');
      Navigator.pop(context, selectedItem);
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
                          "보관함을 선택하세요    ",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _buildNewArchive,
                      child: Icon(
                        Icons.add,
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

  // Folder creation logic
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
        _getFolders(); // Refresh folder list
      } else {
        throw Exception('Failed to create folder');
      }
    } catch (error) {
      print('Error creating folder: $error');
    }
  }
}