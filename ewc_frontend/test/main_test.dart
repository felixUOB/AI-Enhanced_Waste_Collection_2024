import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ewc/main.dart' as my_app;
import 'package:ewc/main.dart';
import 'package:ewc/screens/splash/splash.dart';

void main() {
  // The main entry point for our test suite
  group('main.dart coverage', () {
    // Groups tests related to main.dart under a single label

    testWidgets('1) main() without Completer => calls setupLocator', (WidgetTester tester) async {
      // When no Completer is provided, the branch if (setupCompleter == null) will run:
      // -> setupLocator() and runApp(...) are invoked
      my_app.main();
      // If main() is declared as Future<void>, you could "await" it (Dart 3+).
      // If not, we simply call my_app.main() directly.
    });

    testWidgets('2) main() with Completer => skip setupLocator', (WidgetTester tester) async {
      // If a Completer is passed, the if statement is skipped
      // and only setupCompleter?.complete() is called
      final completer = Completer<void>();
      my_app.main(setupCompleter: completer);
      await completer.future;
      // Wait for the completer to finish, ensuring all async steps complete
    });

    testWidgets('3) Pump App => covers initState, dispose, Splash build', (WidgetTester tester) async {
      // Here we actually render the App widget
      // to cover initState(), dispose(), and the build logic

      await tester.pumpWidget(const App());
      // Renders our top-level App widget in the test environment

      expect(find.byType(MaterialApp), findsOneWidget);
      // Verifies a MaterialApp widget is present

      expect(find.byType(SplashPage), findsOneWidget);
      // Verifies the SplashPage is rendered (as it's set as home in App)

    });
  });
}
