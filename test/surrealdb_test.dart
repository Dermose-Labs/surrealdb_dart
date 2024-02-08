import 'package:surrealdb_dart/surrealdb_dart.dart';

Future<void> main() async {
  SurrealDB client = SurrealDB('https://db.dermose.com');

  client.use(namespace: 'dev', database: 'main');

  final response = await client.query(
    'CREATE customer CONTENT \$user',
    params: {
      'user': {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '858-319-5693',
      },
    },
  );

  print(response);
}
