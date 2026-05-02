import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';

class CommandCenterScreen extends StatefulWidget {
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
  State<CommandCenterScreen> createState() => _CommandCenterScreenState();
}

class _CommandCenterScreenState extends State<CommandCenterScreen> {
  final BackendService _backend = BackendService.instance;
  AdminOverview? _overview;
  AdminAnalytics? _analytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _backend.getAdminOverview(),
        _backend.getAdminAnalytics(),
      ]);

      if (mounted) {
        setState(() {
          _overview = results[0] as AdminOverview;
          _analytics = results[1] as AdminAnalytics;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use latest overview if available, otherwise fall back to initial widget props
    final totalPatients = _overview?.totalPatients ?? widget.totalPatients;
    final waiting = _overview?.waiting ?? widget.waiting;
    final inProgress = _overview?.inProgress ?? widget.inProgress;
    final criticalCases = _overview?.criticalCases ?? widget.criticalCases;
    final slaBreachesCount = _overview?.slaBreaches ?? 0;
    final backlogRisk = _overview?.backlogRisk ?? (waiting >= 10 ? 'HIGH' : waiting >= 5 ? 'MEDIUM' : 'LOW');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Command Center',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadAll,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF005EB8)),
            tooltip: 'Refresh Data',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.groups_2_outlined,
                        title: 'Active Queue',
                        value: '$totalPatients',
                        color: const Color(0xFF005EB8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.loop_outlined,
                        title: 'In Progress',
                        value: '$inProgress',
                        color: const Color(0xFFF57C00),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.timer_outlined,
                        title: 'Waiting',
                        value: '$waiting',
                        color: const Color(0xFFBA1A1A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.local_fire_department_outlined,
                        title: 'Critical (P1)',
                        value: '$criticalCases',
                        color: const Color(0xFF8B1A1A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.warning_amber_rounded,
                        title: 'SLA Breaches',
                        value: '$slaBreachesCount',
                        color: const Color(0xFFBA1A1A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildChartCard(
                  title: 'Wait Time Trends (Last 12h)',
                  subtitle: 'Average time from intake to clinical review',
                  chart: _buildWaitTimeChart(),
                ),
                const SizedBox(height: 16),
                _buildChartCard(
                  title: 'SLA Breach Velocity',
                  subtitle: 'Frequency of incidents exceeding 30m target',
                  chart: _buildSLABreachChart(),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          (backlogRisk.toUpperCase() == 'HIGH'
                                  ? const Color(0xFFBA1A1A)
                                  : Colors.transparent)
                              .withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.analytics_rounded,
                            color: backlogRisk.toUpperCase() == 'HIGH'
                                ? const Color(0xFFBA1A1A)
                                : const Color(0xFF005EB8),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'AI Operational Intelligence',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1C1E),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Operational Level: ${backlogRisk.toUpperCase()} RISK\n'
                        'Unit saturation at ${(totalPatients / 25 * 100).toStringAsFixed(0)}%. '
                        'Recommended: deploy rapid-response clinical nurse to intake desk.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                        ),
                      ),
                      if (backlogRisk.toUpperCase() == 'HIGH') ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(0xFFBA1A1A),
                                  content: Text(
                                    'EMERGENCY BACKUP REQUESTED: Clinical Lead Notified.',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.bolt, color: Colors.white),
                            label: const Text('DEPLOY RAPID RESPONSE TEAM'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBA1A1A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget chart,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Color(0xFF003366),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          SizedBox(height: 180, child: chart),
        ],
      ),
    );
  }

  Widget _buildWaitTimeChart() {
    if (_analytics == null || _analytics!.waitTimeTrend.isEmpty) {
      return const SizedBox();
    }
    final points = _analytics!.waitTimeTrend;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (v) =>
              FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: points
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                .toList(),
            isCurved: true,
            color: const Color(0xFF005EB8),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF005EB8).withValues(alpha: 0.2),
                  const Color(0xFF005EB8).withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSLABreachChart() {
    if (_analytics == null || _analytics!.slaBreachTrend.isEmpty) {
      return const SizedBox();
    }
    final points = _analytics!.slaBreachTrend;

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: points
            .asMap()
            .entries
            .map(
              (e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value.value,
                    color: const Color(0xFFBA1A1A),
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            )
            .toList(),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
