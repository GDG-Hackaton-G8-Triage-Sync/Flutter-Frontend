import 'package:flutter/material.dart';

class DataConsentScreen extends StatefulWidget {
  final VoidCallback onAccepted;

  const DataConsentScreen({super.key, required this.onAccepted});

  @override
  State<DataConsentScreen> createState() => _DataConsentScreenState();
}

class _DataConsentScreenState extends State<DataConsentScreen> {
  bool _acceptedTerms = false;
  bool _acceptedAI = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.security_outlined,
                color: Color(0xFF005EB8),
                size: 48,
              ),
              const SizedBox(height: 24),
              const Text(
                'Privacy and Health\nAgreement',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF002D57),
                  fontFamily: 'Manrope',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'TriageSync is a helper tool. Please read how we look after your information before you start.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF44474E),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _buildConsentTile(
                      'Smart Computer Helper',
                      'I understand that TriageSync uses a smart computer to suggest how quickly I need help. A doctor or nurse will always check this first.',
                      _acceptedAI,
                      (val) => setState(() => _acceptedAI = val ?? false),
                    ),
                    const SizedBox(height: 16),
                    _buildConsentTile(
                      'Keeping your info safe',
                      'I agree to let the app use my health notes to see how sick I am and to keep them private and safe.',
                      _acceptedTerms,
                      (val) => setState(() => _acceptedTerms = val ?? false),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDDE4F0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF005EB8),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Important Note: This app is a helper and does not give medical advice. If you are in big danger, call emergency services right away.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_acceptedAI && _acceptedTerms)
                        ? widget.onAccepted
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005EB8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'I AGREE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsentTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: value ? const Color(0xFF005EB8) : const Color(0xFFDDE4F0),
          ),
          borderRadius: BorderRadius.circular(16),
          color: value
              ? const Color(0xFF005EB8).withValues(alpha: 0.02)
              : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF005EB8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
