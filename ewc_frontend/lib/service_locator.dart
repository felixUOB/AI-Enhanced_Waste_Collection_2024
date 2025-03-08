import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/screens/map/map.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:ewc/services/metrics_service.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingletonAsync<AuthService>(() async {
    final authService = AuthService();
    await authService.initializeAuthService();
    return authService;
  });

  getIt.registerSingletonAsync<RouteService>(() async {
    return RouteService.create();
  });

  getIt.registerSingleton<StopsService>(StopsService());

  getIt.registerSingleton<MetricsService>(MetricsService());

  getIt.registerSingleton<LocationProvider>(LocationProvider());

  getIt.registerSingleton<GeolocatorPlatform>(GeolocatorPlatform.instance);

  getIt.registerSingleton<Config>(Config());

  await getIt.allReady();
}
