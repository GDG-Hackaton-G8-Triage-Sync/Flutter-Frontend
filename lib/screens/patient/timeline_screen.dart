import 'package:flutter/material.dart';
import '../../models/api_models.dart';

class PatientTimelineScreen extends StatelessWidget {
  final TriageItem item;

  const PatientTimelineScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final status = item.status;
    final isVerified = item.verifiedBy != null;

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
            status == 'in_progress' 
              ? 'A medical team member has begun your assessment in the designated care bay.'
              : 'Waiting for clinical bay assignment.',
            'EST. NOW',
            isFirst: true,
            isActive: status == 'in_progress',
            icon: Icons.personal_video_outlined,
          ),
          if (isVerified)
            _buildTimelineStep(
              'Clinical Verification',
              'Nurse ${item.verifiedBy} has manually verified your AI triage score for clinical safety.',
              item.verifiedAt?.toLocal().toString().substring(11, 16) ?? '',
              isActive: true,
              icon: Icons.verified_user_outlined,
            ),
          _buildTimelineStep(
            'Priority Assigned',
            'Symptom analysis complete. Priority Level ${item.priority} designated.',
            item.createdAt.add(const Duration(minutes: 2)).toLocal().toString().substring(11, 16),
            isActive: true,
            icon: Icons.priority_high,
          ),
          _buildTimelineStep(
            'AI Assessment',
            'TriageSync AI analyzed your symptoms and calculated an urgency score of ${item.urgencyScore}/100.',
            item.createdAt.add(const Duration(minutes: 1)).toLocal().toString().substring(11, 16),
            isActive: true,
            icon: Icons.psychology_outlined,
          ),
          _buildTimelineStep(
            'Request Submitted',
            'Your clinical assessment request was successfully synched with the hospital database.',
            item.createdAt.toLocal().toString().substring(11, 16),
            isLast: true,
            isActive: true,
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
