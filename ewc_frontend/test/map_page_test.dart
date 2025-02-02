
import 'package:ewc/screens/map/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Map Page Tests', () {
    // Setup and Initialisation Tests
    testWidgets('Map Page initialises correctly', (WidgetTester tester) async{
      await tester.pumpWidget(MaterialApp(home: MapPage()));
      expect(find.byType(MapPage), findsOneWidget);
    });

  });

}