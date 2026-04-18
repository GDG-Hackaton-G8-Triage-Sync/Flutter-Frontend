import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFFE0F0FF),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005EB8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildInfo('Name', name),
          _buildInfo('Email', email),
          _buildInfo('Role', role),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value.isEmpty ? '-' : value),
      ),
    );
  }
}
