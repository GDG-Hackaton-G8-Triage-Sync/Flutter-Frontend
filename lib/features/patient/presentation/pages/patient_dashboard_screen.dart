import 'package:flutter/material.dart';

import 'package:flutter_frontend/core/services/session_service.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_frontend/features/admin/presentation/pages/admin_portal_screen.dart';
import 'package:flutter_frontend/features/staff/presentation/pages/staff_dashboard_screen.dart';
import 'package:flutter_frontend/features/patient/presentation/pages/profile_screen.dart';
import 'package:flutter_frontend/features/patient/presentation/pages/settings_screen.dart';
import 'package:flutter_frontend/features/patient/presentation/pages/status_screen.dart';
import 'package:flutter_frontend/features/patient/presentation/pages/symptom_input_screen.dart';
import 'package:flutter_frontend/core/presentation/pages/consent_screen.dart';
import 'package:flutter_frontend/features/patient/presentation/widgets/patient_home_tab.dart';
import 'package:flutter_frontend/core/utils/navigation_transitions.dart';
import 'package:flutter_frontend/core/presentation/pages/notification_screen.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {
  final SessionService _session = SessionService();
  int _currentIndex = 0;
  String _name = '';
  String _email = '';
  String _role = 'patient';
  String? _profilePhotoUrl;
  bool _consentLoaded = false;

  /// Bumped after each successful symptom submit to force StatusScreen reload.
  int _statusRefreshTrigger = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    // Don't disconnect here — staff may still need it. Only close on full logout.
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final name = await _session.getName() ?? '';
    final email = await _session.getEmail() ?? '';
    final role = await _session.getRole() ?? 'patient';
    // Fetch profile from backend to get latest photo URL if available.
    try {
      final profile = await BackendService.instance.getProfile();
      _profilePhotoUrl = profile.profilePhotoUrl?.trim();
    } catch (_) {
      // ignore — fallback to initials
    }
    final hasConsented = await _session.getDataConsentAccepted(email: email);
    if (!mounted) return;
    setState(() {
      _name = name;
      _email = email;
      _role = role;
      _hasConsented = hasConsented;
      _consentLoaded = true;
    });
  }

  Future<void> _logout() async {
    await BackendService.instance.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Future<void> _openRoleDashboard() async {
    if (_isStaffRole(_role)) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const StaffDashboardScreen()),
      );
      return;
    }
    if (_role == 'admin') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminPortalScreen()),
      );
    }
  }

  Future<void> _openProfile() async {
    final updated = await Navigator.push<Map<String, String>>(
      context,
      SlideRightRoute(
        child: ProfileScreen(name: _name, email: _email, role: _role),
      ),
    );

    if (!mounted || updated == null) {
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
  }

  void _onSymptomSubmitted() {
    // Bump trigger → StatusScreen will re-fetch
    setState(() {
      _statusRefreshTrigger++;
      _currentIndex = 0; // Switch to Status tab
    });
  }

  bool _hasConsented = false;

  bool _isStaffRole(String role) {
    return role == 'staff' || role == 'nurse' || role == 'doctor';
  }

  @override
  Widget build(BuildContext context) {
    if (!_consentLoaded) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F9FB),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_hasConsented) {
      return DataConsentScreen(
        onAccepted: () async {
          await _session.setDataConsentAccepted(true, email: _email);
          if (!mounted) {
            return;
          }
          setState(() => _hasConsented = true);
        },
      );
    }

    final screens = <Widget>[
      PatientHomeTab(
        name: _name,
        email: _email,
        onStartTriage: () => setState(() => _currentIndex = 2),
        onOpenWaitList: () => setState(() => _currentIndex = 1),
      ),
      StatusScreen(
        key: ValueKey('status_$_statusRefreshTrigger'),
        refreshTrigger: _statusRefreshTrigger,
      ),
      SymptomInputScreen(onSubmitted: _onSymptomSubmitted),
      const NotificationInboxScreen(showAppBar: false),
      SettingsScreen(onOpenProfile: _openProfile, onLogout: _logout),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              const Icon(Icons.hub_rounded, color: Color(0xFF005EB8), size: 28),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF00478D), Color(0xFF005EB8)],
                ).createShader(bounds),
                child: const Text(
                  'TriageSync',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (_isStaffRole(_role) || _role == 'admin')
            IconButton(
              onPressed: _openRoleDashboard,
              icon: const Icon(
                Icons.admin_panel_settings_outlined,
                color: Color(0xFF005EB8),
              ),
              tooltip: 'Switch to Staff View',
            ),
          // User avatar / name chip
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _openProfile,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                      ? Image.network(
                          _profilePhotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF005EB8),
                              child: Center(
                                child: Text(
                                  _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFF005EB8),
                          child: Center(
                            child: Text(
                              _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Help Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFE0F0FF),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF005EB8),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _currentIndex == 2
                        ? 'Need help? Check-in by writing or speaking your symptoms.'
                        : 'Need help? Check your "Check-in" tab to send your symptoms.',
                    style: const TextStyle(
                      color: Color(0xFF005EB8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(index: _currentIndex, children: screens),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF005EB8).withValues(alpha: 0.1),
          height: 70,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.home, color: Color(0xFF005EB8)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.history, color: Color(0xFF005EB8)),
              label: 'Wait List',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline, color: Colors.grey),
              selectedIcon: Icon(Icons.add_circle, color: Color(0xFF005EB8)),
              label: 'Check-in',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.notifications, color: Color(0xFF005EB8)),
              label: 'Messages',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.settings, color: Color(0xFF005EB8)),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
