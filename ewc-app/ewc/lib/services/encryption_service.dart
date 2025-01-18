import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionNotInitializedException implements Exception {
  final String message;

  EncryptionNotInitializedException(this.message);

  @override
  String toString() {
    return "EncryptionNotInitializedException: $message";
  }
}

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();

  EncryptionService._internal();

//Ensures all called versions of encryption service are identical
  factory EncryptionService() {
    return _instance;
  }

// Encryption key - stored in encryption service and unchanging
  encrypt.Key? _key;

// Method to initialize the encryption key
  void init(String keyString) {
    _key = encrypt.Key.fromUtf8(keyString);
  }

// Method to encrypt data
  String encryptData(String plainText) {
    if (_key == null) {
      throw EncryptionNotInitializedException(
          'Encryption key is not initialized.');
    }
    final iv = encrypt.IV.fromLength(16); // Generate a random IV
    final encrypter =
        encrypt.Encrypter(encrypt.AES(_key!, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final ivBase64 = iv.base64;
    final encryptedBase64 = encrypted.base64;

    return '$ivBase64:$encryptedBase64'; //Sends IV with Encrypted Data
  }

  // Method to decrypt data
  String decryptData(String encryptedData) {
    if (_key == null) {
      throw EncryptionNotInitializedException(
          'Encryption key is not initialized.');
    }
    final parts = encryptedData.split(':'); //Splits IV from Encrypted Data

    final iv = encrypt.IV.fromBase64(parts[0]); // Extract the IV

    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);

    final encrypter =
        encrypt.Encrypter(encrypt.AES(_key!, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return decrypted;
  }
}
