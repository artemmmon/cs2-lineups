import 'package:flutter/material.dart';

import '../data/lineups_repository.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text(lineup.title)),
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
