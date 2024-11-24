// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

import 'package:ewc/widgets/login_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  // input page tests
  group('InputPage Widget Tests', (){
    testWidgets('LoginTextField has correct styling', (WidgetTester tester) async{
    final controller = TextEditingController();
    
    await tester.pumpWidget(
      MaterialApp(
        home:Scaffold(
          body: LoginTextfield(
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
  // testWidgets('LoginTextField displays hint and obscures text correctly', (WidgetTester tester) async {
  //   final controller = TextEditingController();
    
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home:Scaffold(
  //         body: LoginTextfeild(
  //           controller: controller, 
  //           hintText: 'Email', 
  //           obscured: true,
  //           ),
  //       ),
  //     ),
  //   );

  //   // check if the hint text is displayed
  //   expect(find.text('Email'), findsOneWidget);

  //   // check if the text field is initially obscured
  //   final textField = tester.widget<TextField>(find.byType(TextField));
  //   expect(textField.obscureText, isTrue);
  // });

  // testWidgets('LoginTextField accepts input', (WidgetTester tester) async {
  //   final controller = TextEditingController();
    
  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home:Scaffold(
  //         body: LoginTextfeild(
  //           controller: controller, 
  //           hintText: 'Email', 
  //           obscured: false,
  //           ),
  //       ),
  //     ),
  //   );

  //   // Enter text into the text field
  //   await tester.enterText(find.byType(TextField), 'testuser');
  //   await tester.pump();

  //   // check if the controller's text matches the entered text
  //   expect(controller.text, 'testuser');
  // });


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
  );
}

//   // schedule page tests

//   group('SchedulePage Widget Tests', (){
//     final List<List<Object>> sampleContent = [
//         ["Stop 1", 5],
//         ["Stop 2", 10],
//         ["Stop 3", 15],
//       ];
//     testWidgets('Renders the correct number of list items', (WidgetTester tester) async {
      
//       await tester.pumpWidget(
//         MaterialApp(
//           home:Scaffold(
//             body: ScheduleStopList(
//               content: sampleContent
//               )
//           ),
//         ),
//       );

//       expect(find.byType(Container), findsNWidgets(sampleContent.length));
//     });

//     testWidgets('minutes and text displayed', (WidgetTester tester) async {
      
//       await tester.pumpWidget(
//         MaterialApp(
//           home:Scaffold(
//             body: ScheduleStopList(
//               content: sampleContent
//               )
//           ),
//         ),
//       );

//       for (var item in sampleContent){
//         expect(find.text(item[0].toString()), findsOneWidget);
//         expect(find.text('${item[1].toString()} mins'), findsOneWidget);
//       }
      
//     });
//     testWidgets('applied correct padding, margin and test style', (WidgetTester tester) async {
      
//       await tester.pumpWidget(
//         MaterialApp(
//           home:Scaffold(
//             body: ScheduleStopList(
//               content: sampleContent
//               )
//           ),
//         ),
//       );

//       final container = tester.widget<Container>(find.byType(Container).first);

//       expect(container.padding, const EdgeInsets.all(15));
//       expect(container.margin, const EdgeInsets.only(left:12, right: 12, bottom: 12));
      
//     });
    
//   });

  

// }