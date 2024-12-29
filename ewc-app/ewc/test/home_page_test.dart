import 'dart:math';

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
import 'package:ewc/screens/map/map_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:ewc/services/route_plot_api.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets("Metric Page Button Functions Correctly",
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MainNavigationBar(
          testing: true,
        ),
      ));
      await tester.pumpAndSettle();

      final metricsDestination = find.byWidgetPredicate(
        (widget) =>
            widget is NavigationDestination && widget.label == "Metrics",
      );
      expect(metricsDestination, findsOneWidget);
      await tester.tap(metricsDestination);
      await tester.pumpAndSettle();
      expect(find.text("Metrics Page"), findsOneWidget);
    });
  });
}
