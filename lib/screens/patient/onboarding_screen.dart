import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/login_screen.dart';

import '../common/terms_of_use_screen.dart';
import 'privacy_security_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _openLegalPage(BuildContext context, String label) {
    Widget destination;
    switch (label) {
      case 'Privacy Policy':
      case 'HIPAA Compliance':
        destination = const PrivacySecurityScreen();
        break;
      case 'Terms of Use':
        destination = const TermsOfUseScreen();
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }

  Widget _footerLink(BuildContext context, String label) {
    return InkWell(
      onTap: () => _openLegalPage(context, label),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF44474E),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TriageSync',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF005EB8),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F0FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified_user,
                          size: 14,
                          color: Color(0xFF005EB8),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Secure Medical Portal',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF005EB8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3E3F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'SMART CARE PRIORITIZATION',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: Color(0xFF00478D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Healthcare, synchronized around your needs.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 32,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF00478D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'TriageSync uses advanced clinical AI to analyze your symptoms in real-time, ensuring our medical staff can prioritize your care effectively and reduce waiting times.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF44474E),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Main Image Card
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF005EB8,
                            ).withValues(alpha: 0.15),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDdgkbRwHlXUAnQO8oT0asZbTpnWHg4htmEWRbgUHEzKXVrnBtUDIpSdClEijR3ue0nWiL4kwfUqz6iyU8AR2roDwFPYARnY2QDHYx58_Ir8Kwh4zc6Abzxqz2lAj90Y2ntcM-L2_SlVvaUbDouPHTc5Q3rkM7Hhk0OKYXLo7VRb8ky2uqRSdE5LuWlwzW8-zbYzApvIXpoKxSsDTWt-n5CMrog10CBTbdQvNniY5ottiv997YQe5KAzNoAebraQfaiVddYy4OF3Og',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.monitor_heart,
                              color: Colors.white,
                              size: 64,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Feature 1
                    _buildFeatureCard(
                      icon: Icons.assignment,
                      title: 'Narrative Entry',
                      description:
                          'Simply speak or type your symptoms. Our AI understands medical nuance better than standard forms.',
                    ),
                    const SizedBox(height: 16),
                    // Feature 2
                    _buildFeatureCard(
                      icon: Icons.analytics,
                      title: 'Live Triage',
                      description:
                          'The system evaluates urgency scores and routes your data directly to the supervising physician\'s dashboard.',
                    ),
                    const SizedBox(height: 16),
                    // Feature 3
                    _buildFeatureCard(
                      icon: Icons.medical_services,
                      title: 'Direct Care',
                      description:
                          'Skip the administrative backlog. Your care team is prepared for your specific needs before you even arrive.',
                    ),

                    const SizedBox(height: 48),

                    // Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005EB8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: const Color(
                            0xFF005EB8,
                          ).withValues(alpha: 0.3),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(16),
                        ),
                        border: Border(
                          left: BorderSide(color: Color(0xFF005EB8), width: 4),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info, color: Color(0xFF005EB8)),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Medical AI Disclaimer',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1C1E),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'TriageSync is an AI-assisted prioritization tool designed to support medical professionals. It does not provide medical diagnoses or replace professional clinical judgment. In case of a life-threatening emergency, please call 911 immediately.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF73777F),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Footer Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _footerLink(context, 'Privacy Policy'),
                        const SizedBox(width: 16),
                        _footerLink(context, 'Terms of Use'),
                        const SizedBox(width: 16),
                        _footerLink(context, 'HIPAA Compliance'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '© 2026 TRIAGESYNC MEDICAL SYSTEMS. ALL RIGHTS RESERVED.',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF005EB8)),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF44474E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
