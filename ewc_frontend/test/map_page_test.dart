import 'dart:async';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/widgets/orientate_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';
import 'mocks/mock_service_locator.dart';
import 'package:ewc/screens/map/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:provider/provider.dart';

class FakeGeolocatorPlatform extends GeolocatorPlatform { 
  @override Future<bool> isLocationServiceEnabled() async => true;

  @override Stream<ServiceStatus> getServiceStatusStream() { 
    // Provide a simple stream that immediately yields enabled. 
    return Stream<ServiceStatus>.value(ServiceStatus.enabled); 
  }

  @override Future<LocationPermission> checkPermission() async => LocationPermission.always;

  @override Future<LocationPermission> requestPermission() async => LocationPermission.always;

  @override Stream<Position> getPositionStream({LocationSettings? locationSettings}) { 
    // Return an empty stream so no position updates occur. 
    return Stream<Position>.empty(); 
    }
}

Widget pumpMap() {
  return MaterialApp(
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider<StopsProvider>(
          create: (_) => StopsProvider(),
        ),
      ],
      child: MapPage(),
    ),
  );
}

Future<List<Stop>> getMockStopList(){
  var completer = Completer<List<Stop>>();
  completer.complete([Stop(id: 1, name: 'test', location: LatLng(0, 0))]);
  return completer.future;
}

void main() {
  // Set the fake GeolocatorPlatform before tests run 
  setUp(() async {
    await mockSetupLocator();
    when(getIt<Config>().inTestMode).thenReturn(true);
    when(getIt<StopsService>().fetchAllStops()).thenAnswer((request) {return getMockStopList();} );
    when(getIt<StopsService>().postStopCollection(1, 10)).thenAnswer((request) {return Completer<void>().future;});
    GeolocatorPlatform.instance = FakeGeolocatorPlatform();
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('Map Page Tests', () {
    // Setup and Initialisation Tests
    testWidgets('Map Page initialises correctly', (WidgetTester tester) async{
      await tester.pumpWidget(pumpMap());

      expect(find.byType(MapPage), findsOneWidget);
      expect(find.byType(FlutterMap), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsExactly(4));
    });

    // ====== START JOURNEY DIALOG REMOVED ======
    /* @Skip('No longer using Start Journey dialog')
    testWidgets('Start Journey dialog shows on Start tap and dismisses on Cancel tap', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());

      // Open the journey dialog.
      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
    
      // Tap the Cancel button within the dialog.
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
    
      // Expect the dialog to be dismissed.
      expect(find.byType(AlertDialog), findsNothing);
    });
    */

    testWidgets('End Journey dialog shows properly and dismisses on Cancel tap', (WidgetTester tester) async {
      // Currently, tapping Start Journey starts the journey without a popup,
      // Tap on ‘Start Journey’ to make it true:
      await tester.pumpWidget(pumpMap());
      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();

      // **** no longer enters text in the start journey dialogue X ****

      // End Journey
      await tester.tap(find.text('End Journey'));
      await tester.pumpAndSettle();

      // assume that the EndJourneyDialog should appear
      expect(find.byType(AlertDialog), findsOneWidget);

      // Tap the Cancel button within the dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    // --- REMOVED ---
    /*
    testWidgets('Invalid input on Start Journey dialog shows error dialog', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());

      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'invalid');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(find.text('Invalid Input'), findsOneWidget);
    });
      // Originally: After confirming invalid input in the "Start Journey" pop-up, an error dialog would appear.
      // Now: The pop-up is skipped entirely.
    */

    testWidgets('Invalid input on End Journey dialog shows error dialog', (WidgetTester tester) async {
      // 1) Pump map
      await tester.pumpWidget(pumpMap());
      await tester.pumpAndSettle();

      // 2) Start journey (no text fields for start journey)
      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();

      // 3) Directly open End Journey
      await tester.tap(find.text('End Journey'));
      await tester.pumpAndSettle();

      // 4) Now we enter invalid input in EndJourneyDialog (assuming 1 textfield)
      await tester.enterText(find.byType(TextField).first, 'invalid');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // 5) Expect "Invalid Input" or similar
      expect(find.text('Invalid Input'), findsOneWidget);
    });

    testWidgets('Ensure buttons load correctly', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());

      expect(find.byKey(Key("recentre button")), findsOneWidget);
      expect(find.byKey(Key("zoom out")), findsOneWidget);
      expect(find.byKey(Key("zoom in")), findsOneWidget);
      expect(find.byKey(Key("orientate button")), findsOneWidget);
    });

    testWidgets('Ensure orientate button toggles north variable', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());
      await tester.pumpAndSettle();

      OrientateButton orientateButton = tester.widget<OrientateButton>(find.byKey(Key("orientate button")));
      expect(orientateButton.north, true);

      await tester.tap(find.byKey(Key("orientate button")));
      await tester.pumpAndSettle();
      orientateButton = tester.widget<OrientateButton>(find.byKey(Key("orientate button")));
      expect(orientateButton.north, false);

      await tester.tap(find.byKey(Key("orientate button")));
      await tester.pumpAndSettle();
      orientateButton = tester.widget<OrientateButton>(find.byKey(Key("orientate button")));
      expect(orientateButton.north, true);
    });

    testWidgets('Ensure register stop shows alters visited attributed of stop', (WidgetTester tester) async {
      var stopsProvider = StopsProvider();
      await tester.pumpWidget(MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<LocationProvider>(
              create: (_) => LocationProvider(),
            ),
            ChangeNotifierProvider<StopsProvider>
              .value(value: stopsProvider),
          ],
          child: MapPage(),
        ),
      ));
      await tester.pumpAndSettle();

      // Start journey
      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '20');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Ensure stop is not visited before logging result
      expect(stopsProvider.stops.first.visited, false);

      await tester.tap(find.byKey(Key('log visit')));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('register collection dialog')), findsOneWidget);
      expect(find.byKey(Key('waste collected')), findsOneWidget);
      expect(find.byKey(Key('dropdown')), findsOneWidget);

      await tester.enterText(find.byKey(Key('waste collected')), '10');

      await tester.tap(find.byKey(Key('dropdown')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('test').last);
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('invalid dialog')), findsNothing);
      expect(find.byKey(Key('register collection dialog')), findsNothing);
      // Check stop is now visited
      expect(stopsProvider.stops.first.visited, true);
    });

    testWidgets('Ensure entering invalid data brings up invalid dialog', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());
      await tester.pumpAndSettle();

      // Start journey
      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '20');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('log visit')));
      await tester.pumpAndSettle();

      // Test blank boxes
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('invalid dialog')), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Select item from dropdown
      await tester.tap(find.byKey(Key('dropdown')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('test').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('invalid dialog')), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Test with invalid weight value
      await tester.enterText(find.byKey(Key('waste collected')), '-1');

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('invalid dialog')), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Cancel dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byKey(Key('register collection dialog')), findsNothing);
    });
  });

}