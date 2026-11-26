import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/ai_feedback_model.dart';
import '../../models/dashboard_model.dart';
import '../../models/grade_model.dart';
import '../../services/ai_service.dart';
import '../../widgets/insight_widgets.dart';

/// Screen 14 - Evaluasi AI: Saran dari AI (terintegrasi dengan backend GET & POST AI Feedback)
class SaranAiScreen extends StatefulWidget {
  final List<AiFeedbackItem> feedbacks;
  final List<GradeCourseModel> courses;
  final DashboardData? dashboardData;

  const SaranAiScreen({
    super.key,
    this.feedbacks = const [],
    this.courses = const [],
    this.dashboardData,
  });

  @override
  State<SaranAiScreen> createState() => _SaranAiScreenState();
}

class _SaranAiScreenState extends State<SaranAiScreen> {
  GradeCourseModel? _selectedCourse;
  bool _isGenerating = false;
  GeneratedAiFeedback? _generatedResult;
  String? _generateError;

  @override
  void initState() {
    super.initState();
    if (widget.courses.isNotEmpty) {
      // Pilih mata kuliah dengan nilai terendah sebagai default untuk saran peningkatan
      final sorted = List<GradeCourseModel>.from(widget.courses)
        ..sort((a, b) => a.finalScore.compareTo(b.finalScore));
      _selectedCourse = sorted.first;
    }
  }

  Future<void> _generateNewFeedback() async {
    if (_isGenerating) return;
    setState(() {
      _isGenerating = true;
      _generateError = null;
    });

    try {
      final course = _selectedCourse;
      final res = await AiService.generateFeedback(
        courseName: course?.title ?? 'Evaluasi Akademik Keseluruhan',
        tugas: course?.tugas,
        uts: course?.uts,
        uas: course?.uas,
        finalScore: course?.finalScore,
        letterGrade: course?.letterGrade,
      );

      if (!mounted) return;
      setState(() {
        _generatedResult = res;
        _isGenerating = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _generateError = e.toString();
        _isGenerating = false;
      });
    }
  }

  List<InsightItem> _buildSavedItems() {
    final items = <InsightItem>[];

    for (final f in widget.feedbacks) {
      final priority = f.finalScore < 80 ? 'Prioritas tinggi' : 'Pertahankan';
      items.add(
        InsightItem(
          '$priority · ${f.code}',
          f.title,
          f.aiFeedback,
        ),
      );
    }

    final att = widget.dashboardData?.stats.attendancePercentage;
    if (att != null) {
      items.add(
        InsightItem(
          att >= 90 ? 'Pertahankan' : 'Perlu ditingkatkan',
          'Kehadiran Perkuliahan ($att%)',
          att >= 90
              ? 'Tingkat kehadiran sangat baik. Teruskan agar penguasaan materi di kelas tetap optimal.'
              : 'Usahakan meningkatkan kehadiran kelas agar tidak tertinggal materi dan kuis.',
        ),
      );
    }

    if (items.isEmpty) {
      items.add(
        const InsightItem(
          'Saran AI',
          'Belum ada ulasan tersimpan',
          'Gunakan tombol "Analisis AI Sekarang" di atas untuk mendapatkan evaluasi belajar otomatis berdasarkan nilaimu.',
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildSavedItems();
    const tone = InsightTone.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 18, color: AppColors.ink),
                  ),
                  const Expanded(
                    child: Text(
                      'Saran dari AI',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: tone.bg,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: tone.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(tone.icon, color: tone.accent, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${items.length} rekomendasi OBE',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Disusun berdasarkan capaian nilai dan evaluasi dosen',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Interactive AI Generator Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.auto_awesome,
                                  size: 18, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text(
                                'Minta Evaluasi AI Baru',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (widget.courses.isNotEmpty) ...[
                            DropdownButtonFormField<GradeCourseModel>(
                              initialValue: _selectedCourse,
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: AppColors.border),
                                ),
                              ),
                              items: widget.courses
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        '${c.title} (${c.finalScore.toStringAsFixed(0)} · ${c.letterGrade})',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedCourse = val),
                            ),
                            const SizedBox(height: 12),
                          ],
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isGenerating ? null : _generateNewFeedback,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: _isGenerating
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.bolt_rounded, size: 18),
                              label: Text(
                                _isGenerating
                                    ? 'Menganalisis...'
                                    : 'Analisis AI Sekarang',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          if (_generateError != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              _generateError!,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.danger),
                            ),
                          ],
                          if (_generatedResult != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFC7D2FE)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Hasil Evaluasi AI Terbaru',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primarySoft,
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          _generatedResult!.source == 'gemini'
                                              ? 'Gemini AI'
                                              : 'OBE Engine',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _generatedResult!.feedback,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.45,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Saved recommendations list
                    for (final item in items) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: tone.bg,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: tone.accent,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.desc,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.45,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
