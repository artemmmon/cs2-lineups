import 'package:flutter/widgets.dart';

import '../data/favorites_api.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController({this.api});

  final FavoritesApi? api;
  final Set<String> _ids = {};

  Future<void> load() async {
    _ids
      ..clear()
      ..addAll(await api!.fetch());
    notifyListeners();
  }

  Set<String> get ids => Set.unmodifiable(_ids);

  bool isFavorite(String id) => _ids.contains(id);

  void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
      api?.remove(id);
      return;
    }
    _ids.add(id);
    api?.add(id);
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
