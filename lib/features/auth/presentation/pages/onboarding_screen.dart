import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/login_screen.dart';

import 'package:flutter_frontend/features/auth/presentation/pages/terms_of_use_screen.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/privacy_security_screen.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/hipaa_compliance_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void _openLegalPage(BuildContext context, String label) {
    Widget destination;
    switch (label) {
      case 'Privacy Policy':
        destination = const PrivacySecurityScreen();
        break;
      case 'HIPAA Compliance':
        destination = const HipaaComplianceScreen();
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
    return TextButton(
      onPressed: () => _openLegalPage(context, label),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF005EB8),
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
                          'Safe Health App',
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
                        'SMART HELP',
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
                      'Health help that is ready for you.',
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
                      'TriageSync uses a smart helper to look at your notes right away. This helps our doctors and nurses see you faster.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF44474E),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Main Image Card (Premium Cinematic Asset)
                    Container(
                      height: 320,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF001A33),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF005EB8,
                            ).withValues(alpha: 0.25),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Stack(
                          children: [
                            // Neon pulse background
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.4,
                                child: const AnimatedHeartbeat(),
                              ),
                            ),
                            // Hero Asset (Platform Aware)
                            Center(
                              child: kIsWeb
                                  ? Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.monitor_heart,
                                        color: Colors.white,
                                        size: 64,
                                      ),
                                    )
                                  : Image.file(
                                      File(
                                        'C:/Users/ms/.gemini/antigravity/brain/935f1e90-cd78-4fb3-b776-aa0c23c57abb/medical_ai_triage_hero_1776637124258.png',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                            ),
                            // Gradient Overlay for depth
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      const Color(
                                        0xFF001A33,
                                      ).withValues(alpha: 0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Feature 1
                    _buildFeatureCard(
                      icon: Icons.assignment,
                      title: 'Type or Talk',
                      description:
                          'Just speak or type how you feel. Our smart helper understands your words.',
                    ),
                    const SizedBox(height: 16),
                    // Feature 2
                    _buildFeatureCard(
                      icon: Icons.analytics,
                      title: 'Fast Check-in',
                      description:
                          'The app sees how sick you are and sends your notes right to the doctor.',
                    ),
                    const SizedBox(height: 16),
                    // Feature 3
                    _buildFeatureCard(
                      icon: Icons.medical_services,
                      title: 'Ready for You',
                      description:
                          'No more long forms. Your doctors and nurses are ready for you before you even walk in.',
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

                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Already have an account? Sign in',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00478D),
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
                                  'Important Note',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1C1E),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'TriageSync is a helper tool for doctors and nurses. It does not give medical advice. If you are in big danger, call emergency services right away.',
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

                    // Compliance Footer
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFD6DEE8),
                          width: 1,
                        ),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4,
                        runSpacing: 2,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 14,
                            color: Color(0xFF005EB8),
                          ),
                          _footerLink(context, 'Privacy Policy'),
                          const Text(
                            '•',
                            style: TextStyle(color: Color(0xFF7A8088)),
                          ),
                          _footerLink(context, 'Terms of Use'),
                          const Text(
                            '•',
                            style: TextStyle(color: Color(0xFF7A8088)),
                          ),
                          _footerLink(context, 'HIPAA Compliance'),
                        ],
                      ),
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

class AnimatedHeartbeat extends StatefulWidget {
  const AnimatedHeartbeat({super.key});

  @override
  State<AnimatedHeartbeat> createState() => _AnimatedHeartbeatState();
}

class _AnimatedHeartbeatState extends State<AnimatedHeartbeat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: HeartbeatPainter(progress: _controller.value),
        );
      },
    );
  }
}

class HeartbeatPainter extends CustomPainter {
  final double progress;

  HeartbeatPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final path = Path();
    path.moveTo(0, y);
    path.lineTo(size.width * 0.2, y);
    path.lineTo(size.width * 0.25, y - 20);
    path.lineTo(size.width * 0.3, y + 40);
    path.lineTo(size.width * 0.35, y - 60);
    path.lineTo(size.width * 0.4, y + 20);
    path.lineTo(size.width * 0.45, y);
    path.lineTo(size.width * 0.6, y);
    path.lineTo(size.width * 0.65, y - 30);
    path.lineTo(size.width * 0.7, y + 50);
    path.lineTo(size.width * 0.75, y - 100);
    path.lineTo(size.width * 0.8, y + 20);
    path.lineTo(size.width * 0.85, y);
    path.lineTo(size.width, y);

    final shift = progress * size.width;
    canvas.save();
    canvas.translate(-shift, 0);

    final glowPaint1 = Paint()
      ..color = const Color(0xFFFF2D55).withValues(alpha: 0.15)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint2 = Paint()
      ..color = const Color(0xFFFF2D55).withValues(alpha: 0.3)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final corePaint = Paint()
      ..color = const Color(0xFFFF2D55).withValues(alpha: 0.8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void drawAllLayers() {
      canvas.drawPath(path, glowPaint1);
      canvas.drawPath(path, glowPaint2);
      canvas.drawPath(path, corePaint);
    }

    drawAllLayers();
    canvas.translate(size.width, 0);
    drawAllLayers();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HeartbeatPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
