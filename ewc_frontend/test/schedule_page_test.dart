import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:latlong2/latlong.dart';

import 'package:ewc/screens/route-schedule/schedule.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'mocks/mock_service_locator.dart';

import 'mocks/mocks.mocks.dart';

void main() {
  late MockRouteService mockRouteService;
  late StopsProvider stopsProvider;
  late LocationProvider locationProvider;

  // Helper: sets up the widget with both providers
  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StopsProvider>.value(value: stopsProvider),
        ChangeNotifierProvider<LocationProvider>.value(value: locationProvider),
      ],
      child: const MaterialApp(
        home: Schedule(),
      ),
    );
  }

  // 1) Make sure we do mockSetupLocator() at least once
  setUpAll(() async {
    await mockSetupLocator();
  });

  // 2) Then for each test, we can reassign RouteService if we want
  setUp(() {
    getIt.allowReassignment = true;

    // Replace the existing RouteService in getIt
    mockRouteService = MockRouteService();
    getIt.registerSingleton<RouteService>(mockRouteService);

    stopsProvider = StopsProvider();
    locationProvider = LocationProvider();
  });
  

  group('Schedule widget tests', () {
    testWidgets('Case 1: location == null => no getStopTimes call',
            (WidgetTester tester) async {
          // Provide some stops (two stops, neither visited)
          final stopA = Stop(id: 1, name: 'Stop A', location: LatLng(51.5, -2.0));
          final stopB = Stop(id: 2, name: 'Stop B', location: LatLng(51.6, -2.1));

          // Use setStopsForTest to inject data
          stopsProvider.setStopsForTest([stopA, stopB]);

          // location is null
          locationProvider.setLatestLocationForTest(null);

          // Stub getStopTimes (should NOT be called if location == null)
          when(mockRouteService.getStopTimes(any, any)).thenAnswer((_) async => [5, 10]);

          // Render the widget
          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          // Verify getStopTimes was never called
          verifyNever(mockRouteService.getStopTimes(any, any));

          // "Stop A" / "Stop B" are shown, but no "mins" text
          expect(find.text('Stop A'), findsOneWidget);
          expect(find.text('Stop B'), findsOneWidget);
          expect(find.textContaining('mins'), findsNothing);
        });

    testWidgets('Case 2: location != null => getStopTimes is called, times shown',
            (WidgetTester tester) async {
          // Provide stops (both unvisited)
          final stopA = Stop(id: 1, name: 'Stop A', location: LatLng(51.5, -2.0));
          final stopB = Stop(id: 2, name: 'Stop B', location: LatLng(51.6, -2.1));
          stopsProvider.setStopsForTest([stopA, stopB]);

          // locationProvider has a valid location
          locationProvider.setLatestLocationForTest(LatLng(50.0, -2.0));

          // Mock getStopTimes => [5, 8]
          when(mockRouteService.getStopTimes(any, any)).thenAnswer((_) async => [5, 8]);

          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          // Ensure getStopTimes was called once
          verify(mockRouteService.getStopTimes(LatLng(50.0, -2.0), any)).called(1);

          // We see "Stop A" / "Stop B" and "5 mins" / "8 mins"
          expect(find.text('Stop A'), findsOneWidget);
          expect(find.text('Stop B'), findsOneWidget);
          expect(find.text('5 mins'), findsOneWidget);
          expect(find.text('8 mins'), findsOneWidget);
        });

    testWidgets('Case 3: visited stops => times array is padded with 0',
            (WidgetTester tester) async {
          // 3 stops: A visited, B/C unvisited
          final stopA = Stop(
            id: 1,
            name: 'Stop A',
            location: LatLng(51.5, -2.0),
            visited: true,
          );
          final stopB = Stop(
            id: 2,
            name: 'Stop B',
            location: LatLng(51.6, -2.1),
            visited: false,
          );
          final stopC = Stop(
            id: 3,
            name: 'Stop C',
            location: LatLng(51.7, -2.2),
            visited: false,
          );

          stopsProvider.setStopsForTest([stopA, stopB, stopC]);
          locationProvider.setLatestLocationForTest(LatLng(50.0, -2.0));

          // visited=1 => we pad with 0, unvisited=2 => getStopTimes => [5,12]
          when(mockRouteService.getStopTimes(any, any)).thenAnswer((_) async => [5, 12]);

          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          // Check we see names A/B/C
          expect(find.text('Stop A'), findsOneWidget);
          expect(find.text('Stop B'), findsOneWidget);
          expect(find.text('Stop C'), findsOneWidget);

          // B => "5 mins", C => "12 mins", A => visited => blank
          expect(find.text('5 mins'), findsOneWidget);
          expect(find.text('12 mins'), findsOneWidget);
          // We only see "mins" exactly 2 times
          expect(find.textContaining('mins'), findsNWidgets(2));
        });

    testWidgets('Case 4: RefreshIndicator => calls getStopTimes again',
            (WidgetTester tester) async {
          // Single stop, unvisited
          final stopA = Stop(
            id: 1,
            name: 'Stop A',
            location: LatLng(51.5, -2.0),
            visited: false,
          );
          stopsProvider.setStopsForTest([stopA]);
          locationProvider.setLatestLocationForTest(LatLng(50.0, -2.0));

          // Initial => [5]
          when(mockRouteService.getStopTimes(any, any)).thenAnswer((_) async => [5]);

          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          // See "5 mins"
          expect(find.text('5 mins'), findsOneWidget);

          // Redefine => [10]
          when(mockRouteService.getStopTimes(any, any)).thenAnswer((_) async => [10]);

          // Pull down the ListView to refresh
          final listFinder = find.byType(ListView);
          await tester.drag(listFinder, const Offset(0, 300));
          await tester.pumpAndSettle();

          // Now we see "10 mins" instead of "5 mins"
          expect(find.text('10 mins'), findsOneWidget);
          expect(find.text('5 mins'), findsNothing);

          // getStopTimes is called twice total (initial + refresh)
          verify(mockRouteService.getStopTimes(LatLng(50.0, -2.0), any)).called(2);
        });

    testWidgets('Case 5: no stops => empty ListView', (WidgetTester tester) async {
      // Provide an empty list of stops
      stopsProvider.setStopsForTest([]);
      locationProvider.setLatestLocationForTest(LatLng(50.0, -2.0));

      // getStopTimes => []
      when(mockRouteService.getStopTimes(any, any)).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // There's a ListView, but no items => no 'mins' text
      expect(find.byType(ListView), findsOneWidget);
      expect(find.textContaining('mins'), findsNothing);
    });

    testWidgets('Case 6: Exception thrown => coverage of catch block',
            (WidgetTester tester) async {
          // Provide a single stop
          final stopA = Stop(
            id: 1,
            name: 'Stop A',
            location: LatLng(51.5, -2.0),
            visited: false,
          );
          stopsProvider.setStopsForTest([stopA]);
          locationProvider.setLatestLocationForTest(LatLng(50.0, -2.0));

          // Throw an exception in getStopTimes => triggers catch => rethrow
          when(mockRouteService.getStopTimes(any, any))
              .thenThrow(Exception('Test route error'));

          await tester.runAsync(() async {
            // We expect the widget to throw an exception
            expectLater(
                  () => tester.pumpWidget(createTestWidget()),
              throwsA(isA<Exception>()),
            );
          });
        });
  });
}
