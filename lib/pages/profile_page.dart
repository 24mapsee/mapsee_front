import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/mapsee_logo.png', // 로고 이미지 경로
          height: 40, // 로고 크기
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // 타이틀 중앙 정렬
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20), // 위쪽 여백
            // 프로필 이미지 및 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40, // 프로필 이미지 크기
                  backgroundImage: AssetImage('assets/images/profile_picture.png'), // 프로필 이미지 경로
                ),
                SizedBox(width: 20), // 이미지와 텍스트 사이 간격
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '구슬이',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('@cherror'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20), // 프로필 이미지 아래 여백
            // 게시물, 팔로워, 팔로잉 정보
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '56',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('저장소'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '27',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('찜'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '472',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('팔로워'),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '486',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('팔로잉'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // 정보와 버튼 사이 여백
            // 정보 수정 및 공유 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 내 정보 수정 버튼 동작
                  },
                  child: Text('내 정보 수정'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // 내 프로필 공유 버튼 동작
                  },
                  child: Text('내 프로필 공유'),
                ),
              ],
            ),
            SizedBox(height: 20), // 버튼 아래 여백
            Divider(), // 구분선
            // 피드 리스트 (예시로 더미 데이터 사용)
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.pink),
              title: Text('데이트 코스'),
              subtitle: Text('김현진님과 함께'),
              trailing: Icon(Icons.lock),
            ),
            ListTile(
              leading: Icon(Icons.star, color: Colors.green),
              title: Text('고독한 미식가'),
              subtitle: Text('910개의 장소'),
            ),
            ListTile(
              leading: Icon(Icons.group, color: Colors.yellow),
              title: Text('동아리 정기 모임 장소'),
              subtitle: Text('27개의 장소'),
            ),
            ListTile(
              leading: Icon(Icons.fitness_center, color: Colors.orange),
              title: Text('클라이밍'),
              subtitle: Text('45개의 장소'),
            ),
            ListTile(
              leading: Icon(Icons.nature, color: Colors.green),
              title: Text('강릉 초당길 맛집 투어'),
              subtitle: Text('6개의 장소'),
            ),
            ListTile(
              leading: Icon(Icons.place, color: Colors.blue),
              title: Text('경주 가볼 곳'),
              subtitle: Text('18개의 장소'),
              trailing: Icon(Icons.lock),
            ),
          ],
        ),
      ),
    );
  }
}