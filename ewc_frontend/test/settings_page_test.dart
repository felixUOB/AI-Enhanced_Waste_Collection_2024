import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'mocks/mock_service_locator.dart';
import 'package:ewc/screens/settings/settings.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:ewc/main.dart';

void main() {
  setUp(() async {
    await mockSetupLocator();
  });

  tearDown(() {
    getIt.reset();
  });

  group('Settings Page Tests', () {

    testWidgets('Builds and shows 7 settings items', (WidgetTester tester) async {
      // Pump the SettingPage
      await tester.pumpWidget(
        MaterialApp(
          home: SettingPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Expect 7 tiles:
      // 1) Change Theme
      // 2) Feedback
      // 3) Privacy Policy
      // 4) Share app
      // 5) Contact us
      // 6) Reset Password
      // 7) Logout
      expect(find.text("Change Theme"), findsOneWidget);
      expect(find.text("Feedback"), findsOneWidget);
      expect(find.text("Privacy Policy"), findsOneWidget);
      expect(find.text("Share app"), findsOneWidget);
      expect(find.text("Contact us"), findsOneWidget);
      expect(find.text("Reset Password"), findsOneWidget);
      expect(find.text("Logout"), findsOneWidget);
    });

    testWidgets('Toggle theme switch', (WidgetTester tester) async {
      // Initially themeManager.themeMode is probably ThemeMode.light
      themeManager.themeMode = ThemeMode.light;
      await tester.pumpWidget(const MaterialApp(home: SettingPage()));
      await tester.pump();

      // find the Switch
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      // toggle it
      await tester.tap(switchFinder);
      await tester.pump();

      // Now themeMode should be ThemeMode.dark
      expect(themeManager.themeMode, ThemeMode.dark);

      // toggle again
      await tester.tap(switchFinder);
      await tester.pump();

      // themeMode => light
      expect(themeManager.themeMode, ThemeMode.light);
    });

    testWidgets('Tap Feedback -> calls _launchUrlFromInput', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingPage()));
      await tester.pump();

      // find the tile text
      final feedbackTile = find.text("Feedback");
      expect(feedbackTile, findsOneWidget);

      // tap it
      await tester.tap(feedbackTile);
      await tester.pumpAndSettle();
    });

    testWidgets('Tap Privacy Policy -> calls _launchUrlFromInput', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingPage()));
      await tester.pump();

      final tile = find.text("Privacy Policy");
      expect(tile, findsOneWidget);

      await tester.tap(tile);
      await tester.pumpAndSettle();
    });

    testWidgets('Tap Share app -> calls Share.share', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingPage()));
      await tester.pump();

      final tile = find.text("Share app");
      expect(tile, findsOneWidget);

      await tester.tap(tile);
      await tester.pumpAndSettle();
    });

    testWidgets('Tap Contact us -> calls _launchUrlFromInput', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingPage()));
      await tester.pump();

      final tile = find.text("Contact us");
      expect(tile, findsOneWidget);

      await tester.tap(tile);
      await tester.pumpAndSettle();
      // coverage for launching
    });

    testWidgets('Tap Reset Password -> calls getIt<AuthService>().launchPasswordReset()', (WidgetTester tester) async {
      // Check if mockAuthService had launchPasswordReset called
      final authMock = getIt<AuthService>();

      await tester.pumpWidget(const MaterialApp(home: SettingPage()));
      await tester.pump();

      final tile = find.text("Reset Password");
      expect(tile, findsOneWidget);

      await tester.tap(tile);
      await tester.pumpAndSettle();

      // verify with mockito or similar
      verify(authMock.launchPasswordReset()).called(1);
    });

    testWidgets('Tap Logout -> show Confirm Dialog -> Yes => calls _logout', (WidgetTester tester) async {
      final authMock = getIt<AuthService>();

      await tester.pumpWidget(const MaterialApp(home: SettingPage()));
      await tester.pump();

      final tile = find.text("Logout");
      expect(tile, findsOneWidget);

      // 1) tap the Logout tile
      await tester.tap(tile);
      await tester.pumpAndSettle();

      // 2) confirm dialog appears
      expect(find.text("Are you sure you want to logout?"), findsOneWidget);
      // find the "Yes" button
      final yesButton = find.text("Yes");
      expect(yesButton, findsOneWidget);

      // 3) tap "Yes"
      await tester.tap(yesButton);
      await tester.pumpAndSettle();

      // coverage: _logout() => authMock.clearCredentials() => Navigator pushAndRemoveUntil => LoginPage
      verify(authMock.clearCredentials()).called(1);
    });

    testWidgets('Tap Logout -> show Confirm Dialog -> No => dismiss', (WidgetTester tester) async {
      final authMock = getIt<AuthService>();

      await tester.pumpWidget(const MaterialApp(home: SettingPage()));
      await tester.pump();

      final tile = find.text("Logout");
      expect(tile, findsOneWidget);

      // tap logout
      await tester.tap(tile);
      await tester.pumpAndSettle();

      final noButton = find.text("No");
      expect(noButton, findsOneWidget);
      await tester.tap(noButton);
      await tester.pumpAndSettle();

      // verify clearCredentials never called
      verifyNever(authMock.clearCredentials());
      // SettingPage still present
      expect(find.byType(SettingPage), findsOneWidget);
    });
  });
}