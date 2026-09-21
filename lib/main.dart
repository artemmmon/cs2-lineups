import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'state/favorites_controller.dart';

void main() => runApp(const LineupsApp());

class LineupsApp extends StatelessWidget {
  const LineupsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FavoritesScope(
      controller: FavoritesController(),
      child: MaterialApp(
        title: 'CS2 Lineups',
        theme: ThemeData(
          colorSchemeSeed: Colors.orange,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: const HomeShell(),
      ),
    );
  }
}
