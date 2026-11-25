import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../models/assignment_model.dart';
import '../../services/assignment_service.dart';
import '../../services/api_client.dart';

class TugasScreen extends StatefulWidget {
  final VoidCallback? onLihatEvaluasiAI;

  const TugasScreen({super.key, this.onLihatEvaluasiAI});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _primary = Color(0xFF4F46E5);

  String _selectedFilter = 'To-Do';

  static const List<String> _filters = [
    'To-Do',
    'Terkumpul',
    'Terlewat',
  ];

  AssignmentResponse? _data;
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasModified = false;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    try {
      final res = await AssignmentService.getAssignments();
      if (mounted) {
        setState(() {
          _data = res;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<AssignmentItemModel> get _filtered {
    if (_data == null) return const [];
    return _data!.assignments
        .where((t) => t.status == _selectedFilter)
        .toList();
  }

  String _filterLabel(String filter) {
    if (_data == null) return filter;
    switch (filter) {
      case 'To-Do':
        return 'To-Do (${_data!.counts.todo})';
      case 'Terkumpul':
        return 'Terkumpul (${_data!.counts.terkumpul})';
      case 'Terlewat':
        return 'Terlewat (${_data!.counts.terlewat})';
      default:
        return filter;
    }
  }

  void _openDetail(AssignmentItemModel tugas) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DetailTugasSheet(
        tugas: tugas,
        onSubmitted: () {
          _hasModified = true;
          _loadAssignments();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        // Return modified state when back button is tapped
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context, _hasModified),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 28,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tugas dan tenggat',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Tab filter
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    children: [
                      for (int i = 0; i < _filters.length; i++) ...[
                        if (i != 0) const SizedBox(width: 4),
                        Expanded(
                          child: _FilterTab(
                            label: _filterLabel(_filters[i]),
                            active: _filters[i] == _selectedFilter,
                            onTap: () {
                              setState(() => _selectedFilter = _filters[i]);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: _primary),
                        )
                      : _errorMessage != null && _data == null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.error_outline_rounded,
                                        size: 40, color: Color(0xFFDC2626)),
                                    const SizedBox(height: 12),
                                    Text(_errorMessage!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: _grey, fontSize: 13)),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _loadAssignments,
                                      child: const Text('Coba lagi'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                      : RefreshIndicator(
                          onRefresh: _loadAssignments,
                          color: _primary,
                          child: items.isEmpty
                              ? SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.55,
                                    child: _selectedFilter == 'To-Do'
                                        ? _TugasKosong(
                                            onLihatEvaluasiAI:
                                                widget.onLihatEvaluasiAI,
                                          )
                                        : const Center(
                                            child: Text(
                                              'Belum ada tugas di kategori ini.',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: _grey,
                                              ),
                                            ),
                                          ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: _border),
                                    ),
                                    child: Column(
                                      children: [
                                        for (int i = 0;
                                            i < items.length;
                                            i++) ...[
                                          _TugasItem(
                                            tugas: items[i],
                                            onTap: () =>
                                                _openDetail(items[i]),
                                          ),
                                          if (i != items.length - 1)
                                            const Divider(
                                                height: 1, color: _border),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Satu baris tugas
// ---------------------------------------------------------------
class _TugasItem extends StatelessWidget {
  final AssignmentItemModel tugas;
  final VoidCallback onTap;

  const _TugasItem({
    required this.tugas,
    required this.onTap,
  });

  // [warna teks, warna latar] chip status
  List<Color> get _statusColors {
    switch (tugas.status) {
      case 'Terlewat':
        return const [Color(0xFFDC2626), Color(0xFFFEF2F2)];
      case 'Terkumpul':
        return const [Color(0xFF059669), Color(0xFFECFDF5)];
      default: // To-Do
        return const [Color(0xFFB45309), Color(0xFFFFFBEB)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tugas.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${tugas.course} · ${tugas.formattedDeadline}',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.45,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: colors[1],
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                tugas.status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors[0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.white : const Color(0x00FFFFFF),
          borderRadius: BorderRadius.circular(10),
          boxShadow: active
              ? const [
                  BoxShadow(
                    color: Color(0x1A0F172A),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ]
              : const [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _TugasKosong extends StatelessWidget {
  final VoidCallback? onLihatEvaluasiAI;

  const _TugasKosong({this.onLihatEvaluasiAI});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 52,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Semua tugas beres',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Tidak ada tugas yang menunggu. Pakai waktumu untuk '
                'mengulang materi atau cek Evaluasi AI.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onLihatEvaluasiAI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Lihat Evaluasi AI',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Modal Detail & Pengumpulan Tugas Mahasiswa
// ---------------------------------------------------------------
class _DetailTugasSheet extends StatefulWidget {
  final AssignmentItemModel tugas;
  final VoidCallback onSubmitted;

  const _DetailTugasSheet({
    required this.tugas,
    required this.onSubmitted,
  });

  @override
  State<_DetailTugasSheet> createState() => _DetailTugasSheetState();
}

class _DetailTugasSheetState extends State<_DetailTugasSheet> {
  static const _primary = Color(0xFF4F46E5);
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  final _urlController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedFileName;
  bool _isSubmitting = false;
  bool _isFormOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.tugas.fileUrl != null) {
      _urlController.text = widget.tugas.fileUrl!;
    }
    if (widget.tugas.notes != null) {
      _notesController.text = widget.tugas.notes!;
    }
    // Jika belum terkumpul, otomatis tampilkan form input
    if (widget.tugas.status != 'Terkumpul') {
      _isFormOpen = true;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'zip', 'rar', 'doc', 'docx', 'png', 'jpg'],
    );
    if (files.isEmpty) return;
    setState(() {
      _selectedFileName = files.first.name;
    });
  }

  Future<void> _submit() async {
    final link = _urlController.text.trim();
    final file = _selectedFileName;
    final notes = _notesController.text.trim();

    if (link.isEmpty && file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan tautan tugas atau unggah dokumen lampiran.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final fileOrUrl = file != null && file.isNotEmpty
          ? (link.isNotEmpty ? '$link ($file)' : file)
          : link;

      await AssignmentService.submitAssignment(
        assignmentId: widget.tugas.id,
        fileUrl: fileOrUrl,
        notes: notes,
      );

      if (!mounted) return;
      Navigator.pop(context);
      widget.onSubmitted();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas berhasil dikumpulkan.'),
          backgroundColor: Color(0xFF059669),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengumpulkan tugas: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tugas;
    final isTerkumpul = t.status == 'Terkumpul';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Top row: Course & Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.course,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _primary,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isTerkumpul
                        ? const Color(0xFFECFDF5)
                        : (t.status == 'Terlewat'
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFFFFBEB)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    t.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isTerkumpul
                          ? const Color(0xFF059669)
                          : (t.status == 'Terlewat'
                              ? const Color(0xFFDC2626)
                              : const Color(0xFFB45309)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Title
            Text(
              t.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _dark,
              ),
            ),
            const SizedBox(height: 10),

            // Deadline info
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 16, color: _grey),
                const SizedBox(width: 6),
                Text(
                  'Tenggat: ${t.formattedDeadline}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: _border),
            const SizedBox(height: 12),

            // Deskripsi tugas
            const Text(
              'Deskripsi Tugas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _dark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t.description.isNotEmpty
                  ? t.description
                  : 'Tidak ada petunjuk deskripsi tambahan dari dosen.',
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF334155),
              ),
            ),

            const SizedBox(height: 20),

            // Tampilan info jika sudah terkumpul
            if (isTerkumpul && !_isFormOpen) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            size: 18, color: Color(0xFF059669)),
                        const SizedBox(width: 8),
                        const Text(
                          'Tugas sudah terkumpul',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF059669),
                          ),
                        ),
                        const Spacer(),
                        if (t.score != null)
                          Text(
                            'Nilai: ${t.score!.toStringAsFixed(0)} / 100',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _primary,
                            ),
                          ),
                      ],
                    ),
                    if (t.fileUrl != null && t.fileUrl!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Berkas / Link: ${t.fileUrl}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (t.notes != null && t.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Catatan: ${t.notes}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: _grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: () => setState(() => _isFormOpen = true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primary,
                    side: const BorderSide(color: _primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Kumpulkan Ulang',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],

            // Form Pengumpulan
            if (_isFormOpen) ...[
              const Text(
                'Pengumpulan Tugas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 10),

              // Input Tautan
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'Tautan Tugas (Google Drive / GitHub / Figma)',
                  hintText: 'https://...',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _primary),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Upload File Box
              InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file_rounded,
                          size: 20, color: _primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedFileName ??
                              'Pilih berkas dokumen (PDF, ZIP, DOCX)',
                          style: TextStyle(
                            fontSize: 13,
                            color: _selectedFileName != null
                                ? _dark
                                : _grey,
                            fontWeight: _selectedFileName != null
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_selectedFileName != null)
                        InkWell(
                          onTap: () =>
                              setState(() => _selectedFileName = null),
                          child: const Icon(Icons.close_rounded,
                              size: 18, color: _grey),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Catatan
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Catatan untuk Dosen (opsional)',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _primary),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _primary.withValues(alpha: 0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Kumpulkan Tugas',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
