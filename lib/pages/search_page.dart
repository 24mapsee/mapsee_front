import 'package:flutter/material.dart';
import 'package:mapsee/components/my_search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: screenHeight * 0.15,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                Expanded(
                    child: MySearchBar(hintText: '장소, 버스, 지하철, 주소 등을 입력하세요.')),
                Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.background,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
