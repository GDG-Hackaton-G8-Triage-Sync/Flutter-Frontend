import 'package:flutter/material.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';

class NotificationInboxScreen extends StatefulWidget {
  const NotificationInboxScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<NotificationInboxScreen> createState() =>
      _NotificationInboxScreenState();
}


class _NotificationInboxScreenState extends State<NotificationInboxScreen> {
  final BackendService _backend = BackendService.instance;
  late Future<List<AppNotification>> _future;

  @override
  void initState() {
    super.initState();
    _future = _backend.getNotifications();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _backend.getNotifications();
    });
  }

  Future<void> _markAllAsRead() async {
    await _backend.markAllNotificationsRead();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final content = FutureBuilder<List<AppNotification>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final notifications = snapshot.data ?? <AppNotification>[];
        if (notifications.isEmpty) {
          return const Center(
            child: Text(
              'No notifications yet.',
              style: TextStyle(color: Color(0xFF44474E)),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: Column(
            children: [
              if (!widget.showAppBar)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Updates & Alerts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _markAllAsRead,
                        child: const Text('Mark all read'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    final color = _notificationColor(item.type);
                    return _buildNotification(
                      item.title,
                      item.message,
                      _relativeTime(item.createdAt),
                      _notificationIcon(item.type),
                      color,
                      isNew: !item.isRead,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!widget.showAppBar) return content;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: content,
    );
  }


  Color _notificationColor(String type) {
    switch (type) {
      case 'critical_alert':
        return const Color(0xFFBA1A1A);
      case 'priority_update':
      case 'triage_status_change':
        return const Color(0xFFF57C00);
      case 'role_change':
        return const Color(0xFF005EB8);
      default:
        return const Color(0xFF146C2E);
    }
  }

  IconData _notificationIcon(String type) {
    switch (type) {
      case 'critical_alert':
        return Icons.report_problem_outlined;
      case 'priority_update':
      case 'triage_status_change':
        return Icons.notification_important;
      case 'role_change':
        return Icons.admin_panel_settings_outlined;
      default:
        return Icons.notifications_active_outlined;
    }
  }

  String _relativeTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  Widget _buildNotification(
    String title,
    String desc,
    String time,
    IconData icon,
    Color color, {
    bool isNew = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isNew ? color.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isNew ? Border.all(color: color.withValues(alpha: 0.2)) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              time,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            desc,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
        ),
      ),
    );
  }
}
