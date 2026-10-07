import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../demo_data.dart';
import '../widgets/common.dart';
import 'pengaturan_notifikasi_screen.dart';

class _Notif {
  final IconData icon;
  final String judul;
  final String isi;
  final String waktu;
  const _Notif(this.icon, this.judul, this.isi, this.waktu);
}

// Tab "Semua" (ringkasan)
const _semua = <_Notif>[
  _Notif(Icons.article_outlined, 'Nilai mata kuliah',
      'Nilai Algoritma & Struktur Data telah diperbarui', '10:24'),
  _Notif(Icons.notifications_none, 'Pengumuman kampus',
      'Jadwal Ujian Semester Ganjil telah diumumkan', '09:00'),
  _Notif(Icons.access_time, 'Reminder tugas',
      'Tugas Pemrograman Mobile dikumpulkan besok', '08:30'),
  _Notif(Icons.info_outline, 'Update sistem',
      'Aplikasi Gradia diperbarui ke versi terbaru', 'Kemarin'),
];

// Tab "Nilai"
const _nilai = <_Notif>[
  _Notif(Icons.article_outlined, 'Nilai mata kuliah',
      'Nilai Algoritma & Struktur Data telah diperbarui', '10:24'),
  _Notif(Icons.article_outlined, 'Nilai UTS',
      'Nilai UTS Basis Data sudah tersedia', 'Kemarin'),
  _Notif(Icons.article_outlined, 'Nilai tugas',
      'Tugas 3 Desain User Interface sudah dinilai', 'Kemarin'),
  _Notif(Icons.article_outlined, 'Nilai kuis',
      'Nilai Kuis 2 Pemrograman Mobile telah ditambahkan', '2 hari lalu'),
  _Notif(Icons.article_outlined, 'Nilai praktikum',
      'Nilai praktikum Jaringan Komputer telah diperbarui', '3 hari lalu'),
  _Notif(Icons.article_outlined, 'IPS semester',
      'IPS semester ini sudah dihitung dan tersedia', '5 hari lalu'),
];

// Tab "Pengumuman"
const _pengumuman = <_Notif>[
  _Notif(Icons.notifications_none, 'Pengumuman kampus',
      'Jadwal Ujian Semester Ganjil telah diumumkan', '09:00'),
  _Notif(Icons.notifications_none, 'Pengumuman kampus',
      'Pendaftaran wisuda periode berikutnya dibuka', 'Kemarin'),
  _Notif(Icons.notifications_none, 'Pengumuman prodi',
      'Kuliah Basis Data Jumat dipindah ke ruang B.2.1', 'Kemarin'),
  _Notif(Icons.notifications_none, 'Beasiswa',
      'Pendaftaran beasiswa prestasi dibuka hingga akhir bulan',
      '2 hari lalu'),
  _Notif(Icons.notifications_none, 'Layanan perpustakaan',
      'Perpustakaan tutup pada akhir pekan ini', '3 hari lalu'),
  _Notif(Icons.notifications_none, 'Kegiatan kampus',
      'Seminar teknologi mobile terbuka untuk semua mahasiswa',
      '5 hari lalu'),
];

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: DemoState.kosong,
      builder: (context, kosong, _) =>
          kosong ? _kosongView(context) : _listView(context),
    );
  }

  /// Screen 29 - Notifikasi kosong
  Widget _kosongView(BuildContext context) {
    return SubScreen(
      title: 'Notifikasi',
      child: EmptyState(
        icon: Icons.notifications_none,
        title: 'Belum ada notifikasi',
        message:
            'Kabar nilai, pengumuman kampus, dan pengingat tugas akan muncul di sini.',
        primaryLabel: 'Atur notifikasi',
        onPrimary: () => push(context, const PengaturanNotifikasiScreen()),
        secondaryLabel: 'Kembali ke dashboard',
        onSecondary: () => Navigator.of(context).maybePop(),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    // Urutan sama dengan tab: 0 = Semua, 1 = Nilai, 2 = Pengumuman
    final items = const [_semua, _nilai, _pengumuman][_tab];

    return SubScreen(
      title: 'Notifikasi',
      child: Column(
        children: [
          PillTabs(
            tabs: const ['Semua', 'Nilai', 'Pengumuman'],
            index: _tab,
            onChanged: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: 20),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text('Belum ada notifikasi',
                  style: TextStyle(color: AppColors.muted)),
            )
          else
            AppCard(
              child: Column(
                children: divide([for (final n in items) _NotifRow(n)]),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  final _Notif n;
  const _NotifRow(this.n);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox(n.icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.judul,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(n.isi,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(n.waktu,
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
        ],
      ),
    );
  }
}