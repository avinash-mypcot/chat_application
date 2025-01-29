import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  final encrypt.Key key;
  final encrypt.IV iv;

  EncryptionHelper(String keyString, String ivString)
      : key = encrypt.Key.fromUtf8(keyString),
        iv = encrypt.IV.fromUtf8(ivString);

  String encryptText(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryptText(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt(
      encrypt.Encrypted.fromBase64(encryptedText),
      iv: iv,
    );
    return decrypted;
  }
}
