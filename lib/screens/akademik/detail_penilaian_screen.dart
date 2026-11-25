import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/grade_model.dart';
import '../../services/grade_service.dart';
import '../../widgets/common.dart';
import '../review/ajukan_review_screen.dart';

/// Screen 08 - Detail penilaian komponen mata kuliah
class DetailPenilaianScreen extends StatefulWidget {
  final String judul;
  final int classId;
  final double? nilaiAwal;
  final String? komentarAwal;

  const DetailPenilaianScreen({
    super.key,
    this.judul = 'Tugas Terstruktur',
    this.classId = 0,
    this.nilaiAwal,
    this.komentarAwal,
  });

  @override
  State<DetailPenilaianScreen> createState() => _DetailPenilaianScreenState();
}

class _DetailPenilaianScreenState extends State<DetailPenilaianScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  double? _score;
  String? _komentar;

  @override
  void initState() {
    super.initState();
    _score = widget.nilaiAwal;
    _komentar = widget.komentarAwal;

    if (_score == null && widget.classId > 0) {
      _loadGrade();
    }
  }

  Future<void> _loadGrade() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final grades = await GradeService.getGrades();
      final course = grades.cast<GradeCourseModel?>().firstWhere(
            (c) => c?.classId == widget.classId,
            orElse: () => null,
          );

      if (course != null) {
        final j = widget.judul.toLowerCase();
        double? matchedScore;
        if (j.contains('tugas')) {
          matchedScore = course.tugas;
        } else if (j.contains('uts')) {
          matchedScore = course.uts;
        } else if (j.contains('uas')) {
          matchedScore = course.uas;
        } else {
          matchedScore = course.finalScore;
        }

        if (mounted) {
          setState(() {
            _score = matchedScore;
            _komentar = course.aiFeedback;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SubScreen(
        title: widget.judul,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return SubScreen(
        title: widget.judul,
        child: AppCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 40, color: AppColors.danger),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              PrimaryButton('Coba lagi', onPressed: _loadGrade),
            ],
          ),
        ),
      );
    }

    final scoreDisplay = _score != null
        ? '${_score! % 1 == 0 ? _score!.toInt().toString() : _score!.toStringAsFixed(1)} / 100'
        : '0 / 100';
    final hasScore = _score != null && _score! > 0;
    final komentarText = (_komentar != null && _komentar!.isNotEmpty)
        ? _komentar!
        : 'Belum ada catatan atau komentar khusus dari dosen untuk komponen ini.';

    return SubScreen(
      title: widget.judul,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nilai kamu',
                    style: TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      scoreDisplay,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 10),
                    StatusChip(
                      hasScore ? 'Dinilai' : 'Belum dinilai',
                      hasScore ? AppColors.successSoft : AppColors.slate100,
                      hasScore ? AppColors.success : AppColors.muted,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Rincian penilaian'),
          const SizedBox(height: 12),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.slate100,
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rincian per butir soal belum tersedia',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Nilai komponen ini tercatat secara terpadu dari sistem akademik.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Jika penilaian dirasa kurang tepat, kamu dapat mengajukan koreksi nilai ke dosen pengampu.',
            style: TextStyle(fontSize: 11, color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            'Ajukan koreksi nilai',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AjukanReviewScreen(
                    classId: widget.classId,
                    soal: widget.judul,
                    nilaiSekarang: scoreDisplay,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const SectionTitle('Komentar dosen'),
          const SizedBox(height: 12),
          InfoCard(komentarText),
        ],
      ),
    );
  }
}
