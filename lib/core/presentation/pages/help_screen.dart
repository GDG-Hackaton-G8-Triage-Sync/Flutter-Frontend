import 'package:flutter/material.dart';

class HelpEscalationScreen extends StatelessWidget {
  const HelpEscalationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text(
          'Get Help',
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
            'Common Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildFaqTile(
            'How soon will I see a doctor?',
            'Our system uses a smart helper to see how sick you are and how busy the hospital is.',
          ),
          _buildFaqTile(
            'Can I update my health notes after sending?',
            'Yes, go to settings and select "Check your health again" or tell a nurse when they call your name.',
          ),
          _buildFaqTile(
            'Is my info shared with others?',
            'No. Your info is only used to see how sick you are right now and is kept very safe.',
          ),
          const SizedBox(height: 24),
          const Text(
            'Ways to Get Help',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSupportOption(
            Icons.headset_mic_outlined,
            'Talk to a Nurse',
            'Available 24/7 at the front desk.',
          ),
          _buildSupportOption(
            Icons.chat_bubble_outline,
            'App Help',
            'Help with using this app.',
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
                'IN BIG DANGER?',
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
            'If you feel much worse (like passing out, lots of bleeding, or trouble breathing), do not wait for the app. Tell a nurse or any staff right away.',
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
              child: const Text('GET HELP RIGHT NOW'),
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
