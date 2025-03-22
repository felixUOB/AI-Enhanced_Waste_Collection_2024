import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/screens/route-schedule/schedule.dart';
import 'package:ewc/models/stop_model.dart';

void main() {
  testWidgets('Minimal coverage test for Schedule', (WidgetTester tester) async {
    // 1) Create providers
    // Instantiate StopsProvider and manually set some test stops.
    // This ensures the widget will have a small dataset to display.
    final stopsProvider = StopsProvider();
    stopsProvider.setStopsForTest([
      Stop(
        id: 1,
        name: 'Stop A',
        location: LatLng(51.5, -2.0),
      ),
      Stop(
        id: 2,
        name: 'Stop B',
        location: LatLng(51.6, -2.1),
      ),
    ]);

    // Similarly, create a LocationProvider and set a test location.
    final locationProvider = LocationProvider();
    locationProvider.setLatestLocationForTest(LatLng(50, -2));

    // 2) Render the Schedule widget inside a MultiProvider
    // - This provides both StopsProvider and LocationProvider to the widget tree.
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

    // 3) Wait for all widgets to settle
    await tester.pumpAndSettle();

    // 4) Checks
    // Verifies that "Stop A" and "Stop B" texts are found in the widget tree
    // This indirectly confirms that the Schedule widget renders them as expected.
    expect(find.text('Stop A'), findsOneWidget);
    expect(find.text('Stop B'), findsOneWidget);
  });
}
