import 'package:ewc/services/auth_service.dart';
import 'package:ewc/services/route_service.dart';
import 'package:get_it/get_it.dart';

import 'mocks.mocks.dart';

final getIt = GetIt.instance;

Future<void> mockSetupLocator() async {
  getIt.registerSingleton<AuthService>(MockAuthService());
  getIt.registerSingleton<RouteService>(MockRouteService());
  await getIt.allReady();
}
