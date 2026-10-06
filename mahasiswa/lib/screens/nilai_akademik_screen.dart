import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'detail_mata_kuliah_screen.dart';

class MataKuliah {
  final String nama;
  final String namaPendek;
  final int sks;
  final int persen;
  final String huruf;
  final Color aksen;
  final Color badgeBg;
  final Color badgeFg;
  const MataKuliah({
    required this.nama,
    required this.namaPendek,
    required this.sks,
    required this.persen,
    required this.huruf,
    required this.aksen,
    required this.badgeBg,
    required this.badgeFg,
  });
}

// Data dummy untuk demo UTS
const _daftarMatkul = <MataKuliah>[
  MataKuliah(
    nama: 'Desain User Interface dan User Experience',
    namaPendek: 'Desain UI dan UX',
    sks: 3,
    persen: 92,
    huruf: 'A',
    aksen: AppColors.primary,
    badgeBg: AppColors.successSoft,
    badgeFg: AppColors.success,
  ),
  MataKuliah(
    nama: 'Jaringan Komputer',
    namaPendek: 'Jaringan Komputer',
    sks: 4,
    persen: 84,
    huruf: 'B+',
    aksen: Color(0xFF0D9488),
    badgeBg: AppColors.primarySoft,
    badgeFg: AppColors.primary,
  ),
  MataKuliah(
    nama: 'Pemrograman Mobile',
    namaPendek: 'Pemrograman Mobile',
    sks: 4,
    persen: 78,
    huruf: 'B',
    aksen: AppColors.orange,
    badgeBg: Color(0xFFF0F9FF),
    badgeFg: Color(0xFF0369A1),
  ),
  MataKuliah(
    nama: 'Pemrograman Web Framework',
    namaPendek: 'Pemrograman Web',
    sks: 3,
    persen: 88,
    huruf: 'A-',
    aksen: Color(0xFFDB2777),
    badgeBg: Color(0xFFF0FDFA),
    badgeFg: Color(0xFF0D9488),
  ),
];

class NilaiAkademikScreen extends StatefulWidget {
  const NilaiAkademikScreen({super.key});

  @override
  State<NilaiAkademikScreen> createState() => _NilaiAkademikScreenState();
}

class _NilaiAkademikScreenState extends State<NilaiAkademikScreen> {
  static const _semesters = [
    'Semester Ganjil 26/27',
    'Semester Genap 25/26',
    'Semester Ganjil 25/26',
  ];
  String _semester = _semesters.first;

  @override
  Widget build(BuildContext context) {
    final totalSks = _daftarMatkul.fold<int>(0, (a, m) => a + m.sks);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nilai akademik',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.ink)),
          const SizedBox(height: 16),
          _semesterDropdown(),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_daftarMatkul.length} mata kuliah',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink)),
              Text('$totalSks SKS',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 14),
          for (final mk in _daftarMatkul) ...[
            _MatkulCard(
              mk: mk,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => DetailMataKuliahScreen(mk: mk)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _semesterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _semester,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.muted),
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.ink),
          borderRadius: BorderRadius.circular(12),
          items: [
            for (final s in _semesters)
              DropdownMenuItem(value: s, child: Text(s)),
          ],
          onChanged: (v) => setState(() => _semester = v ?? _semester),
        ),
      ),
    );
  }
}

class _MatkulCard extends StatelessWidget {
  final MataKuliah mk;
  final VoidCallback onTap;
  const _MatkulCard({required this.mk, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 5, color: mk.aksen),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mk.nama,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink)),
                              const SizedBox(height: 4),
                              Text('${mk.sks} SKS · ${mk.persen}%',
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          constraints: const BoxConstraints(minWidth: 38),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 9),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: mk.badgeBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(mk.huruf,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: mk.badgeFg)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}