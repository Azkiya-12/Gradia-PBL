import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  /// Base URL backend.
  /// - Di Web / Windows / macOS / Linux: `http://localhost:5001/api`
  /// - Di Emulator Android: `http://10.0.2.2:5001/api`
  /// - Di Real Device / LAN: ganti dengan IP laptop
  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5001/api';
    }
    return 'http://localhost:5001/api';
  }

  static const Duration timeout = Duration(seconds: 10);
}

class ApiClient {
  static final http.Client _client = http.Client();

  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _client
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        final errorMsg = decoded is Map && decoded['error'] != null
            ? decoded['error'].toString()
            : 'Terjadi kesalahan (${response.statusCode})';
        throw ApiException(errorMsg, statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Gagal terhubung ke server backend ($e). Pastikan server aktif.',
      );
    }
  }

  static Future<Map<String, dynamic>> get(
    String path, {
    String? token,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _client
          .get(
            uri,
            headers: headers,
          )
          .timeout(ApiConfig.timeout);

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        final errorMsg = decoded is Map && decoded['error'] != null
            ? decoded['error'].toString()
            : 'Terjadi kesalahan (${response.statusCode})';
        throw ApiException(errorMsg, statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Gagal terhubung ke server backend ($e). Pastikan server aktif.',
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
