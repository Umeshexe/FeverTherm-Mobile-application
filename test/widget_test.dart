import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fever_therm/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Find the '+' button and tap it.
    await tester.tap(find.byIcon(Icons.add));

    // Rebuild the widget tree and trigger a frame.
    await tester.pump();

    // Verify that our counter has incremented to 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
