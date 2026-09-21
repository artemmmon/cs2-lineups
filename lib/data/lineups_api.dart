import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/lineup.dart';

class LineupsApi {
  LineupsApi(this._client);

  static const baseUrl = 'https://api.cs2lineups.example/v1';

  final http.Client _client;

  Future<List<Lineup>> fetchLineups({CsMap? map, GrenadeType? type}) async {
    final uri = Uri.parse('$baseUrl/lineups').replace(
      queryParameters: {
        if (map != null) 'map_name': map.name,
        if (type != null) 'type': type.name,
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) return [];

    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => lineupFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Lineup?> fetchLineup(String id) async {
    final response = await _client.get(Uri.parse('$baseUrl/lineups/$id'));
    if (response.statusCode == 404) return null;
    return lineupFromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Lineup lineupFromJson(Map<String, dynamic> json) {
    return Lineup(
      id: json['id'] as String,
      title: json['title'] as String,
      map: CsMap.values.byName(json['map'] as String),
      type: GrenadeType.values.byName(json['type'] as String),
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      throwStyle: ThrowStyle.values.byName(json['throwStyle'] as String),
      from: json['from'] as String,
      to: json['to'] as String,
      steps: (json['steps'] as List).cast<String>(),
    );
  }
}
