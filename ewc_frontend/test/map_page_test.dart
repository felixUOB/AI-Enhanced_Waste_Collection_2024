import 'dart:async';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/services/stops_service.dart';
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

    
    testWidgets('End Journey dialog shows properly and dismisses on Cancel tap', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());

      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '20');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Journey'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      // Tap the Cancel button within the dialog.
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      // Expect the dialog to be dismissed.
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('End Journey button accepts correctly entered values', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());

      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '20');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Journey'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '20');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Invalid input on Start Journey dialog shows error dialog', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());

      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'invalid');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(find.text('Invalid Input'), findsOneWidget);
    });

    testWidgets('Invalid input on End Journey dialog shows error dialog', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());

      await tester.tap(find.text('Start Journey'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '10');
      await tester.enterText(find.byType(TextField).last, '20');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('End Journey'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'invalid');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(find.text('Invalid Input'), findsOneWidget);
    });

    testWidgets('Ensure buttons load correctly', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());

      expect(find.byKey(Key("recentre button")), findsOneWidget);
      expect(find.byKey(Key("zoom out")), findsOneWidget);
      expect(find.byKey(Key("zoom in")), findsOneWidget);
      expect(find.byKey(Key("orientate button")), findsOneWidget);
    });


    

  });

}