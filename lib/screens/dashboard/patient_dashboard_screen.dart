import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../../services/websocket/websocket_manager.dart';
import '../login_screen.dart';
import '../staff/admin_portal_screen.dart';
import '../staff/staff_dashboard_screen.dart';
import '../patient/profile_screen.dart';
import '../patient/settings_screen.dart';
import '../patient/status_screen.dart';
import '../patient/symptom_input_screen.dart';

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

  /// Bumped after each successful symptom submit to force StatusScreen reload.
  int _statusRefreshTrigger = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    // Connect WebSocket (no-op if already connected)
    WebSocketManager.instance.connect();
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
    if (!mounted) return;
    setState(() {
      _name = name;
      _email = email;
      _role = role;
    });
  }

  Future<void> _logout() async {
    WebSocketManager.instance.disconnect();
    await _session.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Future<void> _openRoleDashboard() async {
    if (_role == 'staff') {
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

  void _onSymptomSubmitted() {
    // Bump trigger → StatusScreen will re-fetch
    setState(() {
      _statusRefreshTrigger++;
      _currentIndex = 0; // Switch to Status tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      StatusScreen(
        key: ValueKey('status_$_statusRefreshTrigger'),
        refreshTrigger: _statusRefreshTrigger,
      ),
      SymptomInputScreen(onSubmitted: _onSymptomSubmitted),
      SettingsScreen(
        onOpenProfile: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProfileScreen(name: _name, email: _email, role: _role),
            ),
          );
        },
        onLogout: _logout,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00478D), Color(0xFF005EB8)],
          ).createShader(bounds),
          child: const Text(
            'TriageSync',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          if (_role == 'staff' || _role == 'admin')
            IconButton(
              onPressed: _openRoleDashboard,
              icon: const Icon(
                Icons.dashboard_customize_outlined,
                color: Color(0xFF005EB8),
              ),
              tooltip: 'Open role dashboard',
            ),
          // User avatar / name chip
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProfileScreen(name: _name, email: _email, role: _role),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFE0F0FF),
                child: Text(
                  _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF005EB8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: Colors.white,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Status',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Symptoms',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
