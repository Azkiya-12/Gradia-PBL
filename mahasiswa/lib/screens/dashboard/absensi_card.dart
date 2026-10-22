import 'dart:ui';
import 'package:flutter/material.dart';

/// Kartu "Absensi" di Dashboard.
/// Tombol "Absen sekarang" membuka pilihan (Hadir / Izin / Sakit,
/// dan untuk Hadir: Luring / Daring) di atas latar yang diburamkan.
class AbsensiCard extends StatefulWidget {
  const AbsensiCard({super.key});

  @override
  State<AbsensiCard> createState() => _AbsensiCardState();
}

class _AbsensiCardState extends State<AbsensiCard> {
  // Data contoh sesi yang sedang berlangsung. Nanti dari backend.
  static const _mataKuliah = 'Pemrograman Mobile';
  static const _info = 'Ruang B.2.1 · 10:00–11:40';
  static const _batas = 'Ditutup 10:15';

  /// null = belum absen. Contoh isi: 'Hadir · Luring', 'Izin', 'Sakit'.
  String? _hasil;

  Future<void> _absen() async {
    final hasil = await showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup',
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (context, a1, a2) => const _AbsensiPilihan(
        mataKuliah: _mataKuliah,
        info: _info,
        batas: _batas,
      ),
    );

    if (hasil == null || !mounted) return;
    setState(() => _hasil = hasil);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Absensi tercatat: $hasil')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sudahAbsen = _hasil != null;

    return _SesiKartu(
      mataKuliah: _mataKuliah,
      info: _info,
      batas: _batas,
      chipTeks: sudahAbsen ? 'Sudah absen' : 'Sedang berlangsung',
      aksi: sudahAbsen
          ? Container(
              width: double.infinity,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0x33FFFFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Absensi tercatat · $_hasil',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          : GestureDetector(
              onTap: _absen,
              child: Container(
                width: double.infinity,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Absen sekarang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ),
    );
  }
}

/// Kerangka kartu ungu: chip status, batas waktu, nama mata kuliah, dan [aksi].
class _SesiKartu extends StatelessWidget {
  final String mataKuliah;
  final String info;
  final String batas;
  final String chipTeks;
  final Widget aksi;

  const _SesiKartu({
    required this.mataKuliah,
    required this.info,
    required this.batas,
    required this.chipTeks,
    required this.aksi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF34D399),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      chipTeks,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                batas,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mataKuliah,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            info,
            style: const TextStyle(fontSize: 13, color: Color(0xE6FFFFFF)),
          ),
          const SizedBox(height: 14),
          aksi,
        ],
      ),
    );
  }
}

/// Layar pilihan absen di atas latar buram.
class _AbsensiPilihan extends StatefulWidget {
  final String mataKuliah;
  final String info;
  final String batas;

  const _AbsensiPilihan({
    required this.mataKuliah,
    required this.info,
    required this.batas,
  });

  @override
  State<_AbsensiPilihan> createState() => _AbsensiPilihanState();
}

class _AbsensiPilihanState extends State<_AbsensiPilihan> {
  /// 0 = Hadir / Izin / Sakit, 1 = Luring / Daring
  int _langkah = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> opsi = _langkah == 0
        ? [
            _Opsi('Hadir', () => setState(() => _langkah = 1)),
            _Opsi('Izin', () => Navigator.pop(context, 'Izin')),
            _Opsi('Sakit', () => Navigator.pop(context, 'Sakit')),
          ]
        : [
            _Opsi('Luring', () => Navigator.pop(context, 'Hadir · Luring')),
            _Opsi('Daring', () => Navigator.pop(context, 'Hadir · Daring')),
          ];

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Latar buram. Ketuk di luar kartu untuk menutup.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: const Color(0x99FFFFFF)),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 390),
                child: _SesiKartu(
                mataKuliah: widget.mataKuliah,
                info: widget.info,
                batas: widget.batas,
                chipTeks: 'Sedang berlangsung',
                aksi: Column(mainAxisSize: MainAxisSize.min, children: opsi),
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Opsi extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _Opsi(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        margin: const EdgeInsets.only(bottom: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0x40FFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}