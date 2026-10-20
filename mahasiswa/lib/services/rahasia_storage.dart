import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Menyimpan data rahasia (secrets) dengan flutter_secure_storage.
/// Yang disimpan adalah TOKEN login, bukan password asli.
class RahasiaStorage {
  static const _storage = FlutterSecureStorage();
  static const _kToken = 'auth_token';

  /// Simpan token setelah login berhasil.
  static Future<void> simpanToken(String token) =>
      _storage.write(key: _kToken, value: token);

  /// Baca token. Hasilnya null kalau belum login.
  static Future<String?> bacaToken() => _storage.read(key: _kToken);

  /// Hapus token saat pengguna keluar.
  static Future<void> hapusToken() => _storage.delete(key: _kToken);
}