import 'package:flutter/material.dart';

enum CsMap {
  mirage('Mirage'),
  inferno('Inferno'),
  dust2('Dust II'),
  ancient('Ancient'),
  nuke('Nuke');

  const CsMap(this.label);
  final String label;
}

enum GrenadeType {
  smoke('Smoke', Icons.cloud, Colors.blueGrey),
  flash('Flash', Icons.flash_on, Colors.amber),
  molotov('Molotov', Icons.local_fire_department, Colors.deepOrange),
  he('HE', Icons.brightness_high, Colors.green);

  const GrenadeType(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

enum Difficulty { easy, medium, hard }

enum ThrowStyle { standing, running, jump }

class Lineup {
  const Lineup({
    required this.id,
    required this.title,
    required this.map,
    required this.type,
    required this.difficulty,
    required this.throwStyle,
    required this.from,
    required this.to,
    required this.steps,
  });

  final String id;
  final String title;
  final CsMap map;
  final GrenadeType type;
  final Difficulty difficulty;
  final ThrowStyle throwStyle;
  final String from;
  final String to;
  final List<String> steps;
}
