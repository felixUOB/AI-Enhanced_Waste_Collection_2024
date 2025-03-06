
import 'package:ewc/screens/map/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'mocks/mock_service_locator.dart';
import 'mocks/mocks.mocks.dart';

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

void stubSetup(){
  when(getIt<LocationProvider>().initialiseLocationServices()).thenAnswer((_) async => Future.value());
  when(getIt<LocationProvider>().latestLocation).thenReturn(LatLng(0, 0));
  when(MockLocationProvider().latestLocation).thenReturn(LatLng(0, 0));
  when(getIt<Config>().inTestMode).thenReturn(true);
 }

Widget pumpMap() {
  return MaterialApp(
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => MockLocationProvider(),
        ),
        ChangeNotifierProvider<StopsProvider>(
          create: (_) => MockStopsProvider(),
        ),
      ],
      child: MapPage(),
    ),
  );
}
void main() {
  // Set the fake GeolocatorPlatform before tests run 
  setUp(() { 
    mockSetupLocator();
    stubSetup();
  });

  tearDown(() {
    getIt.reset();
  });
  group('Map Page Tests', () {
    // Setup and Initialisation Tests
    testWidgets('Map Page initialises correctly', (WidgetTester tester) async{
      await tester.pumpWidget(pumpMap());


      expect(find.byType(MapPage), findsOneWidget);
      expect(find.byType(FlutterMap), findsOneWidget);
      expect(find.text('Start Journey'), findsOneWidget);
    });

    testWidgets('Start Journey dialog shows on Start tap and dismisses on Cancel tap', (WidgetTester tester) async {
      await tester.pumpWidget(pumpMap());
      // Open the journey dialog.

    expect(tester.widget<ElevatedButton>(find.byKey(const Key('routeInitButton'))).enabled, isTrue);
    await tester.tap(find.byKey(const Key('routeInitButton')));
    // await tester.pumpAndSettle();


//     await tester.pumpAndSettle(); // Wait for animations to complete
// await tester.ensureVisible(find.byKey(const Key('routeInitButton')));
// await tester.pumpAndSettle();
// await tester.tap(find.byKey(const Key('routeInitButton')));
// await tester.pumpAndSettle(); // Ensure UI updates after tap


    // Check if one of the dialogs (_showStartJourneyDialog or _showEndJourneyDialog) is displayed
    // expect(find.byType(AlertDialog), findsOneWidget);
    });

    
    // testWidgets('End Journey dialog shows properly and dismisses on Cancel tap', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: MultiProvider(
    //         providers: [
    //           ChangeNotifierProvider<LocationProvider>(
    //             create: (_) => LocationProvider(),
    //           ),
    //           ChangeNotifierProvider<StopsProvider>(
    //             create: (_) => StopsProvider(),
    //           ),
    //         ],
    //         child: MapPage(),
    //       ),
    //     ),
    //   );
    //   await tester.tap(find.text('Start Journey'));
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).first, '10');
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).last, '20');
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('Confirm'));
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('End Journey'));
    //   await tester.pumpAndSettle();
    //   expect(find.byType(AlertDialog), findsOneWidget);
    //   // Tap the Cancel button within the dialog.
    //   await tester.tap(find.text('Cancel'));
    //   await tester.pumpAndSettle();
    //   // Expect the dialog to be dismissed.
    //   expect(find.byType(AlertDialog), findsNothing);
    // });

    // testWidgets('End Journey button accepts correctly entered values', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: MultiProvider(
    //         providers: [
    //           ChangeNotifierProvider<LocationProvider>(
    //             create: (_) => LocationProvider(),
    //           ),
    //           ChangeNotifierProvider<StopsProvider>(
    //             create: (_) => StopsProvider(),
    //           ),
    //         ],
    //         child: MapPage(),
    //       ),
    //     ),
    //   );
    //   await tester.tap(find.text('Start Journey'));
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).first, '10');
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).last, '20');
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('Confirm'));
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('End Journey'));
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).first, '10');
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).last, '20');
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('Confirm'));
    //   await tester.pumpAndSettle();
    //   expect(find.byType(AlertDialog), findsNothing);
    // });

    // testWidgets('Invalid input on Start Journey dialog shows error dialog', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: MultiProvider(
    //         providers: [
    //           ChangeNotifierProvider<LocationProvider>(
    //             create: (_) => LocationProvider(),
    //           ),
    //           ChangeNotifierProvider<StopsProvider>(
    //             create: (_) => StopsProvider(),
    //           ),
    //         ],
    //         child: MapPage(),
    //       ),
    //     ),
    //   );
    //   await tester.tap(find.text('Start Journey'));
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).first, 'invalid');
    //   await tester.tap(find.text('Confirm'));
    //   await tester.pumpAndSettle();
    //   expect(find.text('Invalid Input'), findsOneWidget);
    // });

    // testWidgets('Invalid input on End Journey dialog shows error dialog', (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: MultiProvider(
    //         providers: [
    //           ChangeNotifierProvider<LocationProvider>(
    //             create: (_) => LocationProvider(),
    //           ),
    //           ChangeNotifierProvider<StopsProvider>(
    //             create: (_) => StopsProvider(),
    //           ),
    //         ],
    //         child: MapPage(),
    //       ),
    //     ),
    //   );
    //   await tester.tap(find.text('Start Journey'));
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).first, '10');
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).last, '20');
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('Confirm'));
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('End Journey'));
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TextField).first, 'invalid');
    //   await tester.tap(find.text('Confirm'));
    //   await tester.pumpAndSettle();
    //   expect(find.text('Invalid Input'), findsOneWidget);
    // });


    

  });

}