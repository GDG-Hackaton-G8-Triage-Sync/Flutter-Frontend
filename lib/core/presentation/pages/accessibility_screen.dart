import 'package:flutter/material.dart';

class AccessibilitySettingsScreen extends StatefulWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  State<AccessibilitySettingsScreen> createState() => _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState extends State<AccessibilitySettingsScreen> {
  bool _largeText = false;
  bool _highContrast = false;
  bool _reduceMotion = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text('Accessibility', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Vision & Interaction',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            Icons.format_size,
            'Large Text Mode',
            'Increased font sizes for better readability.',
            _largeText,
            (val) => setState(() => _largeText = val),
          ),
          _buildSwitchTile(
            Icons.contrast,
            'High Contrast',
            'Maximizes the contrast between UI elements.',
            _highContrast,
            (val) => setState(() => _highContrast = val),
          ),
          _buildSwitchTile(
            Icons.slow_motion_video,
            'Reduce Motion',
            'Minimizes animations and transitions.',
            _reduceMotion,
            (val) => setState(() => _reduceMotion = val),
          ),
          const SizedBox(height: 24),
          const Text(
            'Language',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF005EB8)),
            title: const Text('Primary Language', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_language),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () => _showLanguagePicker(),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.hearing, color: Color(0xFF005EB8)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Note: TriageSync is designed to be compatible with Screen Readers (VoiceOver/TalkBack).',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF005EB8)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(value: value, onChanged: onChanged, activeThumbColor: const Color(0xFF005EB8)),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        children: ['English', 'Spanish', 'French', 'Arabic', 'Chinese'].map((lang) => ListTile(
          title: Text(lang),
          onTap: () {
            setState(() => _language = lang);
            Navigator.pop(ctx);
          },
        )).toList(),
      ),
    );
  }
}
