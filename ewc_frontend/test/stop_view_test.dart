import 'package:ewc/models/stop_model.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/screens/route-schedule/stop_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'mocks/mock_service_locator.dart';

Widget pumpStopsView() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LocationProvider>(create: (_) => LocationProvider()),
      ChangeNotifierProvider<StopsProvider>(create: (_) => StopsProvider()),
    ],
    child: MaterialApp(
      home: StopView(
        id: 1,
        name: 'Test stop',
        visited: false,
        description: 'This is a stop used for testing'
      ),
    )
  );
}

Widget pumpStopsViewVisited(StopsProvider stopsProvider) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LocationProvider>(create: (_) => LocationProvider()),
      ChangeNotifierProvider<StopsProvider>.value(value: stopsProvider),
    ],
    child: MaterialApp(
      home: StopView(
        id: 1,
        name: 'Test stop',
        visited: true,
        description: 'This is a stop used for testing'
      ),
    )
  );
}

void main() {
  setUp(() async {
    await mockSetupLocator();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('Stop View tests', () {
    testWidgets('Stop View initialises correctly when visited is false', (WidgetTester tester) async {
      await tester.pumpWidget(pumpStopsView());
      await tester.pumpAndSettle();
      
      expect(find.byKey(Key('stop name')), findsOneWidget);
      expect(find.byKey(Key('stop description')), findsOneWidget);
      expect(find.byKey(Key('save button')), findsOneWidget);
      expect(find.byKey(Key('back button')), findsOneWidget);

      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('Stop View initialises correctly when visited is true', (WidgetTester tester) async {
      StopsProvider stopsProvider = StopsProvider();
      stopsProvider.addStopCollection(1, 20);
      await tester.pumpWidget(pumpStopsViewVisited(stopsProvider));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('stop name')), findsOneWidget);
      expect(find.byKey(Key('stop description')), findsOneWidget);
      expect(find.byKey(Key('save button')), findsOneWidget);
      expect(find.byKey(Key('back button')), findsOneWidget);

      expect(find.text('Collected amount - 20kg'), findsOneWidget);
      expect(find.byKey(Key('unvisit button')), findsOneWidget);
    });

    testWidgets('ensure clicking back with unsaved changes brings up dialog', (WidgetTester tester) async {
      StopsProvider stopsProvider = StopsProvider();
      stopsProvider.addStopCollection(1, 20);
      await tester.pumpWidget(pumpStopsViewVisited(stopsProvider));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('unvisit button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('back button')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('unsaved warn dialog')), findsOneWidget);
    });

    testWidgets('ensure clicking Cancel dismisses dialog', (WidgetTester tester) async {
      StopsProvider stopsProvider = StopsProvider();
      stopsProvider.addStopCollection(1, 20);
      await tester.pumpWidget(pumpStopsViewVisited(stopsProvider));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('unvisit button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('back button')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('unsaved warn dialog')), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('unsaved warn dialog')), findsNothing);
    });

    testWidgets('ensure clicking Quit without saving dismisses dialog', (WidgetTester tester) async {
      StopsProvider stopsProvider = StopsProvider();
      stopsProvider.addStopCollection(1, 20);
      await tester.pumpWidget(pumpStopsViewVisited(stopsProvider));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('unvisit button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('back button')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('unsaved warn dialog')), findsOneWidget);

      await tester.tap(find.text('Quit without saving'));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('unsaved warn dialog')), findsNothing);
    });

    testWidgets('ensure clicking back button with no changes does not display dialog', (WidgetTester tester) async {
      await tester.pumpWidget(pumpStopsView());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('back button')));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('unsaved warn dialog')), findsNothing);
    });

    testWidgets('ensure save button alters status of stop', (WidgetTester tester) async {
      StopsProvider stopsProvider = StopsProvider();
      stopsProvider.updateStopOrder([
        Stop(
          id: 1,
          name: 'Test stop',
          visited: true,
          location: LatLng(0, 0),
          description: 'This is a stop used for testing'
        )
      ]);
      stopsProvider.addStopCollection(1, 20);
      await tester.pumpWidget(pumpStopsViewVisited(stopsProvider));
      await tester.pumpAndSettle();

      expect(stopsProvider.stops[0].visited, isTrue);

      await tester.tap(find.byKey(Key('unvisit button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('save button')));
      await tester.pumpAndSettle();

      expect(stopsProvider.stopCollectionLog, isEmpty);
      expect(stopsProvider.stops[0].visited, isFalse);
    });
  });
}