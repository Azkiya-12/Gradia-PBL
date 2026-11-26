import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/ai_feedback_model.dart';
import '../../models/dashboard_model.dart';
import '../../models/grade_model.dart';
import '../../widgets/common.dart';

/// Isi tab "Analisis AI" (dipakai di screen 11 dan screen 13).
class AnalisisAiContent extends StatelessWidget {
  final List<AiFeedbackItem> feedbacks;
  final List<GradeCourseModel> courses;
  final DashboardData? dashboardData;

  const AnalisisAiContent({
    super.key,
    this.feedbacks = const [],
    this.courses = const [],
    this.dashboardData,
  });

  String _buildSummaryText() {
    final ipk = dashboardData?.stats.ipk;
    final att = dashboardData?.stats.attendancePercentage;

    final graded = courses.where((c) => c.finalScore > 0).toList()
      ..sort((a, b) => b.finalScore.compareTo(a.finalScore));

    if (graded.isEmpty && feedbacks.isEmpty) {
      return 'Belum ada data nilai yang cukup untuk dianalisis oleh AI.';
    }

    final bestName = graded.isNotEmpty ? graded.first.title : feedbacks.first.title;
    final worstName = graded.length > 1 ? graded.last.title : null;

    final ipkPart = ipk != null ? 'IPK kamu saat ini ${ipk.toStringAsFixed(2)}' : 'Performa akademikmu';
    final attPart = att != null ? ' dengan tingkat kehadiran $att%' : '';

    if (worstName != null && graded.last.finalScore < 85) {
      return '$ipkPart$attPart. Capaian terbaikmu ada di $bestName, sementara $worstName masih perlu fokus dan latihan tambahan.';
    }
    return '$ipkPart$attPart. Seluruh mata kuliah berjalan sangat baik dengan capaian tertinggi di $bestName.';
  }

  @override
  Widget build(BuildContext context) {
    final graded = courses.where((c) => c.finalScore > 0).toList()
      ..sort((a, b) => b.finalScore.compareTo(a.finalScore));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Kesimpulan performa'),
        const SizedBox(height: 12),
        InfoCard(_buildSummaryText()),
        const SizedBox(height: 24),
        const SectionTitle('Grafik IPK dan IPS per semester'),
        const SizedBox(height: 12),
        _IpkIpsChartCard(courses: courses, currentIpk: dashboardData?.stats.ipk),
        const SizedBox(height: 24),
        const SectionTitle('Terbaik dan perlu ditingkatkan'),
        const SizedBox(height: 12),
        _BestWorst(gradedCourses: graded, feedbacks: feedbacks),
        if (feedbacks.isNotEmpty) ...[
          const SizedBox(height: 24),
          const SectionTitle('Ulasan capaian OBE per mata kuliah'),
          const SizedBox(height: 12),
          for (final item in feedbacks) ...[
            _ObeFeedbackCard(item: item),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _ObeFeedbackCard extends StatelessWidget {
  final AiFeedbackItem item;
  const _ObeFeedbackCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isGood = item.finalScore >= 80;
    final badgeBg = isGood ? AppColors.successSoft : AppColors.warningSoft;
    final badgeFg = isGood ? AppColors.success : AppColors.warning;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.code} · ${item.lecturerName}',
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${item.finalScore.toStringAsFixed(1)} (${item.letterGrade})',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: badgeFg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.aiFeedback,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// Grafik IPS (per semester) dan IPK (kumulatif)
// ---------------------------------------------------------------
class _IpkIpsChartCard extends StatelessWidget {
  final List<GradeCourseModel> courses;
  final double? currentIpk;

  const _IpkIpsChartCard({required this.courses, this.currentIpk});

  static const _gradePoints = <String, double>{
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'D': 1.0,
    'E': 0.0,
  };

  Map<int, double> _computeSemesterIps() {
    final bySem = <int, List<GradeCourseModel>>{};
    for (final c in courses) {
      if (_gradePoints.containsKey(c.letterGrade)) {
        bySem.putIfAbsent(c.semester, () => []).add(c);
      }
    }

    final sortedKeys = bySem.keys.toList()..sort();
    final result = <int, double>{};
    for (final sem in sortedKeys) {
      double qp = 0;
      int sks = 0;
      for (final c in bySem[sem]!) {
        final gp = _gradePoints[c.letterGrade] ?? 0.0;
        qp += gp * c.sks;
        sks += c.sks;
      }
      if (sks > 0) {
        result[sem] = double.parse((qp / sks).toStringAsFixed(2));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final semIpsMap = _computeSemesterIps();
    final semesters = semIpsMap.keys.toList();
    final ips = semIpsMap.values.toList();

    // Jika baru ada 1 semester, tambahkan titik referensi awal atau tampilkan apa adanya
    final List<String> labels;
    final List<double> plotIps;
    final List<double> plotIpk;

    if (ips.isEmpty) {
      final fallback = currentIpk ?? 3.7;
      labels = ['S1'];
      plotIps = [fallback];
      plotIpk = [fallback];
    } else {
      labels = semesters.map((s) => 'S$s').toList();
      plotIps = ips;
      plotIpk = <double>[];
      var total = 0.0;
      for (var i = 0; i < ips.length; i++) {
        total += ips[i];
        plotIpk.add(double.parse((total / (i + 1)).toStringAsFixed(2)));
      }
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _LegendItem('IPS (per semester)', AppColors.primary, false),
              _LegendItem('IPK (kumulatif)', AppColors.warning, true),
            ],
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 2.0,
            child: CustomPaint(
              painter: _IpkIpsPainter(plotIps, plotIpk, labels),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            plotIps.length > 1
                ? 'IPS bergerak dari ${plotIps.first.toStringAsFixed(2)} ke '
                    '${plotIps.last.toStringAsFixed(2)}, IPK kumulatif saat ini '
                    '${plotIpk.last.toStringAsFixed(2)}.'
                : 'IPS ${labels.first}: ${plotIps.first.toStringAsFixed(2)} · IPK kumulatif: ${plotIpk.last.toStringAsFixed(2)}.',
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool putus;
  const _LegendItem(this.label, this.color, this.putus);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 4,
          child: putus
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Container(width: 5, height: 3, color: color),
                  ],
                )
              : Container(color: color),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
      ],
    );
  }
}

class _IpkIpsPainter extends CustomPainter {
  final List<double> ips;
  final List<double> ipk;
  final List<String> labels;
  _IpkIpsPainter(this.ips, this.ipk, this.labels);

  static const double _min = 2.4;
  static const double _max = 4.0;

  void _teks(Canvas canvas, String t, Offset o) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: const TextStyle(fontSize: 10, color: AppColors.muted),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, o);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const kiri = 30.0, bawah = 22.0, atas = 8.0;
    final lebar = size.width - kiri - 8;
    final tinggi = size.height - bawah - atas;

    double xAt(int i) {
      if (ips.length <= 1) return kiri + lebar / 2;
      return kiri + 8 + (lebar - 16) * i / (ips.length - 1);
    }

    double yAt(double v) {
      final clamped = v.clamp(_min, _max);
      return atas + tinggi * (1 - (clamped - _min) / (_max - _min));
    }

    // Garis bantu dan label sumbu Y
    final grid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (var k = 0; k <= 4; k++) {
      final v = _min + 0.4 * k;
      final y = yAt(v);
      canvas.drawLine(Offset(kiri, y), Offset(size.width, y), grid);
      _teks(canvas, v.toStringAsFixed(1), Offset(0, y - 6));
    }

    // Label sumbu X
    for (var i = 0; i < ips.length; i++) {
      _teks(canvas, labels[i], Offset(xAt(i) - 8, size.height - 14));
    }

    _garis(canvas, ipk, xAt, yAt, AppColors.warning, putus: true);
    _garis(canvas, ips, xAt, yAt, AppColors.primary, putus: false);
  }

  void _garis(
    Canvas canvas,
    List<double> data,
    double Function(int) xAt,
    double Function(double) yAt,
    Color warna, {
    required bool putus,
  }) {
    if (data.isEmpty) return;

    if (data.length > 1) {
      final path = Path()..moveTo(xAt(0), yAt(data[0]));
      for (var i = 1; i < data.length; i++) {
        path.lineTo(xAt(i), yAt(data[i]));
      }

      final cat = Paint()
        ..color = warna
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round;

      if (putus) {
        for (final m in path.computeMetrics()) {
          var d = 0.0;
          while (d < m.length) {
            canvas.drawPath(m.extractPath(d, d + 6), cat);
            d += 10;
          }
        }
      } else {
        canvas.drawPath(path, cat);
      }
    }

    for (var i = 0; i < data.length; i++) {
      final p = Offset(xAt(i), yAt(data[i]));
      canvas.drawCircle(p, 4, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        4,
        Paint()
          ..color = warna
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _IpkIpsPainter oldDelegate) =>
      oldDelegate.ips != ips || oldDelegate.ipk != ipk;
}

// ---------------------------------------------------------------
// Terbaik dan perlu ditingkatkan (dinamis dari backend)
// ---------------------------------------------------------------
class _BestWorst extends StatelessWidget {
  final List<GradeCourseModel> gradedCourses;
  final List<AiFeedbackItem> feedbacks;

  const _BestWorst({required this.gradedCourses, required this.feedbacks});

  @override
  Widget build(BuildContext context) {
    String bestTitle = '-';
    String bestDesc = 'Belum ada nilai mata kuliah.';
    String worstTitle = '-';
    String worstDesc = 'Belum ada catatan peningkatan.';

    if (gradedCourses.isNotEmpty) {
      final best = gradedCourses.first;
      bestTitle = best.title;
      bestDesc = best.aiFeedback != null && best.aiFeedback!.isNotEmpty
          ? 'Nilai ${best.finalScore.toStringAsFixed(0)} (${best.letterGrade}). ${best.aiFeedback}'
          : 'Nilai ${best.finalScore.toStringAsFixed(0)} (${best.letterGrade}), capaian tertinggi semester ini.';

      final worst = gradedCourses.last;
      worstTitle = worst.title;
      worstDesc = worst.aiFeedback != null && worst.aiFeedback!.isNotEmpty
          ? 'Nilai ${worst.finalScore.toStringAsFixed(0)} (${worst.letterGrade}). ${worst.aiFeedback}'
          : 'Nilai ${worst.finalScore.toStringAsFixed(0)} (${worst.letterGrade}). Pertahankan latihan dan evaluasi materi.';
    } else if (feedbacks.isNotEmpty) {
      final sorted = List<AiFeedbackItem>.from(feedbacks)
        ..sort((a, b) => b.finalScore.compareTo(a.finalScore));
      final best = sorted.first;
      bestTitle = best.title;
      bestDesc = 'Nilai ${best.finalScore.toStringAsFixed(0)} (${best.letterGrade}). ${best.aiFeedback}';

      final worst = sorted.last;
      worstTitle = worst.title;
      worstDesc = 'Nilai ${worst.finalScore.toStringAsFixed(0)} (${worst.letterGrade}). ${worst.aiFeedback}';
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _Box(
              label: 'Terbaik',
              name: bestTitle,
              description: bestDesc,
              bg: AppColors.successSoft,
              border: const Color(0xFFA7F3D0),
              fg: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Box(
              label: 'Perlu ditingkatkan',
              name: worstTitle,
              description: worstDesc,
              bg: AppColors.warningSoft,
              border: const Color(0xFFFDE68A),
              fg: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final String label;
  final String name;
  final String description;
  final Color bg;
  final Color border;
  final Color fg;
  const _Box({
    required this.label,
    required this.name,
    required this.description,
    required this.bg,
    required this.border,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
          const SizedBox(height: 6),
          Text(name,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink)),
          const SizedBox(height: 6),
          Text(description,
              style: const TextStyle(
                  fontSize: 12, height: 1.45, color: Color(0xFF334155))),
        ],
      ),
    );
  }
}
