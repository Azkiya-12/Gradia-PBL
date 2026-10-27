import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../widgets/common.dart';

/// Isi tab "Kalkulator" (dipakai di screen 11 dan screen 14 + 25).
/// Rumus: nilai akhir = (1 - w) * nilai saat ini + w * UAS
///        UAS dibutuhkan = (target - (1 - w) * nilai saat ini) / w
/// dengan w = bobot UAS (0 sampai 1).
class KalkulatorContent extends StatefulWidget {
  const KalkulatorContent({super.key});

  @override
  State<KalkulatorContent> createState() => _KalkulatorContentState();
}

class _KalkulatorContentState extends State<KalkulatorContent> {
  static const _pesanNilai = 'Nilai harus antara 0 dan 100. Contoh: 82';
  static const _pesanBobot = 'Bobot harus antara 1 dan 100. Contoh: 40';

  final _saatIni = TextEditingController(text: '75');
  final _bobot = TextEditingController(text: '40');
  final _target = TextEditingController(text: '80');

  double? _hasil = 87.5; // null = ada input yang salah
  String _rumus = '(80 − 60% × 75) ÷ 40% = 87.5';
  String? _errSaatIni;
  String? _errBobot;
  String? _errTarget;

  /// Baca angka dengan batas [min] sampai 100. Null kalau tidak valid.
  double? _baca(String v, {double min = 0}) {
    final n = double.tryParse(v.trim().replaceAll(',', '.'));
    if (n == null || n < min || n > 100) return null;
    return n;
  }

  /// 87.0 -> "87", 87.5 -> "87.5"
  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  void _hitung() {
    final a = _baca(_saatIni.text);
    final bobotPersen = _baca(_bobot.text, min: 1);
    final b = _baca(_target.text);

    setState(() {
      _errSaatIni = a == null ? _pesanNilai : null;
      _errBobot = bobotPersen == null ? _pesanBobot : null;
      _errTarget = b == null ? _pesanNilai : null;

      if (a != null && bobotPersen != null && b != null) {
        final w = bobotPersen / 100;
        _hasil = (b - (1 - w) * a) / w;
        _rumus = '(${_fmt(b)} − ${_fmt(100 - bobotPersen)}% × ${_fmt(a)})'
            ' ÷ ${_fmt(bobotPersen)}% = ${_hasil!.toStringAsFixed(1)}';
      } else {
        _hasil = null;
      }
    });
  }

  @override
  void dispose() {
    _saatIni.dispose();
    _bobot.dispose();
    _target.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Nilai saat ini',
          controller: _saatIni,
          keyboardType: TextInputType.number,
          helper: 'Rata-rata UTS dan tugas. Isi 0 sampai 100.',
          error: _errSaatIni,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Bobot UAS (%)',
          controller: _bobot,
          keyboardType: TextInputType.number,
          helper: 'Bobot UTS dan tugas otomatis 100% dikurangi bobot UAS.',
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
        AppCard(
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
              if (_hasil == null)
                const Text('Perbaiki isian di atas untuk melihat hasil.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted))
              else ...[
                const Text('Nilai UAS yang dibutuhkan',
                    style: TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 14),
                Text(_hasil! < 0 ? '0' : _hasil!.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink)),
                const SizedBox(height: 6),
                if (_hasil! < 0)
                  const Text(
                      'Target sudah tercapai, berapa pun nilai UAS-mu aman.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted))
                else if (_hasil! > 100)
                  const Text(
                      'Target ini sulit dicapai (butuh lebih dari 100).',
                      style: TextStyle(fontSize: 12, color: AppColors.danger))
                else
                  Text('$_rumus. Nilai UAS maksimal 100.',
                      style: const TextStyle(
                          fontSize: 12, height: 1.5, color: AppColors.muted)),
              ],
            ],
          ),
        ),
      ],
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