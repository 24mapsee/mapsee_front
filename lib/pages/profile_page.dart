import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

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
      ),
      body: Column(
        children: [
          SizedBox(height: 20), // 위쪽 여백
          // 프로필 이미지 및 정보
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40, // 프로필 이미지 크기
                backgroundImage: AssetImage('assets/images/dummy/katt.png'), // 프로필 이미지 경로
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200], // 연한 회색 배경색
                  foregroundColor: Colors.black, // 검은색 글씨
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 6), // 버튼 패딩
                ),
                child: Text('내 정보 수정'),
              ),
              SizedBox(width: 10), // 버튼 사이 간격
              ElevatedButton(
                onPressed: () {
                  // 내 프로필 공유 버튼 동작
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200], // 연한 회색 배경색
                  foregroundColor: Colors.black, // 검은색 글씨
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 6), // 버튼 패딩
                ),
                child: Text('내 프로필 공유'),
              ),
            ],
          ),
          SizedBox(height: 10,),
          // 탭바
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: Image.asset(
                  'assets/images/png/marker.png', // 사용자 아이콘 1
                  height: 25,
                ),
              ),
              Tab(
                icon: Image.asset(
                  'assets/images/png/route.png', // 사용자 아이콘 2
                  height: 28,
                ),
              ),
              Tab(
                icon: Image.asset(
                  'assets/images/png/filled_heart.png', // 사용자 아이콘 3
                  height: 25,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(dummyProfileData1), // 첫 번째 탭에 대한 리스트뷰
                _buildListView(dummyProfileData2), // 두 번째 탭에 대한 리스트뷰
                _buildListView(dummyProfileData3), // 세 번째 탭에 대한 리스트뷰
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 리스트뷰 빌드 메서드
  Widget _buildListView(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          '아직 데이터가 없습니다!',
          style: TextStyle(color: Colors.grey, fontSize: 16), // 회색 텍스트 스타일
        ),
      );
    }
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.favorite, color: Colors.pink),
          title: Text(data[index]['title']),
          subtitle: Text(data[index]['subtitle']),
          trailing: data[index]['locked'] ? Icon(Icons.lock) : null,
        );
      },
    );
  }
}

// 더미 데이터들
List<Map<String, dynamic>> dummyProfileData1 = [
  {"title": "데이트 코스", "subtitle": "김현진님과 함께", "locked": true},
  {"title": "고독한 미식가", "subtitle": "910개의 장소", "locked": false},
  {"title": "동아리 정기 모임 장소", "subtitle": "27개의 장소", "locked": false},
  {"title": "클라이밍", "subtitle": "45개의 장소", "locked": false},
];

List<Map<String, dynamic>> dummyProfileData2 = [
  {"title": "강릉 초당길 맛집 투어", "subtitle": "6개의 장소", "locked": false},
  {"title": "경주 가볼 곳", "subtitle": "18개의 장소", "locked": true},
];

List<Map<String, dynamic>> dummyProfileData3 = [

];

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}