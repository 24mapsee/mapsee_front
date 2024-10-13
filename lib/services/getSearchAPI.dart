import 'package:http/http.dart' as http;

Future<http.Response> fetchSearchResults(String query) async {
  final key = '35214412-6709-336F-A09E-49858A095E07';  // Replace this with your actual API key

  final url = Uri.parse(
      'https://api.vworld.kr/req/search?service=search&request=search&version=2.0&crs=EPSG:900913&bbox=14140071.146077,4494339.6527027,14160071.146077,4496339.6527027&size=10&page=1&query=$query&type=district&category=L4&format=json&errorformat=json&key=$key');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to load search results');
  }
}
