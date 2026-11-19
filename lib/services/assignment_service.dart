import 'dart:typed_data';
import '../models/assignment_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class AssignmentService {
  /// Mengambil daftar tugas mahasiswa dari backend (opsional filter: 'To-Do', 'Terkumpul', 'Terlewat')
  static Future<AssignmentResponse> getAssignments({String? filter}) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    final query = filter != null && filter.isNotEmpty
        ? '?filter=${Uri.encodeComponent(filter)}'
        : '';
    final response = await ApiClient.get('/student/assignments$query', token: token);
    return AssignmentResponse.fromJson(response);
  }

  /// Mengumpulkan tugas mahasiswa.
  ///
  /// Jika ada file terpilih ([fileBytes] + [fileName]), file diunggah ke
  /// backend terlebih dahulu — backend yang push ke Vercel Blob.
  /// FE / Mobile TIDAK boleh upload langsung ke Vercel Blob.
  ///
  /// [fileUrl] bisa diisi jika ingin mengirim tautan eksternal (mis. Google Drive).
  static Future<Map<String, dynamic>> submitAssignment({
    required int assignmentId,
    Uint8List? fileBytes,
    String? fileName,
    String? fileUrl,
    String? notes,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    String resolvedUrl = fileUrl?.trim() ?? '';

    // Jika ada file binary, upload ke backend → Vercel Blob
    if (fileBytes != null && fileBytes.isNotEmpty && fileName != null) {
      resolvedUrl = await ApiClient.uploadFile(
        '/upload',
        fileBytes: fileBytes,
        fileName: fileName,
        token: token,
        folder: 'assignments',
      );
    }

    return await ApiClient.post(
      '/student/assignments/$assignmentId/submit',
      body: {
        'fileUrl': resolvedUrl,
        'notes': notes?.trim() ?? '',
      },
      token: token,
    );
  }
}
