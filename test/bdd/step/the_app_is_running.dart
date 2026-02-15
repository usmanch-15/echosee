import 'package:flutter_test/flutter_test.dart';
import 'package:echo_see_companion/main.dart';

Future<void> theAppIsRunning(WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
}
