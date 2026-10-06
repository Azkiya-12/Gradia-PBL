import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/common.dart';
import 'ajukan_review_screen.dart';

// ---------------------------------------------------------------
// Data dummy per penilaian
// ---------------------------------------------------------------
class _Butir {
  final String title;
  final String nilai;
  final String? note;
  const _Butir(this.title, this.nilai, {this.note});
}

class _PenilaianData {
  final String nilaiTotal;
  final String judulButir; // judul section daftar nilai
  final String hint;
  final List<_Butir> butir;
  final String komentar;
  final List<String> stat; // rata-rata, median, tertinggi, terendah
  final List<String> histLabels;
  final List<double> histHeights;
  final int histMine; // indeks batang milikmu

  const _PenilaianData({
    required this.nilaiTotal,
    required this.judulButir,
    required this.hint,
    required this.butir,
    required this.komentar,
    required this.stat,
    required this.histLabels,
    required this.histHeights,
    required this.histMine,
  });
}

const _kuis = _PenilaianData(
  nilaiTotal: '18 / 20',
  judulButir: 'Nilai per soal',
  hint: 'Tap soal yang ada pengurangan nilai untuk ajukan review.',
  butir: [
    _Butir('Soal 1 · Hierarki visual', '5 / 5'),
    _Butir('Soal 2 · Prinsip Gestalt', '4 / 5',
        note: '−1 · Contoh Common Region belum tepat'),
    _Butir('Soal 3 · Warna dan kontras', '5 / 5'),
    _Butir('Soal 4 · Microcopy error', '4 / 5',
        note: '−1 · Pesan belum memberi solusi'),
  ],
  komentar:
      'Analisis Gestalt sudah kuat. Perbaiki contoh Common Region dan tambahkan solusi pada microcopy error.',
  stat: ['15.6', '16', '20', '8'],
  histLabels: ['8–10', '11–13', '14–16', '17–18', '19–20'],
  histHeights: [14.0, 28.0, 35.0, 52.0, 22.0],
  histMine: 3,
);

const _wireframe = _PenilaianData(
  nilaiTotal: '92 / 100',
  judulButir: 'Nilai per kriteria',
  hint: 'Tap kriteria yang ada pengurangan nilai untuk ajukan review.',
  butir: [
    _Butir('Struktur dan alur layar', '22 / 25',
        note: '−3 · Alur dari Nilai ke Detail belum lengkap'),
    _Butir('Konsistensi layout dan grid', '20 / 20'),
    _Butir('Hierarki visual', '18 / 20',
        note: '−2 · Judul dan isi kurang dibedakan'),
    _Butir('Kelengkapan layar', '17 / 20',
        note: '−3 · State error belum ada'),
    _Butir('Kerapian dan dokumentasi', '15 / 15'),
  ],
  komentar:
      'Wireframe sudah rapi dan konsisten. Lengkapi state error dan perjelas hierarki antara judul dan konten.',
  stat: ['84.5', '86', '98', '60'],
  histLabels: ['60–69', '70–79', '80–89', '90–94', '95–100'],
  histHeights: [12.0, 24.0, 40.0, 52.0, 18.0],
  histMine: 3,
);

const _uts = _PenilaianData(
  nilaiTotal: '88 / 100',
  judulButir: 'Nilai per bagian',
  hint: 'Tap bagian yang ada pengurangan nilai untuk ajukan review.',
  butir: [
    _Butir('Bagian A · Pilihan ganda', '30 / 30'),
    _Butir('Bagian B · Studi kasus', '30 / 35',
        note: '−5 · Analisis heuristik belum lengkap'),
    _Butir('Bagian C · Esai', '28 / 35',
        note: '−7 · Argumen kurang didukung contoh'),
  ],
  komentar:
      'Pemahaman konsep sudah baik. Perdalam analisis heuristik dan sertakan contoh nyata pada jawaban esai.',
  stat: ['79.2', '80', '96', '55'],
  histLabels: ['55–64', '65–74', '75–84', '85–94', '95–100'],
  histHeights: [12.0, 24.0, 40.0, 52.0, 16.0],
  histMine: 3,
);

const Map<String, _PenilaianData> _dataPenilaian = {
  'Kuis 1: Prinsip Desain': _kuis,
  'Tugas: Wireframe Aplikasi': _wireframe,
  'UTS': _uts,
};

/// Screen 08 - Detail penilaian (data dummy)
class DetailPenilaianScreen extends StatelessWidget {
  final String judul;
  const DetailPenilaianScreen(
      {super.key, this.judul = 'Kuis 1: Prinsip Desain'});

  @override
  Widget build(BuildContext context) {
    final d = _dataPenilaian[judul] ?? _kuis;

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
                  children: [
                    Text(d.nilaiTotal,
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink)),
                    const SizedBox(width: 10),
                    const StatusChip('Dinilai', AppColors.successSoft,
                        AppColors.success),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionTitle(d.judulButir),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: divide([
                for (final b in d.butir) _SoalRow(b.title, b.nilai, note: b.note),
              ]),
            ),
          ),
          const SizedBox(height: 6),
          Text(d.hint,
              style: const TextStyle(fontSize: 11, color: AppColors.muted)),
          const SizedBox(height: 18),
          const SectionTitle('Komentar dosen'),
          const SizedBox(height: 12),
          InfoCard(d.komentar),
          const SizedBox(height: 24),
          const SectionTitle('Statistik kelas'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatBox('Rata-rata', d.stat[0])),
              const SizedBox(width: 8),
              Expanded(child: _StatBox('Median', d.stat[1])),
              const SizedBox(width: 8),
              Expanded(child: _StatBox('Tertinggi', d.stat[2])),
              const SizedBox(width: 8),
              Expanded(child: _StatBox('Terendah', d.stat[3])),
            ],
          ),
          const SizedBox(height: 12),
          _Histogram(
            labels: d.histLabels,
            heights: d.histHeights,
            mine: d.histMine,
          ),
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
  final List<String> labels;
  final List<double> heights;
  final int mine;

  const _Histogram({
    required this.labels,
    required this.heights,
    required this.mine,
  });

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
                for (var i = 0; i < heights.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: heights[i],
                        decoration: BoxDecoration(
                          color: i == mine
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
              for (final l in labels)
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