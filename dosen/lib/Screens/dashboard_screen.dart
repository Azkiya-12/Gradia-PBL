import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Column(
          children: [
            // JUDUL DASHBOARD
            Container(
              height: 48,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 22),
              child: const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFFB8BCC2),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 22),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================
                    // SIDEBAR
                    // =========================
                    const SizedBox(
                      width: 235,
                      child: Sidebar(),
                    ),

                    // =========================
                    // CONTENT
                    // =========================
                    Expanded(
                      child: DashboardContent(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// SIDEBAR
// ======================================================

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Color(0xFFE8EBEF),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LOGO
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EEFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school,
                  color: Color(0xFF315BEA),
                  size: 22,
                ),
              ),
              const SizedBox(width: 9),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gradia',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF20232A),
                    ),
                  ),
                  Text(
                    'Portal Dosen',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF7A8190),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1ECFF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'v2.4',
                  style: TextStyle(
                    fontSize: 7,
                    color: Color(0xFF6546D8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            'UTAMA',
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFF7B818C),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          _MenuItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            selected: true,
          ),

          _MenuItem(
            icon: Icons.library_books_outlined,
            title: 'Manajemen Data Kelas',
          ),

          _MenuItem(
            icon: Icons.groups_outlined,
            title: 'Tambah Kelas & Mahasiswa',
          ),

          const SizedBox(height: 12),

          const Text(
            'PENILAIAN & EVALUASI',
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFF7B818C),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          _MenuItem(
            icon: Icons.receipt_long_outlined,
            title: 'Input Rekap Nilai',
          ),

          _MenuItem(
            icon: Icons.insert_drive_file_outlined,
            title: 'Import Nilai Excel',
          ),

          const SizedBox(height: 12),

          const Text(
            'KECERDASAN BUATAN & LAPORAN',
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFF7B818C),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          _MenuItem(
            icon: Icons.auto_awesome_outlined,
            title: 'Analitik & AI Feedback',
          ),

          _MenuItem(
            icon: Icons.auto_awesome,
            title: 'Generate AI Feedback',
            badge: 'Baru',
          ),

          _MenuItem(
            icon: Icons.print_outlined,
            title: 'Cetak PDF & Laporan',
          ),

          const SizedBox(height: 12),

          const Text(
            'PENGATURAN AKUN',
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFF7B818C),
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          _MenuItem(
            icon: Icons.person_outline,
            title: 'Kelola Profil',
          ),

          _MenuItem(
            icon: Icons.shield_outlined,
            title: 'Keamanan & Akun',
          ),

          const Spacer(),

          Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 14,
                  color: Color(0xFF6045D8),
                ),
                SizedBox(width: 7),
                Text(
                  'Panduan Dosen',
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(0xFF4C3CC4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Text(
                  'v1.0',
                  style: TextStyle(
                    fontSize: 7,
                    color: Color(0xFF8D849F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final String? badge;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.selected = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFEFF2FF)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: selected
                ? const Color(0xFF5540D9)
                : const Color(0xFF555B66),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 8,
                color: selected
                    ? const Color(0xFF4D3CD2)
                    : const Color(0xFF3F444D),
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEBDFFF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  fontSize: 6,
                  color: Color(0xFF703FE0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ======================================================
// DASHBOARD CONTENT
// ======================================================

class DashboardContent extends StatelessWidget {
  DashboardContent({super.key});

  final Color purple = const Color(0xFF5136D9);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // =========================
        // TOP HEADER
        // =========================
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE9EBEF),
              ),
            ),
          ),
          child: Row(
            children: [
              const Text(
                'Portal  >  Sistem Akademik  >  ',
                style: TextStyle(
                  fontSize: 7,
                  color: Color(0xFF717783),
                ),
              ),
              const Text(
                'Dashboard Dosen',
                style: TextStyle(
                  fontSize: 7,
                  color: Color(0xFF252931),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F1FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 5,
                      color: Color(0xFF15B979),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Semester Ganjil 2024/2025',
                      style: TextStyle(
                        fontSize: 7,
                        color: Color(0xFF4E4A79),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 22),

              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Dr. Ir. Hendra, M.T.',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'NIDN: 0412088201',
                    style: TextStyle(
                      fontSize: 6,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4432C7),
                ),
                child: const Center(
                  child: Text(
                    'H',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // =========================
        // MAIN SCROLL
        // =========================
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dashboardTitle(),

                const SizedBox(height: 15),

                _statistics(),

                const SizedBox(height: 18),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          _schedule(),
                          const SizedBox(height: 18),
                          _progress(),
                        ],
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _activities(),
                          const SizedBox(height: 18),
                          _announcement(),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Row(
                  children: [
                    Text(
                      '© 2024 Lembaga Layanan Pendidikan Tinggi (LLDIKTI). Hak Cipta Dilindungi.',
                      style: TextStyle(
                        fontSize: 6,
                        color: Color(0xFF7B8088),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.circle,
                      size: 5,
                      color: Color(0xFF19B77B),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'SLA 99.99% Available',
                      style: TextStyle(
                        fontSize: 6,
                        color: Color(0xFF666D77),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ====================================================
  // TITLE
  // ====================================================

  Widget _dashboardTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Dashboard Dosen',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF20242A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF0FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '2024/2025 Ganjil Aktif',
                      style: TextStyle(
                        fontSize: 6,
                        color: Color(0xFF4E40D5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Monitoring rekapitulasi capaian akademik & konfirmasi evaluasi\n'
                'mahasiswa berbasis Outcome-Based Education (OBE).',
                style: TextStyle(
                  fontSize: 7,
                  height: 1.4,
                  color: Color(0xFF737983),
                ),
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                _TopButton(
                  icon: Icons.picture_as_pdf_outlined,
                  title: 'Export Laporan PDF',
                ),
                const SizedBox(width: 8),
                _TopButton(
                  icon: Icons.auto_awesome,
                  title: 'Generate AI Feedback',
                  purple: true,
                ),
              ],
            ),
            const SizedBox(height: 7),
            _TopButton(
              icon: Icons.add_circle_outline,
              title: 'Input Nilai Baru',
              purple: true,
            ),
          ],
        ),
      ],
    );
  }

  // ====================================================
  // STATISTICS
  // ====================================================

  Widget _statistics() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total Kelas Diampu',
            number: '4',
            subtitle: 'Kelas Aktif',
            icon: Icons.grid_view_rounded,
            color: const Color(0xFF5843DA),
            bottom: '↗ 100%     Kapasitas ruang optimal',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Total Mahasiswa',
            number: '128',
            subtitle: 'Terdaftar',
            icon: Icons.groups_outlined,
            color: const Color(0xFF46464F),
            bottom: '◉ Aktif 128     • 2 Program Studi',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Rekap Tertunda',
            number: '2',
            subtitle: 'Kelas Tertunda',
            icon: Icons.pending_actions_outlined,
            color: const Color(0xFFD46D45),
            bottom: '◷ Sisa 6 hari pengisian',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Analitik OBE & AI',
            number: '3',
            subtitle: 'Laporan Siap',
            icon: Icons.psychology_outlined,
            color: const Color(0xFF7144D9),
            bottom: '● Akurasi model 98.4%',
          ),
        ),
      ],
    );
  }

  // ====================================================
  // SCHEDULE
  // ====================================================

  Widget _schedule() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: Color(0xFF5A42D5),
                ),
              ),
              const SizedBox(width: 9),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jadwal Mengajar Hari Ini',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sinkronisasi langsung dengan Sistem Akademik Kampus',
                    style: TextStyle(
                      fontSize: 6,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Kamis, 24 Okt 2024',
                  style: TextStyle(
                    fontSize: 6,
                    color: Color(0xFF5B45D4),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _ScheduleItem(
            time: '08:00',
            duration: '10:30\nWIB',
            title: 'Rekayasa Perangkat Lunak (IF-401)',
            status: 'Sesi Berlangsung',
            room: 'Lab Komputer 1',
            students: '36 Mahasiswa Hadir',
            button: 'Buka Presensi',
          ),

          const SizedBox(height: 10),

          _ScheduleItem(
            time: '13:00',
            duration: '15:30\nWIB',
            title: 'Sistem Basis Data Terdistribusi (IF-204)',
            status: 'Akan Datang',
            room: 'Ruang Teori 402',
            students: '42 Mahasiswa Terdaftar',
            button: 'Mulai dalam 2 jam',
          ),
        ],
      ),
    );
  }

  // ====================================================
  // PROGRESS
  // ====================================================

  Widget _progress() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                size: 16,
                color: Color(0xFF5A42D5),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress Penginputan Nilai OBE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Status rekap OBE (Capaian Pembelajaran Lulusan)',
                    style: TextStyle(
                      fontSize: 6,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Target Final: 30 Nov 2024',
                  style: TextStyle(
                    fontSize: 6,
                    color: Color(0xFFAE7B18),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _ProgressItem(
            title: 'Rekayasa Perangkat Lunak - Kls A',
            description: '32 dari 36 Mahasiswa telah dinilai komprehensif',
            percent: '85%',
            value: .85,
            color: const Color(0xFF6844D8),
            button: 'Lanjutkan Edit',
            footer: 'Komponen: Tugas (100%), UTS (100%), UAS (80%)',
          ),

          const SizedBox(height: 10),

          _ProgressItem(
            title: 'Interaksi Manusia & Komputer - Kls C',
            description: '48 dari 48 Mahasiswa sudah dinilai penuh',
            percent: '100%',
            value: 1,
            color: const Color(0xFF11B98A),
            button: 'Terkunci / Selesai',
            footer: 'Arsip dikirim ke BAAK pada 22 Okt 2024',
          ),

          const SizedBox(height: 10),

          _ProgressItem(
            title: 'Sistem Basis Data Terdistribusi - Kls B',
            description: '0 dari 42 Mahasiswa dinilai',
            percent: '0%',
            value: 0,
            color: const Color(0xFF6844D8),
            button: 'Mulai Input',
            footer: 'Belum ada nilai tugas terunggah',
          ),
        ],
      ),
    );
  }

  // ====================================================
  // ACTIVITIES
  // ====================================================

  Widget _activities() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_none,
                size: 15,
                color: Color(0xFF6844D8),
              ),
              const SizedBox(width: 7),
              const Text(
                'Aktivitas Terbaru',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '4 Log Baru',
                  style: TextStyle(fontSize: 6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          const _Activity(
            tag: 'AI Generated',
            text:
                'Feedback otomatis rubrik Capaian Pembelajaran kelas RPL A berhasil diaktifkan.',
            time: '10m lalu',
            color: Color(0xFFECE4FF),
          ),

          const _Activity(
            tag: 'Nilai Diinput',
            text:
                'Dedi penilaian Tugas Proyek Kelompok 2 dikonfirmasi ke server pusat.',
            time: '1j lalu',
            color: Color(0xFFEAEAFF),
          ),

          const _Activity(
            tag: 'Portal BAAK',
            text:
                'Batas akhir perbaikan nilai komponen nilai semester genap: 10 Des 2024.',
            time: '3j lalu',
            color: Color(0xFFFFEDE3),
          ),

          const _Activity(
            tag: 'Cetak PDF',
            text:
                'Dokumen Berita Acara Perkuliahan resmi MK-C berhasil diekspor.',
            time: 'Kemarin',
            color: Color(0xFFF0EAFB),
          ),

          const SizedBox(height: 7),

          const Center(
            child: Text(
              'Lihat Riwayat Log Lengkap →',
              style: TextStyle(
                fontSize: 7,
                color: Color(0xFF5B42D4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================
  // ANNOUNCEMENT
  // ====================================================

  Widget _announcement() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.campaign_outlined,
                size: 15,
                color: Color(0xFF6844D8),
              ),
              const SizedBox(width: 7),
              const Text(
                'Pengumuman\nFakultas',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7FFF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Penting',
                  style: TextStyle(
                    fontSize: 6,
                    color: Color(0xFF12A16F),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // GAMBAR PENGUMUMAN
          Container(
            height: 82,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6425C8),
                  Color(0xFFE7B6E7),
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'FACULTY SEMINAR DIGITAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Campus Transformation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Sosialisasi Penjaminan Mutu\nAkademik & Evaluasi OBE',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Diharapkan seluruh koordinator mata kuliah '
            'menghadiri agenda pembekalan kurikulum digital '
            'dan penyiapan administrasi internal pada hari Jumat mendatang.',
            style: TextStyle(
              fontSize: 7,
              height: 1.5,
              color: Color(0xFF737983),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 12,
                color: Color(0xFF747B85),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Auditorium Utama & Zoom',
                  style: TextStyle(
                    fontSize: 7,
                    color: Color(0xFF656B74),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF6544D8),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Daftar\nSekarang →',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 6,
                    color: Color(0xFF6544D8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================
// SECTION CARD
// ======================================================

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFECEEF2),
        ),
      ),
      child: child,
    );
  }
}

// ======================================================
// STAT CARD
// ======================================================

class _StatCard extends StatelessWidget {
  final String title;
  final String number;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String bottom;

  const _StatCard({
    required this.title,
    required this.number,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFECEEF2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 7,
                    color: Color(0xFF636973),
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color.withOpacity(.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20242A),
                ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 7,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            bottom,
            style: TextStyle(
              fontSize: 6,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// TOP BUTTON
// ======================================================

class _TopButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool purple;

  const _TopButton({
    required this.icon,
    required this.title,
    this.purple = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
      ),
      decoration: BoxDecoration(
        color: purple
            ? const Color(0xFF5533D5)
            : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: purple
            ? null
            : Border.all(
                color: const Color(0xFFE4E6EB),
              ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 11,
            color: purple
                ? Colors.white
                : const Color(0xFF545963),
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 7,
              color: purple
                  ? Colors.white
                  : const Color(0xFF545963),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// SCHEDULE ITEM
// ======================================================

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String duration;
  final String title;
  final String status;
  final String room;
  final String students;
  final String button;

  const _ScheduleItem({
    required this.time,
    required this.duration,
    required this.title,
    required this.status,
    required this.room,
    required this.students,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FF),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF523BD2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  duration,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 6,
                    color: Color(0xFF777D86),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Icon(
                      status == 'Sesi Berlangsung'
                          ? Icons.circle
                          : Icons.access_time,
                      size: 7,
                      color: status == 'Sesi Berlangsung'
                          ? const Color(0xFF12B57D)
                          : const Color(0xFF777D86),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 6,
                        color: status == 'Sesi Berlangsung'
                            ? const Color(0xFF12B57D)
                            : const Color(0xFF777D86),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 7,
                      color: Color(0xFF777D86),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      room,
                      style: const TextStyle(
                        fontSize: 6,
                        color: Color(0xFF777D86),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.groups_outlined,
                      size: 7,
                      color: Color(0xFF777D86),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      students,
                      style: const TextStyle(
                        fontSize: 6,
                        color: Color(0xFF777D86),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (status == 'Sesi Berlangsung')
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF5534D6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Buka\nPresensi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 6,
                  color: Colors.white,
                ),
              ),
            )
          else
            Text(
              button,
              style: const TextStyle(
                fontSize: 6,
                color: Color(0xFF777D86),
              ),
            ),

          const SizedBox(width: 5),

          const Icon(
            Icons.chevron_right,
            size: 14,
            color: Color(0xFF777D86),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// PROGRESS ITEM
// ======================================================

class _ProgressItem extends StatelessWidget {
  final String title;
  final String description;
  final String percent;
  final double value;
  final Color color;
  final String button;
  final String footer;

  const _ProgressItem({
    required this.title,
    required this.description,
    required this.percent,
    required this.value,
    required this.color,
    required this.button,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 6,
                        color: Color(0xFF7A8088),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                percent,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(.08),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  button,
                  style: TextStyle(
                    fontSize: 6,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: color.withOpacity(.08),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            footer,
            style: const TextStyle(
              fontSize: 6,
              color: Color(0xFF777D86),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// ACTIVITY
// ======================================================

class _Activity extends StatelessWidget {
  final String tag;
  final String text;
  final String time;
  final Color color;

  const _Activity({
    required this.tag,
    required this.text,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 6,
                    color: Color(0xFF6343D4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 6,
                  color: Color(0xFF858B94),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            text,
            style: const TextStyle(
              fontSize: 7,
              height: 1.4,
              color: Color(0xFF4F545C),
            ),
          ),
        ],
      ),
    );
  }
}