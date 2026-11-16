class ActiveSession {
  final int classId;
  final String nama;
  final String code;
  final String schedule;
  final String room;
  final String batas;
  final bool sudahAbsen;
  final String? status;
  final String? notes;

  ActiveSession({
    required this.classId,
    required this.nama,
    required this.code,
    required this.schedule,
    required this.room,
    required this.batas,
    required this.sudahAbsen,
    this.status,
    this.notes,
  });

  factory ActiveSession.fromJson(Map<String, dynamic> json) {
    return ActiveSession(
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id']?.toString() ?? '0') ?? 0,
      nama: json['nama']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      schedule: json['schedule']?.toString() ?? '',
      room: json['room']?.toString() ?? '',
      batas: json['batas']?.toString() ?? 'Ditutup 10:15',
      sudahAbsen: json['sudahAbsen'] == true,
      status: json['status']?.toString(),
      notes: json['notes']?.toString(),
    );
  }
}

class CourseAttendance {
  final int classId;
  final String nama;
  final String code;
  final String schedule;
  final String room;
  final int total;
  final int hadir;
  final int izin;
  final int sakit;
  final int alpa;
  final int persen;
  final String keterangan;
  final bool dibuka;

  CourseAttendance({
    required this.classId,
    required this.nama,
    required this.code,
    required this.schedule,
    required this.room,
    required this.total,
    required this.hadir,
    required this.izin,
    required this.sakit,
    required this.alpa,
    required this.persen,
    required this.keterangan,
    required this.dibuka,
  });

  factory CourseAttendance.fromJson(Map<String, dynamic> json) {
    return CourseAttendance(
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id']?.toString() ?? '0') ?? 0,
      nama: json['nama']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      schedule: json['schedule']?.toString() ?? '',
      room: json['room']?.toString() ?? '',
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      hadir: json['hadir'] is int
          ? json['hadir']
          : int.tryParse(json['hadir']?.toString() ?? '0') ?? 0,
      izin: json['izin'] is int
          ? json['izin']
          : int.tryParse(json['izin']?.toString() ?? '0') ?? 0,
      sakit: json['sakit'] is int
          ? json['sakit']
          : int.tryParse(json['sakit']?.toString() ?? '0') ?? 0,
      alpa: json['alpa'] is int
          ? json['alpa']
          : int.tryParse(json['alpa']?.toString() ?? '0') ?? 0,
      persen: json['persen'] is int
          ? json['persen']
          : int.tryParse(json['persen']?.toString() ?? '0') ?? 0,
      keterangan: json['keterangan']?.toString() ?? '',
      dibuka: json['dibuka'] == true,
    );
  }
}

class AttendanceData {
  final int overallPercentage;
  final int totalPertemuan;
  final int totalHadir;
  final int totalIzin;
  final int totalSakit;
  final int totalAlpa;
  final ActiveSession? activeSession;
  final List<CourseAttendance> courses;

  AttendanceData({
    required this.overallPercentage,
    required this.totalPertemuan,
    required this.totalHadir,
    required this.totalIzin,
    required this.totalSakit,
    required this.totalAlpa,
    this.activeSession,
    required this.courses,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    final rawCourses = json['courses'] as List? ?? [];
    return AttendanceData(
      overallPercentage: json['overallPercentage'] is int
          ? json['overallPercentage']
          : int.tryParse(json['overallPercentage']?.toString() ?? '100') ?? 100,
      totalPertemuan: json['totalPertemuan'] is int
          ? json['totalPertemuan']
          : int.tryParse(json['totalPertemuan']?.toString() ?? '0') ?? 0,
      totalHadir: json['totalHadir'] is int
          ? json['totalHadir']
          : int.tryParse(json['totalHadir']?.toString() ?? '0') ?? 0,
      totalIzin: json['totalIzin'] is int
          ? json['totalIzin']
          : int.tryParse(json['totalIzin']?.toString() ?? '0') ?? 0,
      totalSakit: json['totalSakit'] is int
          ? json['totalSakit']
          : int.tryParse(json['totalSakit']?.toString() ?? '0') ?? 0,
      totalAlpa: json['totalAlpa'] is int
          ? json['totalAlpa']
          : int.tryParse(json['totalAlpa']?.toString() ?? '0') ?? 0,
      activeSession: json['activeSession'] is Map<String, dynamic>
          ? ActiveSession.fromJson(json['activeSession'])
          : null,
      courses: rawCourses
          .map((c) => CourseAttendance.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

