import 'package:flutter/material.dart';

class TugasScreen extends StatefulWidget {
  final VoidCallback? onLihatEvaluasiAI;

  const TugasScreen({super.key, this.onLihatEvaluasiAI});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  static const _primary = Color(0xFF4F46E5);
  static const _dark = Color(0xFF0F172A);
  static const _grey = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  static const bool _tampilkanKosong = false;

  String _selectedFilter = 'Semua';

  static const List<String> _filters = [
    'Semua',
    'To-Do',
    'Terkumpul',
    'Terlewat',
  ];

  static const List<_Tugas> _semuaTugas = [
    _Tugas(
      title: 'Usability Test Report',
      course: 'Desain User Interface dan User Experience',
      deadline: 'Terlambat 2 hari',
      status: 'Terlewat',
    ),
    _Tugas(
      title: 'Tugas Aplikasi Mobile',
      course: 'Pemrograman Mobile',
      deadline: 'Besok, 23:59',
      status: 'To-Do',
    ),
    _Tugas(
      title: 'Laporan Praktikum Jaringan',
      course: 'Jaringan Komputer',
      deadline: 'Jumat, 17:00',
      status: 'To-Do',
    ),
    _Tugas(
      title: 'Quiz Framework Laravel',
      course: 'Pemrograman Web Framework',
      deadline: 'Senin, 10:00',
      status: 'To-Do',
    ),
    _Tugas(
      title: 'Prototype Hi-Fi',
      course: 'Desain User Interface dan User Experience',
      deadline: 'Terkumpul Selasa',
      status: 'Terkumpul',
    ),
  ];

  List<_Tugas> get _filtered {
    final all = _tampilkanKosong ? const <_Tugas>[] : _semuaTugas;
    if (_selectedFilter == 'Semua') return all;
    return all.where((t) => t.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
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
                    onPressed: () => Navigator.pop(context),
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
                          label: _filters[i],
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
                child: items.isEmpty
                    ? _TugasKosong(onLihatEvaluasiAI: widget.onLihatEvaluasiAI)
                    : SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _border),
                          ),
                          child: Column(
                            children: [
                              for (int i = 0; i < items.length; i++) ...[
                                _TugasItem(tugas: items[i]),
                                if (i != items.length - 1)
                                  const Divider(height: 1, color: _border),
                              ],
                            ],
                          ),
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

// ---------------------------------------------------------------
// Data tugas
// ---------------------------------------------------------------
class _Tugas {
  final String title;
  final String course;
  final String deadline;
  final String status; // 'To-Do', 'Terkumpul', atau 'Terlewat'

  const _Tugas({
    required this.title,
    required this.course,
    required this.deadline,
    required this.status,
  });
}

// ---------------------------------------------------------------
// Satu baris tugas
// ---------------------------------------------------------------
class _TugasItem extends StatelessWidget {
  final _Tugas tugas;

  const _TugasItem({required this.tugas});

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

    return Padding(
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
                  '${tugas.course} · ${tugas.deadline}',
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
      behavior: HitTestBehavior.opaque, // <-- tambahan 1
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // <-- tambahan 2: ganti Colors.transparent
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
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color:
                active ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
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