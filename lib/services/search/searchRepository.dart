import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchRepository {
  static final SearchRepository instance = SearchRepository._internal();
  factory SearchRepository() => instance;
  SearchRepository._internal();

  Future<List<String>> getNaverBlogSearch({required String query}) async {
    const String clientId = "3EeHFkVmzBB3hDOxYBcw";
    const String clientSecret = "tqvJ7JF_90";

    try {
      final http.Response _response = await http.get(
        Uri.parse("https://openapi.naver.com/v1/search/local.json?query=${query}"),
        headers: {
          "X-Naver-Client-Id": clientId,
          "X-Naver-Client-Secret": clientSecret,
        },
      );
      if (_response.statusCode == 200) {
        final data = jsonDecode(_response.body);
        List<dynamic> items = data['items'];
        List<String> result = items.map((item) => item['title'] as String).toList();
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
