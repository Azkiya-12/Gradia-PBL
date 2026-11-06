import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _kToken = 'auth_token';
  static const _kUser = 'auth_user';

  static UserModel? _currentUser;
  static UserModel? get currentUser => _currentUser;

  /// Memeriksa apakah token tersimpan di secure storage
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _kToken);
    if (token == null || token.isEmpty) return false;

    // Load cached user data
    if (_currentUser == null) {
      final userJson = await _storage.read(key: _kUser);
      if (userJson != null) {
        try {
          _currentUser = UserModel.fromJson(jsonDecode(userJson));
        } catch (_) {}
      }
    }
    return true;
  }

  /// Login mahasiswa ke backend
  static Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    final response = await ApiClient.post(
      '/student/login',
      body: {
        'identifier': identifier.trim(),
        'password': password,
      },
    );

    final token = response['token']?.toString();
    final studentData = response['student'] as Map<String, dynamic>?;

    if (token == null || studentData == null) {
      throw ApiException('Format respon dari server tidak sesuai.');
    }

    final user = UserModel.fromJson(studentData);

    // Simpan token dan data user ke FlutterSecureStorage
    await _storage.write(key: _kToken, value: token);
    await _storage.write(key: _kUser, value: jsonEncode(user.toJson()));

    _currentUser = user;
    return user;
  }

  /// Membaca token aktif
  static Future<String?> getToken() => _storage.read(key: _kToken);

  /// Membaca user aktif dari storage jika ada
  static Future<UserModel?> getUser() async {
    if (_currentUser != null) return _currentUser;
    final userJson = await _storage.read(key: _kUser);
    if (userJson != null) {
      try {
        _currentUser = UserModel.fromJson(jsonDecode(userJson));
      } catch (_) {}
    }
    return _currentUser;
  }

  /// Ambil profil terbaru dari API backend
  static Future<UserModel> fetchProfile() async {
    final token = await getToken();
    if (token == null) throw ApiException('Sesi telah berakhir, silakan login kembali.');

    final response = await ApiClient.get('/student/profile', token: token);
    final studentData = response['student'] as Map<String, dynamic>?;
    if (studentData == null) throw ApiException('Data profil tidak ditemukan.');

    final user = UserModel.fromJson(studentData);
    _currentUser = user;
    await _storage.write(key: _kUser, value: jsonEncode(user.toJson()));
    return user;
  }

  /// Ambil data ringkasan dashboard mahasiswa dari backend
  static Future<Map<String, dynamic>> fetchDashboard() async {
    final token = await getToken();
    if (token == null) throw ApiException('Sesi telah berakhir, silakan login kembali.');

    return await ApiClient.get('/student/dashboard', token: token);
  }

  /// Logout mahasiswa
  static Future<void> logout() async {
    _currentUser = null;
    await _storage.delete(key: _kToken);
    await _storage.delete(key: _kUser);
  }
}
