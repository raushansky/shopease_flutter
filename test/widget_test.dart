// This is a basic Flutter widget test for ShopEase.

import 'package:flutter_test/flutter_test.dart';
import 'package:shopease/main.dart';

void main() {
  testWidgets('ShopEase app splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ShopEaseApp());

    // Verify that the splash screen shows the app name.
    expect(find.text('ShopEase'), findsOneWidget);
  });
}
