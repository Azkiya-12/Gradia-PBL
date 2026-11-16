class GradeCourseModel {
  final int classId;
  final String code;
  final String title;
  final int sks;
  final String prodi;
  final int semester;
  final String academicYear;
  final String schedule;
  final String room;
  final String lecturerName;
  final int? gradeId;
  final double? tugas;
  final double? uts;
  final double? uas;
  final double finalScore;
  final String letterGrade;
  final String gradeStatus;
  final String? aiFeedback;

  GradeCourseModel({
    required this.classId,
    required this.code,
    required this.title,
    required this.sks,
    required this.prodi,
    required this.semester,
    required this.academicYear,
    required this.schedule,
    required this.room,
    required this.lecturerName,
    this.gradeId,
    this.tugas,
    this.uts,
    this.uas,
    required this.finalScore,
    required this.letterGrade,
    required this.gradeStatus,
    this.aiFeedback,
  });

  factory GradeCourseModel.fromJson(Map<String, dynamic> json) {
    final rawScore = json['final_score'];
    final finalVal = rawScore is num
        ? rawScore.toDouble()
        : double.tryParse(rawScore?.toString() ?? '0') ?? 0.0;

    return GradeCourseModel(
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id']?.toString() ?? '0') ?? 0,
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      sks: json['sks'] is int
          ? json['sks']
          : int.tryParse(json['sks']?.toString() ?? '3') ?? 3,
      prodi: json['prodi']?.toString() ?? '',
      semester: json['semester'] is int
          ? json['semester']
          : int.tryParse(json['semester']?.toString() ?? '3') ?? 3,
      academicYear: json['academic_year']?.toString() ?? '2024/2025 Ganjil',
      schedule: json['schedule']?.toString() ?? '',
      room: json['room']?.toString() ?? '',
      lecturerName: json['lecturer_name']?.toString() ?? '',
      gradeId: json['grade_id'] is int
          ? json['grade_id']
          : int.tryParse(json['grade_id']?.toString() ?? ''),
      tugas: json['tugas'] != null
          ? (json['tugas'] is num
              ? (json['tugas'] as num).toDouble()
              : double.tryParse(json['tugas'].toString()))
          : null,
      uts: json['uts'] != null
          ? (json['uts'] is num
              ? (json['uts'] as num).toDouble()
              : double.tryParse(json['uts'].toString()))
          : null,
      uas: json['uas'] != null
          ? (json['uas'] is num
              ? (json['uas'] as num).toDouble()
              : double.tryParse(json['uas'].toString()))
          : null,
      finalScore: finalVal,
      letterGrade: json['letter_grade']?.toString() ?? 'B',
      gradeStatus: json['grade_status']?.toString() ?? 'Tersimpan',
      aiFeedback: json['ai_feedback']?.toString(),
    );
  }

  String get shortName {
    if (title.contains('User Interface') || title.contains('UI/UX')) {
      return 'Desain UI/UX';
    }
    if (title.contains('Framework')) return 'Web Framework';
    if (title.contains('Mobile')) return 'Pemrograman Mobile';
    if (title.contains('Jaringan')) return 'Jaringan Komputer';
    if (title.contains('Terapan')) return 'Algoritma';
    if (title.contains('Struktur Data')) return 'Struktur Data';
    if (title.contains('Basis Data')) return 'Basis Data';
    return title;
  }

  int get persen => finalScore.round();
}
