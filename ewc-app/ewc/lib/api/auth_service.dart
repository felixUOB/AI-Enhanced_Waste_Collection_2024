import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();
  final String baseUrl = 'http://127.0.0.1:8000/api';


  // Login method: Obtain JWT access and refresh tokens
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String accessToken = data['access'];
      String refreshToken = data['refresh'];

      // Store access and refresh tokens securely
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'refreshToken', value: refreshToken);
    } else {
      throw Exception('Failed to login');
    }
  }

  // Access token refresh method: Use refresh token
  Future<void> refreshAccessToken() async {
    final refreshToken = await storage.read(key: 'refreshToken');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String newAccessToken = data['access'];

        // Store the new access token securely
        await storage.write(key: 'accessToken', value: newAccessToken);
      } else {
        throw Exception('Failed to refresh access token');
      }
    } else {
      throw Exception('No refresh token available');
    }
  }

  // Method to make an authenticated request
  Future<http.Response> makeAuthenticatedRequest(String endpoint) async {
    String? accessToken = await storage.read(key: 'accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 401) {
      // If the token is expired, attempt to refresh it
      await refreshAccessToken();

      // Retry the request with the new token
      String? newAccessToken = await storage.read(key: 'accessToken');
      if (newAccessToken != null) {
        return await http.get(
          Uri.parse('$baseUrl/$endpoint'),
          headers: {
            'Authorization': 'Bearer $newAccessToken',
            'Content-Type': 'application/json',
          },
        );
      } else {
        throw Exception('Failed to obtain new access token');
      }
    }

    return response;
  }

  // Add registration method
Future<void> register({
  required String username,
  required String password,
  required email,
  required phoneNumber,
  required address,
  // Additional fields if needed
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'password': password,
      'email': email ?? '',
      'phone_number': phoneNumber ?? '',
      'address': address ?? '',
      // Include additional fields if necessary
    }),
  );

  if (response.statusCode == 201) {
    // Perform additional actions upon successful registration
  } else {
    var data = jsonDecode(response.body);
    throw Exception('Failed to register: ${data.toString()}');
  }
}


}
