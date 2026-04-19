import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_frontend/features/patient/presentation/pages/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
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
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _name;
  late String _email;
  late String _role;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _email = widget.email;
    _role = widget.role;
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialName: _name,
          initialEmail: _email,
          role: _role,
        ),
      ),
    );

    if (updated == null || !mounted) {
      return;
    }

    setState(() {
      _name = (updated['name'] ?? _name).trim();
      _email = (updated['email'] ?? _email).trim();
      final role = (updated['role'] ?? _role).trim();
      if (role.isNotEmpty) {
        _role = role;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully.')),
    );
  }

  Map<String, String> _profileMap() => <String, String>{
    'name': _name,
    'email': _email,
    'role': _role,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB).withValues(alpha: 0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF005EB8)),
          onPressed: () => Navigator.pop(context, _profileMap()),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00478D), Color(0xFF005EB8)],
          ).createShader(bounds),
          child: const Text(
            'Patient Profile',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openEditProfile,
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF005EB8)),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(
                        colors: [
                          Color(0xFF005EB8),
                          Color(0xFF00478D),
                          Color(0xFF005EB8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF005EB8).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 112,
                    height: 112,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF005EB8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _name.isEmpty ? 'Unknown User' : _name,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1C1E),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F0FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _role.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF005EB8),
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 48),
            _buildInfoCard(Icons.person_outline, 'Full Name', _name),
            _buildInfoCard(Icons.email_outlined, 'Email Address', _email),
            _buildInfoCard(
              Icons.shield_outlined,
              'Account Role',
              _role.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00478D).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF005EB8), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF73777F),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1C1E),
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
