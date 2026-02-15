import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> iTapPayButton(WidgetTester tester) async {
  final button = find.widgetWithText(ElevatedButton, RegExp(r'Pay PKR.*'));
  await tester.tap(button);
  await tester.pumpAndSettle();
}
