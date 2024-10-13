import 'dart:convert';

import 'package:http/http.dart';

Map<String, dynamic> decodeJson(Response response) {
  Map<String, dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
  return result;
}