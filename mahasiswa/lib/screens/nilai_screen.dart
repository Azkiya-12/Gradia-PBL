import 'package:flutter/material.dart';

class NilaiScreen extends StatefulWidget {
  // Dipanggil saat "Kembali ke dashboard" ditekan (diatur oleh MainShell)
  final VoidCallback? onKembaliKeDashboard;

  const NilaiScreen({super.key, this.onKembaliKeDashboard});

  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  static const _primary = Color(0xFF4F46E5);
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  // Data contoh. Nanti diganti dengan data dari backend.
  static const Map<String, List<_Course>> _dataNilai = {
    'Semester Ganjil 26/27': [
      _Course('Desain User Interface dan User Experience', 3, 92, 'A'),
      _Course('Jaringan Komputer', 4, 84, 'B+'),
      _Course('Pemrograman Mobile', 4, 78, 'B'),
      _Course('Pemrograman Web Framework', 3, 88, 'A-'),
    ],
    // Kosong = nilai belum tersedia
    'Semester Genap 26/27': [],
  };

  String _selectedSemester = 'Semester Ganjil 26/27';

  // Ubah ke true untuk melihat tampilan "Koneksi terputus"
  static const bool _simulasiOffline = false;

  bool _koneksiTerputus = _simulasiOffline;

  // Dipanggil saat tombol "Coba lagi" ditekan.
  // Nanti ganti dengan pemanggilan ulang API ke backend:
  // jika berhasil -> _koneksiTerputus = false, jika gagal -> tetap true.
  Future<void> _cobaLagi() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _koneksiTerputus = false);
  }

  List<_Course> get _courses => _dataNilai[_selectedSemester] ?? const [];

  int get _totalSks => _courses.fold(0, (sum, c) => sum + c.sks);

  // Pilih semester lewat bottom sheet
  void _pilihSemester() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              for (final semester in _dataNilai.keys)
                ListTile(
                  title: Text(
                    semester,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: semester == _selectedSemester ? _primary : _dark,
                    ),
                  ),
                  trailing: semester == _selectedSemester
                      ? const Icon(Icons.check, color: _primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedSemester = semester);
                    Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final courses = _courses;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nilai akademik',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _dark,
                ),
              ),

              const SizedBox(height: 16),

              // Pilihan semester (disembunyikan saat koneksi terputus)
              if (!_koneksiTerputus)
              InkWell(
                onTap: _pilihSemester,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedSemester,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _dark,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: _grey),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: _koneksiTerputus
                    ? _KoneksiTerputus(
                        onCobaLagi: _cobaLagi,
                        onBack: () => widget.onKembaliKeDashboard?.call(),
                      )
                    : courses.isEmpty
                    ? _NilaiKosong(
                        onAktifkan: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notifikasi nilai diaktifkan'),
                            ),
                          );
                        },
                        onLihatSemesterLain: _pilihSemester,
                      )
                    : _buildDaftarNilai(courses),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaftarNilai(List<_Course> courses) {
    return ListView(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${courses.length} mata kuliah',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _dark,
              ),
            ),
            Text(
              '$_totalSks SKS',
              style: const TextStyle(fontSize: 13, color: _grey),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final course in courses) _CourseCard(course: course),
      ],
    );
  }
}

// ---------------------------------------------------------------
// Data mata kuliah
// ---------------------------------------------------------------
class _Course {
  final String name;
  final int sks;
  final int score;
  final String grade;

  const _Course(this.name, this.sks, this.score, this.grade);
}

// ---------------------------------------------------------------
// Kartu mata kuliah
// ---------------------------------------------------------------
class _CourseCard extends StatelessWidget {
  final _Course course;

  const _CourseCard({required this.course});

  // Warna chip nilai: [latar, teks]
  List<Color> get _gradeColors {
    switch (course.grade) {
      case 'A':
        return const [Color(0xFFE8F8EF), Color(0xFF059669)];
      case 'A-':
        return const [Color(0xFFE6FAF5), Color(0xFF0D9488)];
      case 'B+':
        return const [Color(0xFFEEF2FF), Color(0xFF4F46E5)];
      case 'B':
        return const [Color(0xFFE8F4FD), Color(0xFF0369A1)];
      default:
        return const [Color(0xFFF1F5F9), Color(0xFF64748B)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _gradeColors;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(
            course.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${course.sks} SKS · ${course.score}%',
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors[0],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              course.grade,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: colors[1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// Tampilan "Nilai semester ini belum tersedia"
// ---------------------------------------------------------------
class _NilaiKosong extends StatelessWidget {
  final VoidCallback onAktifkan;
  final VoidCallback onLihatSemesterLain;

  const _NilaiKosong({
    required this.onAktifkan,
    required this.onLihatSemesterLain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sticky_note_2_outlined,
                size: 48,
                color: Color(0xFF4F46E5),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Nilai semester ini belum tersedia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 8),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Dosen belum mengunggah nilai untuk semester ini. '
                'Aktifkan notifikasi agar kamu tahu begitu nilai masuk.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onAktifkan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Aktifkan notifikasi nilai',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: onLihatSemesterLain,
              child: const Text(
                'Lihat semester lain',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Tampilan "Koneksi terputus"
// ---------------------------------------------------------------
class _KoneksiTerputus extends StatelessWidget {
  final VoidCallback onCobaLagi;
  final VoidCallback onBack;

  const _KoneksiTerputus({
    required this.onCobaLagi,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: Color(0xFFDC2626),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Koneksi terputus',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 8),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Periksa Wi-Fi atau data seluler kamu, lalu coba lagi. '
                'Data yang sudah tersimpan tetap aman.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onCobaLagi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Coba lagi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: onBack,
              child: const Text(
                'Kembali ke dashboard',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}