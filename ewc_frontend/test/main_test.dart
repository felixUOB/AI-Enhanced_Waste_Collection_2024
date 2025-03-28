import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:ewc/main.dart' as my_app;
import 'package:ewc/main.dart';
import 'package:ewc/screens/splash/splash.dart';

import 'mocks/mock_setup_locator.dart';

void main() {
  group('main.dart coverage (Mock setupLocator)', () {
    testWidgets('1) main() without real setupLocator => skip .env', (WidgetTester tester) async {
      // Create a Completer that, once signaled, indicates "mock setup done"
      final completer = Completer<void>();

      // Call 'mockSetupLocator()' before completing.
      unawaited(mockSetupLocator().then((_) => completer.complete()));

      // Now call main() with the completer
      my_app.main(setupCompleter: completer);
      // This triggers "if (setupCompleter == null)" -> false,
    });

    testWidgets('2) Pump App => covers initState, dispose, Splash build', (WidgetTester tester) async {
      // Pump the App widget to cover build + splash
      await tester.pumpWidget(const App());

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(SplashPage), findsOneWidget);
    });
  });
}