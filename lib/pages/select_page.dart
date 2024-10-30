import 'package:flutter/material.dart';
import 'post_page.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> with TickerProviderStateMixin {
  List<OptionItem> options = [];
  int? expandedIndex; // 현재 확장된 인덱스 추적

  @override
  void initState() {
    super.initState();
    loadCustomRoutesData(Custom_Routes);
  }

  void loadCustomRoutesData(List<Map<String, String>> data) {
    setState(() {
      options = data.map((item) => OptionItem(item['title']!, item['description']!)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "경로를 선택해 주세요",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ExpansionTile(
              key: UniqueKey(),
              title: Text(options[index].title),
              initiallyExpanded: expandedIndex == index,
              trailing: RotationTransition(
                turns: expandedIndex == index
                    ? AlwaysStoppedAnimation(0.5)
                    : AlwaysStoppedAnimation(0.0),
                child: Icon(Icons.expand_more),
              ),
              onExpansionChanged: (isExpanded) {
                setState(() {
                  expandedIndex = isExpanded ? index : null;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    options[index].description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostPage(selectedOption: options[index].title),
                        ),
                      );
                    },
                    child: Text('선택'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 40),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 옵션 데이터 모델 클래스
class OptionItem {
  final String title;
  final String description;

  OptionItem(this.title, this.description);
}

// 더미 데이터
List<Map<String, String>> Custom_Routes = [
  {"title": "부산가는 방법 공유합니다", "description": "대충 내용"},
  {"title": "국민대로 이코", "description": "국민대 가기 진심 햄들다"},
  {"title": "한초희의 투썸 가는 길 룰루", "description": "내일 또 알바 가야 됨"},
  {"title": "추가된 경로", "description": "추가된 설명"},
  {"title": "추가된 경로예욤", "description": "추가된 설명"},
];