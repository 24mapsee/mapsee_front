import 'dart:convert';
import 'package:mapsee/services/getSearchAPI.dart';
import 'package:mapsee/services/search_result.dart';

Future<List<SearchResult>> fetchAndParseResults(String query) async {
  final response = await fetchSearchResults(query);

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);

    // 응답의 구조에서 items 리스트를 추출합니다.
    if (jsonData['response'] != null &&
        jsonData['response']['result'] != null &&
        jsonData['response']['result']['items'] != null) {
      final List<dynamic> itemsList = jsonData['response']['result']['items'];

      // itemsList를 SearchResult 객체 리스트로 변환합니다.
      return itemsList.map((item) {
        // 각 항목의 데이터를 SearchResult로 변환합니다.
        final String title = item['address']['road'] ?? 'No Title';
        final String description = item['address']['parcel'] ?? 'No Description';
        return SearchResult(title: title, description: description);
      }).toList();
    } else {
      throw Exception('Invalid response structure');
    }
  } else {
    throw Exception('Failed to load search results');
  }
}
