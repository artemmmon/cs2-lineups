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
      appBar: AppBar(
        title: Text('Favorites (${favorites.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Clear all favorites?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              if (ok!) {
                await controller.clearAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Favorites cleared')),
                );
              }
            },
          ),
        ],
      ),
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
