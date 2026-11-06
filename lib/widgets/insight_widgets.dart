import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Warna + ikon untuk satu jenis kartu insight (hijau / kuning / biru).
class InsightTone {
  final Color bg;
  final Color border;
  final Color accent;
  final IconData icon;
  const InsightTone({
    required this.bg,
    required this.border,
    required this.accent,
    required this.icon,
  });

  static const success = InsightTone(
    bg: AppColors.successSoft,
    border: Color(0xFFA7F3D0),
    accent: AppColors.success,
    icon: Icons.check,
  );
  static const warning = InsightTone(
    bg: AppColors.warningSoft,
    border: Color(0xFFFDE68A),
    accent: AppColors.warning,
    icon: Icons.error_outline,
  );
  static const primary = InsightTone(
    bg: AppColors.primarySoft,
    border: Color(0xFFC7D2FE),
    accent: AppColors.primary,
    icon: Icons.lightbulb_outline,
  );
}

class InsightItem {
  final String label;
  final String title;
  final String desc;
  const InsightItem(this.label, this.title, this.desc);
}

/// Kerangka screen Kelebihan / Kekurangan / Saran dari AI:
/// header (tombol back bulat + judul besar), kartu ringkasan, lalu daftar kartu.
class InsightScreen extends StatelessWidget {
  final String title;
  final String summaryTitle;
  final String summarySubtitle;
  final InsightTone tone;
  final List<InsightItem> items;
  const InsightScreen({
    super.key,
    required this.title,
    required this.summaryTitle,
    required this.summarySubtitle,
    required this.tone,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              const SizedBox(height: 20),
              _box(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(summaryTitle,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink)),
                    const SizedBox(height: 2),
                    Text(summarySubtitle,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.muted)),
                  ],
                ),
                vertical: 14,
              ),
              for (final item in items) ...[
                const SizedBox(height: 12),
                _itemCard(item),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.slate100),
            child: const Icon(Icons.chevron_left,
                size: 24, color: AppColors.ink),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: AppColors.ink)),
        ),
      ],
    );
  }

  Widget _box({required Widget child, double vertical = 16}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: vertical),
      decoration: BoxDecoration(
        color: tone.bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tone.border),
      ),
      child: child,
    );
  }

  Widget _itemCard(InsightItem item) {
    return _box(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: Icon(tone.icon, size: 18, color: tone.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: tone.accent)),
                const SizedBox(height: 2),
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(item.desc,
                    style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF334155))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
