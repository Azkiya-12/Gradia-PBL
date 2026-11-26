import 'package:flutter/material.dart';
import '../../services/grade_service.dart';
import '../../services/api_client.dart';

class AjukanReviewScreen extends StatefulWidget {
  final int classId;

  /// Judul soal atau komponen yang ditinjau, contoh: "Soal 2 · Prinsip Gestalt"
  final String soal;

  /// Nilai saat ini, contoh: "4 / 5" atau "88 / 100"
  final String nilaiSekarang;

  const AjukanReviewScreen({
    super.key,
    this.classId = 5,
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
  bool _isLoading = false;

  @override
  void dispose() {
    _alasanController.dispose();
    super.dispose();
  }

  Future<void> _kirim() async {
    if (_isLoading) return;

    if (_alasanController.text.trim().length < 5) {
      setState(() => _hasError = true);
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      await GradeService.submitGradeReview(
        classId: widget.classId,
        component: widget.soal,
        currentScore: widget.nilaiSekarang,
        reason: _alasanController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF16A34A),
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text('Permintaan koreksi nilai berhasil diajukan ke dosen.'),
              ),
            ],
          ),
        ),
      );
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _errorRed,
            content: Text(e.message),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _errorRed,
            content: Text('Gagal mengirim review nilai: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                  onPressed: _isLoading ? null : _kirim,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _primary.withValues(alpha: 0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Kirim permintaan koreksi',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
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