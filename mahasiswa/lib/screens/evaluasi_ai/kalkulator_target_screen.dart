import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../widgets/common.dart';

/// Isi tab "Kalkulator" (dipakai di screen 11 dan screen 14 + 25).
///
/// Pertanyaan yang dijawab: "Berapa nilai UAS minimal yang kubutuhkan
/// supaya nilai akhirku mencapai target?"
///
/// Rumus (w = bobot UAS dalam persen):
///   poin terkunci = (100 - w)% x nilai UTS dan tugas
///   nilai UAS     = (target - poin terkunci) / w%
/// Semua angka dibatasi 0 sampai 100.
class KalkulatorContent extends StatefulWidget {
  const KalkulatorContent({super.key});

  @override
  State<KalkulatorContent> createState() => _KalkulatorContentState();
}

class _KalkulatorContentState extends State<KalkulatorContent> {
  static const _pesanNilai = 'Isi angka 0 sampai 100. Contoh: 82';
  static const _pesanBobot = 'Isi angka 1 sampai 100. Contoh: 40';

  final _saatIni = TextEditingController(text: '75');
  final _bobot = TextEditingController(text: '40');
  final _target = TextEditingController(text: '80');

  _Hasil? _hasil;
  String? _errSaatIni;
  String? _errBobot;
  String? _errTarget;

  @override
  void initState() {
    super.initState();
    // Angka lebih dari 100 otomatis dikembalikan menjadi 100
    for (final c in [_saatIni, _bobot, _target]) {
      c.addListener(() => _batasi(c));
    }
    _hasil = _hitungHasil();
  }

  @override
  void dispose() {
    _saatIni.dispose();
    _bobot.dispose();
    _target.dispose();
    super.dispose();
  }

  void _batasi(TextEditingController c) {
    final n = double.tryParse(c.text.trim().replaceAll(',', '.'));
    if (n != null && n > 100) {
      c.value = const TextEditingValue(
        text: '100',
        selection: TextSelection.collapsed(offset: 3),
      );
    }
    setState(() {}); // supaya keterangan di bawah kolom ikut diperbarui
  }

  /// Baca angka antara [min] dan 100. Null kalau kosong atau di luar batas.
  double? _baca(String v, {double min = 0}) {
    final n = double.tryParse(v.trim().replaceAll(',', '.'));
    if (n == null || n < min || n > 100) return null;
    return n;
  }

  _Hasil? _hitungHasil() {
    final a = _baca(_saatIni.text);
    final w = _baca(_bobot.text, min: 1);
    final t = _baca(_target.text);
    if (a == null || w == null || t == null) return null;
    return _Hasil(nilai: a, bobotUas: w, target: t);
  }

  void _hitung() {
    setState(() {
      _errSaatIni = _baca(_saatIni.text) == null ? _pesanNilai : null;
      _errBobot = _baca(_bobot.text, min: 1) == null ? _pesanBobot : null;
      _errTarget = _baca(_target.text) == null ? _pesanNilai : null;
      _hasil = _hitungHasil();
    });
  }

  /// 87.0 -> "87", 87.5 -> "87.5"
  static String _fmt(double v) {
    final s = v.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  /// Dibulatkan KE ATAS satu desimal, karena yang dicari nilai MINIMAL.
  static double _atas(double v) {
    final r = double.parse(v.toStringAsFixed(6));
    return (r * 10).ceil() / 10;
  }

  String get _helperBobot {
    final w = _baca(_bobot.text, min: 1);
    const dasar = 'Seberapa besar UAS menentukan nilai akhir.';
    if (w == null) return dasar;
    return '$dasar UTS dan tugas otomatis ${_fmt(100 - w)}%.';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hitung nilai UAS minimal yang kamu butuhkan supaya nilai akhirmu '
          'mencapai target.',
          style: TextStyle(fontSize: 13, height: 1.45, color: AppColors.muted),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Nilai UTS dan tugas (rata-rata)',
          controller: _saatIni,
          keyboardType: TextInputType.number,
          helper: 'Maksimal 100. Isi rata-rata nilai yang sudah kamu dapat.',
          error: _errSaatIni,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Bobot UAS (%)',
          controller: _bobot,
          keyboardType: TextInputType.number,
          helper: _helperBobot,
          error: _errBobot,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Target nilai akhir',
          controller: _target,
          keyboardType: TextInputType.number,
          helper: 'Maksimal 100.',
          error: _errTarget,
        ),
        const SizedBox(height: 24),
        PrimaryButton('Hitung', onPressed: _hitung),
        const SizedBox(height: 24),
        _kartuHasil(),
      ],
    );
  }

  Widget _kartuHasil() {
    final h = _hasil;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hasil perhitungan',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink)),
          const SizedBox(height: 6),
          if (h == null)
            const Text('Perbaiki isian di atas untuk melihat hasil.',
                style: TextStyle(fontSize: 12, color: AppColors.muted))
          else
            ..._isiHasil(h),
        ],
      ),
    );
  }

  List<Widget> _isiHasil(_Hasil h) {
    // 1) Target sudah pasti tercapai (UAS berapa pun aman)
    if (h.perlu <= 0) {
      return [
        const Text('Nilai UAS minimal',
            style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 10),
        _angkaBesar('0'),
        const SizedBox(height: 8),
        _kalimat(
          'Target sudah pasti tercapai. Bagian UTS dan tugasmu saja sudah '
          'memberi ${_fmt(h.poinTerkunci)} poin, lebih dari target '
          '${_fmt(h.target)}.',
        ),
      ];
    }

    // 2) Target mustahil dicapai: nilai UAS tetap dibatasi 100
    if (h.perlu > 100) {
      return [
        const Text('Nilai UAS maksimal',
            style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 10),
        _angkaBesar('100'),
        const SizedBox(height: 8),
        _kalimat(
          'Target ${_fmt(h.target)} belum bisa dicapai. Dengan nilai UAS 100, '
          'Nilai akhirmu paling tinggi ${_fmt(h.maksimal)}. '
          'Coba turunkan target anda.',
          warna: AppColors.danger,
        ),
      ];
    }

    // 3) Kasus biasa: tampilkan hasil dan langkah hitungnya
    final minimal = _atas(h.perlu);
    return [
      const Text('Nilai UAS minimal',
          style: TextStyle(fontSize: 12, color: AppColors.muted)),
      const SizedBox(height: 10),
      _angkaBesar(_fmt(minimal)),
      const SizedBox(height: 8),
      _kalimat(
        'Kamu butuh nilai UAS minimal ${_fmt(minimal)} supaya nilai akhirmu '
        'mencapai ${_fmt(h.target)}.',
        warna: AppColors.ink,
      ),
      const SizedBox(height: 16),
      const Divider(height: 1, color: AppColors.border),
      const SizedBox(height: 14),
      const Text('Cara menghitungnya',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink)),
      const SizedBox(height: 10),
      _Langkah(
        1,
        'UTS dan tugas bobotnya ${_fmt(h.bobotLain)}%.\n'
        '${_fmt(h.bobotLain)}% × ${_fmt(h.nilai)} = '
        '${_fmt(h.poinTerkunci)} poin (sudah pasti kamu dapat).',
      ),
      _Langkah(
        2,
        'Target ${_fmt(h.target)}, jadi masih kurang '
        '${_fmt(h.sisa)} poin.\n'
        '${_fmt(h.target)} − ${_fmt(h.poinTerkunci)} = ${_fmt(h.sisa)}',
      ),
      _Langkah(
        3,
        'Kekurangan itu harus dicukupi UAS yang bobotnya '
        '${_fmt(h.bobotUas)}%.\n'
        '${_fmt(h.sisa)} ÷ ${_fmt(h.bobotUas)}% = ${_fmt(minimal)}',
      ),
    ];
  }

  Widget _angkaBesar(String t) => Text(t,
      style: const TextStyle(
          fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.ink));

  Widget _kalimat(String t, {Color warna = AppColors.muted}) => Text(t,
      style: TextStyle(fontSize: 13, height: 1.5, color: warna));
}

/// Data dan hitungan satu kali perhitungan.
class _Hasil {
  final double nilai; // nilai UTS dan tugas
  final double bobotUas; // persen
  final double target;

  const _Hasil({
    required this.nilai,
    required this.bobotUas,
    required this.target,
  });

  double get bobotLain => 100 - bobotUas;
  double get poinTerkunci => bobotLain / 100 * nilai;
  double get sisa => target - poinTerkunci;

  /// Nilai UAS yang dibutuhkan (belum dibatasi 0 sampai 100).
  double get perlu => sisa / (bobotUas / 100);

  /// Nilai akhir tertinggi yang mungkin (kalau UAS = 100).
  double get maksimal => poinTerkunci + bobotUas;
}

/// Satu baris langkah: nomor bulat + penjelasan.
class _Langkah extends StatelessWidget {
  final int nomor;
  final String teks;
  const _Langkah(this.nomor, this.teks);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySoft,
            ),
            child: Text('$nomor',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(teks,
                style: const TextStyle(
                    fontSize: 12, height: 1.5, color: AppColors.muted)),
          ),
        ],
      ),
    );
  }
}

/// Screen 14 + 25 - Kalkulator target nilai
class KalkulatorTargetScreen extends StatelessWidget {
  const KalkulatorTargetScreen({super.key});

  @override
  Widget build(BuildContext context) => const SubScreen(
      title: 'Kalkulator Target Nilai', child: KalkulatorContent());
}