import 'dart:ui';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, this.onViewStatus});

  final VoidCallback? onViewStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F8), // A slight gradient base
      body: Stack(
        children: [
          // Background aesthetic elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF005EB8).withValues(alpha: 0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFF146C2E,
                ).withValues(alpha: 0.05), // Greenish tint
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF00478D), Color(0xFF005EB8)],
                  ).createShader(bounds),
                  child: const Text(
                    'TriageSync',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Main Content Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00478D).withValues(alpha: 0.08),
                        blurRadius: 80,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Success Icon
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: const Color(0xFF146C2E),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF146C2E,
                              ).withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Request Submitted',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF00478D),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Your assessment is now being processed by our clinical intelligence engine to determine the optimal care pathway.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF44474E),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // AI Processing Container
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD6E4FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.smart_toy,
                                    color: Color(0xFF00478D),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'AI Processing Priority',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00478D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'We are analyzing your symptoms against hospital capacity and urgency metrics. A clinician will be notified shortly.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF44474E),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Progress indicator track
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: 0.6,
                                backgroundColor: Colors.grey[300],
                                color: const Color(0xFF005EB8),
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'ANALYSIS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'ASSIGNING CARE TEAM',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (onViewStatus != null) {
                              onViewStatus!();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005EB8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'View My Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Please remain in the waiting area. You will receive a mobile notification once your triage priority is finalized.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF44474E),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Footer security badges
                Column(
                  children: [
                    _buildSecurityBadge(Icons.lock, 'ENCRYPTED DATA'),
                    const SizedBox(height: 12),
                    _buildSecurityBadge(
                      Icons.health_and_safety,
                      'CLINICAL OVERSIGHT',
                    ),
                    const SizedBox(height: 12),
                    _buildSecurityBadge(Icons.sync, 'PRIORITY SYNCED'),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBadge(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
