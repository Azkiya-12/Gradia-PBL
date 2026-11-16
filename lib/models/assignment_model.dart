class AssignmentItemModel {
  final int id;
  final int classId;
  final String title;
  final String description;
  final String deadline;
  final String course;
  final String courseCode;
  final int? submissionId;
  final String? fileUrl;
  final String? notes;
  final String? submittedAt;
  final double? score;
  final String status; // 'To-Do', 'Terkumpul', 'Terlewat'

  AssignmentItemModel({
    required this.id,
    required this.classId,
    required this.title,
    required this.description,
    required this.deadline,
    required this.course,
    required this.courseCode,
    this.submissionId,
    this.fileUrl,
    this.notes,
    this.submittedAt,
    this.score,
    required this.status,
  });

  factory AssignmentItemModel.fromJson(Map<String, dynamic> json) {
    return AssignmentItemModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      deadline: json['deadline']?.toString() ?? '',
      course: json['course']?.toString() ?? '',
      courseCode: json['course_code']?.toString() ?? '',
      submissionId: json['submission_id'] is int
          ? json['submission_id']
          : int.tryParse(json['submission_id']?.toString() ?? ''),
      fileUrl: json['file_url']?.toString(),
      notes: json['notes']?.toString(),
      submittedAt: json['submitted_at']?.toString(),
      score: (json['score'] is num)
          ? (json['score'] as num).toDouble()
          : double.tryParse(json['score']?.toString() ?? ''),
      status: json['status']?.toString() ?? 'To-Do',
    );
  }

  /// Format deadline yang ramah pengguna
  String get formattedDeadline {
    if (status == 'Terkumpul') {
      if (submittedAt != null && submittedAt!.isNotEmpty) {
        final dt = DateTime.tryParse(submittedAt!.replaceFirst(' ', 'T'));
        if (dt != null) {
          return 'Terkumpul ${_formatDate(dt)}';
        }
      }
      return 'Terkumpul';
    }

    final dt = DateTime.tryParse(deadline.replaceFirst(' ', 'T'));
    if (dt == null) return deadline;

    final now = DateTime.now();
    final diff = dt.difference(now);

    final timeStr =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    if (diff.isNegative) {
      final daysLate = (now.difference(dt).inHours / 24).ceil();
      if (daysLate <= 1) {
        return 'Terlambat kemarin, $timeStr';
      }
      return 'Terlambat $daysLate hari';
    }

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Hari ini, $timeStr';
    }

    final tomorrow = now.add(const Duration(days: 1));
    if (dt.year == tomorrow.year &&
        dt.month == tomorrow.month &&
        dt.day == tomorrow.day) {
      return 'Besok, $timeStr';
    }

    const hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    if (diff.inDays < 7) {
      return '${hari[dt.weekday - 1]}, $timeStr';
    }

    return '${_formatDate(dt)}, $timeStr';
  }

  static String _formatDate(DateTime dt) {
    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${dt.day} ${bulan[dt.month - 1]}';
  }
}

class AssignmentCounts {
  final int todo;
  final int terkumpul;
  final int terlewat;

  AssignmentCounts({
    required this.todo,
    required this.terkumpul,
    required this.terlewat,
  });

  factory AssignmentCounts.fromJson(Map<String, dynamic> json) {
    return AssignmentCounts(
      todo: json['todo'] is int
          ? json['todo']
          : int.tryParse(json['todo']?.toString() ?? '0') ?? 0,
      terkumpul: json['terkumpul'] is int
          ? json['terkumpul']
          : int.tryParse(json['terkumpul']?.toString() ?? '0') ?? 0,
      terlewat: json['terlewat'] is int
          ? json['terlewat']
          : int.tryParse(json['terlewat']?.toString() ?? '0') ?? 0,
    );
  }
}

class AssignmentResponse {
  final AssignmentCounts counts;
  final List<AssignmentItemModel> assignments;

  AssignmentResponse({
    required this.counts,
    required this.assignments,
  });

  factory AssignmentResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['assignments'] as List? ?? [];
    return AssignmentResponse(
      counts: AssignmentCounts.fromJson(
        json['counts'] is Map<String, dynamic>
            ? json['counts']
            : <String, dynamic>{},
      ),
      assignments: rawList
          .map((item) =>
              AssignmentItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
