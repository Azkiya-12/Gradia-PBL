import 'package:flutter/material.dart';
import '../../models/ai_feedback_model.dart';
import '../../models/grade_model.dart';
import '../../widgets/insight_widgets.dart';

/// Screen 13 - Evaluasi AI: Kekurangan (dinamis dari data backend)
class KekuranganScreen extends StatelessWidget {
  final List<AiFeedbackItem> feedbacks;
  final List<GradeCourseModel> courses;

  const KekuranganScreen({
    super.key,
    this.feedbacks = const [],
    this.courses = const [],
  });

  List<InsightItem> _buildItems() {
    final items = <InsightItem>[];

    final lowCourses = courses
        .where((c) => c.finalScore > 0 && c.finalScore < 85)
        .toList()
      ..sort((a, b) => a.finalScore.compareTo(b.finalScore));

    for (final c in lowCourses) {
      final isRemedial = c.finalScore < 65 || c.gradeStatus.toLowerCase().contains('remedial');
      items.add(
        InsightItem(
          isRemedial ? 'Prioritas tinggi' : 'Perlu ditingkatkan',
          '${c.title} (${c.finalScore.toStringAsFixed(0)} · ${c.letterGrade})',
          (c.aiFeedback != null && c.aiFeedback!.isNotEmpty)
              ? c.aiFeedback!
              : 'Nilai pada mata kuliah ini masih bisa dioptimalkan dengan latihan soal dan penguatan materi.',
        ),
      );
    }

    if (items.isEmpty && feedbacks.isNotEmpty) {
      final sorted = List<AiFeedbackItem>.from(feedbacks)
        ..sort((a, b) => a.finalScore.compareTo(b.finalScore));
      final lowest = sorted.first;
      items.add(
        InsightItem(
          'Fokus peningkatan',
          '${lowest.title} (${lowest.finalScore.toStringAsFixed(0)} · ${lowest.letterGrade})',
          lowest.aiFeedback,
        ),
      );
    }

    if (items.isEmpty) {
      items.add(
        const InsightItem(
          'Pertahankan',
          'Tidak ada nilai tertinggal',
          'Seluruh mata kuliah yang dinilai telah memenuhi ambang batas capaian pembelajaran.',
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    return InsightScreen(
      title: 'Kekurangan',
      summaryTitle: '${items.length} hal perlu diperhatikan',
      summarySubtitle: 'Fokus pada bagian ini agar capaian OBE makin optimal',
      tone: InsightTone.warning,
      items: items,
    );
  }
}
