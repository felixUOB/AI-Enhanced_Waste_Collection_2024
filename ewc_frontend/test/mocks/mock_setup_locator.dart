import 'package:ewc/service_locator.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/services/metrics_service.dart';

/// A mock or stubbed version of setupLocator() that doesn't call RouteService.create().
/// This way, we avoid the ".env" / "API_KEY" error.
Future<void> mockSetupLocator() async {
  // partial or minimal registration so the rest of the app won't crash.
  // For example, we skip routeService and just register stopsService, metricsService, etc.

  getIt.registerSingleton<StopsService>(StopsService());
  getIt.registerSingleton<MetricsService>(MetricsService());
}