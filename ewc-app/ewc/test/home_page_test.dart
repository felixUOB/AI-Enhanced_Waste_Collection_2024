import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets("Metric Page Button Functions Correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MainNavigationBar(
          testing: true,
        ),
      ));
      await tester.pumpAndSettle();

      final metricsDestination = find.byWidgetPredicate(
        (widget) =>
            widget is NavigationDestination && widget.label == "Metrics",
      );
      expect(metricsDestination, findsOneWidget);
      await tester.tap(metricsDestination);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey("metricsPage")), findsOneWidget);
    });
  });

  testWidgets("Schedule Page Button Functions Correctly",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MainNavigationBar(
        testing: true,
      ),
    ));
    await tester.pumpAndSettle();

    final metricsDestination = find.byWidgetPredicate(
      (widget) => widget is NavigationDestination && widget.label == "Schedule",
    );
    expect(metricsDestination, findsOneWidget);
    await tester.tap(metricsDestination);
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey("schedulePage")), findsOneWidget);
  });
}
