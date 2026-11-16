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

  /// Mengumpulkan tugas mahasiswa
  static Future<Map<String, dynamic>> submitAssignment({
    required int assignmentId,
    String? fileUrl,
    String? notes,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    return await ApiClient.post(
      '/student/assignments/$assignmentId/submit',
      body: {
        'fileUrl': fileUrl?.trim() ?? '',
        'notes': notes?.trim() ?? '',
      },
      token: token,
    );
  }
}
