import 'dart:convert';

import 'package:http/http.dart' as http;

// class PlaidModel {
//   final String link_token, expiration, request_id;

//   PlaidModel.fromJson(Map<String, dynamic> json)
//       : link_token = json['link_token'] as String,
//         expiration = json['expiration'] as String,
//         request_id = json['request_id'] as String;
// }

class PlaidService {
  static String linkToken = '';
  static String accessToken = '';

  static Future<void> getLinkToken(http.Client client) async {
    final response = await client
        .get(Uri.parse('https://localhost://8000/create_link_token'));

    if (response.statusCode == 200) {
      linkToken = jsonDecode(response.body)['link_token'];
    } else {
      throw Error();
    }
  }

  static Future<void> setAccessToken(http.Client client) async {
    final response = await client
        .get(Uri.parse("https://localhost://8000/set_access_token"));
    if (response.statusCode == 200) {
      accessToken = jsonDecode(response.body)['access_token'];
    } else {
      throw Error();
    }
  }
}
