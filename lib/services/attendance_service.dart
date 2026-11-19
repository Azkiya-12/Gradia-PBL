import 'dart:typed_data';
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

  /// Mengajukan izin atau sakit beserta alasan dan lampiran bukti.
  ///
  /// [attachmentBytes] dan [attachmentFileName] adalah file yang akan
  /// diunggah ke backend terlebih dahulu — backend yang meneruskannya
  /// ke Vercel Blob. FE / Mobile TIDAK boleh upload langsung ke Blob.
  static Future<Map<String, dynamic>> applyLeave({
    required int classId,
    required String status,
    required String reason,
    Uint8List? attachmentBytes,
    String? attachmentFileName,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    String attachmentUrl = '';

    // Jika ada file, upload ke backend dulu → Vercel Blob
    if (attachmentBytes != null &&
        attachmentBytes.isNotEmpty &&
        attachmentFileName != null) {
      attachmentUrl = await ApiClient.uploadFile(
        '/upload',
        fileBytes: attachmentBytes,
        fileName: attachmentFileName,
        token: token,
        folder: 'attachments',
      );
    }

    return await ApiClient.post(
      '/student/attendances/leave',
      body: {
        'classId': classId,
        'status': status.toLowerCase().trim(),
        'reason': reason.trim(),
        'attachmentUrl': attachmentUrl,
      },
      token: token,
    );
  }
}
