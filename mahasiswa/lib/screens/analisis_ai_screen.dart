import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/common.dart';

/// Isi tab "Analisis AI" (dipakai di screen 11 dan screen 13).
class AnalisisAiContent extends StatelessWidget {
  const AnalisisAiContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle('Kesimpulan performa'),
        SizedBox(height: 12),
        InfoCard(
            'IPK naik konsisten enam semester terakhir dan kehadiran stabil di atas 90%. Nilai Pemrograman Mobile masih di bawah rata-rata kelasmu.'),
        SizedBox(height: 24),
        SectionTitle('Grafik perkembangan nilai'),
        SizedBox(height: 12),
        LineChartCard(),
        SizedBox(height: 24),
        SectionTitle('Terbaik dan perlu ditingkatkan'),
        SizedBox(height: 12),
        _BestWorst(),
      ],
    );
  }
}

class _BestWorst extends StatelessWidget {
  const _BestWorst();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Expanded(
            child: _Box(
              label: 'Terbaik',
              name: 'Desain User Interface dan User Experience',
              bg: AppColors.successSoft,
              border: Color(0xFFA7F3D0),
              fg: AppColors.success,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _Box(
              label: 'Perlu ditingkatkan',
              name: 'Pemrograman Mobile',
              bg: AppColors.warningSoft,
              border: Color(0xFFFDE68A),
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
  final Color bg;
  final Color border;
  final Color fg;
  const _Box(
      {required this.label,
      required this.name,
      required this.bg,
      required this.border,
      required this.fg});

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
