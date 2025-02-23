import 'package:ewc/services/auth_service.dart';
import 'package:ewc/services/route_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingletonAsync<AuthService>(() async {
    final authService = AuthService();
    await authService.initializeAuthService();
    return authService;
  });

  getIt.registerSingletonAsync<RouteService>(() async {
    // Attempt to load the .env file
    await dotenv.load(fileName: '.env');

    // Check if the API key exists in .env; show an error message if not
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("API key missing in .env file.");
    }

    return RouteService(apiKey);
  });

  await getIt.allReady();
}
