import '../models/ai_feedback_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class AiService {
  /// Mengambil daftar ulasan / evaluasi AI yang tersimpan untuk mahasiswa
  /// Endpoint: GET /api/student/ai-feedback
  static Future<List<AiFeedbackItem>> getSavedAiFeedbacks() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    final response = await ApiClient.get('/student/ai-feedback', token: token);
    final raw = response['feedbacks'] as List? ?? [];
    return raw
        .map((item) => AiFeedbackItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Meminta evaluasi AI baru berbasis capaian pembelajaran OBE (Gemini / rule-based fallback)
  /// Endpoint: POST /api/ai/feedback
  static Future<GeneratedAiFeedback> generateFeedback({
    String? studentName,
    String? nim,
    String? courseName,
    num? tugas,
    num? uts,
    num? uas,
    num? finalScore,
    String? letterGrade,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw ApiException('Sesi telah berakhir, silakan login kembali.');
    }

    final user = await AuthService.getUser();
    final name = (studentName != null && studentName.isNotEmpty)
        ? studentName
        : (user?.name ?? 'Mahasiswa');
    final studentNim = (nim != null && nim.isNotEmpty) ? nim : (user?.nim ?? '');

    final response = await ApiClient.post(
      '/ai/feedback',
      body: {
        'studentName': name,
        'nim': studentNim,
        if (courseName != null && courseName.isNotEmpty) 'courseName': courseName,
        if (tugas != null) 'tugas': tugas,
        if (uts != null) 'uts': uts,
        if (uas != null) 'uas': uas,
        if (finalScore != null) 'finalScore': finalScore,
        if (letterGrade != null && letterGrade.isNotEmpty) 'letterGrade': letterGrade,
      },
      token: token,
    );

    return GeneratedAiFeedback.fromJson(response);
  }
}
