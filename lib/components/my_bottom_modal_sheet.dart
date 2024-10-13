import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mapsee/services/decodeJson.dart';
import 'package:mapsee/services/getCurrentLocation.dart';

class MyBottomModalSheet extends StatelessWidget {
  const MyBottomModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // 현재 위치를 Map<String, double> 타입으로 반환하는 비동기 함수

    Future<List<String>> getCurrentAddr() async {
      Map<String, double> position = await getCurrentLocation();
      String lat = position['latitude'].toString();
      String lon = position['longitude'].toString();
      Uri url = Uri.parse(
          "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lon},${lat}&sourcecrs=epsg:4326&output=json");
      Map<String, String> headers = {
        "X-NCP-APIGW-API-KEY-ID": 'nt3da0f7bp',
        "X-NCP-APIGW-API-KEY": 'AVgxmaXai83Jq61EaTX9VKmc768S4oNGiZzt2wY6'
      };
      Response response = await get(url, headers: headers);
      Map<String, dynamic> jsonData = decodeJson(response);
      List<String> result = [
        jsonData['results'][1]['region']['area1']['name'],
        jsonData['results'][1]['region']['area2']['name'],
        jsonData['results'][1]['region']['area3']['name']
      ];
      return result;
    }

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
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: scrollController,
            children: <Widget>[
              Center(
                // 위에
                // Image.asset('assets/images/png/griber.png'),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                            print(
                              '에러 발생: ${snapshot.error}',
                            );
                            return (Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ));
                          } else if (snapshot.hasData) {
                            return Text(
                              "${snapshot.data![0]} ${snapshot.data![1]} ${snapshot.data![2]}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          } else {
                            return Text(
                              'No data available',
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
