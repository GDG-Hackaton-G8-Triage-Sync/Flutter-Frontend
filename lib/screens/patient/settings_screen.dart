import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy settings opened')),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
          ),
        ),
      ],
    );
  }
}
