import '../models/attendance_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class AttendanceService {
  /// Mengambil data rekap kehadiran mahasiswa dari backend
  static Future<AttendanceData> getAttendances() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    final response = await ApiClient.get('/student/attendances', token: token);
    return AttendanceData.fromJson(response);
  }

  /// Melakukan presensi Hadir langsung (Luring / Daring)
  static Future<Map<String, dynamic>> checkIn({
    required int classId,
    String type = 'Luring',
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    return await ApiClient.post(
      '/student/attendances/check-in',
      body: {
        'classId': classId,
        'type': type,
      },
      token: token,
    );
  }

  /// Mengajukan izin atau sakit beserta alasan dan tautan lampiran
  static Future<Map<String, dynamic>> applyLeave({
    required int classId,
    required String status,
    required String reason,
    String? attachmentUrl,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    return await ApiClient.post(
      '/student/attendances/leave',
      body: {
        'classId': classId,
        'status': status.toLowerCase().trim(),
        'reason': reason.trim(),
        'attachmentUrl': attachmentUrl?.trim() ?? '',
      },
      token: token,
    );
  }
}

