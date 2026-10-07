import 'package:flutter/material.dart';

class AjukanReviewScreen extends StatefulWidget {
  /// Judul soal yang ditinjau, contoh: "Soal 2 · Prinsip Gestalt"
  final String soal;

  /// Nilai saat ini, contoh: "4 / 5"
  final String nilaiSekarang;

  const AjukanReviewScreen({
    super.key,
    required this.soal,
    required this.nilaiSekarang,
  });

  @override
  State<AjukanReviewScreen> createState() => _AjukanReviewScreenState();
}

class _AjukanReviewScreenState extends State<AjukanReviewScreen> {
  static const _primary = Color(0xFF4F46E5);
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _errorRed = Color(0xFFDC2626);
  static const _errorBg = Color(0xFFFEF2F2);

  final _alasanController = TextEditingController();
  bool _hasError = false;

  @override
  void dispose() {
    _alasanController.dispose();
    super.dispose();
  }

  void _kirim() {
    if (_alasanController.text.trim().isEmpty) {
      setState(() => _hasError = true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permintaan koreksi terkirim')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _hasError ? _errorRed : _border;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    'Ajukan koreksi nilai',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _dark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Kartu soal yang ditinjau
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Soal yang ditinjau',
                      style: TextStyle(fontSize: 12, color: _grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.soal,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Nilai sekarang ${widget.nilaiSekarang}',
                      style: const TextStyle(fontSize: 12, color: _grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Komentar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _dark,
                ),
              ),

              const SizedBox(height: 8),

              // Kolom alasan
              TextField(
                controller: _alasanController,
                minLines: 5,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onChanged: (_) {
                  if (_hasError) setState(() => _hasError = false);
                },
                style: const TextStyle(fontSize: 14, color: _dark),
                decoration: InputDecoration(
                  hintText: 'Jelaskan bagian jawaban yang menurutmu perlu dicek ulang oleh dosen',
                  hintStyle:
                      const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  filled: true,
                  fillColor: _hasError ? _errorBg : const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _hasError ? _errorRed : _primary,
                    ),
                  ),
                ),
              ),
                const SizedBox(height: 8),

                      const Text(
                        'Batas pengajuan 3 hari setelah nilai dirilis.',
                        style: TextStyle(fontSize: 12, color: _grey),
                      ),

              // Pesan error
              if (_hasError) ...[
                const SizedBox(height: 10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Icon(Icons.error_outline,
                          size: 16, color: _errorRed),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tulis alasan koreksi agar dosen tahu bagian yang '
                        'perlu ditinjau. Contoh: Common Region pada '
                        'kartu produk sudah sesuai definisi.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: _errorRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _kirim,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Kirim permintaan koreksi',
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