import 'package:flutter/material.dart';

import 'screens/lineup_list_screen.dart';

void main() => runApp(const LineupsApp());

class LineupsApp extends StatelessWidget {
  const LineupsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS2 Lineups',
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const LineupListScreen(),
    );
  }
}
