import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchRepository {
  static final SearchRepository instance = SearchRepository._internal();
  factory SearchRepository() => instance;
  SearchRepository._internal();

  Future<List<Map<String, dynamic>>> getNaverBlogSearch({required String query}) async {
    const String clientId = "3EeHFkVmzBB3hDOxYBcw";
    const String clientSecret = "tqvJ7JF_90";

    try {
      final http.Response _response = await http.get(
        Uri.parse("https://openapi.naver.com/v1/search/local.json?query=${query}&sort=random&display=20"),
        headers: {
          "X-Naver-Client-Id": clientId,
          "X-Naver-Client-Secret": clientSecret,
        },
      );
      if (_response.statusCode == 200) {
        final data = jsonDecode(_response.body);
        List<dynamic> items = data['items'];
        print(items);

        // Create a list of maps containing all fields for each item
        List<Map<String, dynamic>> result = items.map((item) => {
          'title': item['title'],
          'link': item['link'],
          'category': item['category'],
          'description': item['description'],
          'telephone': item['telephone'],
          'address': item['address'],
          'roadAddress': item['roadAddress'],
          'mapx': item['mapx'],
          'mapy': item['mapy'],
        }).toList();

        print(result);
        return result;
      } else {
        print('Error: ${_response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error occurred: $error');
      return [];
    }
  }
}
