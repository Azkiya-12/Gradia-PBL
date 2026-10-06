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
  final int kategori; 
  const _Notif(this.icon, this.judul, this.isi, this.waktu, this.kategori);
}

const _data = <_Notif>[
  _Notif(Icons.article_outlined, 'Nilai mata kuliah',
      'Nilai Algoritma & Struktur Data telah diperbarui', '10:24', 1),
  _Notif(Icons.notifications_none, 'Pengumuman kampus',
      'Jadwal Ujian Semester Ganjil telah diumumkan', '09:00', 2),
  _Notif(Icons.access_time, 'Reminder tugas',
      'Tugas Pemrograman Mobile dikumpulkan besok', '08:30', 0),
  _Notif(Icons.info_outline, 'Update sistem',
      'Aplikasi Gradia diperbarui ke versi terbaru', 'Kemarin', 0),
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
    final items = _tab == 0 ? _data : _data.where((n) => n.kategori == _tab);
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
