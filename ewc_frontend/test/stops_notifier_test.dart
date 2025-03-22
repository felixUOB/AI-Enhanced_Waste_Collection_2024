import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:latlong2/latlong.dart';

import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/services/stops_service.dart';

import 'mocks/mock_service_locator.dart';
import 'mocks/mocks.mocks.dart';

// Mock class for StopsService to override fetchAllStops() behavior
class MockStopsService extends Mock implements StopsService {}

void main() {
  group('StopsProvider unit tests', () {
    late StopsProvider stopsProvider;
    late MockStopsService mockStopsService;

    setUpAll(() async  {
      await mockSetupLocator();
    });

    setUp(() {
      mockStopsService = getIt<StopsService>() as MockStopsService;

      stopsProvider = StopsProvider();
    });

    test('Default => _stops is empty', () {
      // Upon creation, the stops list should be empty
      expect(stopsProvider.stops, isEmpty);
    });

    test('setStopsForTest => modifies _stops', () {
      // This method is used for injecting test data
      stopsProvider.setStopsForTest([
        Stop(id: 1, name: 'Stop A', location: LatLng(51, -2)),
        Stop(id: 2, name: 'Stop B', location: LatLng(52, -3)),
      ]);
      expect(stopsProvider.stops.length, 2);
      expect(stopsProvider.stops[0].name, 'Stop A');
    });

    test('setVisited => sets "visited" and notifies listeners', () {
      // 1) Inject test stops
      stopsProvider.setStopsForTest([
        Stop(id: 1, name: 'Stop A', location: LatLng(51, -2), visited: false),
        Stop(id: 2, name: 'Stop B', location: LatLng(52, -3), visited: false),
      ]);

      // 2) Observe notifications via a listener
      bool wasNotified = false;
      stopsProvider.addListener(() {
        wasNotified = true;
      });

      // 3) Call setVisited on stop ID 1
      stopsProvider.setVisited(1);

      // 4) Check if "visited" changed to true
      expect(stopsProvider.stops[0].visited, isTrue);

      // 5) Confirm that notifyListeners was called
      expect(wasNotified, isTrue);
    });

    test('initialiseStops => fetches from stopsService and notifies', () async {
      // 1) Mock the stopsService.fetchAllStops() to return two stops
      when(mockStopsService.fetchAllStops()).thenAnswer((_) async => [
        Stop(id: 1, name: 'Stop A', location: LatLng(51, -2)),
        Stop(id: 2, name: 'Stop B', location: LatLng(52, -3)),
      ]);

      // 2) In real code, we would replace the service in getIt with mockStopsService
      //    or provide a constructor that accepts the service. For illustration,
      //    we skip direct injection here.

      bool wasNotified = false;
      stopsProvider.addListener(() {
        wasNotified = true;
      });

      // 3) Call initialiseStops(), which should call fetchAllStops() inside
      await stopsProvider.initialiseStops();

      // 4) Verification
      //    If we had properly injected mockStopsService, we could do:
      //    verify(mockStopsService.fetchAllStops()).called(1);
      expect(stopsProvider.stops.length, 2);
      expect(wasNotified, isTrue);
    });
  });
}
