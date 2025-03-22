import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';                    // when(...), any
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

// Mocks & service locator
import 'mocks/mock_service_locator.dart';                // mockSetupLocator()
import 'mocks/mocks.mocks.dart';                         // MockRouteService

import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/screens/route-schedule/schedule.dart';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/services/route_service.dart';

void main() {
  late MockRouteService mockRouteService;

  setUpAll(() async {
    // 1) Register Mock dependencies via mockSetupLocator
    await mockSetupLocator();
  });

  setUp(() {
    // 2) Reassign the existing RouteService to a mock
    getIt.allowReassignment = true;
    mockRouteService = getIt<RouteService>() as MockRouteService;
  });

  /// Helper to build the Schedule widget with given providers
  Widget createScheduleWidget({
    required StopsProvider stopsProvider,
    required LocationProvider locationProvider,
  }) {
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

  group('Schedule Page Tests', () {
    // testWidgets('Case 1: location == null => no "mins" displayed',
    //         (WidgetTester tester) async {
    //       // A) Provide stops (both unvisited)
    //       final stopsProvider = StopsProvider();
    //       stopsProvider.setStopsForTest([
    //         Stop(id: 1, name: 'Stop A', location: LatLng(51.5, -2.0), visited: false),
    //         Stop(id: 2, name: 'Stop B', location: LatLng(51.6, -2.1), visited: false),
    //       ]);
    //
    //       // B) location is null => getStopTimes(...) should NOT be called
    //       final locationProvider = LocationProvider();
    //       locationProvider.setLatestLocationForTest(null);
    //
    //       // Stub getStopTimes => if called, returns [5,10] (but we expect not to call)
    //       when(mockRouteService.getStopTimes(any, any))
    //           .thenAnswer((_) async => [5,10]);
    //
    //       // C) Pump
    //       await tester.pumpWidget(createScheduleWidget(
    //         stopsProvider: stopsProvider,
    //         locationProvider: locationProvider,
    //       ));
    //       await tester.pumpAndSettle();
    //
    //       // D) Verify "Stop A"/"Stop B" appear
    //       expect(find.text('Stop A'), findsOneWidget);
    //       expect(find.text('Stop B'), findsOneWidget);
    //
    //       // E) but "mins" text => none, because location == null => no getStopTimes
    //       expect(find.textContaining('mins'), findsNothing);
    //
    //       // F) Also verify getStopTimes was never called
    //       verifyNever(mockRouteService.getStopTimes(any, any));
    //     });

    // testWidgets('Case 2: 2 unvisited stops => getStopTimes => "mins" displayed',
    //         (WidgetTester tester) async {
    //       // A) Provide stops (unvisited)
    //       final stopsProvider = StopsProvider();
    //       stopsProvider.setStopsForTest([
    //         Stop(id: 1, name: 'Stop A', location: LatLng(51.5, -2.0), visited: false),
    //         Stop(id: 2, name: 'Stop B', location: LatLng(51.6, -2.1), visited: false),
    //       ]);
    //
    //       // B) location != null
    //       final locationProvider = LocationProvider();
    //       locationProvider.setLatestLocationForTest(LatLng(50, -2));
    //
    //       // C) Stub getStopTimes => e.g. [5,10]
    //       when(mockRouteService.getStopTimes(any, any))
    //           .thenAnswer((_) async => [5, 10]);
    //
    //       // D) Pump
    //       await tester.pumpWidget(createScheduleWidget(
    //         stopsProvider: stopsProvider,
    //         locationProvider: locationProvider,
    //       ));
    //       await tester.pumpAndSettle();
    //
    //       // E) "Stop A", "Stop B" + "mins" x2
    //       expect(find.text('Stop A'), findsOneWidget);
    //       expect(find.text('Stop B'), findsOneWidget);
    //       expect(find.textContaining('mins'), findsNWidgets(2));
    //
    //       // F) Also verify getStopTimes was called once
    //       verify(mockRouteService.getStopTimes(LatLng(50, -2), any)).called(1);
    //     });

    // testWidgets('Case 3: 1 visited + 1 unvisited => times array with 0 at visited index',
    //         (WidgetTester tester) async {
    //       // Suppose we have Stop A visited, Stop B not visited
    //       final stopsProvider = StopsProvider();
    //       stopsProvider.setStopsForTest([
    //         Stop(id: 1, name: 'Stop A', location: LatLng(51.5, -2.0), visited: true),
    //         Stop(id: 2, name: 'Stop B', location: LatLng(51.6, -2.1), visited: false),
    //       ]);
    //
    //       final locationProvider = LocationProvider();
    //       locationProvider.setLatestLocationForTest(LatLng(50, -2));
    //
    //       // visited=1 => _stopTimes[0] = 0
    //       // unvisited=1 => we expect getStopTimes => e.g. [8], so final => [0, 8]
    //       // => But in the UI, index=0 => visited => blank, index=1 => "8 mins"
    //       when(mockRouteService.getStopTimes(any, any))
    //           .thenAnswer((_) async => [8]);
    //
    //       await tester.pumpWidget(createScheduleWidget(
    //         stopsProvider: stopsProvider,
    //         locationProvider: locationProvider,
    //       ));
    //       await tester.pumpAndSettle();
    //
    //       // "Stop A" (visited => no "mins"), "Stop B" => "8 mins"
    //       expect(find.text('Stop A'), findsOneWidget);
    //       expect(find.text('Stop B'), findsOneWidget);
    //
    //       // We expect only 1 "mins" because first stop is visited => blank
    //       expect(find.textContaining('mins'), findsNWidgets(1));
    //       expect(find.text('8 mins'), findsOneWidget);
    //     });

    // testWidgets('Case 4: Pull-to-refresh => calls getStopTimes again',
    //         (WidgetTester tester) async {
    //       // single unvisited stop
    //       final stopsProvider = StopsProvider();
    //       stopsProvider.setStopsForTest([
    //         Stop(id: 1, name: 'Stop A', location: LatLng(51.5, -2.0), visited: false),
    //       ]);
    //
    //       final locationProvider = LocationProvider();
    //       locationProvider.setLatestLocationForTest(LatLng(50, -2));
    //
    //       // initial => [5]
    //       when(mockRouteService.getStopTimes(any, any))
    //           .thenAnswer((_) async => [5]);
    //
    //       await tester.pumpWidget(createScheduleWidget(
    //         stopsProvider: stopsProvider,
    //         locationProvider: locationProvider,
    //       ));
    //       await tester.pumpAndSettle();
    //
    //       // see "Stop A", "5 mins"
    //       expect(find.text('Stop A'), findsOneWidget);
    //       expect(find.text('5 mins'), findsOneWidget);
    //
    //       // now redefine => [10]
    //       when(mockRouteService.getStopTimes(any, any))
    //           .thenAnswer((_) async => [10]);
    //
    //       // pull-to-refresh
    //       final listFinder = find.byType(ListView);
    //       await tester.drag(listFinder, const Offset(0, 300));
    //       await tester.pumpAndSettle();
    //
    //       // now "10 mins"
    //       expect(find.text('10 mins'), findsOneWidget);
    //       expect(find.text('5 mins'), findsNothing);
    //
    //       // getStopTimes called 2 times total
    //       verify(mockRouteService.getStopTimes(LatLng(50, -2), any)).called(2);
    //     });

    testWidgets('Case 5: location != null but getStopTimes => empty => no "mins"',
            (WidgetTester tester) async {
          final stopsProvider = StopsProvider();
          stopsProvider.setStopsForTest([
            Stop(id: 1, name: 'Stop A', location: LatLng(51.5, -2.0), visited: false),
            Stop(id: 2, name: 'Stop B', location: LatLng(51.6, -2.1), visited: false),
          ]);

          final locationProvider = LocationProvider();
          locationProvider.setLatestLocationForTest(LatLng(50, -2));

          // if getStopTimes => [] => then _stopTimes length=0 => no "mins"
          when(mockRouteService.getStopTimes(any, any))
              .thenAnswer((_) async => []);

          await tester.pumpWidget(createScheduleWidget(
            stopsProvider: stopsProvider,
            locationProvider: locationProvider,
          ));
          await tester.pumpAndSettle();

          // "Stop A"/"Stop B" appear, but no "mins"
          expect(find.text('Stop A'), findsOneWidget);
          expect(find.text('Stop B'), findsOneWidget);
          expect(find.textContaining('mins'), findsNothing);
        });

//     testWidgets('Case 6: getStopTimes => throws => triggers "Failed to initialize map service..."',
//             (WidgetTester tester) async {
//           // Provide stops, location
//           final stopsProvider = StopsProvider();
//           stopsProvider.setStopsForTest([
//             Stop(id: 1, name: 'Stop A', location: LatLng(51.5, -2.0), visited: false),
//           ]);
//
//           final locationProvider = LocationProvider();
//           locationProvider.setLatestLocationForTest(LatLng(50, -2));
//
//           // force an exception
//           when(mockRouteService.getStopTimes(any, any))
//               .thenThrow(Exception('Test route error'));
//
//           // The code in initialiseStops() catches => rethrows as
//           // "Failed to initialize map service..."
//           // So we expect an Exception of type Exception.
//           await tester.runAsync(() async {
//             expectLater(
//                   () => tester.pumpWidget(createScheduleWidget(
//                 stopsProvider: stopsProvider,
//                 locationProvider: locationProvider,
//               )),
//               throwsA(isA<Exception>()),
//             );
//             await tester.pumpAndSettle();
//           });
//         });
//   });
// }