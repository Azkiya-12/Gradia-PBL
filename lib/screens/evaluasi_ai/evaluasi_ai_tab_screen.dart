import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/ai_feedback_model.dart';
import '../../models/dashboard_model.dart';
import '../../models/grade_model.dart';
import '../../services/ai_service.dart';
import '../../services/auth_service.dart';
import '../../services/grade_service.dart';
import '../../widgets/common.dart';
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
  bool _isLoading = true;
  String? _errorMessage;

  List<AiFeedbackItem> _feedbacks = [];
  List<GradeCourseModel> _courses = [];
  DashboardData? _dashboardData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        AiService.getSavedAiFeedbacks(forceRefresh: true),
        GradeService.getGrades(),
        AuthService.fetchDashboardData(),
      ]);

      if (!mounted) return;
      setState(() {
        _feedbacks = results[0] as List<AiFeedbackItem>;
        _courses = results[1] as List<GradeCourseModel>;
        _dashboardData = results[2] as DashboardData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.muted),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final isEmpty = _feedbacks.isEmpty && _courses.isEmpty;
    if (isEmpty) {
      return _kosongView();
    }

    return _isiView();
  }

  /// Screen 30 - Evaluasi AI kosong
  Widget _kosongView() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }

  Widget _isiView() {
    final pages = <Widget>[
      AnalisisAiContent(
        feedbacks: _feedbacks,
        courses: _courses,
        dashboardData: _dashboardData,
      ),
      EvaluasiAiContent(
        feedbacks: _feedbacks,
        courses: _courses,
        dashboardData: _dashboardData,
        onRefresh: _loadData,
      ),
      const KalkulatorContent(),
    ];

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }
}
