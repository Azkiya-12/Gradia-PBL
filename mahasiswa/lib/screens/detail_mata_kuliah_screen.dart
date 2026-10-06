import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/common.dart';
import 'detail_penilaian_screen.dart';
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
              _penilaianList(),
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
              value: mk.persen / 100,
              minHeight: 8,
              backgroundColor: const Color(0x40FFFFFF),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _penilaianList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: const [
          _PenilaianRow('Kuis 1: Prinsip Desain', 'Kuis · 18 / 20'),
          Divider(height: 1, color: AppColors.border),
          _PenilaianRow('Tugas: Wireframe Aplikasi', 'Tugas · 92 / 100'),
          Divider(height: 1, color: AppColors.border),
          _PenilaianRow('UTS', 'Ujian · 88 / 100'),
          Divider(height: 1, color: AppColors.border),
          _PenilaianRow('Usability Test Report', 'Terlewat 2 hari',
              chip: 'Terlewat',
              chipBg: AppColors.dangerSoft,
              chipFg: AppColors.danger),
          Divider(height: 1, color: AppColors.border),
          _PenilaianRow('Prototype Hi-Fi', 'Menunggu dinilai',
              chip: 'Terkumpul',
              chipBg: AppColors.successSoft,
              chipFg: AppColors.success),
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
  const _PenilaianRow(this.title, this.subtitle,
      {this.chip, this.chipBg, this.chipFg});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: chip == null
          ? () => push(context, DetailPenilaianScreen(judul: title))
          : null,
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
