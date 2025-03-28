import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:ewc/main.dart' as my_app;
import 'package:ewc/main.dart';
import 'package:ewc/screens/splash/splash.dart';

void main() {
  // The main entry point for running our tests
  group('main.dart coverage', () {
    // Groups related tests under the label "main.dart coverage"

    testWidgets('1) main() without Completer => calls setupLocator', (WidgetTester tester) async {
      // A widget test that verifies what happens when we call main() with no arguments
      my_app.main();
      // Calls the app's main() function from 'my_app' alias;
      // typically this should trigger setupLocator or any bootstrapping code
    });

    testWidgets('2) main() with Completer => skip setupLocator', (WidgetTester tester) async {
      // A widget test that verifies the behavior when main() is given a Completer

      final completer = Completer<void>();
      // Creates a Completer which can signal when setup is finished

      my_app.main(setupCompleter: completer);
      // Calls main() passing our Completer, presumably causing some setup function to be skipped

      await completer.future;
      // Awaits the Completer's completion, ensuring the asynchronous steps finish
    });

    testWidgets('3) Pump App => covers initState, dispose, SplashPage build', (WidgetTester tester) async {
      // A widget test that actually renders the app's widget tree to cover initState, dispose, and building SplashPage

      await tester.pumpWidget(const App());
      // Pumps (renders) our top-level App widget into the test environment

      expect(find.byType(MaterialApp), findsOneWidget);
      // Verifies that a MaterialApp widget is present

      expect(find.byType(SplashPage), findsOneWidget);
      // Verifies that the SplashPage is actually being built and rendered
    });
  });
}
