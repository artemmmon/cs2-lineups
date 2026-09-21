import 'package:flutter/material.dart';

import '../data/lineups_repository.dart';
import '../state/favorites_controller.dart';
import '../widgets/lineup_card.dart';
import 'lineup_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavoritesScope.of(context);
    const repository = LineupsRepository();
    final favorites = controller.ids
        .map((id) => repository.getAll().firstWhere((l) => l.id == id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Favorites (${favorites.length})')),
      body: favorites.isEmpty
          ? const Center(child: Text('Tap the star on a lineup to save it'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final lineup = favorites[index];
                return LineupCard(
                  lineup: lineup,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LineupDetailScreen(lineupId: lineup.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
