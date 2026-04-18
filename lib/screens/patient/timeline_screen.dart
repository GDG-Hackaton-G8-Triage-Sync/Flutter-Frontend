import 'package:flutter/material.dart';

class PatientTimelineScreen extends StatelessWidget {
  const PatientTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Care Journey', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildTimelineStep(
            'In Treatment',
            'Triage Nurse (ID: 402) has begun your assessment in Bay 4.',
            '09:42 AM',
            isFirst: true,
            isActive: true,
            icon: Icons.personal_video_outlined,
          ),
          _buildTimelineStep(
            'Priority Assigned',
            'Clinical engine designated Priority 2 (Urgent).',
            '09:35 AM',
            icon: Icons.priority_high,
          ),
          _buildTimelineStep(
            'Processing Symptoms',
            'AI analyzing symptom patterns and vital signs.',
            '09:32 AM',
            icon: Icons.psychology_outlined,
          ),
          _buildTimelineStep(
            'Registration Complete',
            'Profile synched with hospital database.',
            '09:30 AM',
            isLast: true,
            icon: Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, String desc, String time, {bool isFirst = false, bool isLast = false, bool isActive = false, required IconData icon}) {
    final color = isActive ? const Color(0xFF005EB8) : Colors.grey[400]!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 2,
              height: 30,
              color: isFirst ? Colors.transparent : Colors.grey[300],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
              child: Icon(icon, color: color, size: 20),
            ),
            Container(
              width: 2,
              height: 80,
              color: isLast ? Colors.transparent : Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isActive ? const Color(0xFF003366) : const Color(0xFF1A1C1E))),
                  Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
