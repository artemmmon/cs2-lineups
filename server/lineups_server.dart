// Minimal mock backend implementing docs/openapi.yaml.
// Run with: dart run server/lineups_server.dart
import 'dart:convert';
import 'dart:io';

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

Future<void> main() async {
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
  _sendError(request, 404, 'not_found', 'No such route');
}

void _list(HttpRequest request) {
  final map = request.uri.queryParameters['map'];
  final type = request.uri.queryParameters['type'];
  final result = _lineups
      .where((l) => map == null || l['map'] == map)
      .where((l) => type == null || l['type'] == type)
      .map(_toJson)
      .toList();
  _sendJson(request, 200, {'items': result, 'total': result.length});
}

void _get(HttpRequest request, String id) {
  final lineup = _lineups.where((l) => l['id'] == id).firstOrNull;
  if (lineup == null) {
    return _sendError(request, 404, 'not_found', 'Lineup not found');
  }
  _sendJson(request, 200, _toJson(lineup));
}

Map<String, Object> _toJson(Map<String, Object> lineup) =>
    {...lineup}..remove('to');

void _sendJson(HttpRequest request, int status, Object body) {
  request.response
    ..statusCode = status
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(body))
    ..close();
}

void _sendError(HttpRequest request, int status, String code, String message) {
  _sendJson(request, status, {
    'error': {'code': code, 'message': message},
  });
}
