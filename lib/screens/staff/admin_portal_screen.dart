import 'dart:ui';
import 'package:flutter/material.dart';

class AdminPortalScreen extends StatelessWidget {
  const AdminPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Control\nPanel',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Color(0xFF00478D),
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Real-time system oversight and triage intelligence.',
              style: TextStyle(fontSize: 14, color: Color(0xFF44474E)),
            ),
            const SizedBox(height: 32),
            _buildVolumeCard(),
            const SizedBox(height: 16),
            _buildWaitTimeCard(),
            const SizedBox(height: 16),
            _buildSystemHealthCard(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Triage Logs',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00478D),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View Full Archive →'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLogCard(
              patientId: 'Patient #8294',
              complaint: 'Chest Pain',
              description:
                  'Patient reports acute pressure in central chest radiating to left arm. AI detected hig...',
              confidence: '94%',
              route: 'ER-1',
              status: 'CRITICAL',
              color: const Color(0xFFBA1A1A),
              bgColor: const Color(0xFFFFDAD6),
            ),
            const SizedBox(height: 12),
            _buildLogCard(
              patientId: 'Patient #8291',
              complaint: 'Joint Discomfort',
              description:
                  'Chronic knee pain, no trauma. Redirected to Orthopedic outpatient queue.',
              confidence: '99%',
              route: 'Outpatient',
              status: 'STABLE',
              color: const Color(0xFF146C2E),
              bgColor: const Color(0xFFC4EED0),
            ),
            const SizedBox(height: 32),
            const Text(
              'Service Monitor',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00478D),
              ),
            ),
            const SizedBox(height: 16),
            _buildServiceMonitorCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: const Color(0xFFF7F9FB).withValues(alpha: 0.8),
            elevation: 0,
            leadingWidth: 0,
            leading: const SizedBox.shrink(),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Color(0xFF005EB8)),
                ),
                const SizedBox(width: 12),
                ShaderMask(
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
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF005EB8),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL DAILY TRIAGE VOLUME',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '1,284',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF00478D),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: const [
                  Icon(Icons.trending_up, color: Color(0xFF146C2E), size: 16),
                  Text(
                    '12%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF146C2E),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(height: 20, color: const Color(0xFFD6E4FF)),
              _buildBar(height: 30, color: const Color(0xFFD6E4FF)),
              _buildBar(height: 25, color: const Color(0xFFD6E4FF)),
              _buildBar(height: 40, color: const Color(0xFFD6E4FF)),
              _buildBar(height: 50, color: const Color(0xFF005EB8)), // Active
              _buildBar(height: 35, color: const Color(0xFFD6E4FF)),
              _buildBar(height: 25, color: const Color(0xFFD6E4FF)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar({required double height, required Color color}) {
    return Container(
      width: 32,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildWaitTimeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, color: Color(0xFF146C2E)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Avg Wait Time',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          const Text(
            '14.2 min',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Down from 18.5 min last hour',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealthCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF00478D),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF146C2E).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'STABLE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'System Health',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          const Text(
            '99.9%',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'All AI nodes operational',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard({
    required String patientId,
    required String complaint,
    required String description,
    required String confidence,
    required String route,
    required String status,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: '$patientId — '),
                              TextSpan(text: complaint),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"$description"',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF44474E),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.analytics_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Confidence: $confidence',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.route_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Route: $route',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceMonitorCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildServiceRow(
            'Voice AI Processor',
            'Optimal',
            0.9,
            const Color(0xFF146C2E),
          ),
          const SizedBox(height: 24),
          _buildServiceRow(
            'Data Integration Hub',
            'Optimal',
            0.85,
            const Color(0xFF146C2E),
          ),
          const SizedBox(height: 24),
          _buildServiceRow(
            'Mobile Sync Gateway',
            'Moderate Load',
            0.4,
            const Color(0xFF005EB8),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Color(0xFFBA1A1A)),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Latent Latency Warning',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Queue 4 experiencing +2s delay',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(
    String title,
    String status,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.bar_chart, 'Status', isActive: true),
          _buildNavItem(Icons.mic, 'Symptoms'),
          _buildNavItem(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE0F0FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: isActive ? const Color(0xFF00478D) : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            color: isActive ? const Color(0xFF00478D) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
