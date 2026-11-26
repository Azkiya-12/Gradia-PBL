import 'package:flutter/material.dart';
import '../../models/ai_feedback_model.dart';
import '../../models/dashboard_model.dart';
import '../../models/grade_model.dart';
import '../../widgets/insight_widgets.dart';

/// Screen 12 - Evaluasi AI: Kelebihan (dinamis dari data backend)
class KelebihanScreen extends StatelessWidget {
  final List<AiFeedbackItem> feedbacks;
  final List<GradeCourseModel> courses;
  final DashboardData? dashboardData;

  const KelebihanScreen({
    super.key,
    this.feedbacks = const [],
    this.courses = const [],
    this.dashboardData,
  });

  List<InsightItem> _buildItems() {
    final items = <InsightItem>[];

    final ipk = dashboardData?.stats.ipk;
    if (ipk != null && ipk >= 3.0) {
      items.add(
        InsightItem(
          'Akademik',
          'IPK Semester ${ipk.toStringAsFixed(2)}',
          ipk >= 3.5
              ? 'Pencapaian indeks prestasi sangat baik dan berada pada kategori sangat memuaskan.'
              : 'Indeks prestasi stabil dan memenuhi target kelulusan semester.',
        ),
      );
    }

    final att = dashboardData?.stats.attendancePercentage;
    if (att != null && att >= 80) {
      items.add(
        InsightItem(
          'Kehadiran',
          'Kehadiran stabil di $att%',
          'Konsistensi hadir di perkuliahan membantu pemahaman materi secara langsung.',
        ),
      );
    }

    final highCourses = courses.where((c) => c.finalScore >= 85).toList()
      ..sort((a, b) => b.finalScore.compareTo(a.finalScore));

    for (final c in highCourses) {
      items.add(
        InsightItem(
          c.code.isNotEmpty ? c.code : 'Capaian Tinggi',
          '${c.title} (${c.finalScore.toStringAsFixed(0)} · ${c.letterGrade})',
          (c.aiFeedback != null && c.aiFeedback!.isNotEmpty)
              ? c.aiFeedback!
              : 'Penguasaan kompetensi mata kuliah ini sangat baik dan melampaui target KKM.',
        ),
      );
    }

    if (items.isEmpty && feedbacks.isNotEmpty) {
      final goodFeedbacks = feedbacks.where((f) => f.finalScore >= 80).toList();
      for (final f in (goodFeedbacks.isNotEmpty ? goodFeedbacks : feedbacks.take(3))) {
        items.add(
          InsightItem(
            f.code,
            '${f.title} (${f.finalScore.toStringAsFixed(0)} · ${f.letterGrade})',
            f.aiFeedback,
          ),
        );
      }
    }

    if (items.isEmpty) {
      items.add(
        const InsightItem(
          'Informasi',
          'Belum ada data kelebihan',
          'Nilai dan evaluasi OBE dari dosen akan muncul di sini setelah penilaian selesai.',
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    return InsightScreen(
      title: 'Kelebihan',
      summaryTitle: '${items.length} kelebihan ditemukan',
      summarySubtitle: 'Berdasarkan nilai dan evaluasi capaian OBE dari backend',
      tone: InsightTone.success,
      items: items,
    );
  }
}
