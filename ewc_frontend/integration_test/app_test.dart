import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ewc/main.dart' as ewc_app;
import 'package:ewc/screens/login/login.dart';
import 'package:ewc/services/auth_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Tests', () {
    testWidgets('1) App starts and shows SplashPage', (WidgetTester tester) async {
      // Launch the main app
      ewc_app.main();
      await tester.pumpAndSettle();

      // Assuming the SplashPage has a text "Splash Screen"
      expect(find.text('Splash Screen'), findsOneWidget);

      // If there's no automatic transition from Splash to Login,
      // you'll need to implement it in the actual app code for this test
      // to proceed further. For example:
      // await tester.pump(const Duration(seconds: 3));
      // expect(find.text('Welcome Back!'), findsOneWidget);
    });

    testWidgets('2) Login → Forgot Password flow', (WidgetTester tester) async {
      // Manually display the LoginPage, wrapped with MaterialApp
      final authService = AuthService();
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(authService: authService),
        ),
      );

      // Build all frames
      await tester.pumpAndSettle();

      // Check if "Welcome Back!" text is visible on the login screen
      expect(find.text("Welcome Back!"), findsOneWidget);

      // Find and tap the "Forgot Password?" link
      final forgotLinkFinder = find.text("Forgot Password?");
      expect(forgotLinkFinder, findsOneWidget);

      await tester.tap(forgotLinkFinder);
      await tester.pumpAndSettle();

      // Once navigating to ForgotPassword page, check for "Reset your password!"
      expect(find.text("Reset your password!"), findsOneWidget);

      // Initially, the password field is not visible.
      // Pressing the "Reset Password" button triggers setState to show it.
      // "Reset Password" is the text for the LoginButton in the logs.
      final resetButtonFinder = find.text("Reset Password");
      expect(resetButtonFinder, findsOneWidget);

      // Tap the button to trigger setState -> password field should appear
      await tester.tap(resetButtonFinder);
      await tester.pumpAndSettle();

      // Check if the password field (key: "passwordField") is now visible
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
    });
  });
}
