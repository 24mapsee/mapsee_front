import 'package:flutter/material.dart';
import 'package:mapsee/components/my_search_bar.dart';
import 'package:mapsee/components/my_search_result_container.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  void _deleteResult(String result) {
    setState(() {
      _searchResults.remove(result);
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _searchResults.insert(0, query);
      });
      _searchController.clear();
    }
  }

  Widget _buildCategoryItem(String label, String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SizedBox(
        child: Row(
          children: [
            Image.asset(
              assetPath,
              width: 20,
            ),
            const SizedBox(width: 5),
            Text(label),
          ],
        ),
      ),
    );
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                  child: MySearchBar(
                    hintText: '장소, 버스, 지하철, 주소 등을 입력하세요.',
                    controller: _searchController,
                    onSubmitted: (value) => _performSearch(value),
                  ),
                ),
                InkWell(
                  onTap: () => _performSearch(_searchController.text),
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.background,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 16, vertical: screenHeight * 0.025),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outline, width: 2),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildCategoryItem('음식점', 'assets/images/png/cutlery.png'),
                  _buildCategoryItem('카페', 'assets/images/png/coffee.png'),
                  _buildCategoryItem('병원', 'assets/images/png/medical.png'),
                  _buildCategoryItem(
                      '편의점', 'assets/images/png/convenience.png'),
                  _buildCategoryItem('마트', 'assets/images/png/mart.png'),
                  _buildCategoryItem('주차장', 'assets/images/png/parking.png'),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 16, vertical: screenHeight * 0.025),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outline, width: 2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildCategoryItem('집', 'assets/images/png/home.png'),
                        _buildCategoryItem(
                            '회사', 'assets/images/png/company.png'),
                        _buildCategoryItem(
                            '학교', 'assets/images/png/school.png'),
                        _buildCategoryItem(
                            '잠실역 2호선', 'assets/images/png/flag.png'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      // Add your add action here
                    },
                    child: Image.asset(
                      'assets/images/png/add.png',
                      width: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.5,
            alignment: Alignment.center,
            child: _searchResults.isEmpty
                ? Text(
              "최근 검색 결과가 없습니다.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
              ),
            )
                : Column(
              children: _searchResults
                  .map(
                    (result) => MySearchResultContainer(
                  text: result,
                  onDelete: () => _deleteResult(result),
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
