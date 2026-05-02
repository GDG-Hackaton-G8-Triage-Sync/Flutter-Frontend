import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/core/providers/accessibility_provider.dart';

class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibility = ref.watch(accessibilityProvider);
    final notifier = ref.read(accessibilityProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text(
          'Accessibility',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Vision & Interaction',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            Icons.format_size,
            'Large Text Mode',
            'Increased font sizes for better readability.',
            accessibility.largeText,
            (val) => notifier.setLargeText(val),
          ),
          _buildSwitchTile(
            Icons.contrast,
            'High Contrast',
            'Maximizes the contrast between UI elements.',
            accessibility.highContrast,
            (val) => notifier.setHighContrast(val),
          ),
          _buildSwitchTile(
            Icons.slow_motion_video,
            'Reduce Motion',
            'Minimizes animations and transitions.',
            accessibility.reduceMotion,
            (val) => notifier.setReduceMotion(val),
          ),
          const SizedBox(height: 24),
          const Text(
            'Language',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF005EB8)),
            title: const Text(
              'Primary Language',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(accessibility.language),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () => _showLanguagePicker(context, ref),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
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

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF005EB8)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF005EB8),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(accessibilityProvider.notifier);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        children: ['English', 'Spanish', 'French', 'Arabic', 'Chinese']
            .map(
              (lang) => ListTile(
                title: Text(lang),
                onTap: () {
                  notifier.setLanguage(lang);
                  Navigator.pop(ctx);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

