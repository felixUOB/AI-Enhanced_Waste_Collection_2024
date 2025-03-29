import 'package:ewc/service_locator.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/services/metrics_service.dart';

Future<void> mockSetupLocator() async {

  getIt.registerSingleton<StopsService>(StopsService());
  getIt.registerSingleton<MetricsService>(MetricsService());
}