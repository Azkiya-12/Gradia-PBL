import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../notifikasi/notifikasi_screen.dart';
import '../akademik/tugas_screen.dart';
import 'absensi_card.dart' show AbsensiCard;
import '../akademik/absensi_screen.dart' show AbsensiScreen;

class DashboardScreen extends StatefulWidget {
  final ValueChanged<int>? onTabChange;

  const DashboardScreen({super.key, this.onTabChange});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final cached = await AuthService.getUser();
    if (mounted) setState(() => _user = cached);

    try {
      final fresh = await AuthService.fetchProfile();
      if (mounted) setState(() => _user = fresh);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _user?.namaPanggilan ?? 'Sinta';
    final inisial = _user?.inisial ?? 'SP';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6366F1), Color(0xFFA78BFA)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        inisial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Halo,',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifikasiScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 26,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 17),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Insight',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Performa akademikmu meningkat dibandingkan semester sebelumnya.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Lihat selengkapnya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _SectionHeader(
                title: 'Ringkasan nilai',
                action: 'Lihat semua',
                onTap: () => widget.onTabChange?.call(1),
              ),

              const SizedBox(height: 12),

              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _StatCard(label: 'IPK semester', value: '3.7'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(label: 'Kehadiran', value: '92%'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _SectionHeader(
                title: 'Absensi',
                action: 'Lihat semua',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AbsensiScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              const AbsensiCard(),

              const SizedBox(height: 24),

              const Text(
                'Status tugas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 12),

              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _TaskStatusCard(
                      label: 'Terlewat',
                      value: '1',
                      valueColor: Color(0xFFDC2626),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _TaskStatusCard(
                      label: 'Mendatang',
                      value: '3',
                      valueColor: Color(0xFF4F46E5),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _TaskStatusCard(
                      label: 'Terkumpul',
                      value: '1',
                      valueColor: Color(0xFF059669),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _SectionHeader(
                title: 'Tugas dan tenggat',
                action: 'Lihat semua',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TugasScreen(
                        onLihatEvaluasiAI: () {
                          Navigator.pop(context);
                          widget.onTabChange?.call(2);
                        },
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    _AssignmentItem(
                      title: 'Usability Test Report',
                      subtitle: 'Desain User Interface dan User Experience',
                      deadline: 'Terlambat 2 hari',
                      status: 'Terlewat',
                      statusColor: Color(0xFFDC2626),
                      statusBackground: Color(0xFFFEE2E2),
                    ),
                    Divider(height: 1, color: Color(0xFFE2E8F0)),
                    _AssignmentItem(
                      title: 'Tugas Aplikasi Mobile',
                      subtitle: 'Pemrograman Mobile',
                      deadline: 'Besok, 23:59',
                      status: 'Segera',
                      statusColor: Color(0xFFB45309),
                      statusBackground: Color(0xFFFEF3C7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4F46E5),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskStatusCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _TaskStatusCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: valueColor,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String deadline;
  final String status;
  final Color statusColor;
  final Color statusBackground;

  const _AssignmentItem({
    required this.title,
    required this.subtitle,
    required this.deadline,
    required this.status,
    required this.statusColor,
    required this.statusBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 2),

                // Di desain subtitle dan tenggat satu teks yang mengalir
                Text(
                  '$subtitle · $deadline',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBackground,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}