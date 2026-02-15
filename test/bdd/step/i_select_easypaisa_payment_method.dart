import 'package:flutter_test/flutter_test.dart';

Future<void> iSelectEasypaisaPaymentMethod(WidgetTester tester) async {
  await tester.tap(find.text('EasyPaisa'));
  await tester.pumpAndSettle();
}
