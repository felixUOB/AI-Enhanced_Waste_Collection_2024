import 'dart:convert';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'mocks/mock_service_locator.dart';
import 'package:ewc/services/model_service.dart';


void main() {

  setUp(() async {
    await mockSetupLocator();
  });

  tearDown(() {
    getIt.reset();
  });

  group('ModelService.runmodel', () {
    test('Returns success message on model run', () async {
      // Creates a mock JSON response
      final mockResponse = http.Response(jsonEncode({
        "message": "Command executed",
        "output": "200",
      }), 200);
      
      when(getIt<ModelService>().sendModelRequest(123))
          .thenAnswer((_) async {
            return mockResponse;
          });

      final result = await getIt<ModelService>().sendModelRequest(123);
      final responseBody = jsonDecode(result.body);
      final message = responseBody["message"];
      expect(message, "Command executed");
      expect(result.statusCode, 200);
    });
    test('Throws Exception on non 200 error code', () async {

      when(getIt<AuthService>().makeAuthenticatedRequest(any))
          .thenThrow(Exception('Failed to run model.'));

      expect(
            () => ModelService().sendModelRequest(10),
        throwsA(isA<Exception>()),
      );
    });
  });
}
