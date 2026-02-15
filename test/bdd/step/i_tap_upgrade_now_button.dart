import 'package:flutter_test/flutter_test.dart';

Future<void> iTapUpgradeNowButton(WidgetTester tester) async {
  await tester.tap(find.textContaining('Upgrade Now'));
  await tester.pumpAndSettle();
}
