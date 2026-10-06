import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/common.dart';

/// Isi tab "Kalkulator" (dipakai di screen 11 dan screen 14 + 25).
/// Rumus: nilai akhir = 60% * nilai saat ini + 40% * UAS
///        UAS dibutuhkan = (target - 0.6 * nilai saat ini) / 0.4
class KalkulatorContent extends StatefulWidget {
  const KalkulatorContent({super.key});

  @override
  State<KalkulatorContent> createState() => _KalkulatorContentState();
}

class _KalkulatorContentState extends State<KalkulatorContent> {
  static const _bobotUas = 0.4;
  static const _pesanRentang = 'Nilai harus antara 0 dan 100. Contoh: 82';
  final _saatIni = TextEditingController(text: '75');
  final _target = TextEditingController(text: '80');
  double? _hasil = 87.5; // null = ada input yang salah
  String? _errSaatIni;
  String? _errTarget;

  double? _baca(String v) {
    final n = double.tryParse(v.trim().replaceAll(',', '.'));
    if (n == null || n < 0 || n > 100) return null;
    return n;
  }

  void _hitung() {
    final a = _baca(_saatIni.text);
    final b = _baca(_target.text);
    setState(() {
      _errSaatIni = a == null ? _pesanRentang : null;
      _errTarget = b == null ? _pesanRentang : null;
      _hasil = (a != null && b != null)
          ? (b - (1 - _bobotUas) * a) / _bobotUas
          : null;
    });
  }

  @override
  void dispose() {
    _saatIni.dispose();
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
          helper: 'Rata-rata UTS dan tugas. Bobot UAS 40%.',
          error: _errSaatIni,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Target nilai akhir',
          controller: _target,
          keyboardType: TextInputType.number,
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
                Text(_hasil!.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink)),
                if (_hasil! > 100) ...[
                  const SizedBox(height: 6),
                  const Text('Target ini sulit dicapai (butuh lebih dari 100).',
                      style: TextStyle(fontSize: 12, color: AppColors.danger)),
                ],
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
