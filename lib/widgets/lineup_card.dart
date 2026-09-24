import 'package:flutter/material.dart';

import '../models/lineup.dart';

class LineupCard extends StatelessWidget {
  const LineupCard({super.key, required this.lineup, required this.onTap});

  final Lineup lineup;
  final VoidCallback onTap;

  Color _difficultyColor(Difficulty d) {
    switch (d) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.green;
    }
  }

  IconData _throwStyleIcon(ThrowStyle style) {
    switch (style) {
      case ThrowStyle.standing:
        return Icons.accessibility_new;
      case ThrowStyle.running:
        return Icons.arrow_upward;
      case ThrowStyle.jump:
        return Icons.directions_run;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        isThreeLine: true,
        leading: CircleAvatar(
          backgroundColor: lineup.type.color.withValues(alpha: 0.2),
          child: Icon(lineup.type.icon, color: lineup.type.color),
        ),
        title: Text(lineup.title),
        subtitle: Text(
          '${lineup.map.label} • ${lineup.from} → ${lineup.to}\n'
          '${lineup.steps.first}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_throwStyleIcon(lineup.throwStyle), size: 18),
            Text(
              lineup.difficulty.name.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                color: _difficultyColor(lineup.difficulty),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
