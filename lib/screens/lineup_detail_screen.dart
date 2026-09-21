import 'package:flutter/material.dart';

import '../data/lineups_repository.dart';
import '../state/favorites_controller.dart';

class LineupDetailScreen extends StatelessWidget {
  const LineupDetailScreen({super.key, required this.lineupId});

  final String lineupId;

  @override
  Widget build(BuildContext context) {
    final lineup = const LineupsRepository().findById(lineupId);

    if (lineup == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Lineup not found')),
      );
    }

    final favorites = FavoritesScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lineup.title),
        actions: [
          IconButton(
            icon: Icon(
              favorites.isFavorite(lineup.id) ? Icons.star : Icons.star_border,
            ),
            onPressed: () async {
              favorites.toggle(lineup.id);
              await Future.delayed(const Duration(milliseconds: 300));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    favorites.isFavorite(lineup.id)
                        ? 'Added to favorites'
                        : 'Removed from favorites',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: [
              Chip(
                avatar: Icon(lineup.type.icon, color: lineup.type.color),
                label: Text(lineup.type.label),
              ),
              Chip(label: Text(lineup.map.label)),
              Chip(label: Text(lineup.difficulty.name)),
              Chip(label: Text(lineup.throwStyle.name)),
            ],
          ),
          const SizedBox(height: 16),
          Text('From', style: Theme.of(context).textTheme.labelLarge),
          Text(lineup.from),
          const SizedBox(height: 8),
          Text('To', style: Theme.of(context).textTheme.labelLarge),
          Text(lineup.to),
          const SizedBox(height: 24),
          Text('Steps', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (var i = 0; i < lineup.steps.length; i++)
            ListTile(
              leading: CircleAvatar(radius: 14, child: Text('${i + 1}')),
              title: Text(lineup.steps[i]),
            ),
        ],
      ),
    );
  }
}
