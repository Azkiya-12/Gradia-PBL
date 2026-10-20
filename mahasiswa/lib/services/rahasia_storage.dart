import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class RahasiaStorage {
  static const _storage = FlutterSecureStorage();
  static const _kToken = 'auth_token';

  static Future<void> simpanToken(String token) =>
      _storage.write(key: _kToken, value: token);


  static Future<String?> bacaToken() => _storage.read(key: _kToken);

  static Future<void> hapusToken() => _storage.delete(key: _kToken);
}