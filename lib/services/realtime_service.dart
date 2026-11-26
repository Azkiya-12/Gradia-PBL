import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'auth_service.dart';

class RealtimeEvent {
  final String event;
  final Map<String, dynamic> data;

  RealtimeEvent({required this.event, required this.data});
}

/// Layanan sinkronisasi real-time via Server-Sent Events (SSE) ke Backend_dosen.
class RealtimeService {
  static final StreamController<RealtimeEvent> _controller =
      StreamController<RealtimeEvent>.broadcast();

  static Stream<RealtimeEvent> get events => _controller.stream;

  static http.Client? _client;
  static StreamSubscription<String>? _subscription;
  static Timer? _reconnectTimer;
  static bool _shouldReconnect = false;
  static bool _isConnecting = false;

  /// Membuka koneksi SSE menggunakan token JWT mahasiswa aktif.
  static Future<void> connect() async {
    _shouldReconnect = true;
    if (_isConnecting || _subscription != null) return;

    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) return;

    _isConnecting = true;
    try {
      _client = http.Client();
      final uri = Uri.parse('${ApiConfig.baseUrl}/realtime/stream');
      final request = http.Request('GET', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'text/event-stream';

      final response = await _client!.send(request);
      if (response.statusCode != 200) {
        _scheduleReconnect();
        return;
      }

      String currentEvent = 'message';
      final dataLines = <String>[];

      _subscription = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
        (line) {
          if (line.isEmpty) {
            if (dataLines.isNotEmpty) {
              final rawData = dataLines.join('\n');
              dataLines.clear();
              try {
                final decoded = jsonDecode(rawData);
                final payload = decoded is Map<String, dynamic>
                    ? decoded
                    : <String, dynamic>{'raw': decoded};
                _controller.add(RealtimeEvent(event: currentEvent, data: payload));
              } catch (_) {}
            }
            currentEvent = 'message';
            return;
          }

          if (line.startsWith(':')) return; // Heartbeat comment
          if (line.startsWith('event:')) {
            currentEvent = line.substring(6).trim();
          } else if (line.startsWith('data:')) {
            dataLines.add(line.substring(5).trim());
          }
        },
        onError: (_) => _scheduleReconnect(),
        onDone: () => _scheduleReconnect(),
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  static void _scheduleReconnect() {
    _cleanupConnection();
    if (!_shouldReconnect) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (_shouldReconnect) {
        connect();
      }
    });
  }

  static void _cleanupConnection() {
    _subscription?.cancel();
    _subscription = null;
    _client?.close();
    _client = null;
  }

  /// Menutup koneksi SSE (mis. saat logout).
  static void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _cleanupConnection();
  }
}
