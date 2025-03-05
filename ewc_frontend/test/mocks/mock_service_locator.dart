import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:ewc/services/metrics_service.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../map_page_test.dart';
import 'mocks.mocks.dart';

final getIt = GetIt.instance;

Future<void> mockSetupLocator() async {
  getIt.registerSingleton<AuthService>(MockAuthService());
  getIt.registerSingleton<RouteService>(MockRouteService());
  getIt.registerSingleton<StopsService>(MockStopsService());
  getIt.registerSingleton<MetricsService>(MockMetricsService());
  getIt.registerSingleton<GeolocatorPlatform>(FakeGeolocatorPlatform());
  
  await getIt.allReady();
}
