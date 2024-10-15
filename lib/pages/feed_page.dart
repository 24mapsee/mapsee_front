import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/mapsee_logo.png', // 로고 이미지 경로
          height: 40, // 이미지 크기 조정
        ),
        backgroundColor: Colors.white,
        elevation: 0,// 타이틀 중앙 정렬
      ),
      body: ListView.separated(
        itemCount: dummyFeedData.length, // 더미 데이터 개수
        itemBuilder: (context, index) {
          return FeedItem(feedData: dummyFeedData[index]); // 게시물 아이템 표시
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey, // 구분선 색상
            thickness: 1, // 구분선 두께
            indent: 12, // 왼쪽 여백
            endIndent: 12, // 오른쪽 여백
          );
        },
      ),
    );
  }
}

class FeedItem extends StatelessWidget {
  final Map<String, dynamic> feedData;
  FeedItem({required this.feedData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/user_icon.png'), // 사용자 아이콘
            ),
            title: Text(feedData['username']), // 사용자 이름
            subtitle: Text(feedData['timePosted']), // 게시 시간
            trailing: Icon(Icons.more_vert),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(feedData['postImage']), // 게시물 이미지
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              feedData['description'], // 게시물 설명
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// feed_page.dart 파일 내에 위치
List<Map<String, dynamic>> dummyFeedData = [
  {
    "username": "구슬이",
    "timePosted": "1분 전",
    "postImage": "assets/images/dummy/dummy1.jpg",
    "description": "부산 여행 2일차!"
  },
  {
    "username": "웅성은성",
    "timePosted": "6시간 전",
    "postImage": "assets/images/dummy/dummy2.jpg",
    "description": "국민대에서 양주 예비군 훈련소 가는 길"
  },
  {
    "username": "1004재인",
    "timePosted": "18시간 전",
    "postImage": "assets/images/dummy/dummy3.jpg",
    "description": "홍대가는 법? 뉴진스의 하입보이요"
  },
  {
    "username": "루미루미",
    "timePosted": "2일 전",
    "postImage": "assets/images/dummy/dummy4.jpg",
    "description": "국민대생이라면 알아야 하는 길음역 가는 최고의 방법"
  },
  {
    "username": "라춘식",
    "timePosted": "5일 전",
    "postImage": "assets/images/dummy/dummy5.jpg",
    "description": "카카오 본사 면접날 최고의 동선"
  },
  {
    "username": "최고심",
    "timePosted": "10일 전",
    "postImage": "assets/images/dummy/dummy6.jpg",
    "description": "서교동 고심 팝업 오는 길"
  },
  {
    "username": "아기돼지살구999",
    "timePosted": "13일 전",
    "postImage": "assets/images/dummy/dummy7.jpg",
    "description": "북한산 등반 후 바람난오리궁뎅이 추천하는 이유"
  },
];