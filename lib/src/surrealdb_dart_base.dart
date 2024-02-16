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
    final internal.SurrealDB client = await _intializeClient();

    final response = await client.query(query, params);

    client.close();

    return response;
  }
}
