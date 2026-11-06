import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../widgets/common.dart';

/// Isi tab "Analisis AI" (dipakai di screen 11 dan screen 13).
class AnalisisAiContent extends StatelessWidget {
  const AnalisisAiContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle('Kesimpulan performa'),
        SizedBox(height: 12),
        InfoCard(
            'IPK naik konsisten enam semester terakhir dan kehadiran stabil di atas 90%. Nilai Pemrograman Mobile masih di bawah rata-rata kelasmu.'),
        SizedBox(height: 24),
        SectionTitle('Grafik IPK dan IPS per semester'),
        SizedBox(height: 12),
        _IpkIpsChartCard(),
        SizedBox(height: 24),
        SectionTitle('Terbaik dan perlu ditingkatkan'),
        SizedBox(height: 12),
        _BestWorst(),
      ],
    );
  }
}

// ---------------------------------------------------------------
// Grafik IPS (per semester) dan IPK (kumulatif)
// ---------------------------------------------------------------
class _IpkIpsChartCard extends StatelessWidget {
  const _IpkIpsChartCard();

  // Data contoh IPS enam semester. Nanti dari backend.
  static const List<double> _ips = [3.1, 3.3, 3.2, 3.5, 3.6, 3.7];

  /// IPK = rata-rata kumulatif IPS (dengan asumsi SKS tiap semester sama).
  List<double> get _ipk {
    final hasil = <double>[];
    var total = 0.0;
    for (var i = 0; i < _ips.length; i++) {
      total += _ips[i];
      hasil.add(total / (i + 1));
    }
    return hasil;
  }

  @override
  Widget build(BuildContext context) {
    final ipk = _ipk;
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _LegendItem('IPS (per semester)', AppColors.primary, false),
              _LegendItem('IPK (kumulatif)', AppColors.warning, true),
            ],
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 2.0,
            child: CustomPaint(
              painter: _IpkIpsPainter(_ips, ipk),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'IPS naik dari ${_ips.first.toStringAsFixed(1)} ke '
            '${_ips.last.toStringAsFixed(1)}, IPK naik dari '
            '${ipk.first.toStringAsFixed(1)} ke ${ipk.last.toStringAsFixed(1)}.',
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool putus;
  const _LegendItem(this.label, this.color, this.putus);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 4,
          child: putus
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Container(width: 5, height: 3, color: color),
                  ],
                )
              : Container(color: color),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
      ],
    );
  }
}

class _IpkIpsPainter extends CustomPainter {
  final List<double> ips;
  final List<double> ipk;
  _IpkIpsPainter(this.ips, this.ipk);

  static const double _min = 3.0;
  static const double _max = 3.8;

  void _teks(Canvas canvas, String t, Offset o) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: const TextStyle(fontSize: 10, color: AppColors.muted),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, o);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const kiri = 30.0, bawah = 22.0, atas = 8.0;
    final lebar = size.width - kiri - 8;
    final tinggi = size.height - bawah - atas;

    double xAt(int i) => kiri + 8 + (lebar - 16) * i / (ips.length - 1);
    double yAt(double v) => atas + tinggi * (1 - (v - _min) / (_max - _min));

    // Garis bantu dan label sumbu Y
    final grid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (var k = 0; k <= 4; k++) {
      final v = _min + 0.2 * k;
      final y = yAt(v);
      canvas.drawLine(Offset(kiri, y), Offset(size.width, y), grid);
      _teks(canvas, v.toStringAsFixed(1), Offset(0, y - 6));
    }

    // Label sumbu X
    for (var i = 0; i < ips.length; i++) {
      _teks(canvas, 'S${i + 1}', Offset(xAt(i) - 8, size.height - 14));
    }

    _garis(canvas, ipk, xAt, yAt, AppColors.warning, putus: true);
    _garis(canvas, ips, xAt, yAt, AppColors.primary, putus: false);
  }

  void _garis(
    Canvas canvas,
    List<double> data,
    double Function(int) xAt,
    double Function(double) yAt,
    Color warna, {
    required bool putus,
  }) {
    final path = Path()..moveTo(xAt(0), yAt(data[0]));
    for (var i = 1; i < data.length; i++) {
      path.lineTo(xAt(i), yAt(data[i]));
    }

    final cat = Paint()
      ..color = warna
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round;

    if (putus) {
      for (final m in path.computeMetrics()) {
        var d = 0.0;
        while (d < m.length) {
          canvas.drawPath(m.extractPath(d, d + 6), cat);
          d += 10;
        }
      }
    } else {
      canvas.drawPath(path, cat);
    }

    for (var i = 0; i < data.length; i++) {
      final p = Offset(xAt(i), yAt(data[i]));
      canvas.drawCircle(p, 4, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        4,
        Paint()
          ..color = warna
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------
// Terbaik dan perlu ditingkatkan (sekarang dengan penjelasan)
// ---------------------------------------------------------------
class _BestWorst extends StatelessWidget {
  const _BestWorst();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Expanded(
            child: _Box(
              label: 'Terbaik',
              name: 'Desain User Interface dan User Experience',
              description: 'Nilai 92 (A), tertinggi dan di atas rata-rata kelas.',
              bg: AppColors.successSoft,
              border: Color(0xFFA7F3D0),
              fg: AppColors.success,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _Box(
              label: 'Perlu ditingkatkan',
              name: 'Pemrograman Mobile',
              description:
                  'Nilai 78 (B), di bawah rata-rata kelas. Perbanyak latihan membuat aplikasi dan kumpulkan tugas praktik tepat waktu.',
              bg: AppColors.warningSoft,
              border: Color(0xFFFDE68A),
              fg: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final String label;
  final String name;
  final String description;
  final Color bg;
  final Color border;
  final Color fg;
  const _Box(
      {required this.label,
      required this.name,
      required this.description,
      required this.bg,
      required this.border,
      required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
          const SizedBox(height: 10),
          Text(name,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink)),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(
                  fontSize: 12, height: 1.45, color: Color(0xFF334155))),
        ],
      ),
    );
  }
}

/// Screen 13 - Analisis AI
class AnalisisAiScreen extends StatelessWidget {
  const AnalisisAiScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const SubScreen(title: 'Analisis AI', child: AnalisisAiContent());
}