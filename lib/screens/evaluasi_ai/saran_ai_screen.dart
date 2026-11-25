import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/ai_feedback_model.dart';
import '../../services/ai_service.dart';
import '../../widgets/common.dart';
import '../../widgets/insight_widgets.dart';

/// Screen 14 - Evaluasi AI: Saran dari AI
class SaranAiScreen extends StatefulWidget {
  const SaranAiScreen({super.key});

  @override
  State<SaranAiScreen> createState() => _SaranAiScreenState();
}

class _SaranAiScreenState extends State<SaranAiScreen> {
  bool _isLoading = true;
  bool _isGenerating = false;
  String? _errorMessage;

  List<AiFeedbackItem> _savedFeedbacks = [];
  GeneratedAiFeedback? _generatedFeedback;

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

      if (mounted) {
        setState(() {
          _savedFeedbacks = saved;
          _generatedFeedback = cachedGen;
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
        const Expanded(
          child: Text('Saran dari AI',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: AppColors.ink)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                const SizedBox(height: 32),
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 40, color: AppColors.danger),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.muted),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton('Coba lagi',
                          onPressed: () => _loadData(forceRefresh: true)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final hasData = _savedFeedbacks.isNotEmpty || _generatedFeedback != null;
    if (!hasData) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                Expanded(
                  child: EmptyState(
                    icon: Icons.auto_awesome_outlined,
                    title: 'Belum ada saran dari AI',
                    message:
                        'Generate evaluasi AI untuk mendapatkan rekomendasi belajar berdasarkan capaian nilaimu.',
                    primaryLabel: _isGenerating
                        ? 'Menganalisis...'
                        : 'Generate Evaluasi',
                    onPrimary: _isGenerating ? () {} : _generateEvaluation,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Bangun daftar butir saran AI
    final items = <InsightItem>[];

    if (_generatedFeedback != null) {
      items.add(
        InsightItem(
          'Prioritas utama',
          'Rekomendasi AI OBE',
          _generatedFeedback!.effectiveRecommendation,
        ),
      );
    }

    if (_savedFeedbacks.isNotEmpty) {
      final sortedAsc = List<AiFeedbackItem>.from(_savedFeedbacks)
        ..sort((a, b) => a.finalScore.compareTo(b.finalScore));

      for (final f in sortedAsc) {
        if (f.finalScore < 85 || sortedAsc.indexOf(f) == 0) {
          items.add(
            InsightItem(
              'Prioritas tinggi',
              'Pendampingan ${f.title}',
              f.aiFeedback.isNotEmpty
                  ? 'Terapkan telaah dosen: ${f.aiFeedback}'
                  : 'Luangkan 2-3 jam per minggu untuk mengulang materi dan latihan soal bersama dosen pengampu (${f.lecturerName}).',
            ),
          );
        }
      }

      items.add(
        const InsightItem(
          'Pertahankan',
          'Jaga Presensi & Kehadiran',
          'Pertahankan tingkat kehadiran di atas 90% pada setiap pertemuan agar materi perkuliahan tidak terlewat.',
        ),
      );
    } else {
      items.add(
        const InsightItem(
          'Prioritas sedang',
          'Belajar Bersama Rekan Kelas',
          'Bentuk kelompok belajar kecil untuk mendiskusikan modul praktikum dan studi kasus proyek.',
        ),
      );
      items.add(
        const InsightItem(
          'Pertahankan',
          'Jaga Kehadiran di Atas 90%',
          'Kebiasaan hadir tepat waktu sangat membantu pemahaman materi secara konsisten.',
        ),
      );
    }

    final count = items.length;
    return InsightScreen(
      title: 'Saran dari AI',
      summaryTitle: '$count saran untuk semester depan',
      summarySubtitle: 'Disusun dari capaian nilai dan telaah AI OBE',
      tone: InsightTone.primary,
      items: items,
    );
  }
}
