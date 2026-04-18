import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'privacy_security_screen.dart';
import '../common/accessibility_screen.dart';
import '../common/help_screen.dart';
import '../common/about_screen.dart';
import '../common/notification_screen.dart';
import '../common/demo_story_screen.dart';
import '../../widgets/premium_interactive.dart';
import '../../utils/navigation_transitions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.onOpenProfile,
    required this.onLogout,
  });

  final VoidCallback onOpenProfile;
  final VoidCallback onLogout;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _biometricLogin = false;

  static const _prefNotifications = 'pref_push_notifications';
  static const _prefBiometric = 'pref_biometric_login';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _pushNotifications = prefs.getBool(_prefNotifications) ?? true;
      _biometricLogin = prefs.getBool(_prefBiometric) ?? false;
    });
  }

  Future<void> _setNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefNotifications, value);
    if (!mounted) return;
    setState(() => _pushNotifications = value);
  }

  Future<void> _setBiometric(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefBiometric, value);
    if (!mounted) return;
    setState(() => _biometricLogin = value);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            subtitle: const Text('Manage personal information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: widget.onOpenProfile,
          ),
        ),
        Card(
          child: SwitchListTile(
            value: _pushNotifications,
            onChanged: _setNotifications,
            title: const Text('Push Notifications'),
            subtitle: const Text('Critical updates and queue alerts'),
          ),
        ),
        Card(
          child: SwitchListTile(
            value: _biometricLogin,
            onChanged: _setBiometric,
            title: const Text('Biometric Login'),
            subtitle: const Text('Use device biometrics for sign in'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text('Privacy & Security'),
            subtitle: const Text('Manage consent and security settings'),
            onTap: () => Navigator.push(context, FadePageRoute(child: const PrivacySecurityScreen())),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications_none_outlined),
            title: const Text('Notification Inbox'),
            subtitle: const Text('View system and clinical alerts'),
            onTap: () => Navigator.push(context, FadePageRoute(child: const NotificationInboxScreen())),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.accessibility_new_outlined),
            title: const Text('Accessibility'),
            subtitle: const Text('Text size, contrast, and language'),
            onTap: () => Navigator.push(context, FadePageRoute(child: const AccessibilitySettingsScreen())),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            subtitle: const Text('FAQ, safety, and escalation'),
            onTap: () => Navigator.push(context, FadePageRoute(child: const HelpEscalationScreen())),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About TriageSync'),
            subtitle: const Text('Architecture and Trust'),
            onTap: () => Navigator.push(context, FadePageRoute(child: const AboutTrustScreen())),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.rocket_launch_outlined, color: Colors.blueAccent),
            title: const Text('Launch Demo Briefing', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            subtitle: const Text('Initial mission control overview'),
            onTap: () => Navigator.push(context, FadePageRoute(child: DemoStoryScreen(onStart: () => Navigator.pop(context)))),
          ),
        ),
        const SizedBox(height: 32),
        PremiumButton(
          onTap: widget.onLogout,
          label: 'Sign Out of Session',
          color: const Color(0xFFBA1A1A),
          icon: Icons.logout_rounded,
        ),
      ],
    );
  }
}
