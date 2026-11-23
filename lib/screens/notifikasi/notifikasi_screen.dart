import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/common.dart';
import 'pengaturan_notifikasi_screen.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  int _tab = 0;
  bool _isLoading = true;
  String? _errorMessage;
  int _unreadCount = 0;
  List<NotificationItem> _notifications = [];

  static const _categories = ['all', 'nilai', 'pengumuman', 'reminder'];
  static const _tabTitles = ['Semua', 'Nilai', 'Pengumuman', 'Pengingat'];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final category = _categories[_tab];
      final res = await NotificationService.getNotifications(
        category: category == 'all' ? null : category,
      );

      if (!mounted) return;
      setState(() {
        _notifications = res.notifications;
        _unreadCount = res.unreadCount;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await NotificationService.markAllAsRead();
      if (!mounted) return;
      setState(() {
        _notifications = _notifications
            .map((n) => NotificationItem(
                  id: n.id,
                  category: n.category,
                  title: n.title,
                  message: n.message,
                  isRead: true,
                  createdAt: n.createdAt,
                ))
            .toList();
        _unreadCount = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua notifikasi ditandai dibaca')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui notifikasi: $e')),
      );
    }
  }

  Future<void> _markOneAsRead(NotificationItem n) async {
    if (n.isRead) return;
    try {
      await NotificationService.markAsRead(n.id);
      if (!mounted) return;
      setState(() {
        final idx = _notifications.indexWhere((item) => item.id == n.id);
        if (idx != -1) {
          _notifications[idx] = NotificationItem(
            id: n.id,
            category: n.category,
            title: n.title,
            message: n.message,
            isRead: true,
            createdAt: n.createdAt,
          );
          if (_unreadCount > 0) _unreadCount--;
        }
      });
    } catch (_) {}
  }

  void _onTabChanged(int i) {
    if (_tab == i) return;
    setState(() => _tab = i);
    _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 18, color: AppColors.ink),
                  ),
                  const Expanded(
                    child: Text(
                      'Notifikasi',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Pengaturan Notifikasi',
                    onPressed: () => push(context, const PengaturanNotifikasiScreen()),
                    icon: const Icon(Icons.tune_rounded, size: 22, color: AppColors.ink),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchNotifications,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PillTabs(
                        tabs: _tabTitles,
                        index: _tab,
                        onChanged: _onTabChanged,
                      ),
                      const SizedBox(height: 14),

                      // Bar aksi jika ada yang belum dibaca
                      if (_unreadCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$_unreadCount belum dibaca',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              GestureDetector(
                                onTap: _markAllAsRead,
                                child: const Text(
                                  'Tandai semua dibaca',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        )
                      else if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Center(
                            child: Column(
                              children: [
                                const Icon(Icons.error_outline, size: 40, color: AppColors.danger),
                                const SizedBox(height: 10),
                                Text(_errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: AppColors.muted)),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchNotifications,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (_notifications.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: EmptyState(
                            icon: Icons.notifications_none,
                            title: 'Belum ada notifikasi',
                            message:
                                'Kabar nilai, pengumuman kampus, dan pengingat tugas akan muncul di sini.',
                            primaryLabel: 'Atur notifikasi',
                            onPrimary: () =>
                                push(context, const PengaturanNotifikasiScreen()),
                          ),
                        )
                      else
                        AppCard(
                          child: Column(
                            children: divide([
                              for (final n in _notifications)
                                _NotifRow(
                                  n: n,
                                  onTap: () => _markOneAsRead(n),
                                ),
                            ]),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  final NotificationItem n;
  final VoidCallback onTap;

  const _NotifRow({required this.n, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: n.isRead ? Colors.transparent : const Color(0xFFF8FAFC),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconBox(n.icon),
                if (!n.isRead)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w700,
                            color: n.isRead ? const Color(0xFF334155) : AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    n.message,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: n.isRead ? AppColors.muted : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              n.formattedTime,
              style: TextStyle(
                fontSize: 11,
                fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600,
                color: n.isRead ? AppColors.muted : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
