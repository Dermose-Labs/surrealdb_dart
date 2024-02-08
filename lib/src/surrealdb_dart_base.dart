import 'dart:convert';

import 'package:dio/dio.dart';

class SurrealDB {
  final Dio _client = Dio();

  SurrealDB(String url) {
    _client.options.baseUrl = url;
    _client.options.headers['Accept'] = 'application/json';
  }

  void use({required String namespace, required String database}) {
    _client.options.headers['NS'] = namespace;
    _client.options.headers['DB'] = database;
  }

  Future<dynamic> query(String query, {Map<String, dynamic> params = const {}}) async {
    final Response response = await _client.post(
      '/sql',
      data: query,
      queryParameters: params.map((key, value) => MapEntry(key, jsonEncode(value))),
    );

    // Process response

    return response;
  }
}
