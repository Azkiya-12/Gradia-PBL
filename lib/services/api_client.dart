import 'dart:convert';
import 'dart:io';

class ApiConfig {
  /// Base URL backend.
  /// - Di Emulator Android: `10.0.2.2:5000`
  /// - Di Real Device / LAN: ganti dengan IP laptop (misal `10.224.216.71:5000`)
  /// - Di Windows / macOS / Linux: `127.0.0.1:5000`
  static String get baseUrl {
    if (Platform.isAndroid) {
      // 10.0.2.2 adalah localhost host machine pada Android Emulator
      return 'http://10.0.2.2:5001/api';
    }
    return 'http://127.0.0.1:5001/api';
  }

  static const Duration timeout = Duration(seconds: 10);
}

class ApiClient {
  static final HttpClient _client = HttpClient()
    ..connectionTimeout = ApiConfig.timeout;

  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    try {
      final request = await _client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      if (token != null && token.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      }

      if (body != null) {
        final bodyBytes = utf8.encode(jsonEncode(body));
        request.add(bodyBytes);
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(responseBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        final errorMsg = decoded is Map && decoded['error'] != null
            ? decoded['error'].toString()
            : 'Terjadi kesalahan (${response.statusCode})';
        throw ApiException(errorMsg, statusCode: response.statusCode);
      }
    } on SocketException catch (_) {
      throw ApiException(
        'Gagal terhubung ke server backend. Pastikan server berjalan dan IP/koneksi sesuai.',
      );
    } on HandshakeException catch (_) {
      throw ApiException('Kesalahan sertifikat koneksi (Handshake error).');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Gagal memproses permintaan: $e');
    }
  }

  static Future<Map<String, dynamic>> get(
    String path, {
    String? token,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    try {
      final request = await _client.getUrl(uri);
      request.headers.contentType = ContentType.json;
      if (token != null && token.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(responseBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        final errorMsg = decoded is Map && decoded['error'] != null
            ? decoded['error'].toString()
            : 'Terjadi kesalahan (${response.statusCode})';
        throw ApiException(errorMsg, statusCode: response.statusCode);
      }
    } on SocketException catch (_) {
      throw ApiException(
        'Gagal terhubung ke server backend. Pastikan server berjalan dan IP/koneksi sesuai.',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Gagal memproses permintaan: $e');
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
