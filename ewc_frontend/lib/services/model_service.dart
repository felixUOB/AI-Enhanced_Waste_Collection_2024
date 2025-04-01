import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:http/http.dart';

class ModelService {
  final String siteUrl = 'https://devnest.software';

  // Function to request permission to access device location
  Future<Response> sendModelRequest(int? id) async {
    if (id != null) {
      final response = await getIt<AuthService>().makeAuthenticatedRequest('runmodel?stopid=$id');

      if (response.statusCode != 200) {
        throw Exception('Failed to run model.');
      } 
      return response;
    }
    else {
      throw Exception('Failed to run model - no stop ID provided.');
    }
  }
}