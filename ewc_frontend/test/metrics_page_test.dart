import 'package:ewc/screens/metrics/metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// This file contains tests for the Metrics Page
void main() {
  // Group of tests for the Metrics Page
  group('Metrics Page Tests', () {
    // Test to check if all graphical widgets are present on the Metrics Page
    testWidgets("Check all graphical widgets are present",
        (WidgetTester tester) async {
      // Build the MetricsPage widget inside a MaterialApp
      await tester.pumpWidget(MaterialApp(
        home: MetricsPage(),
      ));
      // Wait for all animations to complete
      await tester.pumpAndSettle();

      // Verify that the bar graph widget is present
      expect(find.byKey(ValueKey("barGraph")), findsOneWidget);
      // Verify that the line graph widget is present
      expect(find.byKey(ValueKey("lineGraph")), findsOneWidget);
      // Verify that the pie graph widget is present
      expect(find.byKey(ValueKey("pieGraph")), findsOneWidget);
    });
  });
}
