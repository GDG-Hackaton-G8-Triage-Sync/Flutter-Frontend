import 'dart:ui';
import 'package:flutter/material.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              children: [
                _buildPatientCard(
                  id: '#TS-9421',
                  name: 'Sarah J. Miller',
                  symptoms:
                      'Severe chest pain, radiating to left arm, dyspnea.',
                  urgencyScore: 98,
                  status: 'IMMEDIATE',
                  color: const Color(0xFFBA1A1A), // Red
                ),
                _buildPatientCard(
                  id: '#TS-9428',
                  name: 'Robert Chen',
                  symptoms: 'Suspected deep vein thrombosis, localized...',
                  urgencyScore: 84,
                  status: 'HIGH RISK',
                  color: const Color(0xFFF9A825), // Orange/Yellow
                  bgColor: const Color(0xFFFFF8E1),
                  textColor: const Color(0xFFF57F17),
                ),
                _buildPatientCard(
                  id: '#TS-9430',
                  name: 'Emma Watson',
                  symptoms:
                      'High fever (103.4F), persistent vomiting, lethargy.',
                  urgencyScore: 79,
                  status: 'HIGH RISK',
                  color: const Color(0xFFF9A825),
                  bgColor: const Color(0xFFFFF8E1),
                  textColor: const Color(0xFFF57F17),
                ),
                _buildPatientCard(
                  id: '#TS-9433',
                  name: 'David Thompson',
                  symptoms: 'Possible fracture, wrist deformity, pain...',
                  urgencyScore: 45,
                  status: 'STANDARD',
                  color: const Color(0xFF005EB8), // Blue
                  bgColor: const Color(0xFFD6E4FF),
                  textColor: const Color(0xFF00478D),
                ),
                _buildPatientCard(
                  id: '#TS-9435',
                  name: 'Elena Rodriguez',
                  symptoms: 'Abdominal discomfort, nausea, previous history...',
                  urgencyScore: 41,
                  status: 'STANDARD',
                  color: const Color(0xFF005EB8),
                  bgColor: const Color(0xFFD6E4FF),
                  textColor: const Color(0xFF00478D),
                ),
                _buildPatientCard(
                  id: '#TS-9440',
                  name: 'Kevin Baxter',
                  symptoms:
                      'Prescription refill request, routine blood sugar...',
                  urgencyScore: 12,
                  status: 'STABLE',
                  color: const Color(0xFF146C2E), // Green
                  bgColor: const Color(0xFFC4EED0),
                  textColor: const Color(0xFF146C2E),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF00478D),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      bottomSheet: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF7F9FB).withValues(alpha: 0.8),
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text(
              'LIVE QUEUE',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              '24 Patients',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF005EB8),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(Icons.notifications, color: Color(0xFF005EB8)),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.sort, color: Colors.grey, size: 20),
              SizedBox(width: 8),
              Text(
                'URGENCY PRIORITY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDAD6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '4 CRITICAL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFBA1A1A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E4FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '12 STABLE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00478D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard({
    required String id,
    required String name,
    required String symptoms,
    required int urgencyScore,
    required String status,
    required Color color,
    Color? bgColor,
    Color? textColor,
  }) {
    bgColor ??= const Color(0xFFFFDAD6);
    textColor ??= const Color(0xFFBA1A1A);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
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
                        Row(
                          children: [
                            Text(
                              id,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
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
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              urgencyScore.toString(),
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: color,
                                height: 1.0,
                              ),
                            ),
                            const Text(
                              'URGENCY',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      symptoms,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF44474E),
                        fontStyle: FontStyle.italic,
                      ),
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
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.bar_chart, 'Status', isActive: true),
          _buildNavItem(Icons.mic_none, 'Symptoms'),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFD6E4FF) : Colors.transparent,
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
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF00478D) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
