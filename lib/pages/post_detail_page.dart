import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final Map<String, dynamic> feedData;

  PostDetailPage({required this.feedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(feedData['title'] ?? '제목 없음'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              feedData['image_url'] ??
                  'https://via.placeholder.com/200', // 이미지가 없을 경우 기본 이미지 URL로 대체
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            SizedBox(height: 16),
            Text(
              feedData['title'] ?? '제목 없음',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              feedData['description'] ?? '설명 없음',
              style: TextStyle(fontSize: 16),
            ),
            // 필요한 다른 정보들도 표시 가능
          ],
        ),
      ),
    );
  }
}
