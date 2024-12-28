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

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets("Metric Page Button Functions Correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MainNavigationBar(),
      ));
      expect(find.byKey(Key("metricsLink")), findsOneWidget);
      await tester.tap(find.byKey(Key("metricsLink")));
      await tester.pumpAndSettle();
      expect(find.byKey(Key("metricsPageAppBar")), findsOneWidget);
    });
  });
}
