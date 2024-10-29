import 'package:flutter/material.dart';
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
          padding: const EdgeInsets.all(5.0),
          child: ListView(
            controller: scrollController,
            children: <Widget>[
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/png/marker.png',
                        color: Theme.of(context).colorScheme.primary,
                        width: 30,
                      ),
                      SizedBox(width: 10),
                      FutureBuilder<List<String>>(
                        future: getCurrentAddr(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            print('Error: ${snapshot.error}');
                            return Text(
                              '현재 위치를 찾을 수 없습니다.',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            );
                          } else if (snapshot.hasData) {
                            return Text(
                              "${snapshot.data![0]} ${snapshot.data![1]} ${snapshot.data![2]}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          } else {
                            return Text(
                              '현재 위치를 찾을 수 없습니다.',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
