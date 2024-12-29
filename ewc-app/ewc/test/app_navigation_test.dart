import 'package:ewc/screens/metrics/metrics.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Navigation Tests', () {
    testWidgets("Main Navigation Bar Buttons Function Correctly",
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

      final mapDestination = find.byWidgetPredicate(
        (widget) => widget is NavigationDestination && widget.label == "Map",
      );
      final scheduleDestination = find.byWidgetPredicate(
        (widget) =>
            widget is NavigationDestination && widget.label == "Schedule",
      );

      expect(metricsDestination, findsOneWidget);
      expect(mapDestination, findsOneWidget);
      expect(scheduleDestination, findsOneWidget);

      await tester.tap(metricsDestination);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey("metricsPage")), findsOneWidget);

      await tester.tap(mapDestination);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey("mapPageReplacement")), findsOneWidget);

      await tester.tap(scheduleDestination);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey("schedulePage")), findsOneWidget);
    });

    testWidgets("Metrics Page", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MetricsPage(),
      ));
      await tester.pumpAndSettle();
    });
  });
}
