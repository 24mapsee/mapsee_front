import 'package:flutter/material.dart';

class PlaceFolderDetailPage extends StatelessWidget {
  final String? title;
  final List<String>? placeNames;
  final int? folderId; // folderId 추가

  const PlaceFolderDetailPage({
    Key? key,
    this.title,
    this.placeNames,
    this.folderId, // folderId를 받도록 생성자 수정
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '폴더 상세 보기'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              title ?? '폴더 이름 없음',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: placeNames?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(placeNames![index]),
                    leading: const Icon(Icons.location_on),
                  );
                },
              ),
            ),
            if (folderId != null)
              Text('폴더 ID: $folderId'), // folderId 디버깅 출력
          ],
        ),
      ),
    );
  }
}