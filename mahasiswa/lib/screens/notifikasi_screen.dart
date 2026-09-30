import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _selectedFilter = 'Semua';

  static const List<String> _filters = ['Semua', 'Nilai', 'Pengumuman'];

  static const List<_NotificationData> _notifications = [
    _NotificationData(
      category: 'Nilai',
      icon: Icons.description_outlined,
      title: 'Nilai mata kuliah',
      message: 'Nilai Algoritma & Struktur Data telah diperbarui',
      time: '10:24',
    ),
    _NotificationData(
      category: 'Pengumuman',
      icon: Icons.notifications_none_rounded,
      title: 'Pengumuman kampus',
      message: 'Jadwal Ujian Semester Ganjil telah diumumkan',
      time: '09:00',
    ),
    _NotificationData(
      category: 'Reminder',
      icon: Icons.access_time,
      title: 'Reminder tugas',
      message: 'Tugas Pemrograman Mobile dikumpulkan besok',
      time: '08:30',
    ),
    _NotificationData(
      category: 'Sistem',
      icon: Icons.info_outline,
      title: 'Update sistem',
      message: 'Aplikasi Gradia diperbarui ke versi terbaru',
      time: 'Kemarin',
    ),
  ];

  List<_NotificationData> get _filteredNotifications {
    if (_selectedFilter == 'Semua') return _notifications;
    return _notifications
        .where((item) => item.category == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredNotifications;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    'Notifikasi',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    for (int i = 0; i < _filters.length; i++) ...[
                      if (i != 0) const SizedBox(width: 6),
                      Expanded(
                        child: _FilterTab(
                          label: _filters[i],
                          active: _filters[i] == _selectedFilter,
                          onTap: () {
                            setState(() {
                              _selectedFilter = _filters[i];
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
                child: items.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'Belum ada notifikasi',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          for (int i = 0; i < items.length; i++) ...[
                            _NotificationTile(data: items[i]),
                            if (i != items.length - 1)
                              const Divider(
                                height: 1,
                                color: Color(0xFFE2E8F0),
                              ),
                          ],
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

class _NotificationData {
  final String category;
  final IconData icon;
  final String title;
  final String message;
  final String time;

  const _NotificationData({
    required this.category,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
  });
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
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
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
            color: active
                ? const Color(0xFF4F46E5)
                : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final _NotificationData data;

  const _NotificationTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              data.icon,
              size: 18,
              color: const Color(0xFF4F46E5),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  data.message,
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

          Text(
            data.time,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}