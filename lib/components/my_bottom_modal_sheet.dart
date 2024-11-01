import 'package:flutter/material.dart';
import 'package:mapsee/components/my_gribber.dart';
import 'package:mapsee/pages/search_result_page.dart';
import 'package:mapsee/services/getCurrentAddr.dart';

class MyBottomModalSheet extends StatelessWidget {
  const MyBottomModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.1,
      maxChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                children: <Widget>[
                  const MyGribber(),
                  const SizedBox(height: 8),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/png/marker.png',
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  FutureBuilder<List<String>>(
                                    future: getCurrentAddr(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<String>> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        print('Error: ${snapshot.error}');
                                        return Text(
                                          '현재 위치를 찾을 수 없습니다.',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        );
                                      } else if (snapshot.hasData) {
                                        return Text(
                                          "${snapshot.data![0]} ${snapshot.data![1]} ${snapshot.data![2]}",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        );
                                      } else {
                                        return Text(
                                          '현재 위치를 찾을 수 없습니다.',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            side: const BorderSide(
                                color: Colors.transparent, width: 0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchResultPage(),
                              ),
                            );
                          },
                          child: const Text('길찾기',
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
