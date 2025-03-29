import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ewc/main.dart' as app_main;
import 'package:ewc/main.dart';
import 'package:ewc/screens/splash/splash.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/services/metrics_service.dart';


Future<void> mockSetupLocator() async {
  getIt.registerSingleton<StopsService>(StopsService());
  getIt.registerSingleton<MetricsService>(MetricsService());
}

void main() {
  group('main.dart test', () {
    // First test: call main() with a Completer to skip the real setupLocator
    testWidgets('main() with Completer => skip real setupLocator', (WidgetTester tester) async {
      // 1) We manually invoke mockSetupLocator(), then complete the mockCompleter when it's done
      final mockCompleter = Completer<void>();
      unawaited(mockSetupLocator().then((_) => mockCompleter.complete()));

      // 2) When calling app_main.main(), if (setupCompleter != null),
      app_main.main(setupCompleter: mockCompleter);

      // Wait for all asynchronous operations to finish
      await mockCompleter.future;
    });

    // Second test: actually pump the App widget to cover initState, dispose, and the build logic
    testWidgets('Pump App => covers initState, dispose, Splash build', (WidgetTester tester) async {
      // Render the top-level App widget in the test environment
      await tester.pumpWidget(const App());

      // Verify a MaterialApp is rendered
      expect(find.byType(MaterialApp), findsOneWidget);

      // Check that the SplashPage is set as the home widget
      expect(find.byType(SplashPage), findsOneWidget);
    });
  });
}
