import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Privacy & Security',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _InfoCard(
            icon: Icons.lock_outline,
            title: 'Data Encryption',
            description:
                'All session and transport channels are encrypted. Production deployment should enable end-to-end TLS and managed key rotation.',
          ),
          SizedBox(height: 12),
          _InfoCard(
            icon: Icons.verified_user_outlined,
            title: 'Consent Policy',
            description:
                'Patient consent must be obtained before sharing records. For hackathon demo, this acts as policy guidance and operator checklist.',
          ),
          SizedBox(height: 12),
          _InfoCard(
            icon: Icons.history_toggle_off,
            title: 'Audit Visibility',
            description:
                'Every sensitive action should be traceable by user, timestamp, and reason. The admin audit log viewer demonstrates this behavior.',
          ),
          SizedBox(height: 12),
          _InfoCard(
            icon: Icons.warning_amber_rounded,
            title: 'Emergency Access Controls',
            description:
                'Break-glass access should require explicit justification and generate mandatory audit records for compliance review.',
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF005EB8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1C1E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: Color(0xFF44474E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
