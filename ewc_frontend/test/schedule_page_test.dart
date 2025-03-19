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

  setUp(() async {
    // Reassigning the existing RouteService in the service locator to a mock
    getIt.allowReassignment = true;
    mockRouteService = MockRouteService();
    getIt.registerSingleton<RouteService>(mockRouteService);

    // Instantiate real providers
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

