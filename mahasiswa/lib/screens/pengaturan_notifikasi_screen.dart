import 'package:flutter/material.dart';

class PengaturanNotifikasiScreen extends StatefulWidget {
  const PengaturanNotifikasiScreen({super.key});

  @override
  State<PengaturanNotifikasiScreen> createState() =>
      _PengaturanNotifikasiScreenState();
}

class _PengaturanNotifikasiScreenState
    extends State<PengaturanNotifikasiScreen> {
  static const _primary = Color(0xFF4F46E5);
  static const _dark = Color(0xFF0F172A);
  static const _border = Color(0xFFE2E8F0);

  bool _notifikasiNilai = true;
  bool _pengumumanKampus = true;
  bool _reminderTugas = true;
  bool _updateSistem = false;

  void _simpan() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengaturan disimpan')),
    );
    Navigator.pop(context);
  }

  Widget _judulBagian(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _dark,
          ),
        ),
      );

  Widget _kartu(List<Widget> children) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1)
                const Divider(height: 1, color: _border),
            ],
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                  const SizedBox(width: 12),
                  const Text(
                    'Pengaturan notifikasi',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _dark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _judulBagian('Akademik'),
              _kartu([
                _SwitchRow(
                  judul: 'Notifikasi nilai',
                  keterangan: 'Saat nilai diperbarui',
                  value: _notifikasiNilai,
                  onChanged: (v) => setState(() => _notifikasiNilai = v),
                ),
                _SwitchRow(
                  judul: 'Pengumuman kampus',
                  keterangan: 'Jadwal dan kabar penting',
                  value: _pengumumanKampus,
                  onChanged: (v) => setState(() => _pengumumanKampus = v),
                ),
                _SwitchRow(
                  judul: 'Reminder tugas',
                  keterangan: 'Sehari sebelum tenggat',
                  value: _reminderTugas,
                  onChanged: (v) => setState(() => _reminderTugas = v),
                ),
              ]),
              const SizedBox(height: 24),
              _judulBagian('Aplikasi'),
              _kartu([
                _SwitchRow(
                  judul: 'Update sistem',
                  keterangan: 'Versi baru Gradia',
                  value: _updateSistem,
                  onChanged: (v) => setState(() => _updateSistem = v),
                ),
              ]),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan perubahan',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String judul;
  final String keterangan;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.judul,
    required this.keterangan,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  keterangan,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: const WidgetStatePropertyAll(Colors.white),
            activeTrackColor: const Color(0xFF4F46E5),
            inactiveTrackColor: const Color(0xFFCBD5E1),
            trackOutlineColor:
                const WidgetStatePropertyAll(Colors.transparent),
          ),
        ],
      ),
    );
  }
}