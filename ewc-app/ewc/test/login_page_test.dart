import 'package:ewc/api/auth_service.dart';
import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/map/map.dart';
import 'package:ewc/screens/register/register.dart';
import 'package:ewc/widgets/hyperlink_text.dart';
import 'package:ewc/widgets/login_textfield.dart';
import 'package:ewc/widgets/main_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ewc/widgets/login_button.dart';
import 'package:mockito/annotations.dart';
import "package:mockito/mockito.dart";
import 'login_page_test.mocks.dart';

class MockUrlLauncher extends Mock {
  Future<bool> mockCanLaunchUrl(Uri url) => Future.value(true);
  void mockLaunchUrl(Uri url);
}

class MockPageRouter extends Mock {
  void mockPageRouter();
}

@GenerateMocks([AuthService, MapPage])
void main() {
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
              obscured: false,
              key: Key("emailField"),
            ),
          ),
        ),
      );

      // verify background color
      expect(find.byKey(Key("emailField")), findsOneWidget);
      final textFieldDecoration =
          tester.widget<TextField>(find.byType(TextField)).decoration;
      expect(textFieldDecoration?.fillColor,
          const Color.fromARGB(250, 240, 240, 240));

      // verify focused border color
      final borderSide =
          (textFieldDecoration?.focusedBorder as OutlineInputBorder).borderSide;
      expect(borderSide.color, Colors.black);
    });

    testWidgets('LoginTextField displays hint and obscures text correctly',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginTextfield(
              controller: controller,
              hintText: 'Email',
              obscured: true,
              key: Key("emailField"),
            ),
          ),
        ),
      );

      // check if the hint text is displayed
      expect(find.text('Email'), findsOneWidget);

      // check if the text field is initially obscured
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets("Forgot Password button routes to email reset page",
        (WidgetTester tester) async {
      final mockUrlLauncher = MockUrlLauncher();
      final testUrl = Uri.parse("http://127.0.0.1:8000/reset_password/");

      when(mockUrlLauncher.mockCanLaunchUrl(testUrl));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HyperLinkText(
            string1: "",
            hyperString: "Forgot Password?", //Pump Hyperlink text
            string2: "",
            onTap: () async {
              mockUrlLauncher.mockLaunchUrl(testUrl);
            },
          ),
        ),
      ));

      final richTextFinder = find.byWidgetPredicate(
        //Pulls text out of Rich Text Widget
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains("Forgot Password?"),
      );
      expect(richTextFinder, findsOneWidget); //Tests if present

      await tester.tap(richTextFinder); //Simulates Tapping link
      await tester.pumpAndSettle();

      verify(mockUrlLauncher.mockLaunchUrl(testUrl)).called(1);
    });
    testWidgets("Register Here button routes to registration page",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: LoginPage(), routes: {"register": (_) => RegisterPage()}));

      expect(find.text("Welcome Back!"), findsOneWidget);

      final richTextFinder = find.byWidgetPredicate(
        //Pulls text out of Rich Text Widget
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains("Register Here"),
      );
      await tester.tap(richTextFinder);
      await tester.pumpAndSettle();

      expect(find.text("Create an Account"), findsOneWidget);
    });

    testWidgets("Logo Loads Correctly", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Image.asset(
            "assets/RecycleNXT-Logo_Update_Black.png",
            scale: 8,
          ),
        ),
      ));
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
    });
    testWidgets("SignIn Button Functions Correctly On Correct Login",
        (WidgetTester tester) async {
      MockAuthService mockAuth = MockAuthService();

      when((mockAuth.login("mockUsername", "mockPassword")))
          .thenAnswer((_) async {
        return Future.value();
      });

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: LoginButton(
            text1: "Sign In",
            onPressed: () async {
              await mockAuth.login("mockUsername", "mockPassword");
              Navigator.push(
                tester.element(find.byKey(Key('loginButton'))),
                MaterialPageRoute(
                    builder: (context) =>
                        MainNavigationBar(altRouteService: null)),
              );
            }),
      )));
      expect(find.byKey(Key("loginButton")), findsOneWidget);
      await tester.tap(find.byKey(Key('loginButton')));
      await tester.pumpAndSettle();
      expect(find.text("RecycleNXT"), findsOneWidget);
    });
  });
}
