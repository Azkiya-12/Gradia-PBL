import 'package:flutter/material.dart';

/// Halaman rekap kehadiran. Kartu "Absen sekarang" hanya ada di Dashboard.
class AbsensiScreen extends StatelessWidget {
  const AbsensiScreen({super.key});

  static const _primary = Color(0xFF4F46E5);
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  // Data contoh. Nanti diganti dengan data dari backend.
  static const List<_Matkul> _data = [
    _Matkul('Algoritma & Struktur Data', 8, 8),
    _Matkul('Basis Data', 7, 8, izin: 1),
    _Matkul('Desain UI dan UX', 8, 8),
    _Matkul('Pemrograman Mobile', 8, 9, sakit: 1, dibuka: true),
    _Matkul('Jaringan Komputer', 8, 9, izin: 1),
    _Matkul('Pemrograman Web Framework', 7, 8, alpa: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.chevron_left,
                        size: 28, color: _dark),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Absensi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _dark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ringkasan(),
                      const SizedBox(height: 6),
                      const Text(
                        'Per mata kuliah',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _dark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: _border),
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < _data.length; i++) ...[
                              _BarisMatkul(mk: _data[i]),
                              if (i != _data.length - 1)
                                const Divider(height: 1, color: _border),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ringkasan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Kehadiran semester ini',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _grey,
                  ),
                ),
              ),
              Text(
                '92%',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: _primary,
                  height: 1.15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.92,
              minHeight: 8,
              backgroundColor: _border,
              valueColor: AlwaysStoppedAnimation(_primary),
            ),
          ),
          const SizedBox(height: 11),
          const Row(
            children: [
              Expanded(
                child: _Kotak(
                    '46', 'Hadir', Color(0xFF059669), Color(0xFFECFDF5)),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _Kotak(
                    '2', 'Izin', Color(0xFF4F46E5), Color(0xFFEEF2FF)),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _Kotak(
                    '1', 'Sakit', Color(0xFFB45309), Color(0xFFFEF3C7)),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _Kotak(
                    '1', 'Alpa', Color(0xFFDC2626), Color(0xFFFEE2E2)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// Data mata kuliah
// ---------------------------------------------------------------
class _Matkul {
  final String nama;
  final int hadir;
  final int total;
  final int izin;
  final int sakit;
  final int alpa;
  final bool dibuka; // absensi sedang dibuka

  const _Matkul(
    this.nama,
    this.hadir,
    this.total, {
    this.izin = 0,
    this.sakit = 0,
    this.alpa = 0,
    this.dibuka = false,
  });

  int get persen => (hadir * 100 / total).round();

  String get keterangan {
    var s = '$hadir dari $total pertemuan';
    if (izin > 0) s += ' · $izin izin';
    if (sakit > 0) s += ' · $sakit sakit';
    if (alpa > 0) s += ' · $alpa alpa';
    return s;
  }
}

// ---------------------------------------------------------------
// Kotak angka (Hadir, Izin, Sakit, Alpa)
// ---------------------------------------------------------------
class _Kotak extends StatelessWidget {
  final String angka;
  final String label;
  final Color fg;
  final Color bg;

  const _Kotak(this.angka, this.label, this.fg, this.bg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            angka,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: fg,
              height: 1.1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: fg,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// Satu baris mata kuliah (bisa dibuka untuk detail)
// ---------------------------------------------------------------
class _BarisMatkul extends StatefulWidget {
  final _Matkul mk;

  const _BarisMatkul({required this.mk});

  @override
  State<_BarisMatkul> createState() => _BarisMatkulState();
}

class _BarisMatkulState extends State<_BarisMatkul> {
  bool _buka = false;

  @override
  Widget build(BuildContext context) {
    final mk = widget.mk;

    return Material(
      color: mk.dibuka ? const Color(0xFFEEF2FF) : Colors.white,
      child: InkWell(
        onTap: () => setState(() => _buka = !_buka),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          mk.nama,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        if (mk.dibuka)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Dibuka',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${mk.persen}%',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _buka
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 22,
                    color: const Color(0xFF0F172A),
                  ),
                ],
              ),
              Text(
                mk.keterangan,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: mk.hadir / mk.total,
                  minHeight: 6,
                  backgroundColor:
                      mk.dibuka ? Colors.white : const Color(0xFFE2E8F0),
                  valueColor:
                      const AlwaysStoppedAnimation(Color(0xFF4F46E5)),
                ),
              ),
              if (_buka) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip('Hadir ${mk.hadir}', const Color(0xFF059669),
                        const Color(0xFFECFDF5)),
                    _chip('Izin ${mk.izin}', const Color(0xFF4F46E5),
                        const Color(0xFFEEF2FF)),
                    _chip('Sakit ${mk.sakit}', const Color(0xFFB45309),
                        const Color(0xFFFEF3C7)),
                    _chip('Alpa ${mk.alpa}', const Color(0xFFDC2626),
                        const Color(0xFFFEE2E2)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String teks, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        teks,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}