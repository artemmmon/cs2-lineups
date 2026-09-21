import 'dart:convert';

import 'package:http/http.dart' as http;

class FavoritesApi {
  FavoritesApi(this._client, {this.token = ''});

  static const baseUrl = 'http://api.cs2lineups.example/v1';

  final http.Client _client;
  final String token;

  Future<Set<String>> fetch() async {
    final response = await _client.get(Uri.parse('$baseUrl/favorites'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load favorites: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['ids'] as List).cast<String>().toSet();
  }

  Future<void> add(String lineupId) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Authorization': 'Bearer $token'},
      body: jsonEncode({'lineupId': lineupId}),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to add favorite: ${response.statusCode}');
    }
  }

  Future<void> remove(String lineupId) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/favorites/$lineupId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite: ${response.statusCode}');
    }
  }
}
