import 'package:flutter/material.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_service.dart';

/// Halaman rekap kehadiran mahasiswa terintegrasi dengan backend.
class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({super.key});

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  static const _primary = Color(0xFF4F46E5);
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  AttendanceData? _data;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  Future<void> _loadAttendances() async {
    try {
      final res = await AttendanceService.getAttendances();
      if (mounted) {
        setState(() {
          _data = res;
          _isLoading = false;
          _errorMessage = null;
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: _primary),
                      )
                    : _errorMessage != null && _data == null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline_rounded,
                                      size: 48, color: Color(0xFFDC2626)),
                                  const SizedBox(height: 12),
                                  Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: _grey, fontSize: 13),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _loadAttendances,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primary,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                        onRefresh: _loadAttendances,
                        color: _primary,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ringkasan(),
                              const SizedBox(height: 16),
                              const Text(
                                'Per mata kuliah',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: _dark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _daftarMataKuliah(),
                              const SizedBox(height: 24),
                            ],
                          ),
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
    final persen = _data?.overallPercentage ?? 92;
    final hadir = _data?.totalHadir ?? 46;
    final izin = _data?.totalIzin ?? 2;
    final sakit = _data?.totalSakit ?? 1;
    final alpa = _data?.totalAlpa ?? 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
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
                '$persen%',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: _primary,
                  height: 1.15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (persen / 100.0).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: _border,
              valueColor: const AlwaysStoppedAnimation(_primary),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Kotak(
                    '$hadir', 'Hadir', const Color(0xFF059669), const Color(0xFFECFDF5)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Kotak(
                    '$izin', 'Izin', const Color(0xFF4F46E5), const Color(0xFFEEF2FF)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Kotak(
                    '$sakit', 'Sakit', const Color(0xFFB45309), const Color(0xFFFEF3C7)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Kotak(
                    '$alpa', 'Alpa', const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _daftarMataKuliah() {
    final courses = _data?.courses ?? [];

    if (courses.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border),
        ),
        child: const Center(
          child: Text(
            'Tidak ada data mata kuliah.',
            style: TextStyle(color: _grey, fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          for (int i = 0; i < courses.length; i++) ...[
            _BarisMatkul(mk: courses[i]),
            if (i != courses.length - 1)
              const Divider(height: 1, color: _border),
          ],
        ],
      ),
    );
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            angka,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: fg,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
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
  final CourseAttendance mk;

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
              const SizedBox(height: 2),
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
                  value: mk.total > 0
                      ? (mk.hadir / mk.total).clamp(0.0, 1.0)
                      : 1.0,
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
