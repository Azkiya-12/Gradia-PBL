import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/common.dart';
import 'kekurangan_screen.dart';
import 'kelebihan_screen.dart';
import 'saran_ai_screen.dart';

/// Isi tab "Evaluasi" (dipakai di screen 11 dan screen 12).
class EvaluasiAiContent extends StatelessWidget {
  const EvaluasiAiContent({super.key});

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
                onTap: () => push(context, const KelebihanScreen()),
                subtitle: 'Lihat hasil kelebihan akademikmu',
              ),
              _MenuRow(
                icon: Icons.error_outline,
                bg: AppColors.warningSoft,
                fg: AppColors.warning,
                title: 'Kekurangan',
                onTap: () => push(context, const KekuranganScreen()),
                subtitle: 'Lihat bagian yang perlu diperbaiki',
              ),
              _MenuRow(
                icon: Icons.auto_awesome_outlined,
                bg: AppColors.primarySoft,
                fg: AppColors.primary,
                title: 'Saran dari AI',
                onTap: () => push(context, const SaranAiScreen()),
                subtitle: 'Rekomendasi berdasarkan nilai dan performa',
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Evaluasi pribadi',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text(
                  'AI menilai perkembangan akademikmu dari nilai, kehadiran, dan konsistensi belajar. Pertahankan ritme di mata kuliah desain, dan sisihkan waktu ekstra untuk Pemrograman Mobile.',
                  style: TextStyle(
                      color: Colors.white, fontSize: 13, height: 1.55)),
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
