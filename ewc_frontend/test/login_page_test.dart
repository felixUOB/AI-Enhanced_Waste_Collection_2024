import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/register/register.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:ewc/services/metrics_service.dart';
import 'package:ewc/widgets/hyperlink_text.dart';
import 'package:ewc/widgets/login_textfield.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:ewc/widgets/password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ewc/widgets/login_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import "package:mockito/mockito.dart";
import 'mocks/mock_service_locator.dart';
import 'mocks/mocks.mocks.dart';
import 'package:ewc/screens/map/map.dart';

class FakeGeolocatorPlatform extends GeolocatorPlatform { 
  @override Future<bool> isLocationServiceEnabled() async => true;

  @override Stream<ServiceStatus> getServiceStatusStream() { 
    // Provide a simple stream that immediately yields enabled. 
    return Stream<ServiceStatus>.value(ServiceStatus.enabled); 
  }

  @override Future<LocationPermission> checkPermission() async => LocationPermission.always;

  @override Future<LocationPermission> requestPermission() async => LocationPermission.always;

  @override Stream<Position> getPositionStream({LocationSettings? locationSettings}) { 
    // Return an empty stream so no position updates occur. 
    return Stream<Position>.empty(); 
    }
}

void main() {
  setUp(() async {
    await mockSetupLocator();
    GeolocatorPlatform.instance = FakeGeolocatorPlatform();
  });

  tearDown(() {
    getIt.reset();
  });

  group('LoginPage Widget Tests', () {
    testWidgets('LoginTextField has correct styling',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginTextfield(
              controller: controller,
              hintText: 'Email',
              key: Key("emailField"),
            ),
          ),
        ),
      );

      // Verify background color
      expect(find.byKey(Key("emailField")), findsOneWidget);
      final textFieldDecoration =
          tester.widget<TextField>(find.byType(TextField)).decoration;
      expect(textFieldDecoration?.fillColor,
          const Color.fromARGB(250, 240, 240, 240));

      // Verify focused border color
      final borderSide =
          (textFieldDecoration?.focusedBorder as OutlineInputBorder).borderSide;
      expect(borderSide.color, Colors.black);
    });

    // Test to check if the LoginTextField displays hint text correctly
    testWidgets('LoginTextField displays hint text correctly',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginTextfield(
              controller: controller,
              hintText: 'Email',
              key: Key("emailField"),
            ),
          ),
        ),
      );

      // Check if the hint text is displayed
      expect(find.text('Email'), findsOneWidget);
    });

    // Test to check if the PasswordTextfield displays hint and obscures text correctly
    testWidgets('PasswordTextfield displays hint and obscures text correctly',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordTextfield(
              controller: controller,
              hintText: 'Password',
              key: Key("passwordField"),
            ),
          ),
        ),
      );

      // Check if the hint text is displayed
      expect(find.text('Password'), findsOneWidget);

      // Check if the text field is initially obscured
      var textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);

      // Check if show password button correctly toggles obscuring text
      await tester.tap(find.byType(IconButton)); // Simulates tapping show password button
      await tester.pump();

      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isFalse); // Assure text is now not obscured

      await tester.tap(find.byType(IconButton)); // Simulates tapping show password button
      await tester.pump();

      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue); // Assure text is obscured again
    });

    // Test to check if the Forgot Password button routes to email reset page
    testWidgets("Forgot Password button routes to email reset page",
        (WidgetTester tester) async {
      // Mock the URL launcher behavior
      when(getIt<AuthService>().launchPasswordReset())
          .thenAnswer((_) async => Future<void>.value());

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HyperLinkText(
            string1: "",
            hyperString: "Forgot Password?", // Pump Hyperlink text
            string2: "",
            onTap: () {
              getIt<AuthService>().launchPasswordReset();
            },
          ),
        ),
      ));

      final richTextFinder = find.byWidgetPredicate(
        // Pulls text out of Rich Text Widget
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains("Forgot Password?"),
      );
      expect(richTextFinder, findsOneWidget); // Tests if present

      await tester.tap(richTextFinder); // Simulates tapping link
      await tester.pumpAndSettle();

      // Verify that the URL launcher was called
      verify(getIt<AuthService>().launchPasswordReset()).called(1);
    });

    // Test to check if the Register Here button routes to registration page
    testWidgets("Register Here button routes to registration page",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: LoginPage(), routes: {"register": (_) => RegisterPage()}));

      // Verify that the welcome text is displayed
      expect(find.text("Welcome Back!"), findsOneWidget);

      final richTextFinder = find.byWidgetPredicate(
        // Pulls text out of Rich Text Widget
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains("Register Here"),
      );
      await tester.tap(richTextFinder);
      await tester.pumpAndSettle();

      // Verify that the registration page is displayed
      expect(find.byKey(ValueKey("registerPage")), findsOneWidget);
    });

    testWidgets("Logo Loads Correctly", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));
      // Verify that the logo is displayed
      expect(find.byKey(ValueKey("logo")), findsOneWidget);
    });

    testWidgets("SignIn Button Functions Correctly On Correct Login",
        (WidgetTester tester) async {
      // Mock the login behavior
      when(getIt<AuthService>().login("mockUsername", "mockPassword"))
          .thenAnswer((_) async {
        return Future.value();
      });

      when(getIt<AuthService>().makeAuthenticatedRequest("route_env_data/"))
          .thenAnswer((_) async => Future.value(
                Response(
                  '[{"route_env_data_id": 1, "distance": 10.5, "mpg": 8.2, "date": "2023-10-01"}]', // JSON array string body
                  200, // Status code
                ),
              ));
      
      when(getIt<MetricsService>().fetchAllRoutes()).thenAnswer((_) async => []);
      
      when(getIt<AuthService>().makeAuthenticatedRequest("route-env-data-30-days/"))
          .thenAnswer((_) async => Future.value(
                Response(
                  '[{"route_env_data_id": 1, "distance": 10.5, "mpg": 8.2, "date": "2025-03-14"}]', // JSON array string body
                  200, // Status code
                ),
              ));
      when(getIt<MetricsService>().fetchLast30Days()).thenAnswer((_) async => []);

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: LoginButton(
            text1: "Sign In",
            onPressed: () async {
              await getIt<AuthService>().login("mockUsername", "mockPassword");
              Navigator.push(
                tester.element(find.byKey(Key('loginButton'))),
                MaterialPageRoute(
                    builder: (context) => MainNavigationBar(
                          testing: true,
                        )),
              );
            }),
      )));
      // Verify that the login button is displayed
      expect(find.byKey(Key("loginButton")), findsOneWidget);
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle();
      // Verify that the main navigation bar and map page are displayed
      expect(find.byKey(Key("mainNavigationBar")), findsOneWidget);
      expect(find.byKey(Key("mapPageReplacement")), findsOneWidget);
    });
    testWidgets("Remember Me Checkbox Functions as Expected",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: LoginPage()),
      );
      var rememberMe =
          tester.widget<Checkbox>(find.byKey(Key(("remember_me"))));
      expect(rememberMe.value, false);
      await tester.tap(find.byKey(Key(("remember_me"))));
      await tester.pumpAndSettle();

      // Retrieve the updated state of the checkbox
      rememberMe = tester.widget<Checkbox>(find.byKey(Key("remember_me")));
      expect(rememberMe.value, true);
    });

    testWidgets("Remember Me Functions as Expected",
        (WidgetTester tester) async {
      // Mock the saveUserCredentials and loadUserCredentials methods
      when(getIt<AuthService>()
              .saveUserCredentials("mockUsername", "mockPassword"))
          .thenAnswer((_) async => Future.value());
      when(getIt<AuthService>().loadUserCredentials()).thenAnswer((_) async => {
            "username": "mockUsername",
            "password": "mockPassword",
          });

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Initial state of the checkbox
      var rememberMe = tester.widget<Checkbox>(find.byKey(Key("remember_me")));
      expect(rememberMe.value, false);

      // Tap the checkbox
      await tester.tap(find.byKey(Key("remember_me")));
      await tester.pumpAndSettle();

      // Retrieve the updated state of the checkbox
      rememberMe = tester.widget<Checkbox>(find.byKey(Key("remember_me")));
      expect(rememberMe.value, true);

      // Call the mocked saveUserCredentials method
      await getIt<AuthService>()
          .saveUserCredentials("mockUsername", "mockPassword");
      final credentials = await getIt<AuthService>().loadUserCredentials();

      // Verify the credentials
      expect(credentials["username"], "mockUsername");
      expect(credentials["password"], "mockPassword");
    });

    testWidgets("SignIn fails if password is empty",
        (WidgetTester tester) async {
      // If the username is "mockUsername" and the password is "", we expect an exception
      when(getIt<AuthService>().login("mockUsername", ""))
          .thenThrow(Exception("Password missing"));

      when(getIt<Config>().inTestMode).thenReturn(true);

      when(getIt<MetricsService>().fetchAllRoutes()).thenAnswer((_) async => []);
      
      when(getIt<AuthService>().makeAuthenticatedRequest("route-env-data-30-days/"))
          .thenAnswer((_) async => Future.value(
                Response(
                  '[{"route_env_data_id": 1, "distance": 10.5, "mpg": 8.2, "date": "2025-03-14"}]', // JSON array string body
                  200, // Status code
                ),
              ));
      when(getIt<MetricsService>().fetchLast30Days()).thenAnswer((_) async => []);
      

      // Build the test widget
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Find the text fields and enter only the username
      final usernameFieldFinder = find.byKey(const Key('usernameField'));
      final passwordFieldFinder = find.byKey(const Key('passwordField'));

      await tester.enterText(usernameFieldFinder, 'mockUsername');
      await tester.enterText(passwordFieldFinder, "");
      await tester.pumpAndSettle();

      // Tap the login button
      final loginButtonFinder = find.byKey(const Key('loginButtonTop'));

      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle(Duration(seconds: 10));

      // Verify that the login call with never called because it wasn't allowed to submit it due to verification
      verifyNever(getIt<AuthService>().login("mockUsername", ""));
    });
  });
}
