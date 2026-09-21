import 'package:cs2_lineups/data/lineups_repository.dart';
import 'package:cs2_lineups/models/lineup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repository = LineupsRepository();

  test('getByMap returns only lineups of the given map', () {
    final result = repository.getByMap(CsMap.mirage);
    expect(result, isNotEmpty);
    expect(result.every((l) => l.map == CsMap.mirage), isTrue);
  });

  test('findById returns null for unknown id', () {
    expect(repository.findById('nope'), isNull);
  });

  test('lineup ids are unique', () {
    final ids = repository.getAll().map((l) => l.id).toList();
    expect(ids.toSet().length, ids.length);
  });
}
