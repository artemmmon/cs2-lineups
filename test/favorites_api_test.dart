import 'dart:convert';

import 'package:cs2_lineups/data/favorites_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('fetch parses favorite ids', () async {
    final client = MockClient(
      (_) async => http.Response(
        jsonEncode({'ids': ['mirage-window-smoke']}),
        200,
      ),
    );

    final ids = await FavoritesApi(client).fetch();

    expect(ids, {'mirage-window-smoke'});
  });

  test('add succeeds on 204', () async {
    final client = MockClient((_) async => http.Response('', 204));

    await FavoritesApi(client, token: 't').add('mirage-window-smoke');
  });
}
