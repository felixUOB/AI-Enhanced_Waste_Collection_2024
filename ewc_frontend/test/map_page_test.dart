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
import 'package:hive/hive.dart';



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

class MockBox extends Mock implements Box {}

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

  // Setup a mock channel and mock platform method
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set the fake GeolocatorPlatform before tests run 
  setUp(() async {
    await mockSetupLocator();
    when(getIt<Config>().inTestMode).thenReturn(true);
    when(getIt<StopsService>().fetchAllStops()).thenAnswer((request) {return getMockStopList();} );
    when(getIt<StopsService>().postStopCollection(1, 10)).thenAnswer((request) {return Completer<void>().future;});
    GeolocatorPlatform.instance = FakeGeolocatorPlatform();

    when(() => Hive.openBox('Settings')).thenAnswer(0 as Answering<Future<Box> Function()>);
  });

  tearDown(() async {
    await getIt.reset();
    await Hive.deleteFromDisk();
  });

  group('Map Page Tests', () {

    //test hive init
    test('Test MPG initialization with mocked Hive', () async {
      // Open the mocked box
      final mockBox = await Hive.openBox('Settings');

      // Mock behavior of getting 'mpg' from the mocked box
      when(() => mockBox.get('mpg')).thenReturn(0 as Function());

      // Get the value from the mock box
      final mpgValue = mockBox.get('mpg');

      // Assert that 'mpg' is null (as mocked)
      expect(mpgValue, isNull);

      // If you want to test for a non-null value:
      when(() => mockBox.get('mpg')).thenReturn(25.0 as Function());  // mock a value like 25 MPG

      final mpgValue2 = mockBox.get('mpg');
      expect(mpgValue2, 25.0);  // check that we get the mocked value
    });

    // Setup and Initialisation Tests
    testWidgets('Map Page initialises correctly', (WidgetTester tester) async{
      await tester.runAsync(() async {
        await tester.pumpWidget(pumpMap());
        await tester.pumpAndSettle();

        expect(find.byType(MapPage), findsOneWidget);
        expect(find.byType(FlutterMap), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsExactly(4));
        });
      });

    testWidgets('End Journey dialog shows properly and dismisses on Cancel tap', (WidgetTester tester) async {
      await tester.runAsync(() async {
        // Currently, tapping Start Journey starts the journey without a popup,
        // Tap on ‘Start Journey’ to make it true:
        await tester.pumpWidget(pumpMap());
        await tester.tap(find.text('Start Journey'));
        await tester.pumpAndSettle();

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
    });

    testWidgets('Invalid input on End Journey dialog shows error dialog', (WidgetTester tester) async {
      await tester.runAsync(() async {
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
    });

    testWidgets('Ensure buttons load correctly', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(pumpMap());
        await tester.pumpAndSettle();

        expect(find.byKey(Key("recentre button")), findsOneWidget);
        expect(find.byKey(Key("zoom out")), findsOneWidget);
        expect(find.byKey(Key("zoom in")), findsOneWidget);
        expect(find.byKey(Key("orientate button")), findsOneWidget);
      });
    });

    testWidgets('Ensure orientate button toggles north variable', (WidgetTester tester) async {
      await tester.runAsync(() async {
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
    });

    testWidgets('Ensure register stop shows alters visited attributed of stop', (WidgetTester tester) async {
      await tester.runAsync(() async {
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

        // Start journey (no text fields!)
        await tester.tap(find.text('Start Journey'));
        await tester.pumpAndSettle();

        // Check visited = false initially
        expect(stopsProvider.stops.first.visited, false);

        // Now open "log visit" dialog
        await tester.tap(find.byKey(Key('log visit')));
        await tester.pumpAndSettle();

        expect(find.byKey(Key('register collection dialog')), findsOneWidget);

        // Fill in waste collected
        await tester.enterText(find.byKey(const Key('waste collected')), '10');
        expect(find.widgetWithText(TextField, '10'), findsOneWidget);

        // Enter collected waste
        expect(find.byKey(Key('dropdown')), findsOneWidget);
        await tester.tap(find.byKey(const Key('dropdown')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('test').last);
        await tester.pumpAndSettle();

        // Confirm
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        // Make sure no invalid dialogs have popped up and that the register collection dialog is closed
        expect(find.byKey(Key('invalid dialog')), findsNothing);
        expect(find.byKey(Key('register collection dialog')), findsNothing);

        // Check stop is now visited
        expect(stopsProvider.stops.first.visited, true);
      });
    });

    testWidgets('Ensure entering invalid data brings up invalid dialog', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(pumpMap());
        await tester.pumpAndSettle();

        // Start journey
        await tester.tap(find.text('Start Journey'));
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
  });

  // Increase Flutter Coverage %
  testWidgets('map page shows error dialog on fetchAllStops exception', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Throw exception in mock
      when(getIt<StopsService>().fetchAllStops()).thenThrow(Exception('Mock Error'));

      await tester.pumpWidget(pumpMap());
      await tester.pumpAndSettle();

      // expect: AlertDialog with "Error" title
      expect(find.text('Error'), findsOneWidget);
    });
  });
}