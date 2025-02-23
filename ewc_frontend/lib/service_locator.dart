import 'package:ewc/services/auth_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingletonAsync<AuthService>(() async {
    final authService = AuthService();
    await authService.initializeAuthService();
    return authService;
  });

  await getIt.allReady();
}
