import 'package:cs2_lineups/state/favorites_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toggle adds a lineup to favorites and notifies', () {
    final controller = FavoritesController();
    var notified = 0;
    controller.addListener(() => notified++);

    controller.toggle('mirage-window-smoke');

    expect(controller.isFavorite('mirage-window-smoke'), isTrue);
    expect(notified, 1);
  });
}
