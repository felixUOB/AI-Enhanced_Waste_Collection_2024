import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/metrics/metrics.dart';
import 'package:ewc/screens/splash/splash.dart';
import 'package:ewc/services/auth_service.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements AuthService {}

// This file contains tests for the Metrics Page
void main() {
  testWidgets("Auto Login Functions as Expected", (WidgetTester tester) async {
    final mockAuthService = MockAuthService();

    // Mock the loadUserCredentials and login methods
    when(mockAuthService.loadUserCredentials()).thenAnswer((_) async => {
      "username": "mockUsername",
      "password": "mockPassword",
    });
    when(mockAuthService.login("mockUsername", "mockPassword")).thenAnswer((_) async => Future.value());

    await tester.pumpWidget(
      MaterialApp(
        home: SplashPage(authService: mockAuthService),
      ),
    );

    // Verify that the CircularProgressIndicator is displayed initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the auto-login process to complete
    await tester.pumpAndSettle();

    // Verify that the auto-login process was called
    verify(mockAuthService.loadUserCredentials()).called(1);
    verify(mockAuthService.login("mockUsername", "mockPassword")).called(1);

    // Verify that the CircularProgressIndicator is no longer displayed
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Add additional verifications for navigation or other UI changes after auto-login
    expect(find.byType(LoginPage), findsOneWidget);
  });
}