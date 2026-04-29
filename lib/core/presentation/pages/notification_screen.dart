import 'package:flutter/material.dart';

class NotificationInboxScreen extends StatelessWidget {
  const NotificationInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          TextButton(onPressed: () {}, child: const Text('Mark all as read')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotification(
            'Major status change',
            'Your triage priority has been updated to P2. A physician will see you shortly.',
            '2m ago',
            Icons.notification_important,
            Colors.orange,
            isNew: true,
          ),
          _buildNotification(
            'Vitals Analysis Ready',
            'Symptom processing complete. View your care journey for details.',
            '1h ago',
            Icons.biotech,
            const Color(0xFF005EB8),
            isNew: true,
          ),
          _buildNotification(
            'Safety Alert',
            'High patient volume detected in ED. Check-in wait times increased by 10 min.',
            '3h ago',
            Icons.report_problem_outlined,
            Colors.red,
          ),
          _buildNotification(
            'Profile Update',
            'Biometric access enabled for your account.',
            'Yesterday',
            Icons.fingerprint,
            Colors.green,
          ),
        ],
      ),
    );
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
