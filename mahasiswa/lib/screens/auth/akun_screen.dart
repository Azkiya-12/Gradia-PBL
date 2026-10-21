import 'package:flutter/material.dart';
import '../../services/pengaturan_storage.dart';
import '../../services/rahasia_storage.dart';
import 'login_screen.dart';

class AkunScreen extends StatefulWidget {
  const AkunScreen({super.key});

  @override
  State<AkunScreen> createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  static const _inisial = 'SP';
  static const _email = 'sintaanabella@kampus';
  static const _nim = '251234567899';
  static const _prodiSingkat = 'Teknologi Informasi';
  static const List<List<String>> _dataDiri = [
    ['Nama lengkap', 'Sinta Putri Anabella'],
    ['Angkatan', '2025'],
    ['Status Akademik', 'Aktif'],
    ['Fakultas', 'Vokasi'],
    ['Jurusan', 'Non jurusan'],
    ['Jenjang dan Program Studi', 'D3 – Teknologi Informasi'],
  ];

  bool _notifikasiNilai = true;
  bool _pengumumanKampus = true;
  bool _reminderTugas = true;
  bool _updateSistem = false; 

  @override
  void initState() {
    super.initState();
    _muatPengaturan();
  }

  Future<void> _muatPengaturan() async {
    final p = await PengaturanStorage.muat();
    if (!mounted) return;
    setState(() {
      _notifikasiNilai = p['nilai']!;
      _pengumumanKampus = p['pengumuman']!;
      _reminderTugas = p['reminder']!;
      _updateSistem = p['update']!;
    });
  }

  // Simpan otomatis setiap tombol geser diubah
  Future<void> _simpanPengaturan() {
    return PengaturanStorage.simpan(
      nilai: _notifikasiNilai,
      pengumuman: _pengumumanKampus,
      reminder: _reminderTugas,
      update: _updateSistem,
    );
  }

  // Keluar: hapus token dari secure storage, lalu kembali ke Login
  Future<void> _keluar() async {
    await RahasiaStorage.hapusToken();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Akun',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Kartu profil
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0x40FFFFFF),
                        ),
                        child: const Text(
                          _inisial,
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        _email,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '$_nim · $_prodiSingkat',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xE6FFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Data diri
              for (final item in _dataDiri) ...[
                _InfoRow(label: item[0], value: item[1]),
                const Divider(height: 1, color: _border),
              ],

              const SizedBox(height: 24),

              // Pengaturan notifikasi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pengaturan notifikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Akademik',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        children: [
                          _SwitchRow(
                            judul: 'Notifikasi nilai',
                            keterangan: 'Saat nilai diperbarui',
                            value: _notifikasiNilai,
                            onChanged: (v) {
                              setState(() => _notifikasiNilai = v);
                              _simpanPengaturan();
                            },
                          ),
                          const Divider(height: 1, color: _border),
                          _SwitchRow(
                            judul: 'Pengumuman kampus',
                            keterangan: 'Jadwal dan kabar penting',
                            value: _pengumumanKampus,
                            onChanged: (v) {
                              setState(() => _pengumumanKampus = v);
                              _simpanPengaturan();
                            },
                          ),
                          const Divider(height: 1, color: _border),
                          _SwitchRow(
                            judul: 'Reminder tugas',
                            keterangan: 'Sehari sebelum tenggat',
                            value: _reminderTugas,
                            onChanged: (v) {
                              setState(() => _reminderTugas = v);
                              _simpanPengaturan();
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Keluar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _keluar,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFDC2626),
                          side: const BorderSide(color: Color(0xFFFECACA)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Keluar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
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
                    fontSize: 15,
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