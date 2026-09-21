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
  final _searchController = TextEditingController();
  CsMap? _selectedMap;
  String _query = '';
  bool _easiestFirst = false;

  @override
  Widget build(BuildContext context) {
    var lineups = _selectedMap == null
        ? _repository.getAll()
        : _repository.getByMap(_selectedMap!);

    if (_query.isNotEmpty) {
      lineups = lineups.where((l) => l.title.contains(_query)).toList();
    }

    if (_easiestFirst) {
      lineups.sort((a, b) => b.difficulty.index - a.difficulty.index);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CS2 Lineups'),
        actions: [
          IconButton(
            tooltip: 'Easiest first',
            icon: Icon(
              Icons.sort,
              color: _easiestFirst ? Theme.of(context).colorScheme.primary : null,
            ),
            onPressed: () => setState(() => _easiestFirst = !_easiestFirst),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search lineups',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
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
                ? const Center(child: Text('No lineups found'))
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
