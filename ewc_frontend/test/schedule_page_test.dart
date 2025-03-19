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


// NO TESTING NEEDED UNTIL API IS LINKED AS ALL IS HARDCODED INTO PAGE AND UNCHANGING
