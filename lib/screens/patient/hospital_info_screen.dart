import 'package:flutter/material.dart';

class HospitalInfoScreen extends StatelessWidget {
  const HospitalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hospital Information',
          style: TextStyle(color: Color(0xFF00478D), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF005EB8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMapCard(),
          const SizedBox(height: 20),
          _buildDetailCard(
            'Emergency Department',
            'Open 24/7 • Entrance A',
            Icons.emergency,
            const Color(0xFFBA1A1A),
          ),
          const SizedBox(height: 12),
          _buildDetailCard(
            'Main Pharmacy',
            '08:00 AM - 10:00 PM • Entrance B',
            Icons.local_pharmacy,
            const Color(0xFF005EB8),
          ),
          const SizedBox(height: 20),
          _buildContactSection(),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 48, color: Colors.grey),
                    Text('Interactive Hospital Map Loading...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: FloatingActionButton.small(
              onPressed: () {},
              backgroundColor: const Color(0xFF005EB8),
              child: const Icon(Icons.navigation, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00478D), Color(0xFF00274D)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Need Immediate Assistance?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _contactIcon(Icons.phone, 'Call'),
              _contactIcon(Icons.chat_bubble_outline, 'Chat'),
              _contactIcon(Icons.mail_outline, 'Mail'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
