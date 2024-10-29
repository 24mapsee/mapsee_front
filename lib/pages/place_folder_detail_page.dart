import 'package:flutter/material.dart';

class PlaceFolderDetailPage extends StatelessWidget {
  final String? title;
  final List<String> placeNames;

  const PlaceFolderDetailPage({Key? key, this.title, required this.placeNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '장소 상세 보기'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? '제목 없음',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: placeNames.length, // placeNames 리스트 길이만큼 항목 생성
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(placeNames[index]),
                    leading: Icon(Icons.location_on),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}