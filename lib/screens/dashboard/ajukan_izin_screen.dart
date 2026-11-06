import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class IzinColors {
  static const primary = Color(0xFF5048E5);
  static const primarySoft = Color(0xFFEEF1FF);
  static const primaryBorder = Color(0xFFC7CCF5);
  static const text = Color(0xFF1F2430);
  static const muted = Color(0xFF6B7280);
  static const fieldBg = Color(0xFFF8F9FB);
  static const fieldBorder = Color(0xFFE5E7EB);
}

/// Mengembalikan `true` lewat Navigator.pop jika izin berhasil dikirim.
class AjukanIzinScreen extends StatefulWidget {
  const AjukanIzinScreen({
    super.key,
    this.namaMatkul = 'Pemrograman Mobile',
    this.ruangJam = 'Ruang B.2.1 · 10:00–11:40',
  });

  final String namaMatkul;
  final String ruangJam;

  @override
  State<AjukanIzinScreen> createState() => _AjukanIzinScreenState();
}

class _AjukanIzinScreenState extends State<AjukanIzinScreen> {
  static const _maxBytes = 5 * 1024 * 1024;
  static const _allowedExt = ['pdf', 'jpg', 'jpeg', 'png'];

  final _alasanController = TextEditingController();

  String? _fileName;
  int? _fileSize;
  bool _dragging = false;

  @override
  void dispose() {
    _alasanController.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  String _formatSize(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Validasi lalu simpan file terpilih (dari picker maupun drag & drop).
  void _setFile(String name, int size) {
    final ext = name.split('.').last.toLowerCase();
    if (!_allowedExt.contains(ext)) {
      _toast('Format file harus PDF, JPG, atau PNG.');
      return;
    }
    if (size > _maxBytes) {
      _toast('Ukuran file maksimal 5 MB.');
      return;
    }
    setState(() {
      _fileName = name;
      _fileSize = size;
    });
  }

  Future<void> _pilihFile() async {
    final f = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: _allowedExt,
    );
    if (f == null) return; // pengguna batal
    final size = f.lengthSync() ?? await f.length() ?? 0;
    _setFile(f.name, size);
  }

  Future<void> _onDrop(DropDoneDetails detail) async {
    setState(() => _dragging = false);
    if (detail.files.isEmpty) return;
    final f = detail.files.first;
    _setFile(f.name, await f.length());
  }

  void _hapusFile() => setState(() {
        _fileName = null;
        _fileSize = null;
      });

  void _kirimIzin() {
    if (_alasanController.text.trim().isEmpty) {
      _toast('Alasan izin wajib diisi.');
      return;
    }
    if (_fileName == null) {
      _toast('Lampiran wajib diisi.');
      return;
    }
    // TODO: kirim ke backend (alasan + file), baru tutup layar.
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context, false),
                    child: const Icon(Icons.chevron_left,
                        size: 30, color: IzinColors.text),
                  ),
                  const SizedBox(width: 14),
                  const Text('Ajukan izin',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: IzinColors.text)),
                ],
              ),
              const SizedBox(height: 24),
              _buildSesiCard(),
              const SizedBox(height: 16),
              _label('Alasan izin'),
              const SizedBox(height: 6),
              _buildAlasanField(),
              const SizedBox(height: 16),
              _label('Lampiran bukti'),
              const SizedBox(height: 6),
              _buildUploadBox(),
              const SizedBox(height: 6),
              const Text('PDF, JPG, atau PNG. Maksimal 5 MB.',
                  style: TextStyle(fontSize: 12, color: IzinColors.muted)),
              const SizedBox(height: 10),
              if (_fileName != null) _buildFileItem(),
              const SizedBox(height: 4),
              const Text('Lampiran wajib untuk izin supaya bisa diperiksa dosen.',
                  style: TextStyle(fontSize: 12, color: IzinColors.muted)),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _kirimIzin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IzinColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Kirim izin',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSesiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: IzinColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sesi absensi',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDCDDFB))),
          const SizedBox(height: 4),
          Text(widget.namaMatkul,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 2),
          Text(widget.ruangJam,
              style: const TextStyle(fontSize: 13, color: Color(0xFFE6E7FD))),
        ],
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, color: IzinColors.text));

  Widget _buildAlasanField() {
    return TextField(
      controller: _alasanController,
      maxLines: 4,
      minLines: 4,
      style: const TextStyle(fontSize: 15, color: IzinColors.text),
      decoration: InputDecoration(
        filled: true,
        fillColor: IzinColors.fieldBg,
        contentPadding: const EdgeInsets.all(14),
        hintText: 'Tulis alasan izin',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: IzinColors.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: IzinColors.primary),
        ),
      ),
    );
  }

  /// Kotak upload: bisa di-tap (file picker) atau drag & drop (web/desktop).
  Widget _buildUploadBox() {
    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: _onDrop,
      child: InkWell(
        onTap: _pilihFile,
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: _dragging ? IzinColors.primary : IzinColors.primaryBorder,
            radius: 16,
          ),
          child: Container(
            height: 90,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _dragging
                  ? IzinColors.primary.withOpacity(0.12)
                  : IzinColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _dragging ? 'Lepaskan file di sini' : 'Pilih file',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: IzinColors.primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileItem() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IzinColors.fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_fileName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: IzinColors.text)),
                const SizedBox(height: 2),
                Text(_formatSize(_fileSize ?? 0),
                    style:
                        const TextStyle(fontSize: 12, color: IzinColors.muted)),
              ],
            ),
          ),
          InkWell(
            onTap: _hapusFile,
            customBorder: const CircleBorder(),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                  color: Color(0xFFF1F2F5), shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 15, color: IzinColors.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, Radius.circular(radius)));
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 6), paint);
        d += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}