import 'package:flutter/material.dart';

import '../data/lineups_repository.dart';
import '../models/lineup.dart';
import '../widgets/lineup_card.dart';
import 'lineup_detail_screen.dart';

class LineupListScreen extends StatefulWidget {
  const LineupListScreen({super.key});

  @override
  State<LineupListScreen> createState() => _LineupListScreenState();
}

class _LineupListScreenState extends State<LineupListScreen> {
  final _repository = const LineupsRepository();
  CsMap? _selectedMap;

  @override
  Widget build(BuildContext context) {
    final lineups = _selectedMap == null
        ? _repository.getAll()
        : _repository.getByMap(_selectedMap!);

    return Scaffold(
      appBar: AppBar(title: const Text('CS2 Lineups')),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: _selectedMap == null,
                    onSelected: (_) => setState(() => _selectedMap = null),
                  ),
                ),
                for (final map in CsMap.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(map.label),
                      selected: _selectedMap == map,
                      onSelected: (_) => setState(() => _selectedMap = map),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: lineups.isEmpty
                ? const Center(child: Text('No lineups for this map yet'))
                : ListView.builder(
                    itemCount: lineups.length,
                    itemBuilder: (context, index) {
                      final lineup = lineups[index];
                      return LineupCard(
                        lineup: lineup,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                LineupDetailScreen(lineupId: lineup.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
