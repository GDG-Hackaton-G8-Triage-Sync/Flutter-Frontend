import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Terms of Use',
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
          _ClauseCard(
            title: 'Scope of Service',
            text:
                'TriageSync provides clinical intake support and queue prioritization workflows. It does not replace physician judgment or emergency services.',
          ),
          SizedBox(height: 12),
          _ClauseCard(
            title: 'Medical Disclaimer',
            text:
                'This platform does not provide diagnosis. In a life-threatening emergency, contact local emergency services immediately.',
          ),
          SizedBox(height: 12),
          _ClauseCard(
            title: 'Acceptable Use',
            text:
                'Users must provide accurate information and must not attempt unauthorized access, abuse, or disruption of clinical operations.',
          ),
          SizedBox(height: 12),
          _ClauseCard(
            title: 'Data Handling',
            text:
                'Clinical data is processed under privacy and security policies. Access is role-restricted and auditable for compliance.',
          ),
          SizedBox(height: 12),
          _ClauseCard(
            title: 'Account Responsibility',
            text:
                'Each user is responsible for securing credentials and reporting suspicious access events immediately.',
          ),
        ],
      ),
    );
  }
}

class _ClauseCard extends StatelessWidget {
  const _ClauseCard({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
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
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF44474E),
            ),
          ),
        ],
      ),
    );
  }
}
