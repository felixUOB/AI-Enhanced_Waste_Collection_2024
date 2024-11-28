import 'package:ewc/screens/login/login.dart';
import 'package:ewc/widgets/hyperlink_text.dart';
import 'package:ewc/widgets/login_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ewc/api/auth_service.dart';
import "package:mockito/mockito.dart";
import 'package:url_launcher/url_launcher.dart';

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
            ),
          ),
        ),
      );

      // verify background color
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
  });
}

class MockUrlLauncher extends Mock {
  Future<bool> mockCanLaunchUrl(Uri url) => Future.value(true);
  void mockLaunchUrl(Uri url);
}
