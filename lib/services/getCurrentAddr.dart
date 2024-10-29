import 'package:http/http.dart';
import 'package:mapsee/services/decodeJson.dart';
import 'package:mapsee/services/getCurrentLocation.dart';

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
