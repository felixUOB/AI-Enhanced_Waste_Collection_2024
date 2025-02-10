
import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/register/register.dart';
import 'package:ewc/widgets/hyperlink_text.dart';
import 'package:ewc/widgets/login_textfield.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:ewc/widgets/password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ewc/widgets/login_button.dart';
import "package:mockito/mockito.dart";
import 'mocks.mocks.dart' as mocks;

// Mock Url Launcher function to replace real urlLauncher
class MockUrlLauncher extends Mock {
  Future<bool> mockCanLaunchUrl(Uri url) => Future.value(true);
  void mockLaunchUrl(Uri url);
}

class MockPageRouter extends Mock {
  void mockPageRouter();
}

void main() {
  // Group of tests for the Login Page
  group('LoginPage Widget Tests', () {
    // Test to check if the LoginTextField has correct styling
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
      final mockUrlLauncher = MockUrlLauncher();
      final testUrl = Uri.parse("http://127.0.0.1:8000/reset_password/");

      // Mock the URL launcher behavior
      when(mockUrlLauncher.mockCanLaunchUrl(testUrl));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HyperLinkText(
            string1: "",
            hyperString: "Forgot Password?", // Pump Hyperlink text
            string2: "",
            onTap: () async {
              mockUrlLauncher.mockLaunchUrl(testUrl);
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
      verify(mockUrlLauncher.mockLaunchUrl(testUrl)).called(1);
    });

    // Test to check if the Register Here button routes to registration page
    testWidgets("Register Here button routes to registration page",
        (WidgetTester tester) async {
      mocks.MockAuthService  mockAuthService = mocks.MockAuthService();

      await tester.pumpWidget(MaterialApp(
          home: LoginPage(authService: mockAuthService,), routes: {"register": (_) => RegisterPage()}));

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

    // Test to check if the logo loads correctly
    testWidgets("Logo Loads Correctly", (WidgetTester tester) async {
      mocks.MockAuthService  mockAuthService = mocks.MockAuthService();

      await tester.pumpWidget(MaterialApp(home: LoginPage(authService: mockAuthService)));
      // Verify that the logo is displayed
      expect(find.byKey(ValueKey("logo")), findsOneWidget);
    });

    // Test to check if the SignIn button functions correctly on correct login
    testWidgets("SignIn Button Functions Correctly On Correct Login",
        (WidgetTester tester) async {
      mocks.MockAuthService  mockAuthService = mocks.MockAuthService();

      // Mock the login behavior
      when((mockAuthService.login("mockUsername", "mockPassword")))
          .thenAnswer((_) async {
        return Future.value();
      });
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: LoginButton(
            text1: "Sign In",
            onPressed: () async {
              await mockAuthService.login("mockUsername", "mockPassword");
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
      mocks.MockAuthService  mockAuthService = mocks.MockAuthService();
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(authService: mockAuthService,)
        ),
      );
      var rememberMe = tester.widget<Checkbox>(find.byKey(Key(("remember_me"))));
      expect(rememberMe.value, false);
      await tester.tap(find.byKey(Key(("remember_me"))));
      await tester.pumpAndSettle();

      // Retrieve the updated state of the checkbox
      rememberMe = tester.widget<Checkbox>(find.byKey(Key("remember_me")));
      expect(rememberMe.value, true);
    }
    );

    testWidgets("Remember Me Functions as Expected", (WidgetTester tester) async {
    final mockAuthService = mocks.MockAuthService();

    // Mock the saveUserCredentials and loadUserCredentials methods
    when(mockAuthService.saveUserCredentials("mockUsername", "mockPassword")).thenAnswer((_) async => Future.value());
    when(mockAuthService.loadUserCredentials()).thenAnswer((_) async => {
      "username": "mockUsername",
      "password": "mockPassword",
    });

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(authService: mockAuthService,),
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
    await mockAuthService.saveUserCredentials("mockUsername", "mockPassword");
    final credentials = await mockAuthService.loadUserCredentials();


    // Verify the credentials
    expect(credentials["username"], "mockUsername");
    expect(credentials["password"], "mockPassword");
  });

    testWidgets("SignIn fails if password is empty", (WidgetTester tester) async {
      final mockAuthService = mocks.MockAuthService();

      // If the username is "mockUsername" and the password is "", we expect an exception
      when(mockAuthService.login("mockUsername", ""))
          .thenThrow(Exception("Password missing"));

      // Build the test widget
      await tester.pumpWidget(MaterialApp(home: LoginPage(authService: mockAuthService)));

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

      // Verify that the login call with an empty password was indeed made and caused an exception
      verify(mockAuthService.login("mockUsername", "")).called(1);

      // Verify that an error message is displayed
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}
