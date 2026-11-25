import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/ai_feedback_model.dart';
import '../../services/ai_service.dart';
import '../../widgets/common.dart';
import '../../widgets/insight_widgets.dart';

/// Screen 12 - Evaluasi AI: Kelebihan
class KelebihanScreen extends StatefulWidget {
  const KelebihanScreen({super.key});

  @override
  State<KelebihanScreen> createState() => _KelebihanScreenState();
}

class _KelebihanScreenState extends State<KelebihanScreen> {
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
          child: Text('Kelebihan',
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
                    title: 'Belum ada data kelebihan',
                    message:
                        'Generate evaluasi AI untuk menganalisis capaian pembelajaran dan menemukan kelebihan akademikmu.',
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

    // Bangun daftar butir kelebihan
    final items = <InsightItem>[];

    if (_savedFeedbacks.isNotEmpty) {
      final sorted = List<AiFeedbackItem>.from(_savedFeedbacks)
        ..sort((a, b) => b.finalScore.compareTo(a.finalScore));

      // Ambil mata kuliah bernilai baik / tuntas
      for (final f in sorted) {
        if (f.finalScore >= 75 || sorted.indexOf(f) < 2) {
          items.add(
            InsightItem(
              'Kompetensi Unggul',
              f.title,
              f.aiFeedback.isNotEmpty
                  ? f.aiFeedback
                  : 'Meraih nilai ${f.finalScore.toStringAsFixed(0)} (${f.letterGrade}). Capaian pembelajaran OBE terpenuhi dengan sangat baik.',
            ),
          );
        }
      }

      if (_generatedFeedback != null) {
        items.insert(
          0,
          InsightItem(
            'Kekuatan Akademik',
            'Evaluasi AI OBE',
            _generatedFeedback!.effectiveStrength,
          ),
        );
      }
    } else if (_generatedFeedback != null) {
      items.add(
        InsightItem(
          'Kekuatan Akademik',
          'Evaluasi AI OBE',
          _generatedFeedback!.effectiveStrength,
        ),
      );
      items.add(
        const InsightItem(
          'Kompetensi Pembelajaran',
          'Pemahaman Konsep',
          'Capaian materi perkuliahan telah terpenuhi dengan baik dan siap untuk studi kasus lanjutan.',
        ),
      );
      items.add(
        const InsightItem(
          'Konsistensi Akademik',
          'Kemampuan Belajar',
          'Memiliki potensi peningkatan performa yang tinggi melalui bimbingan terarah dan evaluasi berkala.',
        ),
      );
    }

    final count = items.length;
    return InsightScreen(
      title: 'Kelebihan',
      summaryTitle: '$count kelebihan ditemukan',
      summarySubtitle: 'Berdasarkan nilai dan evaluasi AI capaian OBE',
      tone: InsightTone.success,
      items: items,
    );
  }
}
