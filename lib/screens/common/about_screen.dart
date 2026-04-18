import 'package:flutter/material.dart';

class AboutTrustScreen extends StatelessWidget {
  const AboutTrustScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text('System Trust & Architecture', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeroCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Platform Architecture'),
          _buildFeatureCard(
            Icons.security,
            'HIPAA Compliant Data Handling',
            'All medical data is encrypted at rest and in transit. No PII is exposed to untrusted environments.',
          ),
          _buildFeatureCard(
            Icons.psychology,
            'Responsible AI Strategy',
            'Our Clinical Intelligence Engine acts as decision support. Final triage priority MUST be confirmed by a licensed clinician.',
          ),
          _buildFeatureCard(
            Icons.cloud_sync,
            'Real-time Synchronization',
            'Powered by WebSockets for zero-latency queue updates between patients and staff.',
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Build Information'),
          _buildInfoRow('Version', '1.0.0-Hackathon.Final'),
          _buildInfoRow('Engine', 'Triage-X Core v2.4'),
          _buildInfoRow('Status', 'Production Ready / Demo Mode'),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'Designed with ♥ for GDG Hackathon 2026',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF00478D), Color(0xFF005EB8)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF005EB8).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          const Icon(Icons.verified_user_outlined, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Clinical Masterpiece',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Manrope'),
          ),
          const SizedBox(height: 4),
          Text(
            'Built to solve healthcare congestion with resilience and empathy.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF73777F), letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF005EB8)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1C1E))),
        ],
      ),
    );
  }
}
