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

    testWidgets('Case: location != null but getStopTimes => empty => no "mins"',
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
  });
}