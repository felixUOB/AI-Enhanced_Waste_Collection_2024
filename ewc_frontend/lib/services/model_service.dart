import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';

class ModelService {
  final String siteUrl = 'https://devnest.software';

  // Function to request permission to access device location
  Future<void> sendModelRequest(int id) async {
    final response = await getIt<AuthService>().makeAuthenticatedRequest('runmodel?stopid=$id');

    if (response.statusCode != 200) {
      throw Exception('Failed to run model.');
    } 
  }
}