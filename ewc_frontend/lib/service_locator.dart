import 'package:ewc/screens/map/map.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:ewc/services/depot_service.dart';
import 'package:ewc/services/metrics_service.dart';
import 'package:ewc/services/model_service.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:get_it/get_it.dart';

/// This file manages the service locator for the application.
///
/// Functions:
/// - `setupLocator()`: Sets up the dependency injection for the services.

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

  getIt.registerSingleton<Config>(Config());

  getIt.registerSingleton<DepotService>(DepotService());

  getIt.registerSingleton<ModelService>(ModelService());

  await getIt.allReady();
}
