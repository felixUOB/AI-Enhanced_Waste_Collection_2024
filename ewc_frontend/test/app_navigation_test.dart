import 'package:ewc/services/auth_service.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import 'mocks/mock_service_locator.dart';

// This file contains tests for the App Navigation
void main() {
  setUp(() async {
    await mockSetupLocator();
  });

  tearDown(() {
    getIt.reset();
  });

  group('App Navigation Tests', () {
    testWidgets("Main Navigation Bar Buttons Function Correctly",
        (WidgetTester tester) async {
      when(getIt<AuthService>().makeAuthenticatedRequest("route_env_data/"))
          .thenAnswer((_) async => Future.value(
                Response(
                  '[{"route_env_data_id": 1, "distance": 10.5, "mpg": 8.2, "date": "2023-10-01"}]', // JSON array string body
                  200, // Status code
                ),
              ));

      // Build the MainNavigationBar widget inside a MaterialApp
      await tester.pumpWidget(MaterialApp(
        home: MainNavigationBar(
          testing: true,
        ),
      ));
      // Wait for all animations to complete
      await tester.pumpAndSettle();

      // Creating instances of widgets if found
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

      // Checking number of instances is correct
      expect(metricsDestination, findsOneWidget);
      expect(mapDestination, findsOneWidget);
      expect(scheduleDestination, findsOneWidget);

      // Check all buttons change shown widget correctly
      await tester.tap(metricsDestination);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey("metricsPage")), findsOneWidget);

      await tester.tap(mapDestination);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey("mapPageReplacement")), findsOneWidget);

      await tester.tap(scheduleDestination);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey("schedulePageReplacement")), findsOneWidget);
    });
  });
}
