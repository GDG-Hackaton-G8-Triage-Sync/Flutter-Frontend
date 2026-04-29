import 'package:flutter/material.dart';

class HelpEscalationScreen extends StatelessWidget {
  const HelpEscalationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text(
          'Help & Safety',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildEmergencyBanner(),
          const SizedBox(height: 24),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildFaqTile(
            'How is my priority level determined?',
            'Our system uses a Clinical Decision Support AI to analyze the severity of your symptoms compared to actual hospital capacity.',
          ),
          _buildFaqTile(
            'Can I update my symptoms after submission?',
            'Yes, go to settings and select "Submit New Triage" or tell your nurse when they call your name.',
          ),
          _buildFaqTile(
            'Is my data shared with insurance companies?',
            'No. Your data is strictly used for immediate clinical triage and is protected by hospital-grade security.',
          ),
          const SizedBox(height: 24),
          const Text(
            'Support Channels',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSupportOption(
            Icons.headset_mic_outlined,
            'Talk to a Desk Nurse',
            'Available 24/7 at the front intake.',
          ),
          _buildSupportOption(
            Icons.chat_bubble_outline,
            'Technical Support',
            'Help with the mobile application.',
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBA1A1A)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.emergency_share, color: Color(0xFFBA1A1A)),
              SizedBox(width: 12),
              Text(
                'IMMEDIATE DANGER?',
                style: TextStyle(
                  color: Color(0xFFBA1A1A),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'If you feel your condition is rapidly worsening (e.g., passing out, severe bleeding, or airway block), do not wait for the app. Alert any staff member immediately.',
            style: TextStyle(
              color: Color(0xFF410002),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
              ),
              child: const Text('EMERGENCY ESCALATION NOW'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTile(String q, String a) {
    return ExpansionTile(
      title: Text(
        q,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            a,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportOption(IconData icon, String label, String desc) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF005EB8)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    );
  }
}
