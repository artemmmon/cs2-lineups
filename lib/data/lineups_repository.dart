import '../models/lineup.dart';

class LineupsRepository {
  const LineupsRepository();

  static const _lineups = <Lineup>[
    Lineup(
      id: 'mirage-window-smoke',
      title: 'Window smoke from T spawn',
      map: CsMap.mirage,
      type: GrenadeType.smoke,
      difficulty: Difficulty.easy,
      throwStyle: ThrowStyle.standing,
      from: 'T spawn',
      to: 'Window (mid)',
      steps: [
        'Stand in the corner next to the T spawn wall.',
        'Aim at the top-left edge of the antenna.',
        'Left click to throw.',
      ],
    ),
    Lineup(
      id: 'mirage-jungle-smoke',
      title: 'Jungle smoke from Ticket booth',
      map: CsMap.mirage,
      type: GrenadeType.smoke,
      difficulty: Difficulty.medium,
      throwStyle: ThrowStyle.jump,
      from: 'Ticket booth',
      to: 'Jungle',
      steps: [
        'Stand at the back of the Ticket booth.',
        'Put the crosshair on the tip of the tallest building.',
        'Jump-throw with left click.',
      ],
    ),
    Lineup(
      id: 'mirage-a-molly',
      title: 'Molotov on Triple box',
      map: CsMap.mirage,
      type: GrenadeType.molotov,
      difficulty: Difficulty.hard,
      throwStyle: ThrowStyle.running,
      from: 'Top mid',
      to: 'Triple box (A site)',
      steps: [
        'Run forward from Top mid holding W.',
        'Aim just left of the palm tree.',
        'Release W and throw.',
      ],
    ),
    Lineup(
      id: 'inferno-banana-molly',
      title: 'Banana molotov on Car',
      map: CsMap.inferno,
      type: GrenadeType.molotov,
      difficulty: Difficulty.easy,
      throwStyle: ThrowStyle.standing,
      from: 'Banana start',
      to: 'Car',
      steps: [
        'Stand on the edge of the T ramp.',
        'Aim at the lamp above the truck.',
        'Right click for a soft throw.',
      ],
    ),
    Lineup(
      id: 'inferno-apps-flash',
      title: 'Pop flash for Apartments',
      map: CsMap.inferno,
      type: GrenadeType.flash,
      difficulty: Difficulty.medium,
      throwStyle: ThrowStyle.standing,
      from: 'Mid',
      to: 'Apartments entrance',
      steps: [
        'Stand next to the mid boxes.',
        'Aim at the top of the arch.',
        'Throw and swing right away.',
      ],
    ),
    Lineup(
      id: 'dust2-xbox-smoke',
      title: 'Xbox smoke from Mid doors',
      map: CsMap.dust2,
      type: GrenadeType.smoke,
      difficulty: Difficulty.easy,
      throwStyle: ThrowStyle.standing,
      from: 'Mid doors',
      to: 'Xbox',
      steps: [
        'Stand in the doorway facing CT.',
        'Aim at the small marking on the wall.',
        'Throw.',
      ],
    ),
    Lineup(
      id: 'dust2-b-flash',
      title: 'B tunnels flash',
      map: CsMap.dust2,
      type: GrenadeType.flash,
      difficulty: Difficulty.easy,
      throwStyle: ThrowStyle.running,
      from: 'Upper tunnels',
      to: 'B site',
      steps: [
        'Run to the end of upper tunnels.',
        'Aim above the arch.',
        'Throw and push.',
      ],
    ),
    Lineup(
      id: 'ancient-mid-he',
      title: 'HE for Mid connector',
      map: CsMap.ancient,
      type: GrenadeType.he,
      difficulty: Difficulty.medium,
      throwStyle: ThrowStyle.jump,
      from: 'Mid',
      to: 'Connector',
      steps: [
        'Stand behind the pillar.',
        'Aim at the corner of the roof.',
        'Jump-throw.',
      ],
    ),
    Lineup(
      id: 'nuke-outside-smoke',
      title: 'Outside smoke from Silo',
      map: CsMap.nuke,
      type: GrenadeType.smoke,
      difficulty: Difficulty.hard,
      throwStyle: ThrowStyle.jump,
      from: 'Silo',
      to: 'Outside',
      steps: [
        'Stand in the corner of the Silo ramp.',
        'Aim at the top of the pipe.',
        'Jump-throw with left click.',
      ],
    ),
    Lineup(
      id: 'inferno-b-site-smoke',
      title: 'Coffins smoke from Banana',
      map: CsMap.mirage,
      type: GrenadeType.smoke,
      difficulty: Difficulty.medium,
      throwStyle: ThrowStyle.standing,
      from: 'Banana',
      to: 'Coffins',
      steps: [
        'Stand next to the sandbags on Banana.',
        'Aim at the top of the far wall.',
        'Throw.',
      ],
    ),
    Lineup(
      id: 'ancient-a-flash',
      title: 'A site pop flash',
      map: CsMap.ancient,
      type: GrenadeType.flash,
      difficulty: Difficulty.hard,
      throwStyle: ThrowStyle.jump,
      from: 'A main',
      to: 'A site',
      steps: [],
    ),
  ];

  List<Lineup> getAll() => List.unmodifiable(_lineups);

  List<Lineup> getByMap(CsMap map) =>
      _lineups.where((l) => l.map == map).toList();

  Lineup? findById(String id) {
    for (final lineup in _lineups) {
      if (lineup.id == id) return lineup;
    }
    return null;
  }
}
