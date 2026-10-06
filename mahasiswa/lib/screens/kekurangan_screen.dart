import 'package:flutter/material.dart';
import '../widgets/insight_widgets.dart';

/// Screen 13 - Evaluasi AI: Kekurangan (data dummy)
class KekuranganScreen extends StatelessWidget {
  const KekuranganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InsightScreen(
      title: 'Kekurangan',
      summaryTitle: '3 hal perlu ditingkatkan',
      summarySubtitle: 'Fokus pada ini agar IPK makin kuat',
      tone: InsightTone.warning,
      items: [
        InsightItem(
          'Prioritas tinggi',
          'Pemrograman Mobile',
          'Nilaimu masih di bawah rata-rata kelas. Ini satu-satunya mata kuliah yang tertinggal.',
        ),
        InsightItem(
          'Perlu dijaga',
          'UIUX belum selalu stabil',
          'UIUX sempat turun di semester 3 dan 5 sebelum naik lagi. Pola ini bisa terulang.',
        ),
        InsightItem(
          'Perlu dijaga',
          'Nilai belum merata antar mata kuliah',
          'Selisih antara nilai terbaik dan terendahmu masih cukup lebar.',
        ),
      ],
    );
  }
}
