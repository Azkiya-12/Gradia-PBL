import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/ai_feedback_model.dart';
import '../../services/ai_service.dart';
import '../../widgets/common.dart';
import '../../widgets/insight_widgets.dart';

/// Screen 13 - Evaluasi AI: Kekurangan
class KekuranganScreen extends StatefulWidget {
  const KekuranganScreen({super.key});

  @override
  State<KekuranganScreen> createState() => _KekuranganScreenState();
}

class _KekuranganScreenState extends State<KekuranganScreen> {
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
          child: Text('Kekurangan',
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
                    title: 'Belum ada data kekurangan',
                    message:
                        'Generate evaluasi AI untuk menemukan area kompetensi yang perlu kamu tingkatkan.',
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

    // Bangun daftar butir kekurangan
    final items = <InsightItem>[];

    if (_savedFeedbacks.isNotEmpty) {
      final sortedAsc = List<AiFeedbackItem>.from(_savedFeedbacks)
        ..sort((a, b) => a.finalScore.compareTo(b.finalScore));

      // Ambil mata kuliah dengan skor terendah / butuh remedial
      for (final f in sortedAsc) {
        if (f.finalScore < 85 || sortedAsc.indexOf(f) == 0) {
          final isHighPriority = f.finalScore < 70 || f.gradeStatus.toLowerCase().contains('remedial');
          items.add(
            InsightItem(
              isHighPriority ? 'Prioritas tinggi' : 'Perlu ditingkatkan',
              f.title,
              f.aiFeedback.isNotEmpty
                  ? f.aiFeedback
                  : 'Nilai ${f.finalScore.toStringAsFixed(0)} (${f.letterGrade}). Perlu penguatan materi dasar dan ketelitian pada tugas praktikum.',
            ),
          );
        }
      }

      if (_generatedFeedback != null) {
        items.add(
          InsightItem(
            'Fokus Perbaikan',
            'Evaluasi AI OBE',
            _generatedFeedback!.effectiveImprovement,
          ),
        );
      }
    } else if (_generatedFeedback != null) {
      items.add(
        InsightItem(
          'Fokus Perbaikan',
          'Evaluasi AI OBE',
          _generatedFeedback!.effectiveImprovement,
        ),
      );
      items.add(
        const InsightItem(
          'Perlu dijaga',
          'Konsistensi Pengerjaan Tugas',
          'Pastikan seluruh tugas praktik dikerjakan dan dikumpulkan sebelum batas tenggat waktu.',
        ),
      );
      items.add(
        const InsightItem(
          'Perlu dijaga',
          'Ketelitian Evaluasi Ujian',
          'Tingkatkan latihan soal studi kasus untuk mempersiapkan ujian tengah dan akhir semester.',
        ),
      );
    }

    final count = items.length;
    return InsightScreen(
      title: 'Kekurangan',
      summaryTitle: '$count hal perlu ditingkatkan',
      summarySubtitle: 'Fokus pada ini agar IPK makin kuat',
      tone: InsightTone.warning,
      items: items,
    );
  }
}
