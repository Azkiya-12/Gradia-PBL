import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../services/ai_service.dart';
import '../../services/realtime_service.dart';
import '../../models/user_model.dart';
import '../../models/dashboard_model.dart';
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
  DashboardData? _dashboardData;
  int _unreadNotifCount = 0;
  String? _aiInsightText;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<RealtimeEvent>? _realtimeSub;

  @override
  void initState() {
    super.initState();
    _loadAll();
    RealtimeService.connect();
    _realtimeSub = RealtimeService.events.listen((event) {
      if (event.event != 'connected') {
        _loadAll();
      }
    });
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }

  Future<void> _loadAll() async {
    final cached = await AuthService.getUser();
    if (mounted && cached != null) setState(() => _user = cached);

    try {
      final futures = await Future.wait([
        AuthService.fetchProfile(),
        AuthService.fetchDashboardData(),
      ]);
      if (mounted) {
        setState(() {
          _user = futures[0] as UserModel;
          _dashboardData = futures[1] as DashboardData;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }

    try {
      final notifRes = await NotificationService.getNotifications();
      if (mounted) {
        setState(() => _unreadNotifCount = notifRes.unreadCount);
      }
    } catch (_) {}

    try {
      final feedbacks = await AiService.getSavedAiFeedbacks(forceRefresh: true);
      if (mounted) {
        setState(() {
          _aiInsightText =
              feedbacks.isNotEmpty ? feedbacks.first.aiFeedback : null;
        });
      }
    } catch (_) {}
  }

  String _resolveAiInsightText() {
    if (_aiInsightText != null && _aiInsightText!.trim().isNotEmpty) {
      return _aiInsightText!;
    }
    final data = _dashboardData;
    if (data == null) {
      return 'Performa akademikmu meningkat dibandingkan semester sebelumnya.';
    }
    final ipk = data.stats.ipk.toStringAsFixed(2);
    final att = data.stats.attendancePercentage;
    if (att < 75) {
      return 'IPK semester $ipk dengan kehadiran $att%. Tingkatkan kehadiran kelas agar capaian akademikmu tetap optimal.';
    }
    if (data.stats.ipk >= 3.5 && att >= 80) {
      return 'IPK semester $ipk dan kehadiran $att% terjaga sangat baik. Pertahankan konsistensi belajarmu.';
    }
    return 'IPK semester saat ini $ipk dengan kehadiran $att%. Pantau terus evaluasi dan target nilaimu.';
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _user?.namaPanggilan ?? 'Mahasiswa';
    final inisial = _user?.inisial ?? 'M';
    final ipkVal = _dashboardData != null
        ? _dashboardData!.stats.ipk.toStringAsFixed(2)
        : '-';
    final attendanceVal = _dashboardData != null
        ? '${_dashboardData!.stats.attendancePercentage}%'
        : '-';
    final terlewatVal = _dashboardData != null
        ? '${_dashboardData!.stats.taskStats.terlewat}'
        : '-';
    final mendatangVal = _dashboardData != null
        ? '${_dashboardData!.stats.taskStats.mendatang}'
        : '-';
    final terkumpulVal = _dashboardData != null
        ? '${_dashboardData!.stats.taskStats.terkumpul}'
        : '-';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAll,
          color: const Color(0xFF4F46E5),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifikasiScreen(),
                        ),
                      );
                      _loadAll();
                    },
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          size: 26,
                          color: Color(0xFF0F172A),
                        ),
                        if (_unreadNotifCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFDC2626),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 17),

              GestureDetector(
                onTap: () => widget.onTabChange?.call(2),
                child: Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Insight',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _resolveAiInsightText(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
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
              ),

              const SizedBox(height: 24),

              _SectionHeader(
                title: 'Ringkasan nilai',
                action: 'Lihat semua',
                onTap: () => widget.onTabChange?.call(1),
              ),

              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _StatCard(label: 'IPK semester', value: ipkVal),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(label: 'Kehadiran', value: attendanceVal),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _SectionHeader(
                title: 'Absensi',
                action: 'Lihat semua',
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AbsensiScreen(),
                    ),
                  );
                  if (mounted) _loadAll();
                },
              ),

              const SizedBox(height: 12),

              AbsensiCard(
                activeSession: _dashboardData?.activeSession,
                onAttendanceChanged: _loadAll,
              ),

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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _TaskStatusCard(
                      label: 'Terlewat',
                      value: terlewatVal,
                      valueColor: const Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TaskStatusCard(
                      label: 'Mendatang',
                      value: mendatangVal,
                      valueColor: const Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TaskStatusCard(
                      label: 'Terkumpul',
                      value: terkumpulVal,
                      valueColor: const Color(0xFF059669),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _SectionHeader(
                title: 'Tugas dan tenggat',
                action: 'Lihat semua',
                onTap: () async {
                  await Navigator.push(
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
                  if (mounted) _loadAll();
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
                child: _buildUpcomingTasks(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildUpcomingTasks() {
    final list = _dashboardData?.upcomingAssignments;

    if (list != null && list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            'Semua tugas beres!',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (list != null && list.isNotEmpty) {
      return Column(
        children: [
          for (int i = 0; i < list.length; i++) ...[
            _AssignmentItem(
              title: list[i].title,
              subtitle: list[i].course,
              deadline: list[i].formattedDeadline,
              status: list[i].status == 'To-Do' ? 'Segera' : list[i].status,
              statusColor: list[i].status == 'Terlewat'
                  ? const Color(0xFFDC2626)
                  : (list[i].status == 'Terkumpul'
                      ? const Color(0xFF059669)
                      : const Color(0xFFB45309)),
              statusBackground: list[i].status == 'Terlewat'
                  ? const Color(0xFFFEE2E2)
                  : (list[i].status == 'Terkumpul'
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFFEF3C7)),
              onTap: () async {
                await Navigator.push(
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
                if (mounted) _loadAll();
              },
            ),
            if (i != list.length - 1)
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
          ],
        ],
      );
    }

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Color(0xFF4F46E5),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          _errorMessage != null
              ? 'Gagal memuat daftar tugas dari server.'
              : 'Belum ada tugas.',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
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
  final VoidCallback? onTap;

  const _AssignmentItem({
    required this.title,
    required this.subtitle,
    required this.deadline,
    required this.status,
    required this.statusColor,
    required this.statusBackground,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
      ),
    );
  }
}