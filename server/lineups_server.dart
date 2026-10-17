// Minimal mock backend implementing docs/openapi.yaml.
// Run with: DEVICE_TOKEN_SECRET=dev dart run server/lineups_server.dart
import 'dart:convert';
import 'dart:io';

import 'auth/device_token.dart';

const _lineups = <Map<String, Object>>[
  {
    'id': 'mirage-window-smoke',
    'title': 'Window smoke from T spawn',
    'map': 'mirage',
    'type': 'smoke',
    'difficulty': 'easy',
    'throw_style': 'standing',
    'from': 'T spawn',
    'to': 'Window (mid)',
    'steps': ['Aim at the antenna.', 'Left click to throw.'],
  },
  {
    'id': 'inferno-banana-molly',
    'title': 'Banana molotov on Car',
    'map': 'inferno',
    'type': 'molotov',
    'difficulty': 'easy',
    'throw_style': 'standing',
    'from': 'Banana start',
    'to': 'Car',
    'steps': ['Aim at the lamp above the truck.', 'Right click to throw.'],
  },
  {
    'id': 'dust2-xbox-smoke',
    'title': 'Xbox smoke from Mid doors',
    'map': 'dust2',
    'type': 'smoke',
    'difficulty': 'easy',
    'throw_style': 'standing',
    'from': 'Mid doors',
    'to': 'Xbox',
    'steps': ['Aim at the marking on the wall.', 'Throw.'],
  },
];

final _favoriteIds = <String>{};

Future<void> main() async {
  logDeviceTokenFingerprint();
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  stdout.writeln('Listening on http://localhost:8080/v1');
  await for (final request in server) {
    _handle(request);
  }
}

void _handle(HttpRequest request) {
  final path = request.uri.path;
  if (request.method == 'GET' && path == '/v1/lineups') {
    return _list(request);
  }
  final single = RegExp(r'^/v1/lineups/([^/]+)$').firstMatch(path);
  if (request.method == 'GET' && single != null) {
    return _get(request, single.group(1)!);
  }

  final favorites = RegExp(r'^/v1/favorites(?:/([^/]+))?$').firstMatch(path);
  if (favorites != null) {
    if (!isValidDeviceToken(request)) {
      return _send(request, 401, {
        'code': 'unauthorized',
        'message': 'Missing or invalid X-Device-Token',
      });
    }
    final id = favorites.group(1);
    if (request.method == 'GET' && id == null) return _listFavorites(request);
    if (request.method == 'PUT' && id != null) return _addFavorite(request, id);
    if (request.method == 'DELETE' && id != null) {
      return _removeFavorite(request, id);
    }
  }

  _send(request, 404, {'code': 'not_found', 'message': 'No such route'});
}

void _listFavorites(HttpRequest request) {
  _send(request, 200, {'lineup_ids': _favoriteIds.toList()});
}

void _addFavorite(HttpRequest request, String id) {
  _favoriteIds.add(id);
  request.response
    ..statusCode = 204
    ..close();
}

void _removeFavorite(HttpRequest request, String id) {
  _favoriteIds.remove(id);
  request.response
    ..statusCode = 204
    ..close();
}

const _pageSize = 20;

void _list(HttpRequest request) {
  final map = request.uri.queryParameters['map'];
  final type = request.uri.queryParameters['type'];
  final page = int.tryParse(request.uri.queryParameters['page'] ?? '') ?? 1;
  final result = _lineups
      .where((l) => map == null || l['map'] == map)
      .where((l) => type == null || l['type'] == type)
      .map(_toJson)
      .skip((page - 1) * _pageSize)
      .take(_pageSize)
      .toList();
  _send(request, 200, {'items': result, 'total': result.length, 'page': page});
}

void _get(HttpRequest request, String id) {
  for (final lineup in _lineups) {
    if (lineup['id'] == id) return _send(request, 200, _toJson(lineup));
  }
  _send(request, 404, {'code': 'not_found', 'message': 'Lineup not found'});
}

Map<String, Object> _toJson(Map<String, Object> lineup) =>
    {...lineup}..remove('to');

void _send(HttpRequest request, int status, Object body) {
  request.response
    ..statusCode = status
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(body))
    ..close();
}
