import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Pindah ke screen lain (shortcut Navigator.push).
void push(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

void showSnack(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );

/// Sisipkan Divider di antara widget (untuk list di dalam card).
List<Widget> divide(List<Widget> items) {
  final out = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    if (i > 0) out.add(const Divider(height: 1, color: AppColors.border));
    out.add(items[i]);
  }
  return out;
}

class GradiaLogo extends StatelessWidget {
  final double size;
  const GradiaLogo({super.key, this.size = 62});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.violet],
        ),
      ),
      child: const Text('G',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
    );
  }
}

/// Kerangka screen dengan tombol back + judul (dipakai hampir semua sub-screen).
class SubScreen extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets padding;
  const SubScreen({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 16, 20, 24),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 18, color: AppColors.ink),
                  ),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(padding: padding, child: child),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink));
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color color;
  const AppCard(
      {super.key,
      required this.child,
      this.padding,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

/// Kotak teks abu-abu muda (kesimpulan, komentar dosen, dll).
class InfoCard extends StatelessWidget {
  final String text;
  const InfoCard(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(16),
      child: Text(text,
          style: const TextStyle(
              fontSize: 14, height: 1.45, color: AppColors.ink)),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const StatusChip(this.text, this.bg, this.fg, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text,
          style:
              TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;

  /// Isi null untuk tampilan nonaktif.
  final VoidCallback? onPressed;
  const PrimaryButton(this.label, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.hint,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        child: Text(label),
      ),
    );
  }
}

/// Tombol sekunder (outline biru).
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const SecondaryButton(this.label, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.secondaryBorder),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        child: Text(label),
      ),
    );
  }
}

/// Tombol destruktif (outline merah), misalnya "Keluar".
class DestructiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const DestructiveButton(this.label, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          side: const BorderSide(color: AppColors.dangerBorder),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        child: Text(label),
      ),
    );
  }
}

/// Baris pesan error kecil (ikon + teks merah) di bawah input.
class FieldError extends StatelessWidget {
  final String text;
  const FieldError(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(Icons.error_outline, size: 14, color: AppColors.danger),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 12, height: 1.4, color: AppColors.danger)),
        ),
      ],
    );
  }
}

/// Banner error di atas form (contoh: login gagal).
class FormBanner extends StatelessWidget {
  final String title;
  final String message;
  const FormBanner({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dangerSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dangerBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline,
              size: 18, color: AppColors.dangerDark),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dangerDark)),
                const SizedBox(height: 2),
                Text(message,
                    style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.dangerDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscure;
  final bool readOnly;
  final String? helper;

  /// Pesan error. Kalau diisi, input jadi merah dan pesan tampil di bawahnya.
  final String? error;

  /// Merah tanpa pesan di bawah input (dipakai saat pesannya ada di banner).
  final bool invalid;
  final int maxLines;
  final TextInputType? keyboardType;
  const AppTextField({
    super.key,
    required this.label,
    this.hint = '',
    this.controller,
    this.obscure = false,
    this.readOnly = false,
    this.helper,
    this.error,
    this.invalid = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c),
      );

  @override
  Widget build(BuildContext context) {
    final hasError = error != null || invalid;
    final line = hasError ? AppColors.danger : AppColors.border;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          readOnly: readOnly,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
              fontSize: 14, color: readOnly ? AppColors.muted : AppColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.hint),
            filled: true,
            fillColor: hasError
                ? AppColors.dangerSoft
                : (readOnly ? AppColors.slate100 : AppColors.surface),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            border: _border(line),
            enabledBorder: _border(line),
            focusedBorder:
                _border(hasError ? AppColors.danger : AppColors.primary),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          FieldError(error!),
        ] else if (helper != null) ...[
          const SizedBox(height: 6),
          Text(helper!,
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
        ],
      ],
    );
  }
}

/// Tab berbentuk pil (Semua / Terlewat / ...).
class PillTabs extends StatelessWidget {
  final List<String> tabs;
  final int index;
  final ValueChanged<int> onChanged;
  const PillTabs(
      {super.key,
      required this.tabs,
      required this.index,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == index ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: i == index
                        ? const [
                            BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 4,
                                offset: Offset(0, 1))
                          ]
                        : null,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(tabs[i],
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: i == index
                                ? AppColors.primary
                                : AppColors.muted)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Kotak ikon kecil (dipakai di notifikasi & evaluasi AI).
class IconBox extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final double size;
  const IconBox(this.icon,
      {super.key,
      this.bg = AppColors.primarySoft,
      this.fg = AppColors.primary,
      this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: fg, size: 20),
    );
  }
}

/// Grafik garis "IPS per semester" (data dummy: 3.1 -> 3.7).
class LineChartCard extends StatelessWidget {
  const LineChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2.2,
            child: CustomPaint(painter: _LinePainter(), size: Size.infinite),
          ),
          const SizedBox(height: 12),
          const Text('Perkembangan Nilai menaik dari 3.1 ke 3.7',
              style: TextStyle(fontSize: 12, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  static const _pts = [
    Offset(10, 81.5),
    Offset(38, 60.5),
    Offset(66, 71),
    Offset(94, 39.5),
    Offset(122, 50),
    Offset(150, 29),
    Offset(178, 29),
    Offset(206, 18.5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 220;
    final sy = size.height / 100;
    final p = _pts.map((o) => Offset(o.dx * sx, o.dy * sy)).toList();

    final area = Path()..moveTo(p.first.dx, size.height);
    for (final o in p) {
      area.lineTo(o.dx, o.dy);
    }
    area
      ..lineTo(p.last.dx, size.height)
      ..close();
    canvas.drawPath(area, Paint()..color = AppColors.primarySoft);

    final line = Path()..moveTo(p.first.dx, p.first.dy);
    for (final o in p.skip(1)) {
      line.lineTo(o.dx, o.dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );

    for (final o in p) {
      canvas.drawCircle(o, 4.5, Paint()..color = Colors.white);
      canvas.drawCircle(
        o,
        4.5,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Tampilan kosong (belum ada data) dengan ikon, teks, dan tombol.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 110, 18, 0),
      child: Column(
        children: [
          Container(
            width: 108,
            height: 108,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.primarySoft),
            child: Icon(icon, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink)),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, height: 1.45, color: AppColors.muted)),
          const SizedBox(height: 24),
          PrimaryButton(primaryLabel, onPressed: onPrimary),
          if (secondaryLabel != null) ...[
            const SizedBox(height: 18),
            GestureDetector(
              onTap: onSecondary,
              child: Text(secondaryLabel!,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted)),
            ),
          ],
        ],
      ),
    );
  }
}
