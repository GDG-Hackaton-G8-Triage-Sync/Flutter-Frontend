import 'package:flutter/material.dart';

class CommandCenterScreen extends StatelessWidget {
  const CommandCenterScreen({
    super.key,
    required this.totalPatients,
    required this.waiting,
    required this.inProgress,
    required this.criticalCases,
  });

  final int totalPatients;
  final int waiting;
  final int inProgress;
  final int criticalCases;

  @override
  Widget build(BuildContext context) {
    final slaBreaches = waiting > 0 ? (waiting / 3).ceil() : 0;
    final backlogRisk = waiting >= 10
        ? 'High'
        : waiting >= 5
        ? 'Medium'
        : 'Low';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Command Center',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MetricTile(
            icon: Icons.groups_2_outlined,
            title: 'Total Active Queue',
            value: '$totalPatients',
            color: const Color(0xFF005EB8),
          ),
          const SizedBox(height: 12),
          _MetricTile(
            icon: Icons.timer_outlined,
            title: 'Waiting Patients',
            value: '$waiting',
            color: const Color(0xFFBA1A1A),
          ),
          const SizedBox(height: 12),
          _MetricTile(
            icon: Icons.local_fire_department_outlined,
            title: 'Critical Cases (P1)',
            value: '$criticalCases',
            color: const Color(0xFF8B1A1A),
          ),
          const SizedBox(height: 12),
          _MetricTile(
            icon: Icons.warning_amber_rounded,
            title: 'SLA Breaches (> 30 mins)',
            value: '$slaBreaches',
            color: const Color(0xFFF57C00),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operational Assessment',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1C1E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Backlog Risk: $backlogRisk\nIn Progress: $inProgress\nRecommended action: route one additional nurse to intake if waiting exceeds 8.',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF44474E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, color: Color(0xFF44474E)),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
