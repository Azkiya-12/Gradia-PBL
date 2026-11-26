import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/ai_feedback_model.dart';
import '../../models/dashboard_model.dart';
import '../../models/grade_model.dart';
import '../../widgets/common.dart';
import 'kekurangan_screen.dart';
import 'kelebihan_screen.dart';
import 'saran_ai_screen.dart';

/// Isi tab "Evaluasi" (dipakai di screen 11 dan screen 12).
class EvaluasiAiContent extends StatelessWidget {
  final List<AiFeedbackItem> feedbacks;
  final List<GradeCourseModel> courses;
  final DashboardData? dashboardData;
  final VoidCallback? onRefresh;

  const EvaluasiAiContent({
    super.key,
    this.feedbacks = const [],
    this.courses = const [],
    this.dashboardData,
    this.onRefresh,
  });

  String _buildPersonalEvaluation() {
    final graded = courses.where((c) => c.finalScore > 0).toList()
      ..sort((a, b) => b.finalScore.compareTo(a.finalScore));

    final ipk = dashboardData?.stats.ipk.toStringAsFixed(2);
    final att = dashboardData?.stats.attendancePercentage;

    if (graded.isEmpty) {
      return 'AI menilai perkembangan akademikmu dari nilai, kehadiran, dan konsistensi belajar.';
    }

    final best = graded.first;
    final worst = graded.last;
    final statsPart = (ipk != null && att != null)
        ? 'Dengan IPK $ipk dan kehadiran $att%, performa belajarmu terjaga baik. '
        : '';

    if (graded.length > 1 && worst.finalScore < 85) {
      return '${statsPart}Pertahankan pencapaian sangat baik di ${best.title} (${best.letterGrade}), dan sisihkan waktu ekstra untuk mendalami ${worst.title} (${worst.letterGrade}).';
    }

    return '${statsPart}Pertahankan ritme belajar yang konsisten, terutama pada mata kuliah ${best.title} (${best.letterGrade}).';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            children: divide([
              _MenuRow(
                icon: Icons.check,
                bg: AppColors.successSoft,
                fg: AppColors.success,
                title: 'Kelebihan',
                onTap: () => push(
                  context,
                  KelebihanScreen(
                    feedbacks: feedbacks,
                    courses: courses,
                    dashboardData: dashboardData,
                  ),
                ),
                subtitle: 'Lihat hasil kelebihan akademikmu',
              ),
              _MenuRow(
                icon: Icons.error_outline,
                bg: AppColors.warningSoft,
                fg: AppColors.warning,
                title: 'Kekurangan',
                onTap: () => push(
                  context,
                  KekuranganScreen(
                    feedbacks: feedbacks,
                    courses: courses,
                  ),
                ),
                subtitle: 'Lihat bagian yang perlu diperbaiki',
              ),
              _MenuRow(
                icon: Icons.auto_awesome_outlined,
                bg: AppColors.primarySoft,
                fg: AppColors.primary,
                title: 'Saran dari AI',
                onTap: () => push(
                  context,
                  SaranAiScreen(
                    feedbacks: feedbacks,
                    courses: courses,
                    dashboardData: dashboardData,
                  ),
                ),
                subtitle: 'Rekomendasi OBE dan ulasan AI terbaru',
              ),
            ]),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.violet],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Evaluasi pribadi',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                _buildPersonalEvaluation(),
                style: const TextStyle(
                    color: Colors.white, fontSize: 13, height: 1.55),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MenuRow({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconBox(icon, bg: bg, fg: fg),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.ink, size: 22),
          ],
        ),
      ),
    );
  }
}

/// Screen 12 - Evaluasi AI
class EvaluasiAiScreen extends StatelessWidget {
  const EvaluasiAiScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const SubScreen(title: 'Evaluasi AI', child: EvaluasiAiContent());
}
