import 'package:flutter/material.dart';
import 'package:mapsee/pages/select_page.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String selectedFilter = '팔로워만 보기';
  final List<String> filterOptions = ['팔로워만 보기', '전체 보기', '현재 지역 보기'];
  List<dynamic> feedData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFeedData();
  }

  Future<void> fetchFeedData() async {
    setState(() {
      feedData = dummyFeedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/mapsee_logo.png',
          height: 40,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Container(
              width: 132,
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedFilter,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  items: filterOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
        itemCount: feedData.length,
        itemBuilder: (context, index) {
          return FeedItem(feedData: feedData[index]);
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Color(0xFFE5E5E5),
            thickness: 0.7,
            indent: 15,
            endIndent: 15,
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
            leading: Container(
              padding: EdgeInsets.all(2), // 테두리 두께 조절
              decoration: BoxDecoration(
                color: Colors.white, // 배경색
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline, // 테두리 색상
                  width: 1.2, // 테두리 두께
                ),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(feedData['user_image'] ?? 'assets/images/dummy/katt.png'),
                radius: 20, // CircleAvatar 크기
              ),
            ),
            title: Text(
              feedData['user_id'].toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            subtitle: Text(
              feedData['created_at'] ?? '시간 정보 없음',
              style: TextStyle(
                color: Color(0xFF606060),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
              ),
            ), // 게시 시간
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                feedData['image_url'],
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 4.0),
            child: Text(
              feedData['title'] ?? '제목 없음', // 제목
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 4.0, bottom: 12.0),
            child: Text(
              feedData['description'] ?? '설명 없음', // 설명
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                color: Color(0xff9d9d9d),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 더미 데이터
List<Map<String, dynamic>> dummyFeedData = [
  {
    "feed_id": 1,
    "user_id": "구슬이",
    "place_id": 201,
    "route_id": 301,
    "title": "부산 여행 2일차!",
    "description": "부산 서면역과 전포역 부근 맛집 위주의 찐 리얼후기!",
    "image_url": "assets/images/dummy/dummy1.jpg",
    "created_at": "1분 전",
    "user_image": "assets/images/dummy/katt.png"
  },
  {
    "feed_id": 2,
    "user_id": "웅성은성",
    "place_id": 202,
    "route_id": 302,
    "title": "국민대생 필수 루트",
    "description": "국민대에서 양주 예비군 훈련소 가는 지름길 노하우",
    "image_url": "assets/images/dummy/dummy2.jpg",
    "created_at": "6시간 전",
    "user_image": "assets/images/dummy/katt.png"
  },
  // 추가 더미 데이터 ...
];
