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
            Image.asset(
              feedData['image_url'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
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