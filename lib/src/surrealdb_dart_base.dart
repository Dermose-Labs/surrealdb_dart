// ignore: library_prefixes
import 'package:dio/dio.dart';
import 'package:surrealdb/surrealdb.dart' as internal;

class SurrealDB {
  final String baseUrl;

  String? ns;
  String? db;

  String? autherizationToken;

  SurrealDB(this.baseUrl);

  void use({required String namespace, required String database}) {
    ns = namespace;
    db = database;

    print('Connecting to namespace: $namespace, database: $database');
  }

  void authenticate(String token) {
    autherizationToken = 'Bearer $token';
  }

  Future<internal.SurrealDB> _intializeClient() async {
    final client = internal.SurrealDB(baseUrl);

    client.connect();

    await client.wait();

    print('Connecting to namespace: $ns, database: $db');

    await client.use(ns!, db!);

    if (autherizationToken != null) {
      await client.authenticate(autherizationToken!);
    }

    return client;
  }

  Future<dynamic> query(String query, [Map<String, dynamic> params = const {}]) async {
    final DateTime start = DateTime.now();

    final internal.SurrealDB client = await _intializeClient();

    final DateTime afterConnect = DateTime.now();

    final response = await client.query(query, params);

    final DateTime afterQuery = DateTime.now();

    print('Connect took: ${afterConnect.difference(start).inMilliseconds}ms');
    print('Query took: ${afterQuery.difference(afterConnect).inMilliseconds}ms');

    client.close();

    final DateTime end = DateTime.now();

    print('Close took: ${end.difference(afterQuery).inMilliseconds}ms');
    print('Total took: ${end.difference(start).inMilliseconds}ms');

    return response;
  }

  Future<dynamic> queryHttp(String query) async {
    final DateTime start = DateTime.now();

    final client = Dio();

    client.options.baseUrl = baseUrl;
    client.options.headers['Accept'] = 'application/json';
    client.options.headers['Authorization'] = autherizationToken;
    client.options.headers['NS'] = ns;
    client.options.headers['DB'] = db;

    final response = await client.post('/sql', data: query);

    final DateTime end = DateTime.now();

    print('Total took: ${end.difference(start).inMilliseconds}ms');

    return response;
  }
}
