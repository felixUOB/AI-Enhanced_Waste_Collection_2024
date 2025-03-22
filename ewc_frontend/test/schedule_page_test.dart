import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

// GetIt setup for the test environment
import 'mocks/mock_service_locator.dart';    // Contains mockSetupLocator()
import 'mocks/mocks.mocks.dart';            // Provides MockRouteService, etc.

import 'package:mockito/mockito.dart';

import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/screens/route-schedule/schedule.dart';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/services/route_service.dart';

void main() {
  late MockRouteService mockRouteService;

  setUpAll(() async {
    // 1) Calls mockSetupLocator(), which registers MockStopsService, MockRouteService, etc. in GetIt
    await mockSetupLocator();

    // 2) Retrieve the registered RouteService and cast it to MockRouteService
    mockRouteService = getIt<RouteService>() as MockRouteService;

    // 3) Define the behavior of getStopTimes(...) to return [5, 10]
    //    This matches our test scenario of having exactly two stops
    when(mockRouteService.getStopTimes(any, any))
        .thenAnswer((_) async => [5, 10]);
  });

  testWidgets('Coverage test for Schedule', (WidgetTester tester) async {
    // 4) Create a StopsProvider and provide two test stops
    final stopsProvider = StopsProvider();
    stopsProvider.setStopsForTest([
      Stop(id: 1, name: 'Stop A', location: LatLng(51.5, -2.0)),
      Stop(id: 2, name: 'Stop B', location: LatLng(51.6, -2.1)),
    ]);

    // 5) Create a LocationProvider with a non-null location
    final locationProvider = LocationProvider();
    locationProvider.setLatestLocationForTest(LatLng(50, -2));

    // 6) Render the Schedule widget within a MultiProvider
    //    This ensures both providers are available to the widget.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<StopsProvider>.value(value: stopsProvider),
          ChangeNotifierProvider<LocationProvider>.value(value: locationProvider),
        ],
        child: const MaterialApp(
          home: Schedule(), // The widget under test
        ),
      ),
    );

    // 7) Allow time for async methods (initState -> getStopTimes) to complete
    await tester.pumpAndSettle();

    // 8) Verify that the expected stop names are displayed
    expect(find.text('Stop A'), findsOneWidget);
    expect(find.text('Stop B'), findsOneWidget);

    // 9) Verify that "mins" appears exactly twice
    expect(find.textContaining('mins'), findsNWidgets(2));
  });
}
