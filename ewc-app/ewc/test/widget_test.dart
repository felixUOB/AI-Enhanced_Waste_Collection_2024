// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ewc/imports/imports.dart';
import 'package:ewc/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('LoginTextField has correct styling', (WidgetTester tester) async{
    final controller = TextEditingController();
    
    await tester.pumpWidget(
      MaterialApp(
        home:Scaffold(
          body: LoginTextfeild(
            controller: controller, 
            hintText: 'Email', 
            obscured: false,
            ),
        ),
      ),
    );

    // verify background color
    final textFieldDectoration = tester.widget<TextField>(find.byType(TextField)).decoration;
    expect(textFieldDectoration?.fillColor, const Color.fromARGB(250, 240, 240, 240));

    // verify focused border color
    final borderSide = (textFieldDectoration?.focusedBorder as OutlineInputBorder).borderSide;
    expect(borderSide.color, Colors.black);
  }
  );
  testWidgets('LoginTextField displays hint and obscures text correctly', (WidgetTester tester) async {
    final controller = TextEditingController();
    
    await tester.pumpWidget(
      MaterialApp(
        home:Scaffold(
          body: LoginTextfeild(
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

  testWidgets('LoginTextField accepts input', (WidgetTester tester) async {
    final controller = TextEditingController();
    
    await tester.pumpWidget(
      MaterialApp(
        home:Scaffold(
          body: LoginTextfeild(
            controller: controller, 
            hintText: 'Email', 
            obscured: false,
            ),
        ),
      ),
    );

    // Enter text into the text field
    await tester.enterText(find.byType(TextField), 'testuser');
    await tester.pump();

    // check if the controller's text matches the entered text
    expect(controller.text, 'testuser');
  });

  // testWidgets('Tapping "Forgot Password?" triggers onTap callback', (WidgetTester tester) async{

  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: Scaffold(
  //         body: HyperLinkText(
  //           string1: '',
  //           hyperString: 'Forgot Password?',
  //           string2: '',
  //           link: Uri.parse('https://en.wikipedia.org/wiki/Lamia'),
  //         )
  //       )
  //       )
  //   );
  //   await tester.pump();
  //   // certify that the "Forgot password" text is present
  //   expect(find.text('Forgot Password?'), findsOneWidget);

  //   // simulate a tap on the "Forogto password" link
  //   await tester.tap(find.text('Forgot Password?'));
  //   await tester.pumpAndSettle();
  // });

}