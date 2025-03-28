import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:ewc/services/auth_service/encryption_service.dart';

const MethodChannel secureStorageChannel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage'); // Defines the channel used by flutter_secure_storage

final Map<String, String> mockSecureStorage = {}; // In-memory map that simulates secure storage

Future<dynamic> mockSecureStorageHandler(MethodCall methodCall) async { // Handles method calls to the channel in a mock environment
  switch (methodCall.method) {
    case 'write':
      final key = methodCall.arguments['key'] as String?; // Extracts the key to be written
      final value = methodCall.arguments['value'] as String?; // Extracts the value to be written
      if (key != null && value != null) {
        mockSecureStorage[key] = value; // Stores the key-value pair in the mock map
      }
      return null;
    case 'read':
      final key = methodCall.arguments['key'] as String?; // Extracts the key to be read
      if (key != null && mockSecureStorage.containsKey(key)) {
        return mockSecureStorage[key]; // Returns the stored value if it exists
      }
      return null;
    case 'delete':
      final key = methodCall.arguments['key'] as String?; // Extracts the key to be deleted
      if (key != null && mockSecureStorage.containsKey(key)) {
        mockSecureStorage.remove(key); // Removes the entry from the mock map
      }
      return null;
    case 'deleteAll':
      mockSecureStorage.clear(); // Clears the entire mock map
      return null;
  }
  return null; // Returns null if the method is not recognized
}

void main() { // Entry point for the test suite
  TestWidgetsFlutterBinding.ensureInitialized(); // Prepares the widget test environment

  setUpAll(() async {
    await dotenv.load(fileName: '.env'); // Loads environment variables from the .env file

    // Hooks our mock handler to the secureStorageChannel for all method calls
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, mockSecureStorageHandler);
  });

  group('EncryptionService Tests', () { // Tests related to EncryptionService
    test('init, encrypt, decrypt', () {
      final encryptionService = EncryptionService(); // Creates an instance of EncryptionService
      final keyFromEnv = dotenv.env['ENCRYPTION_KEY'] ?? '0123456789ABCDEF'; // Retrieves encryption key from .env or uses a default
      encryptionService.init(keyFromEnv); // Initializes the service with the key

      final originalText = 'Hello Encryption'; // Example text to encrypt
      final encryptedText = encryptionService.encryptData(originalText); // Encrypts the text
      final decryptedText = encryptionService.decryptData(encryptedText); // Decrypts the text

      expect(decryptedText, originalText); // Checks if the decrypted text matches the original
    });
  });

  group('AuthService Tests', () { // Tests related to AuthService
    late AuthService authService; // Declares a variable for AuthService

    setUp(() {
      authService = AuthService(); // Instantiates AuthService before each test
    });

    test('initializeAuthService runs without error', () async {
      await authService.initializeAuthService(); // Verifies that initialization doesn't throw any error
    });

    test('saveUserCredentials / loadUserCredentials', () async {
      await authService.initializeAuthService(); // Ensures the service is initialized
      await authService.saveUserCredentials('testUser', 'testPassword'); // Saves credentials using the mock storage

      final creds = await authService.loadUserCredentials(); // Loads credentials back from mock storage
      expect(creds['username'], equals('testUser')); // Checks if username matches the saved value
      expect(creds['password'], equals('testPassword')); // Checks if password matches the saved value
    });

    test('loadUserCredentials returns null after clearCredentials', () async {
      await authService.initializeAuthService(); // Ensures the service is initialized
      await authService.saveUserCredentials('testUser', 'testPassword'); // Saves credentials

      await authService.clearCredentials(); // Clears stored credentials in mock storage

      final creds = await authService.loadUserCredentials(); // Attempts to load cleared credentials
      expect(creds['username'], isNull); // Username should be null after clearing
      expect(creds['password'], isNull); // Password should be null after clearing
    });
  });
}
