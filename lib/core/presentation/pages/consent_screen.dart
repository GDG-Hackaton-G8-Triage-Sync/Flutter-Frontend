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
                'Data Privacy &\nClinical Consent',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF002D57),
                  fontFamily: 'Manrope',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'TriageSync is a decision support tool. Please review how your data is handled before continuing.',
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
                      'AI Decision Support',
                      'I understand that TriageSync uses AI to suggest urgency levels, and these must be confirmed by a medical professional.',
                      _acceptedAI,
                      (val) => setState(() => _acceptedAI = val ?? false),
                    ),
                    const SizedBox(height: 16),
                    _buildConsentTile(
                      'Data Processing (HIPAA)',
                      'I agree to the secure processing of my medical symptoms and health data for the purpose of triage.',
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
                              'Medical Disclaimer: This app does not provide medical advice. In case of a life-threatening emergency, call your local emergency services immediately.',
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
                      'I CONSENT AND AGREE',
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
