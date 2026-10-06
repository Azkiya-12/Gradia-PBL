import 'package:flutter/material.dart';
import '../widgets/insight_widgets.dart';

/// Screen 12 - Evaluasi AI: Kelebihan (data dummy)
class KelebihanScreen extends StatelessWidget {
  const KelebihanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InsightScreen(
      title: 'Kelebihan',
      summaryTitle: '4 kelebihan ditemukan',
      summarySubtitle: 'Berdasarkan nilai dan kehadiran 6 semester terakhir',
      tone: InsightTone.success,
      items: [
        InsightItem(
          'Akademik',
          'IPK naik konsisten',
          'IPS naik dari 3.1 ke 3.7 dalam enam semester. Cara belajarmu makin efektif.',
        ),
        InsightItem(
          'Kehadiran',
          'Kehadiran stabil di atas 90%',
          'Hampir semua pertemuan kamu hadiri, jadi materi kelas jarang terlewat.',
        ),
        InsightItem(
          'Keahlian',
          'Desain User Interface dan User Experience',
          'Ini nilai tertingginya dan berada di atas rata-rata kelas.',
        ),
        InsightItem(
          'Tren',
          'Pemulihan setelah IPS turun',
          'Saat IPS turun di semester 3 dan 5, kamu bisa naik lagi di semester berikutnya.',
        ),
      ],
    );
  }
}
