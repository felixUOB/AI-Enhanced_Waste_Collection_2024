import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:ewc/services/auth_service/auth_service.dart';

class MockAuthService extends Mock implements AuthService {
  @override
  Future<http.Response> makeAuthenticatedRequest(String endpoint) =>
      super.noSuchMethod(
        Invocation.method(#makeAuthenticatedRequest, [endpoint]),
        returnValue: Future.value(http.Response('', 200)),
        returnValueForMissingStub: Future.value(http.Response('', 200)),
      );

  @override
  Future<http.Response> makeAuthenticatedPostRequest(String endpoint, Map<String, dynamic>? body) =>
      super.noSuchMethod(
        Invocation.method(#makeAuthenticatedPostRequest, [endpoint, body]),
        returnValue: Future.value(http.Response('', 201)),
        returnValueForMissingStub: Future.value(http.Response('', 201)),
      );
}