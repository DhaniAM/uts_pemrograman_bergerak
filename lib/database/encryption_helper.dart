import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionHelper {
  static final _iv = encrypt.IV.fromLength(16);

  static String encryptPassword(String password, String username) {
    final key = _generateKey(username);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(password, iv: _iv);
    return encrypted.base64;
  }

  static String decryptPassword(String encryptedPassword, String username) {
    final key = _generateKey(username);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedPassword, iv: _iv);
    return decrypted;
  }

  static encrypt.Key _generateKey(String username) {
    final keyBytes = utf8.encode(username.padRight(16, '0').substring(0, 16));
    return encrypt.Key(Uint8List.fromList(keyBytes));
  }
}
