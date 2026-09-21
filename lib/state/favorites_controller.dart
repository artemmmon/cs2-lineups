import 'package:flutter/widgets.dart';

class FavoritesController extends ChangeNotifier {
  final Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);

  bool isFavorite(String id) => _ids.contains(id);

  void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
      return;
    }
    _ids.add(id);
    print('added $id to favorites, total: ${_ids.length}');
    notifyListeners();
  }
}

class FavoritesScope extends InheritedNotifier<FavoritesController> {
  const FavoritesScope({
    super.key,
    required FavoritesController controller,
    required super.child,
  }) : super(notifier: controller);

  static FavoritesController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FavoritesScope>()!
        .notifier!;
  }
}
