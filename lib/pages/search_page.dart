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
          ),

          // 나중에 수정해야 함
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 16, vertical: screenHeight * 0.025),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 2))),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/png/cutlery.png',
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text('음식점')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/png/coffee.png',
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text('카페')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/png/medical.png',
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text('병원')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/png/convenience.png',
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text('편의점')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/png/mart.png',
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text('마트')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/png/parking.png',
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text('주차장')
                        ],
                      ),
                    ),
                  )
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
                        color: Theme.of(context).colorScheme.outline,
                        width: 2))),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/png/home.png',
                                width: 20,
                              ),
                              SizedBox(width: 5),
                              Text('집')
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/png/company.png',
                                width: 20,
                              ),
                              SizedBox(width: 5),
                              Text('회사')
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/png/school.png',
                                width: 20,
                              ),
                              SizedBox(width: 5),
                              Text('학교')
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/png/flag.png',
                                width: 20,
                              ),
                              SizedBox(width: 5),
                              Text('잠실역 2호선')
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Image.asset(
                    'assets/images/png/add.png',
                    width: 20,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.5,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "최근 검색 결과가 없습니다.",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
