import 'package:cs2_lineups/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('list screen shows lineups and filters by map', (tester) async {
    await tester.pumpWidget(const LineupsApp());

    expect(find.text('Window smoke from T spawn'), findsOneWidget);

    await tester.tap(find.text('Inferno'));
    await tester.pump();

    expect(find.text('Window smoke from T spawn'), findsNothing);
    expect(find.text('Banana molotov on Car'), findsOneWidget);
  });
}
