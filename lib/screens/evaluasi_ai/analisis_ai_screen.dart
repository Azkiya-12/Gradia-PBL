import 'dart:math';
import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/ai_feedback_model.dart';
import '../../services/ai_service.dart';
import '../../services/grade_service.dart';
import '../../widgets/common.dart';

/// Isi tab "Analisis AI" (dipakai di screen 11 dan screen 13).
class AnalisisAiContent extends StatefulWidget {
  const AnalisisAiContent({super.key});

  @override
  State<AnalisisAiContent> createState() => _AnalisisAiContentState();
}

class _AnalisisAiContentState extends State<AnalisisAiContent> {
  bool _isLoading = true;
  bool _isGenerating = false;
  String? _errorMessage;

  List<AiFeedbackItem> _savedFeedbacks = [];
  GeneratedAiFeedback? _generatedFeedback;
  List<double> _ipsList = [];
  List<double> _ipkList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final saved = await AiService.getSavedAiFeedbacks(forceRefresh: forceRefresh);
      final cachedGen = AiService.cachedGeneratedFeedback;

      _savedFeedbacks = saved;
      _generatedFeedback = cachedGen;

      await _computeIpsIpk();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _computeIpsIpk() async {
    try {
      final grades = await GradeService.getGrades();
      if (grades.isNotEmpty) {
        final Map<int, List<double>> semesterScores = {};
        for (final g in grades) {
          semesterScores.putIfAbsent(g.semester, () => []);
          semesterScores[g.semester]!.add(_scoreToPoint(g.finalScore));
        }

        final sortedSemesters = semesterScores.keys.toList()..sort();
        final List<double> computedIps = [];
        for (final sem in sortedSemesters) {
          final scores = semesterScores[sem]!;
          final avg = scores.reduce((a, b) => a + b) / scores.length;
          computedIps.add(double.parse(avg.toStringAsFixed(2)));
        }

        if (computedIps.isNotEmpty) {
          _ipsList = computedIps;
          _ipkList = _calculateCumulativeIpk(_ipsList);
          return;
        }
      }
    } catch (_) {}

    if (_savedFeedbacks.isNotEmpty) {
      final points = _savedFeedbacks.map((f) => _scoreToPoint(f.finalScore)).toList();
      _ipsList = [double.parse((points.reduce((a, b) => a + b) / points.length).toStringAsFixed(2))];
      _ipkList = _calculateCumulativeIpk(_ipsList);
    } else {
      _ipsList = [3.5];
      _ipkList = [3.5];
    }
  }

  double _scoreToPoint(double score) {
    if (score >= 85) return 4.0;
    if (score >= 80) return 3.7;
    if (score >= 75) return 3.3;
    if (score >= 70) return 3.0;
    if (score >= 65) return 2.7;
    if (score >= 60) return 2.3;
    if (score >= 55) return 2.0;
    if (score >= 40) return 1.0;
    return 0.0;
  }

  List<double> _calculateCumulativeIpk(List<double> ips) {
    final result = <double>[];
    var sum = 0.0;
    for (var i = 0; i < ips.length; i++) {
      sum += ips[i];
      result.add(double.parse((sum / (i + 1)).toStringAsFixed(2)));
    }
    return result;
  }

  Future<void> _generateEvaluation() async {
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      final gen = await AiService.generateFeedback();
      if (!mounted) return;
      setState(() {
        _generatedFeedback = gen;
        _isGenerating = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_errorMessage != null) {
      return AppCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 40, color: AppColors.danger),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            PrimaryButton('Coba lagi', onPressed: () => _loadData(forceRefresh: true)),
          ],
        ),
      );
    }

    final hasData = _savedFeedbacks.isNotEmpty || _generatedFeedback != null;
    if (!hasData) {
      return EmptyState(
        icon: Icons.auto_awesome_outlined,
        title: 'Belum ada evaluasi AI',
        message:
            'Evaluasi AI menganalisis nilai akademik dan capaian pembelajaran OBE untuk memberikan telaah performa.',
        primaryLabel: _isGenerating ? 'Menganalisis...' : 'Generate Evaluasi',
        onPrimary: _isGenerating ? () {} : _generateEvaluation,
      );
    }

    // Tentukan Kesimpulan Performa
    String summary;
    if (_generatedFeedback != null) {
      summary = _generatedFeedback!.feedback;
    } else {
      final feedbacks = _savedFeedbacks
          .where((f) => f.aiFeedback.isNotEmpty)
          .map((f) => '${f.title}: ${f.aiFeedback}')
          .toList();
      summary = feedbacks.isNotEmpty
          ? feedbacks.join('\n\n')
          : 'Evaluasi capaian OBE telah tersimpan. Pertahankan ritme belajar pada mata kuliah unggulan.';
    }

    // Tentukan Terbaik & Perlu Ditingkatkan
    String bestName = 'Mata Kuliah Unggulan';
    String bestDesc = 'Capaian indikator OBE sangat memuaskan.';
    String worstName = 'Perlu Ditingkatkan';
    String worstDesc = 'Perlu latihan tambahan dan konsultasi bimbingan.';

    if (_savedFeedbacks.isNotEmpty) {
      final sorted = List<AiFeedbackItem>.from(_savedFeedbacks)
        ..sort((a, b) => b.finalScore.compareTo(a.finalScore));
      final best = sorted.first;
      final worst = sorted.last;

      bestName = best.title;
      bestDesc = best.aiFeedback.isNotEmpty
          ? best.aiFeedback
          : 'Nilai ${best.finalScore.toStringAsFixed(0)} (${best.letterGrade}), tertinggi di kelas.';

      if (sorted.length > 1) {
        worstName = worst.title;
        worstDesc = worst.aiFeedback.isNotEmpty
            ? worst.aiFeedback
            : 'Nilai ${worst.finalScore.toStringAsFixed(0)} (${worst.letterGrade}). Perbanyak latihan dan tingkatkan tugas praktik.';
      } else {
        worstName = 'Target Berikutnya';
        worstDesc = 'Pertahankan penguasaan materi dan tingkatkan pemahaman studi kasus mandiri.';
      }
    } else if (_generatedFeedback != null) {
      bestName = 'Penguasaan Konsep';
      bestDesc = _generatedFeedback!.effectiveStrength;
      worstName = 'Fokus Perbaikan';
      worstDesc = _generatedFeedback!.effectiveImprovement;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Kesimpulan performa'),
        const SizedBox(height: 12),
        InfoCard(summary),
        const SizedBox(height: 24),
        const SectionTitle('Grafik IPK dan IPS per semester'),
        const SizedBox(height: 12),
        _IpkIpsChartCard(ips: _ipsList, ipk: _ipkList),
        const SizedBox(height: 24),
        const SectionTitle('Terbaik dan perlu ditingkatkan'),
        const SizedBox(height: 12),
        _BestWorst(
          bestName: bestName,
          bestDesc: bestDesc,
          worstName: worstName,
          worstDesc: worstDesc,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------
// Grafik IPS (per semester) dan IPK (kumulatif)
// ---------------------------------------------------------------
class _IpkIpsChartCard extends StatelessWidget {
  final List<double> ips;
  final List<double> ipk;

  const _IpkIpsChartCard({
    required this.ips,
    required this.ipk,
  });

  @override
  Widget build(BuildContext context) {
    final displayIps = ips.isNotEmpty ? ips : [3.5];
    final displayIpk = ipk.isNotEmpty ? ipk : [3.5];

    final summaryText = displayIps.length > 1
        ? 'IPS dari ${displayIps.first.toStringAsFixed(1)} ke ${displayIps.last.toStringAsFixed(1)}, IPK dari ${displayIpk.first.toStringAsFixed(1)} ke ${displayIpk.last.toStringAsFixed(1)}.'
        : 'IPS Semester ini: ${displayIps.first.toStringAsFixed(2)}, IPK Kumulatif: ${displayIpk.first.toStringAsFixed(2)}.';

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
              painter: _IpkIpsPainter(displayIps, displayIpk),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            summaryText,
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
  _IpkIpsPainter(this.ips, this.ipk);

  @override
  void paint(Canvas canvas, Size size) {
    const kiri = 30.0, bawah = 22.0, atas = 8.0;
    final lebar = size.width - kiri - 8;
    final tinggi = size.height - bawah - atas;

    final allVals = [...ips, ...ipk];
    final minVal = allVals.isNotEmpty
        ? (allVals.reduce(min) - 0.3).clamp(0.0, 3.5)
        : 3.0;
    final maxVal = allVals.isNotEmpty
        ? (allVals.reduce(max) + 0.3).clamp(1.0, 4.0)
        : 4.0;
    final span = max(0.1, maxVal - minVal);

    double xAt(int i) {
      if (ips.length <= 1) return kiri + lebar / 2;
      return kiri + 8 + (lebar - 16) * i / (ips.length - 1);
    }

    double yAt(double v) => atas + tinggi * (1 - (v - minVal) / span);

    // Garis bantu dan label sumbu Y
    final grid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (var k = 0; k <= 4; k++) {
      final v = minVal + (span / 4) * k;
      final y = yAt(v);
      canvas.drawLine(Offset(kiri, y), Offset(size.width, y), grid);
      _teks(canvas, v.toStringAsFixed(1), Offset(0, y - 6));
    }

    // Label sumbu X
    for (var i = 0; i < ips.length; i++) {
      _teks(canvas, 'S${i + 1}', Offset(xAt(i) - 8, size.height - 14));
    }

    _garis(canvas, ipk, xAt, yAt, AppColors.warning, putus: true);
    _garis(canvas, ips, xAt, yAt, AppColors.primary, putus: false);
  }

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

  void _garis(
    Canvas canvas,
    List<double> data,
    double Function(int) xAt,
    double Function(double) yAt,
    Color warna, {
    required bool putus,
  }) {
    if (data.isEmpty) return;

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------
// Terbaik dan perlu ditingkatkan (sekarang dengan data dinamis)
// ---------------------------------------------------------------
class _BestWorst extends StatelessWidget {
  final String bestName;
  final String bestDesc;
  final String worstName;
  final String worstDesc;

  const _BestWorst({
    required this.bestName,
    required this.bestDesc,
    required this.worstName,
    required this.worstDesc,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _Box(
              label: 'Terbaik',
              name: bestName,
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
              name: worstName,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
          const SizedBox(height: 10),
          Text(name,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink)),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(
                  fontSize: 12, height: 1.45, color: Color(0xFF334155))),
        ],
      ),
    );
  }
}

/// Screen 13 - Analisis AI
class AnalisisAiScreen extends StatelessWidget {
  const AnalisisAiScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const SubScreen(title: 'Analisis AI', child: AnalisisAiContent());
}
