import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'mocks/mock_service_locator.dart';
import 'package:ewc/services/model_service.dart';


void main() {

  setUp(() async {
    await mockSetupLocator();
  });

  // Resets the service locator after each test to avoid affecting subsequent tests
  tearDown(() {
    getIt.reset();
  });

  group('ModelService.runmodel', () {
    test('Returns 200 on success', () async {
      // Creates a mock JSON response
      final mockResponse = http.Response(jsonEncode({
        "message": "Command executed",
        "output": "200",
      }), 200);
      

      // When the mock AuthService is called with 'stops/123',
      // respond with the mock JSON
      when(getIt<ModelService>().sendModelRequest(any))
          .thenAnswer((_) async {
            print("Mocking sendModelRequest");
            return mockResponse;
          });

      final result = await getIt<ModelService>().sendModelRequest(123);
      final responseBody = jsonDecode(result.body);
      final message = responseBody["message"];
      expect(message, "Command executed");
    });
  });
}
