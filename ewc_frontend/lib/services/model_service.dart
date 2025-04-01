import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:http/http.dart';

/// This file manages the route service and provides functionality to fetch
///
/// Functions:
/// - `sendModelRequest()`: Sends a request to the model service to run the model on a specified ID.

class ModelService {
  final String siteUrl = 'https://devnest.software';

  // Function to request permission to access device location
  Future<Response> sendModelRequest(int? id) async {
    if (id != null) {
      final response = await getIt<AuthService>().makeAuthenticatedRequest('run-model/$id');

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