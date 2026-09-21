import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/lineup.dart';

class ApiException implements Exception {
  ApiException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'ApiException($statusCode)';
}

class LineupsApi {
  LineupsApi(this._client, {this.baseUrl = defaultBaseUrl});

  static const defaultBaseUrl = 'https://api.cs2lineups.example/v1';

  final http.Client _client;
  final String baseUrl;

  Future<List<Lineup>> fetchLineups({CsMap? map, GrenadeType? type}) async {
    final uri = Uri.parse('$baseUrl/lineups').replace(
      queryParameters: {
        if (map != null) 'map_name': map.name,
        if (type != null) 'type': type.name,
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) throw ApiException(response.statusCode);

    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => _fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Lineup?> fetchLineup(String id) async {
    final response = await _client.get(Uri.parse('$baseUrl/lineups/$id'));
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) throw ApiException(response.statusCode);

    return _fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Lineup _fromJson(Map<String, dynamic> json) {
    return Lineup(
      id: json['id'] as String,
      title: json['title'] as String,
      map: CsMap.values.byName(json['map'] as String),
      type: GrenadeType.values.byName(json['type'] as String),
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      throwStyle: ThrowStyle.values.byName(json['throw_style'] as String),
      from: json['from'] as String,
      to: json['to'] as String,
      steps: (json['steps'] as List).cast<String>(),
    );
  }
}
