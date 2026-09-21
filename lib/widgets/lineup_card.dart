import 'package:flutter/material.dart';

import '../models/lineup.dart';

class LineupCard extends StatelessWidget {
  const LineupCard({super.key, required this.lineup, required this.onTap});

  final Lineup lineup;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: lineup.type.color.withValues(alpha: 0.2),
          child: Icon(lineup.type.icon, color: lineup.type.color),
        ),
        title: Text(lineup.title),
        subtitle: Text('${lineup.map.label} • ${lineup.from} → ${lineup.to}'),
        trailing: Text(lineup.difficulty.name.toUpperCase()),
      ),
    );
  }
}
