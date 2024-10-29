import 'package:flutter/material.dart';

class MySelectModal extends StatefulWidget {
  const MySelectModal({super.key});

  @override
  State<MySelectModal> createState() => _MySelectModalState();
}

class _MySelectModalState extends State<MySelectModal> {
  int? selectedIndex;

  void _confirmSelection() {
    if (selectedIndex != null) {
      final selectedItem = dummyProfileData1[selectedIndex!];
      print('선택된 아이템: ${selectedItem['archive_name']}');
      Navigator.pop(context, selectedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CloseButton(),
                    Expanded(
                      child: Center(
                        child: Text(
                          "저장 목록",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 새 저장 목록 만들기
                      },
                      child: Image.asset(
                        'assets/images/png/add.png',
                        width: 25,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: _buildListView(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: SizedBox(
              height: screenHeight * 0.04,
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
    if (dummyProfileData1.isEmpty) {
      return Center(
        child: Text(
          '아직 데이터가 없습니다!',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      itemCount: dummyProfileData1.length,
      itemBuilder: (context, index) {
        final archiveName =
            dummyProfileData1[index]['archive_name'] ?? '아카이브 없음';
        final collaboratorName = dummyProfileData1[index]['collaborator_name'];

        return ListTile(
          leading: Icon(Icons.favorite, color: Colors.pink),
          title: Text(archiveName),
          subtitle: collaboratorName != null
              ? Text(
                  '${collaboratorName} 님과 함께',
                  style: TextStyle(color: Colors.grey[700]),
                )
              : null,
          trailing:
              dummyProfileData1[index]['locked'] ? Icon(Icons.lock) : null,
          selected: selectedIndex == index,
          selectedTileColor: Colors.blue[100],
          onTap: () {
            setState(() {
              selectedIndex = index; // 선택된 인덱스 저장
            });
          },
        );
      },
    );
  }
}

List<Map<String, dynamic>> dummyProfileData1 = [
  {"archive_name": "데이트 코스", "collaborator_name": "김현진", "locked": true},
  {"archive_name": "고독한 미식가", "collaborator_name": null, "locked": false},
  {"archive_name": "동아리 정기 모임 장소", "collaborator_name": "민수", "locked": false},
  {"archive_name": "클라이밍", "collaborator_name": null, "locked": false},
  {"archive_name": "동아리 정기 모임 장소", "collaborator_name": "민수", "locked": false},
  {"archive_name": "클라이밍", "collaborator_name": null, "locked": false},
  {"archive_name": "동아리 정기 모임 장소", "collaborator_name": "민수", "locked": false},
  {"archive_name": "클라이밍", "collaborator_name": null, "locked": false},
];
