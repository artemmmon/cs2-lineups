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
  final single = RegExp(r'^/v1/lineup/([^/]+)$').firstMatch(path);
  if (request.method == 'GET' && single != null) {
    return _get(request, single.group(1)!);
  }
  _send(request, 404, {'code': 'not_found', 'message': 'No such route'});
}

const _pageSize = 20;

void _list(HttpRequest request) {
  final map = request.uri.queryParameters['map'];
  final type = request.uri.queryParameters['type'];
  final page = int.tryParse(request.uri.queryParameters['page'] ?? '') ?? 1;
  if (map == null) {
    return _send(request, 400, {
      'code': 'bad_request',
      'message': 'map is required',
    });
  }
  final result = _lineups
      .where((l) => l['map'] == map)
      .where((l) => type == null || l['type'] == type)
      .map(_toJson)
      .skip((page - 1) * _pageSize)
      .take(_pageSize)
      .toList();
  _send(request, 200, {'data': result, 'count': result.length, 'page': page});
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
