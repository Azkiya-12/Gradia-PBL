import 'package:flutter/material.dart';

class NotificationItem {
  final int id;
  final String category; // 'nilai', 'pengumuman', 'reminder', 'sistem'
  final String title;
  final String message;
  final bool isRead;
  final DateTime? createdAt;

  NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.isRead,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['created_at'] != null) {
      try {
        parsedDate = DateTime.tryParse(json['created_at'].toString());
      } catch (_) {}
    }

    final rawIsRead = json['is_read'];
    final isReadBool = rawIsRead == 1 || rawIsRead == true || rawIsRead == '1';

    return NotificationItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      category: json['category']?.toString() ?? 'pengumuman',
      title: json['title']?.toString() ?? 'Pemberitahuan',
      message: json['message']?.toString() ?? '',
      isRead: isReadBool,
      createdAt: parsedDate,
    );
  }

  IconData get icon {
    switch (category.toLowerCase()) {
      case 'nilai':
        return Icons.article_outlined;
      case 'reminder':
        return Icons.access_time;
      case 'sistem':
        return Icons.info_outline;
      case 'pengumuman':
      default:
        return Icons.notifications_none;
    }
  }

  String get formattedTime {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);

    if (diff.inMinutes < 60) {
      return diff.inMinutes <= 1 ? 'Baru saja' : '${diff.inMinutes} mnt lalu';
    } else if (diff.inHours < 24) {
      final hour = createdAt!.hour.toString().padLeft(2, '0');
      final minute = createdAt!.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else if (diff.inDays == 1) {
      return 'Kemarin';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      final day = createdAt!.day.toString().padLeft(2, '0');
      final month = createdAt!.month.toString().padLeft(2, '0');
      return '$day/$month';
    }
  }
}

class NotificationResponse {
  final int unreadCount;
  final List<NotificationItem> notifications;

  NotificationResponse({
    required this.unreadCount,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['notifications'] as List? ?? [];
    final items = rawList
        .map((item) => NotificationItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return NotificationResponse(
      unreadCount: json['unreadCount'] is int
          ? json['unreadCount']
          : int.tryParse(json['unreadCount']?.toString() ?? '0') ?? 0,
      notifications: items,
    );
  }
}
