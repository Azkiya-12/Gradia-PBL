import 'attendance_model.dart';
import 'assignment_model.dart';

class TaskStats {
  final int terlewat;
  final int mendatang;
  final int terkumpul;

  TaskStats({
    required this.terlewat,
    required this.mendatang,
    required this.terkumpul,
  });

  factory TaskStats.fromJson(Map<String, dynamic> json) {
    return TaskStats(
      terlewat: json['terlewat'] is int
          ? json['terlewat']
          : int.tryParse(json['terlewat']?.toString() ?? '0') ?? 0,
      mendatang: json['mendatang'] is int
          ? json['mendatang']
          : int.tryParse(json['mendatang']?.toString() ?? '0') ?? 0,
      terkumpul: json['terkumpul'] is int
          ? json['terkumpul']
          : int.tryParse(json['terkumpul']?.toString() ?? '0') ?? 0,
    );
  }
}

class DashboardStats {
  final int totalCourses;
  final int totalSks;
  final double ipk;
  final int attendancePercentage;
  final TaskStats taskStats;
  final String academicYear;
  final int semester;

  DashboardStats({
    required this.totalCourses,
    required this.totalSks,
    required this.ipk,
    required this.attendancePercentage,
    required this.taskStats,
    required this.academicYear,
    required this.semester,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalCourses: json['totalCourses'] is int
          ? json['totalCourses']
          : int.tryParse(json['totalCourses']?.toString() ?? '0') ?? 0,
      totalSks: json['totalSks'] is int
          ? json['totalSks']
          : int.tryParse(json['totalSks']?.toString() ?? '0') ?? 0,
      ipk: (json['ipk'] is num)
          ? (json['ipk'] as num).toDouble()
          : double.tryParse(json['ipk']?.toString() ?? '3.75') ?? 3.75,
      attendancePercentage: json['attendancePercentage'] is int
          ? json['attendancePercentage']
          : int.tryParse(json['attendancePercentage']?.toString() ?? '92') ?? 92,
      taskStats: TaskStats.fromJson(
        json['taskStats'] is Map<String, dynamic>
            ? json['taskStats']
            : <String, dynamic>{},
      ),
      academicYear: json['academicYear']?.toString() ?? '2024/2025 Ganjil',
      semester: json['semester'] is int
          ? json['semester']
          : int.tryParse(json['semester']?.toString() ?? '3') ?? 3,
    );
  }
}

class DashboardData {
  final DashboardStats stats;
  final List<dynamic> courses;
  final ActiveSession? activeSession;
  final List<AssignmentItemModel> upcomingAssignments;

  DashboardData({
    required this.stats,
    required this.courses,
    this.activeSession,
    this.upcomingAssignments = const [],
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final rawUpcoming = json['upcomingAssignments'] as List? ?? [];
    return DashboardData(
      stats: DashboardStats.fromJson(
        json['stats'] is Map<String, dynamic>
            ? json['stats']
            : <String, dynamic>{},
      ),
      courses: json['courses'] is List ? json['courses'] : [],
      activeSession: json['activeSession'] is Map<String, dynamic>
          ? ActiveSession.fromJson(json['activeSession'])
          : null,
      upcomingAssignments: rawUpcoming
          .map((item) =>
              AssignmentItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

