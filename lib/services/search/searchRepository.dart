import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchRepository {
  static final SearchRepository instance = SearchRepository._internal();
  factory SearchRepository() => instance;
  SearchRepository._internal();

  Future<List<Map<String, dynamic>>> getNaverPlaceSearch(
      {required String query}) async {
    const String clientId = "3EeHFkVmzBB3hDOxYBcw";
    const String clientSecret = "tqvJ7JF_90";

    try {
      final http.Response _response = await http.get(
        Uri.parse(
            "https://openapi.naver.com/v1/search/local.json?query=${query}&sort=random&display=20"),
        headers: {
          "X-Naver-Client-Id": clientId,
          "X-Naver-Client-Secret": clientSecret,
        },
      );
      if (_response.statusCode == 200) {
        final data = jsonDecode(_response.body);
        List<dynamic> items = data['items'];
        log(items.toString());

        // Create a list of maps containing all fields for each item
        List<Map<String, dynamic>> result = items
            .map((item) => {
                  'title': item['title'],
                  'link': item['link'],
                  'category': item['category'],
                  'description': item['description'],
                  'telephone': item['telephone'],
                  'address': item['address'],
                  'roadAddress': item['roadAddress'],
                  'mapx': item['mapx'],
                  'mapy': item['mapy'],
                })
            .toList();

        log(result.toString());
        return result;
      } else {
        log('Error: ${_response.statusCode}');
        return [];
      }
    } catch (error) {
      log('Error occurred: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getKakaoPlaceSearch(
      {required String query}) async {
    String? kakaoApiKey = dotenv.env["KAKAO_API_KEY"];
    try {
      final http.Response _response = await http.get(
        Uri.parse(
            "https://dapi.kakao.com/v2/local/search/keyword?query=${query}"),
        headers: {
          "Authorization": kakaoApiKey ?? "",
        },
      );
      if (_response.statusCode == 200) {
        final data = jsonDecode(_response.body);
        List<dynamic> items = data['documents'];
        log(items.toString());

        // Create a list of maps containing all fields for each item
        List<Map<String, dynamic>> result = items
            .map((item) => {
                  'title': item['place_name'],
                  'link': item['place_url'],
                  'category': item['category_name'],
                  'telephone': item['phone'],
                  'address': item['address_name'],
                  'roadAddress': item['road_address_name'],
                  'mapx': item['x'],
                  'mapy': item['y'],
                })
            .toList();

        log(result.toString());
        return result;
      } else {
        log('Error: ${_response.statusCode}');
        return [];
      }
    } catch (error) {
      log('Error occurred: $error');
      return [];
    }
  }
}

Future<List<Map<String, dynamic>>> getKakaoPlaceSearchWithPlaceID(
    {required String query, required String kakaoPlaceId}) async {
  String? kakaoApiKey = dotenv.env["KAKAO_API_KEY"];
  try {
    final http.Response _response = await http.get(
      Uri.parse(
          "https://dapi.kakao.com/v2/local/search/keyword?query=${query}"),
      headers: {
        "Authorization": kakaoApiKey ?? "",
      },
    );
    if (_response.statusCode == 200) {
      final data = jsonDecode(_response.body);
      List<dynamic> items = data['documents'];
      log(items.toString());

      // Create a list of maps containing all fields for each item
      List<Map<String, dynamic>> result = items
          .where((item) => item['id'] == kakaoPlaceId)
          .map((item) => {
                'title': item['place_name'],
                'link': item['place_url'],
                'category': item['category_name'],
                'telephone': item['phone'],
                'address': item['address_name'],
                'roadAddress': item['road_address_name'],
                'mapx': item['x'],
                'mapy': item['y'],
              })
          .toList();

      log(result.toString());
      return result;
    } else {
      log('Error: ${_response.statusCode}');
      return [];
    }
  } catch (error) {
    log('Error occurred: $error');
    return [];
  }
}
