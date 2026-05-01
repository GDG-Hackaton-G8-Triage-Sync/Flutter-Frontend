import 'package:flutter/material.dart';

class HipaaComplianceScreen extends StatelessWidget {
  const HipaaComplianceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'HIPAA Compliance',
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
          _HipaaCard(
            icon: Icons.shield_outlined,
            color: Color(0xFF005EB8),
            title: 'What is HIPAA?',
            description:
                'The Health Insurance Portability and Accountability Act (HIPAA) establishes national standards to protect sensitive patient health information from being disclosed without the patient\'s consent or knowledge.',
          ),
          SizedBox(height: 12),
          _HipaaCard(
            icon: Icons.medical_information_outlined,
            color: Color(0xFF006D44),
            title: 'Protected Health Information (PHI)',
            description:
                'TriageSync treats all patient data — including symptoms, medical history, and vitals — as Protected Health Information. PHI is only accessible to authorized clinical staff and the patient themselves.',
          ),
          SizedBox(height: 12),
          _HipaaCard(
            icon: Icons.manage_accounts_outlined,
            color: Color(0xFF6750A4),
            title: 'Minimum Necessary Standard',
            description:
                'Staff members are granted access only to the patient data that is strictly necessary for their clinical role. Doctors and nurses cannot view records outside their assigned cases without audit justification.',
          ),
          SizedBox(height: 12),
          _HipaaCard(
            icon: Icons.history_edu_outlined,
            color: Color(0xFFF57C00),
            title: 'Audit Logging & Accountability',
            description:
                'Every data access, modification, and deletion event is logged with the acting user, timestamp, and justification. These immutable logs are available to administrators for compliance review at any time.',
          ),
          SizedBox(height: 12),
          _HipaaCard(
            icon: Icons.lock_person_outlined,
            color: Color(0xFFBA1A1A),
            title: 'Breach Notification',
            description:
                'In the event of a data security incident, TriageSync\'s operational protocols require notification to affected individuals and relevant authorities within the timeframe mandated by HIPAA\'s Breach Notification Rule.',
          ),
          SizedBox(height: 12),
          _HipaaCard(
            icon: Icons.how_to_reg_outlined,
            color: Color(0xFF005EB8),
            title: 'Patient Rights',
            description:
                'Patients have the right to access their own health records, request corrections, and understand how their data is used. These rights are enforced through the patient profile and triage history screens.',
          ),
          SizedBox(height: 24),
          _HipaaDisclaimer(),
        ],
      ),
    );
  }
}

class _HipaaCard extends StatelessWidget {
  const _HipaaCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
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

class _HipaaDisclaimer extends StatelessWidget {
  const _HipaaDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF005EB8).withValues(alpha: 0.25)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF005EB8), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'This application is designed for educational and hackathon demonstration purposes. For production deployment in a healthcare setting, a formal HIPAA Business Associate Agreement (BAA) and a full risk assessment conducted by a qualified compliance officer are required.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Color(0xFF00478D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
