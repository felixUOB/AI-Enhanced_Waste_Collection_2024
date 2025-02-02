import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/splash/splash.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.mocks.dart' as mocks;

// This file contains tests for the Metrics Page

void main() {

  mocks.MockAuthService  mockAuthService = mocks.MockAuthService();
  // Group of tests for the Login Page
  group('Splash Page Widget Tests', () {
    testWidgets("Auto Login Success Functions as Expected", (WidgetTester tester) async {


      when(mockAuthService.loadUserCredentials()).thenAnswer((_) async => <String, String?>{
        "username": "mockUsername",
        "password": "mockPassword",
      });

      when(mockAuthService.login("mockUsername", "mockPassword"))
        .thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(authService: mockAuthService, isTesting: true,),
          
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

      // Verify that the user is navigated to the main page after auto-login success
      expect(find.byType(MainNavigationBar), findsOneWidget);
  });

  testWidgets("Auto Login Failure Functions as Expected", (WidgetTester tester) async {
    final mockAuthService = mocks.MockAuthService();

    // Mock the loadUserCredentials and login methods
    when(mockAuthService.loadUserCredentials()).thenAnswer((_) async => {
      "username": "mockUsername",
      "password": "mockPassword",
    });
    when(mockAuthService.login("mockUsername", "mockPassword")).thenThrow(Exception("Login failed"));

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


  });
}
