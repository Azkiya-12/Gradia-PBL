import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/common.dart';
import 'ajukan_review_screen.dart';

/// Screen 08 - Detail penilaian (data dummy)
class DetailPenilaianScreen extends StatelessWidget {
  final String judul;
  const DetailPenilaianScreen({super.key, this.judul = 'Kuis 1: Prinsip Desain'});

  @override
  Widget build(BuildContext context) {
    return SubScreen(
      title: judul,
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
                  children: const [
                    Text('18 / 20',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink)),
                    SizedBox(width: 10),
                    StatusChip('Dinilai', AppColors.successSoft,
                        AppColors.success),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle('Nilai per soal'),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: divide(const [
                _SoalRow('Soal 1 · Hierarki visual', '5 / 5'),
                _SoalRow('Soal 2 · Prinsip Gestalt', '4 / 5',
                    note: '−1 · Contoh Common Region belum tepat'),
                _SoalRow('Soal 3 · Warna dan kontras', '5 / 5'),
                _SoalRow('Soal 4 · Microcopy error', '4 / 5',
                    note: '−1 · Pesan belum memberi solusi'),
              ]),
            ),
          ),
          const SizedBox(height: 6),
          const Text('Tap soal yang ada pengurangan nilai untuk ajukan review.',
              style: TextStyle(fontSize: 11, color: AppColors.muted)),
          const SizedBox(height: 18),
          const SectionTitle('Komentar dosen'),
          const SizedBox(height: 12),
          const InfoCard(
              'Analisis Gestalt sudah kuat. Perbaiki contoh Common Region dan tambahkan solusi pada microcopy error.'),
          const SizedBox(height: 24),
          const SectionTitle('Statistik kelas'),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _StatBox('Rata-rata', '15.6')),
              SizedBox(width: 8),
              Expanded(child: _StatBox('Median', '16')),
              SizedBox(width: 8),
              Expanded(child: _StatBox('Tertinggi', '20')),
              SizedBox(width: 8),
              Expanded(child: _StatBox('Terendah', '8')),
            ],
          ),
          const SizedBox(height: 12),
          const _Histogram(),
        ],
      ),
    );
  }
}

class _SoalRow extends StatelessWidget {
  final String title;
  final String nilai;
  final String? note;
  const _SoalRow(this.title, this.nilai, {this.note});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: note == null
          ? null
          : () => push(
              context, AjukanReviewScreen(soal: title, nilaiSekarang: nilai)),
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
                  if (note != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.warningSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(note!,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.warning)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(nilai,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink)),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink)),
        ],
      ),
    );
  }
}

/// Histogram sebaran nilai kelas (data dummy). Batang biru = rentang nilaimu.
class _Histogram extends StatelessWidget {
  const _Histogram();

  static const _labels = ['8–10', '11–13', '14–16', '17–18', '19–20'];
  static const _heights = [14.0, 28.0, 35.0, 52.0, 22.0];
  static const _mine = 3;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < _heights.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: _heights[i],
                        decoration: BoxDecoration(
                          color: i == _mine
                              ? AppColors.primary
                              : const Color(0xFFC7D2FE),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (final l in _labels)
                Expanded(
                  child: Center(
                    child: Text(l,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.muted)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Sebaran nilai kelas',
              style: TextStyle(fontSize: 12, color: AppColors.muted)),
        ],
      ),
    );
  }
}
