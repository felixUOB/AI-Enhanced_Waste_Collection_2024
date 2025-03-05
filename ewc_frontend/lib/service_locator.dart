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

  getIt.registerSingleton<GeolocatorPlatform>(GeolocatorPlatform.instance);

  await getIt.allReady();
}
