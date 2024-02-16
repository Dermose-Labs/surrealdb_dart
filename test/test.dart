import 'package:surrealdb_dart/surrealdb_dart.dart';

Future<void> main() async {
  final client = SurrealDB('wss://db.dermose.com/rpc');

  client.use(namespace: 'dev', database: 'main');

  final query = await client.query('SELECT * FROM service;');

  print(query);
}
