import 'package:ewc/screens/metrics/metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Metrics Page Tests', () {
    testWidgets("Check all graphical widgets are present",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MetricsPage(),
      ));
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey("barGraph")), findsOneWidget);
      expect(find.byKey(ValueKey("lineGraph")), findsOneWidget);
      expect(find.byKey(ValueKey("pieGraph")), findsOneWidget);
    });
  });
}
