import 'dart:convert';
import "package:http/http.dart" as http;

class SurrealDB {
  final String baseUrl;

  String? namespace;
  String? database;

  String? autherizationToken;

  SurrealDB(this.baseUrl);

  void use({required String namespace, required String database}) {
    namespace = namespace;
    database = database;
  }

  void authenticate(String token) {
    autherizationToken = 'Bearer $token';
  }

  Future<dynamic> query(String query) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("$baseUrl/sql"),
        body: utf8.encode(query),
        headers: {
          'Accept': 'application/json',
          'NS': namespace ?? '',
          'DB': database ?? '',
          'Authorization': autherizationToken ?? '',
        },
      );

      return jsonDecode(response.body);

      // final Response response = await _client.post(
      //   '/sql',
      //   data: utf8.encode(query),
      //   options: Options(
      //     contentType: 'text/plain',
      //     headers: {'Accept': 'application/json'},
      //   ),
      // );

      // // Process response
      // // - Do error checking
      // // - Parse response
      // // - Return data

      // return response.data;
    } catch (e) {
      print(e);
    }
  }
}
