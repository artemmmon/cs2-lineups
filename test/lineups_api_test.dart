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
    'throwStyle': 'standing',
    'from': 'T spawn',
    'to': 'Window (mid)',
    'steps': ['Aim at the antenna.'],
  };

  test('fetchLineups maps json to lineups', () async {
    final client = MockClient(
      (_) async => http.Response(jsonEncode([lineupJson]), 200),
    );

    final lineups = await LineupsApi(client).fetchLineups(map: CsMap.mirage);

    expect(lineups.single.id, 'mirage-window-smoke');
    expect(lineups.single.throwStyle, ThrowStyle.standing);
  });

  test('fetchLineup returns null on 404', () async {
    final client = MockClient((_) async => http.Response('{}', 404));

    expect(await LineupsApi(client).fetchLineup('nope'), isNull);
  });
}
