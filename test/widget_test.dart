import 'package:flutter_test/flutter_test.dart';
import 'package:civwatch_app/main.dart';

void main() {
  testWidgets('app builds', (tester) async {
    await tester.pumpWidget(const CivwatchApp());
    expect(find.text('CIVWATCH'), findsOneWidget);
  });
}
