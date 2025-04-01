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

  // Resets the service locator after each test to avoid affecting subsequent tests
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
      

      // When the mock AuthService is called with 'stops/123',
      // respond with the mock JSON
      when(getIt<ModelService>().sendModelRequest(any))
          .thenAnswer((_) async {
            return mockResponse;
          });

      final result = await getIt<ModelService>().sendModelRequest(123);
      final responseBody = jsonDecode(result.body);
      final message = responseBody["message"];
      expect(message, "Command executed");
      expect(result.statusCode, 200);
    });


    test('Returns failure message on model fail', () async {
      // Creates a mock JSON response

      // When the mock AuthService is called with 'stops/123',
      // respond with the mock JSON
      when(getIt<AuthService>().makeAuthenticatedRequest(any))
          .thenThrow(Exception('Failed to run model.'));
      // Expects an exception when status is not 200
      expect(
            () => ModelService().sendModelRequest(null),
        throwsA(isA<Exception>()),
      );

    });

// def run_model_view(request):
//     if request.method == "GET":
//         stopid = request.GET.get("stopid", None)
//         if not stopid:
//             return JsonResponse({"error": "Missing argument"}, status=400)

//         try:
//             stopid = int(stopid)
//         except ValueError:
//             return JsonResponse({"error": "Invalid Stop"}, status=400)

//         output = io.StringIO()  # Capture command output
//         call_command("run_prediction", stopid, stdout=output, stderr=output)
//         return JsonResponse({"message": "Command executed", "output": output.getvalue().strip()}, status=200)

//     return JsonResponse({"error": "Invalid request"}, status=400)

  });

  
}
