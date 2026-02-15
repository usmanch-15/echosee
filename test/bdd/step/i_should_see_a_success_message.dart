import 'package:flutter_test/flutter_test.dart';

Future<void> iShouldSeeASuccessMessage(WidgetTester tester) async {
  expect(find.text('Success!'), findsOneWidget);
}
