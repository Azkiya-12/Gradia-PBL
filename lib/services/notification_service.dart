import '../models/notification_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class NotificationService {
  /// Mengambil daftar notifikasi mahasiswa dari backend
  /// [category]: 'all', 'nilai', 'pengumuman', 'reminder', 'sistem'
  static Future<NotificationResponse> getNotifications({String? category}) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    final query = category != null && category.isNotEmpty && category != 'all'
        ? '?category=${Uri.encodeComponent(category)}'
        : '';
    final response = await ApiClient.get('/student/notifications$query', token: token);
    return NotificationResponse.fromJson(response);
  }

  /// Menandai satu notifikasi telah dibaca
  static Future<void> markAsRead(int notificationId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    await ApiClient.put('/student/notifications/$notificationId/read', token: token);
  }

  /// Menandai semua notifikasi telah dibaca
  static Future<void> markAllAsRead() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    await ApiClient.put('/student/notifications/read-all', token: token);
  }
}
