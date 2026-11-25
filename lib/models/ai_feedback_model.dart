class AiFeedbackItem {
  final int classId;
  final String code;
  final String title;
  final int sks;
  final String lecturerName;
  final double finalScore;
  final String letterGrade;
  final String gradeStatus;
  final String aiFeedback;
  final String? updatedAt;

  AiFeedbackItem({
    required this.classId,
    required this.code,
    required this.title,
    required this.sks,
    required this.lecturerName,
    required this.finalScore,
    required this.letterGrade,
    required this.gradeStatus,
    required this.aiFeedback,
    this.updatedAt,
  });

  factory AiFeedbackItem.fromJson(Map<String, dynamic> json) {
    return AiFeedbackItem(
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id']?.toString() ?? '0') ?? 0,
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      sks: json['sks'] is int
          ? json['sks']
          : int.tryParse(json['sks']?.toString() ?? '0') ?? 0,
      lecturerName: json['lecturer_name']?.toString() ?? '',
      finalScore: (json['final_score'] is num)
          ? (json['final_score'] as num).toDouble()
          : double.tryParse(json['final_score']?.toString() ?? '0') ?? 0.0,
      letterGrade: json['letter_grade']?.toString() ?? '',
      gradeStatus: json['grade_status']?.toString() ?? '',
      aiFeedback: json['ai_feedback']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class GeneratedAiFeedback {
  final String feedback;
  final String source; // 'gemini' | 'rule-based'
  final String? strength;
  final String? improvement;
  final String? recommendation;

  GeneratedAiFeedback({
    required this.feedback,
    required this.source,
    this.strength,
    this.improvement,
    this.recommendation,
  });

  String get effectiveStrength =>
      (strength != null && strength!.isNotEmpty) ? strength! : feedback;

  String get effectiveImprovement =>
      (improvement != null && improvement!.isNotEmpty)
          ? improvement!
          : 'Tingkatkan latihan praktikum dan perdalam konsep pada materi yang masih memerlukan penguatan.';

  String get effectiveRecommendation =>
      (recommendation != null && recommendation!.isNotEmpty)
          ? recommendation!
          : 'Jaga kehadiran aktif di kelas, diskusikan materi sulit bersama dosen atau rekan kelompok, dan kumpulkan tugas tepat waktu.';

  factory GeneratedAiFeedback.fromJson(Map<String, dynamic> json) {
    return GeneratedAiFeedback(
      feedback: json['feedback']?.toString() ?? '',
      source: json['source']?.toString() ?? 'rule-based',
      strength: json['strength']?.toString(),
      improvement: json['improvement']?.toString(),
      recommendation: json['recommendation']?.toString(),
    );
  }
}
