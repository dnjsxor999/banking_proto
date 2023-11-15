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
  static Future<String> getLinkToken(http.Client client) async {
    final response = await client.post(
      Uri.parse('http://127.0.0.1:8000/create_link_token'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['link_token'];
    } else {
      throw Exception('Failed to get link token');
    }
  }

  static Future<String> setAccessToken(
      http.Client client, String publicToken) async {
    final response = await client.post(
      Uri.parse("http://127.0.0.1:8000/set_access_token"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'public_token': publicToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'];
    } else {
      throw Exception('Failed to set access token');
    }
  }
}
