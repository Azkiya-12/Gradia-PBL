import 'package:flutter/material.dart';
import '../widgets/insight_widgets.dart';

/// Screen 14 - Evaluasi AI: Saran dari AI (data dummy)
class SaranAiScreen extends StatelessWidget {
  const SaranAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InsightScreen(
      title: 'Saran dari AI',
      summaryTitle: '4 saran untuk semester depan',
      summarySubtitle: 'Disusun dari kelebihan dan kekuranganmu',
      tone: InsightTone.primary,
      items: [
        InsightItem(
          'Prioritas tinggi',
          'Perbanyak latihan Pemrograman Mobile',
          'Luangkan 3 jam per minggu untuk membuat aplikasi kecil dan ulangi materi yang masih lemah.',
        ),
        InsightItem(
          'Prioritas sedang',
          'Belajar bersama teman',
          'Gabung kelompok belajar dengan teman yang nilai Pemrograman Mobile-nya tinggi.',
        ),
        InsightItem(
          'Prioritas sedang',
          'Pakai keahlian UI/UX di proyek mobile',
          'Rancang tampilan aplikasi sendiri agar belajar kode terasa lebih seru.',
        ),
        InsightItem(
          'Pertahankan',
          'Jaga kehadiran di atas 90%',
          'Kebiasaan ini sudah bagus. Teruskan agar nilai tetap naik.',
        ),
      ],
    );
  }
}
