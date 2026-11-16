import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../review/ajukan_review_screen.dart';
import 'nilai_akademik_screen.dart';

class DetailMataKuliahScreen extends StatelessWidget {
  final MataKuliah mk;
  const DetailMataKuliahScreen({super.key, required this.mk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 18, color: AppColors.ink),
                  ),
                  Expanded(
                    child: Text(mk.namaPendek,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _hero(),
              const SizedBox(height: 24),
              const Text('Penilaian',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink)),
              const SizedBox(height: 12),
              _penilaianList(context),
              if (mk.aiFeedback != null && mk.aiFeedback!.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Evaluasi AI (OBE)',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                _aiFeedbackCard(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nilai saat ini',
              style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 12)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('${mk.persen}%',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text(mk.huruf,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (mk.persen / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0x40FFFFFF),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _penilaianList(BuildContext context) {
    final tugasScore = mk.tugas != null ? '${mk.tugas!.toStringAsFixed(0)} / 100' : '92 / 100';
    final utsScore = mk.uts != null ? '${mk.uts!.toStringAsFixed(0)} / 100' : '88 / 100';
    final uasScore = mk.uas != null ? '${mk.uas!.toStringAsFixed(0)} / 100' : '94 / 100';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _PenilaianRow(
            'Tugas Terstruktur',
            'Tugas · $tugasScore (Bobot 30%)',
            onTap: () => _openReview(context, 'Tugas Terstruktur', tugasScore),
          ),
          const Divider(height: 1, color: AppColors.border),
          _PenilaianRow(
            'Ujian Tengah Semester (UTS)',
            'Ujian · $utsScore (Bobot 35%)',
            onTap: () => _openReview(context, 'UTS', utsScore),
          ),
          const Divider(height: 1, color: AppColors.border),
          _PenilaianRow(
            'Ujian Akhir Semester (UAS)',
            'Ujian · $uasScore (Bobot 35%)',
            onTap: () => _openReview(context, 'UAS', uasScore),
          ),
        ],
      ),
    );
  }

  void _openReview(BuildContext context, String component, String score) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AjukanReviewScreen(
          classId: mk.classId,
          soal: '$component · ${mk.nama}',
          nilaiSekarang: score,
        ),
      ),
    );
  }

  Widget _aiFeedbackCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded,
                  size: 18, color: Color(0xFF16A34A)),
              SizedBox(width: 8),
              Text(
                'Capaian Pembelajaran (OBE)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mk.aiFeedback!,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF166534),
            ),
          ),
        ],
      ),
    );
  }
}

class _PenilaianRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? chip;
  final Color? chipBg;
  final Color? chipFg;
  final VoidCallback? onTap;

  const _PenilaianRow(
    this.title,
    this.subtitle, {
    this.chip,
    this.chipBg,
    this.chipFg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.muted)),
                ],
              ),
            ),
            if (chip != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(chip!,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: chipFg)),
              )
            else
              const Icon(Icons.chevron_right, color: AppColors.ink, size: 22),
          ],
        ),
      ),
    );
  }
}
