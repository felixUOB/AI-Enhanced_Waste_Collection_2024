import 'package:ewc/screens/metrics/metrics.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// This file contains tests for the Metrics Page
void main() {
  // Group of tests for the Metrics Page
  group('Map Page Tests', () {
    // Test to check if all graphical widgets are present on the Metrics Page
    testWidgets("Check all graphical widgets are present",
        (WidgetTester tester) async {
          tester.pumpWidget(
            MaterialApp(
              home: MainNavigationBar(testing: true,),
            )
          );
    });
  });
}
