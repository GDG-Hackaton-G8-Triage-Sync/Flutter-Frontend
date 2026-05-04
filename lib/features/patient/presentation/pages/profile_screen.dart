import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';
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
  final BackendService _backend = BackendService.instance;
  late Future<PatientProfile> _profileFuture;
  late PatientProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = PatientProfile(
      name: widget.name,
      email: widget.email,
      role: widget.role,
    );
    _profileFuture = _loadProfile();
  }

  Future<PatientProfile> _loadProfile() async {
    try {
      final profile = await _backend.getProfile();
      _profile = profile;
      return profile;
    } catch (_) {
      return _profile;
    }
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(initialProfile: _profile),
      ),
    );

    if (updated == null || !mounted) {
      return;
    }

    setState(() {
      _profile = PatientProfile(
        name: (updated['name'] ?? _profile.name).trim(),
        email: (updated['email'] ?? _profile.email).trim(),
        role: (updated['role'] ?? _profile.role).trim(),
        age: _profile.age,
        gender: _profile.gender,
        bloodType: _profile.bloodType,
        healthHistory: _profile.healthHistory,
        allergies: _profile.allergies,
        medications: _profile.medications,
        lifestyleHabits: _profile.lifestyleHabits,
        profilePhotoName:
            (updated['profilePhotoName'] ?? _profile.profilePhotoName)?.trim(),
        profilePhotoUrl:
          (updated['profilePhotoUrl'] ?? _profile.profilePhotoUrl)?.trim(),
      );
      _profileFuture = Future.value(_profile);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully.')),
    );
  }

  Map<String, String> _profileMap() => <String, String>{
    'name': _profile.name,
    'email': _profile.email,
    'role': _profile.role,
  };

  Widget _buildAvatar(PatientProfile profile) {
    final photoUrl = profile.profilePhotoUrl?.trim();
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ClipOval(
          child: hasPhoto
              ? Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildInitialAvatar(profile.name);
                  },
                )
              : _buildInitialAvatar(profile.name),
        ),
      ),
    );
  }

  Widget _buildInitialAvatar(String name) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: Color(0xFF005EB8),
          ),
        ),
      ),
    );
  }

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
      body: FutureBuilder<PatientProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          final profile = snapshot.data ?? _profile;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                Center(
                  child: _buildAvatar(profile),
                ),
                const SizedBox(height: 24),
                Text(
                  profile.name.isEmpty ? 'Unknown User' : profile.name,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F0FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    profile.role.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF005EB8),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                _buildInfoCard(Icons.person_outline, 'Full Name', profile.name),
                _buildInfoCard(
                  Icons.email_outlined,
                  'Email Address',
                  profile.email,
                ),
                _buildInfoCard(
                  Icons.cake_outlined,
                  'Age',
                  profile.age?.toString() ?? '-',
                ),
                _buildInfoCard(
                  Icons.wc_outlined,
                  'Gender',
                  profile.gender ?? '-',
                ),
                _buildInfoCard(
                  Icons.bloodtype_outlined,
                  'Blood Type',
                  profile.bloodType ?? '-',
                ),
                _buildInfoCard(
                  Icons.medical_information_outlined,
                  'Health History',
                  profile.healthHistory ?? '-',
                ),
                _buildInfoCard(
                  Icons.warning_amber_outlined,
                  'Allergies',
                  profile.allergies ?? '-',
                ),
                _buildInfoCard(
                  Icons.medication_outlined,
                  'Medications',
                  profile.medications ?? '-',
                ),
                _buildInfoCard(
                  Icons.self_improvement_outlined,
                  'Lifestyle Habits',
                  profile.lifestyleHabits ?? '-',
                ),
                _buildInfoCard(
                  Icons.image_outlined,
                  'Profile Photo',
                  profile.profilePhotoName ?? '-',
                ),
              ],
            ),
          );
        },
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
