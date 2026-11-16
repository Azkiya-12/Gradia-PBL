import '../models/grade_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class GradeService {
  /// Mengambil daftar nilai akademik seluruh mata kuliah mahasiswa dari backend
  static Future<List<GradeCourseModel>> getGrades() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    final response = await ApiClient.get('/student/grades', token: token);
    final raw = response['courses'] as List? ?? [];
    return raw
        .map((c) => GradeCourseModel.fromJson(c as Map<String, dynamic>))
        .toList();
  }

  /// Mengajukan permohonan koreksi / sanggahan nilai ke dosen pengampu
  static Future<Map<String, dynamic>> submitGradeReview({
    required int classId,
    required String component,
    required String currentScore,
    required String reason,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    return await ApiClient.post(
      '/student/grade-reviews',
      body: {
        'classId': classId,
        'component': component.trim(),
        'currentScore': currentScore.trim(),
        'reason': reason.trim(),
      },
      token: token,
    );
  }

  /// Mengambil riwayat pengajuan review / sanggahan nilai mahasiswa
  static Future<List<dynamic>> getGradeReviews() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    final response =
        await ApiClient.get('/student/grade-reviews', token: token);
    return response['reviews'] as List? ?? [];
  }
}
