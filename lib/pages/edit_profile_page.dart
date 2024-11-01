import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 수정', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // 추가된 부분
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  AssetImage('assets/images/dummy/katt.png'), // 프로필 이미지 경로
            ),
            SizedBox(height: 20),
            _buildEditableField('이름', '00'),
            _buildEditableField('아이디', '00'),
            _buildEditableField('휴대전화', '010 - 0000 - 0000'),
            _buildEditableField('생년월일', '0000 - 00 - 00'),
            _buildEditableField('성별', '성별 추가', isPlaceholder: true),
            _buildEditableField('연동 계정', '연동 추가', isPlaceholder: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 정보 수정 완료 로직
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary, // 테마에서 primary 색상 가져오기
                foregroundColor: Colors.white, // 글씨 색상 설정
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              ),
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String value,
      {bool isPlaceholder = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            style: TextStyle(
              color: isPlaceholder ? Colors.grey : Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
