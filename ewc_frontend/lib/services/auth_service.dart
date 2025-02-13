import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'encryption_service.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final encryptionService = encrypt.EncryptionService();
  final authStorage = FlutterSecureStorage();
  final String apiUrl = 'http://127.0.0.1:8000/api';
  final String adminUrl = 'http://127.0.0.1:8000/admin';

  Future<void> initializeAuthService() async {
    await dotenv.load(fileName: '.env');

    // Check if the API key exists in .env; show an error message if not
    final encryptionKey = dotenv.env['ENCRYPTION_KEY'];
    if (encryptionKey == null || encryptionKey.isEmpty) {
      throw Exception("Encryption Key missing in .env file.");
    }
    encryptionService.init(encryptionKey);
  }

//====================AUTO LOGIN FUNCTIONS=======================================

  // Save username and password
  Future<void> saveUserCredentials(String username, String password) async {
    await authStorage.write(key: 'username', value: username); // Store username

    var encryptedPassword =
        encryptionService.encryptData(password); // Encrypt Password

    await authStorage.write(
        key: 'password', value: encryptedPassword); // Store password
  }

  // Load username and password
  Future<Map<String, String?>> loadUserCredentials() async {
    String? username = await authStorage.read(key: 'username');
    String? encryptedPassword = await authStorage.read(key: 'password');

    if (encryptedPassword != null && username != null) {
      try {
        var password = encryptionService
            .decryptData(encryptedPassword); //Attempts decryption
        return {'username': username, 'password': password};
      } catch (e) {
        print('Decryption failed: $e');
        return {'username': null, 'password': null};
      }
    } else {
      return {'username': null, 'password': null};
    }
  }

  // Clear credentials and tokens
  Future<void> clearCredentials() async {
    await authStorage.deleteAll(); // Remove all data
  }

//====================DJANGO AUTH FUNCTIONS=======================================

  Future<bool> checkEmail(String email) async {
    final response = await http
        .get(Uri.parse("$apiUrl/check-email/?email=$email"), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 500) {
      throw Exception(
          "Server Error: If email field is blank please input email.");
    } else if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['exists'] ?? false;
    } else {
      throw Exception('Failed to check email');
    }
  }

  // Login method: Obtain JWT access and refresh tokens
  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String accessToken = data['access'];
        String refreshToken = data['refresh'];

        // Store access and refresh tokens securely
        await authStorage.write(key: 'accessToken', value: accessToken);
        await authStorage.write(key: 'refreshToken', value: refreshToken);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      // Catch network or connectivity issues
      throw Exception('Network error: Unable to login. Details: $e');
    }
  }

// Access token refresh method: Use refresh token
  Future<void> refreshAccessToken() async {
    final refreshToken = await authStorage.read(key: 'refreshToken');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse('$apiUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String newAccessToken = data['access'];

        // Store the new access token securely
        await authStorage.write(key: 'accessToken', value: newAccessToken);
      } else if (response.statusCode == 401) {
        // Handle case where refresh token is invalid or expired
        await authStorage.delete(key: 'refreshToken');
        throw Exception('Refresh token expired. Please log in again.');
      } else {
        throw Exception(
            'Failed to refresh access token. Status code: ${response.statusCode}');
      }
    } else {
      throw Exception('No refresh token available');
    }
  }

  // Method to make an authenticated request
  Future<http.Response> makeAuthenticatedRequest(String endpoint) async {
    String? accessToken = await authStorage.read(key: 'accessToken');

    final response = await http.get(
      Uri.parse('$apiUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 401) {
      // If the token is expired, attempt to refresh it
      await refreshAccessToken();

      // Retry the request with the new token
      String? newAccessToken = await authStorage.read(key: 'accessToken');
      if (newAccessToken != null) {
        return await http.get(
          Uri.parse('$apiUrl/$endpoint'),
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
      Uri.parse('$apiUrl/register/'),
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
      try {
        var data = jsonDecode(response.body);
        throw Exception('Failed to register: ${data.toString()}');
      } catch (e) {
        throw Exception('Invalid server response: $e');
      }
    }
  }
}

Future<void> launchPasswordReset() async {
  final Uri resetUri = Uri.parse("http://127.0.0.1:8000/reset_password/");

  if (await canLaunchUrl(resetUri)) {
    await launchUrl(resetUri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch password reset URL';
  }
}
