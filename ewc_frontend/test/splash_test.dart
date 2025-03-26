import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/splash/splash.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:ewc/services/metrics_service.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'mocks/mock_service_locator.dart';

void main() {
  setUp(() async {
    await mockSetupLocator();
  });

  tearDown(() {
    getIt.reset();
  });

  // Group of tests for the Splash Page
  group('Splash Page Widget Tests', () {
    testWidgets("Auto Login Success Functions as Expected",
 (WidgetTester tester) async {
      when(getIt<AuthService>().loadUserCredentials())
          .thenAnswer((_) async => <String, String?>{
                "username": "mockUsername",
                "password": "mockPassword",
              });

      when(getIt<AuthService>().login("mockUsername", "mockPassword"))
          .thenAnswer((_) async {});

      when(getIt<AuthService>().makeAuthenticatedRequest("route-env-data-30-days/"))
          .thenAnswer((_) async => Future.value(
                Response(
                  '[{"route_env_data_id": 1, "distance": 10.5, "mpg": 8.2, "date": "2025-03-14"}]', // JSON array string body
                  200, // Status code
                ),
              ));
      when(getIt<MetricsService>().fetchLast30Days()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(
            isTesting: true,
          ),
        ),
      );

      // Verify that the CircularProgressIndicator is displayed initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the auto-login process to complete
      await tester.pumpAndSettle();

      // Verify that the auto-login process was called
      verify(getIt<AuthService>().loadUserCredentials()).called(1);
      verify(getIt<AuthService>().login("mockUsername", "mockPassword"))
          .called(1);

      // Verify that the CircularProgressIndicator is no longer displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Verify that the user is navigated to the main page after auto-login success
      expect(find.byType(MainNavigationBar), findsOneWidget);
    });

    testWidgets("Auto Login Failure Functions as Expected",
        (WidgetTester tester) async {
      // Mock the loadUserCredentials and login methods
      when(getIt<AuthService>().loadUserCredentials()).thenAnswer((_) async => {
            "username": "mockUsername",
            "password": "mockPassword",
          });
      when(getIt<AuthService>().login("mockUsername", "mockPassword"))
          .thenThrow(Exception("Login failed"));

      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(),
        ),
      );

      // Verify that the CircularProgressIndicator is displayed initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the auto-login process to complete
      await tester.pumpAndSettle();

      // Verify that the auto-login process was called
      verify(getIt<AuthService>().loadUserCredentials()).called(1);
      verify(getIt<AuthService>().login("mockUsername", "mockPassword"))
          .called(1);

      // Verify that the CircularProgressIndicator is no longer displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Add additional verifications for navigation or other UI changes after auto-login
      expect(find.byType(LoginPage), findsOneWidget);
    });
    testWidgets("Auto Login Null Return Functions as Expected",
        (WidgetTester tester) async {
      // Mock the loadUserCredentials and login methods
      when(getIt<AuthService>().loadUserCredentials())
          .thenAnswer((_) async => {});

      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(),
        ),
      );

      // Verify that the CircularProgressIndicator is displayed initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the auto-login process to complete
      await tester.pumpAndSettle();

      // Verify that the auto-login process was called
      verify(getIt<AuthService>().loadUserCredentials()).called(1);

      // Verify that the CircularProgressIndicator is no longer displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Add additional verifications for navigation or other UI changes after auto-login
      expect(find.byType(LoginPage), findsOneWidget);
    });
    testWidgets(
        "Auto Login Partial Credential (username, no password) leads to LoginPage",
        (WidgetTester tester) async {
      // Mock user credentials with no password
      when(getIt<AuthService>().loadUserCredentials()).thenAnswer((_) async => {
            "username": "mockUsername",
            "password": "",
          });

      // Attempting to log in should fail because the password is missing
      when(getIt<AuthService>().login("mockUsername", ""))
          .thenThrow(Exception("Missing password"));

      when(getIt<MetricsService>().fetchAllRoutes()).thenAnswer((_) async => []);

    
      // Build the SplashPage with the mocked authService
      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(),
        ),
      );

      // Initially, a loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Let the widgets update
      await tester.pumpAndSettle();

      // Verify loadUserCredentials() was called and that we landed on the LoginPage
      verify(getIt<AuthService>().loadUserCredentials()).called(1);
      expect(find.byType(LoginPage), findsOneWidget);
      // The loading indicator should be gone now
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
