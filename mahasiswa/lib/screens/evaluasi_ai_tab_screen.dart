import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../demo_data.dart';
import '../widgets/common.dart';
import 'analisis_ai_screen.dart';
import 'evaluasi_ai_screen.dart';
import 'kalkulator_target_screen.dart';

/// Screen 11 - Tab "Evaluasi AI" di bottom nav (Analisis AI / Evaluasi / Kalkulator)
class EvaluasiAiTabScreen extends StatefulWidget {
  /// Dipanggil dari tampilan kosong untuk pindah ke tab Nilai.
  final VoidCallback? onLihatNilai;
  const EvaluasiAiTabScreen({super.key, this.onLihatNilai});

  @override
  State<EvaluasiAiTabScreen> createState() => _EvaluasiAiTabScreenState();
}

class _EvaluasiAiTabScreenState extends State<EvaluasiAiTabScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: DemoState.kosong,
      builder: (context, kosong, _) =>
          kosong ? _kosongView() : _isiView(),
    );
  }

  /// Screen 30 - Evaluasi AI kosong
  Widget _kosongView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Evaluasi AI',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.ink)),
          EmptyState(
            icon: Icons.auto_awesome_outlined,
            title: 'Evaluasi AI butuh data nilai dulu',
            message:
                'Setelah nilai satu semester tersimpan, AI bisa menganalisis kelebihan dan memberi saran belajar untukmu.',
            primaryLabel: 'Lihat nilai akademik',
            onPrimary: widget.onLihatNilai ?? () {},
          ),
        ],
      ),
    );
  }

  Widget _isiView() {
    const pages = <Widget>[
      AnalisisAiContent(),
      EvaluasiAiContent(),
      KalkulatorContent(),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Evaluasi Akademik dengan AI',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink)),
          const SizedBox(height: 18),
          PillTabs(
            tabs: const ['Analisis AI', 'Evaluasi', 'Kalkulator'],
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: 24),
          pages[_tab],
        ],
      ),
    );
  }
}
