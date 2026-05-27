import 'package:flutter_test/flutter_test.dart';

import 'package:flicktv_interview/app.dart';
void main() {
  testWidgets('Matches recording sequence: wallet → blinkit → MONEY → cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MihirBhojaniApp());
    await tester.pump();

    expect(find.text('blinkit'), findsNothing);
    expect(find.text('MONEY'), findsNothing);

    // ~0.9s — wallet visible, no text yet
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('blinkit'), findsNothing);

    // ~2.8s — blinkit appears
    await tester.pump(const Duration(milliseconds: 2000));
    expect(find.text('blinkit'), findsOneWidget);
    expect(find.text('MONEY'), findsNothing);

    // ~4.0s — MONEY appears
    await tester.pump(const Duration(milliseconds: 1300));
    expect(find.text('MONEY'), findsOneWidget);

    // ~6.5s — cards + Add Money
    await tester.pump(const Duration(milliseconds: 2600));
    expect(find.text('Single tap payments'), findsOneWidget);
    expect(find.text('Add Money'), findsOneWidget);
  });
}
