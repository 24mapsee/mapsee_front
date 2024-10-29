import 'package:flutter/material.dart';
import 'post_page.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  final List<OptionItem> options = [
    OptionItem('Option 1', 'Description for Option 1'),
    OptionItem('Option 2', 'Description for Option 2'),
    OptionItem('Option 3', 'Description for Option 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Page"),
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(options[index].title),
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
                    // 선택된 옵션과 함께 PostPage로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostPage(selectedOption: options[index].title),
                      ),
                    );
                  },
                  child: Text('선택'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40), // 버튼을 화면 전체 너비로 확장
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
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