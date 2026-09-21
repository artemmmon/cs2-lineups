import 'dart:convert';

import 'package:cs2_lineups/data/lineups_api.dart';
import 'package:cs2_lineups/models/lineup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const lineupJson = {
    'id': 'mirage-window-smoke',
    'title': 'Window smoke from T spawn',
    'map': 'mirage',
    'type': 'smoke',
    'difficulty': 'easy',
    'throw_style': 'standing',
    'from': 'T spawn',
    'to': 'Window (mid)',
    'steps': ['Aim at the antenna.'],
  };

  test('fetchLineups sends map_name and maps json to lineups', () async {
    late Uri requested;
    final client = MockClient((request) async {
      requested = request.url;
      return http.Response(jsonEncode([lineupJson]), 200);
    });

    final lineups = await LineupsApi(client).fetchLineups(map: CsMap.mirage);

    expect(requested.queryParameters['map_name'], 'mirage');
    expect(lineups.single.id, 'mirage-window-smoke');
    expect(lineups.single.throwStyle, ThrowStyle.standing);
    expect(lineups.single.to, 'Window (mid)');
  });

  test('fetchLineups throws ApiException on server error', () async {
    final client = MockClient((_) async => http.Response('{}', 500));

    expect(
      LineupsApi(client).fetchLineups(),
      throwsA(isA<ApiException>()),
    );
  });

  test('fetchLineup returns null on 404', () async {
    final client = MockClient((_) async => http.Response('{}', 404));

    expect(await LineupsApi(client).fetchLineup('nope'), isNull);
  });
}
