import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyRouteTabModal(),
      ),
    );
  }
}

class MyRouteTabModal extends StatefulWidget {
  const MyRouteTabModal({super.key});

  @override
  _MyRouteTabModalState createState() => _MyRouteTabModalState();
}

class _MyRouteTabModalState extends State<MyRouteTabModal> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.1,
      maxChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: _buildListView(scrollController),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(ScrollController scrollController) {
    if (dummyProfileData1.isEmpty) {
      return Center(
        child: Text(
          '아직 데이터가 없습니다!',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      controller: scrollController,
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
              selectedIndex = index;
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
];
