import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';
import 'package:flutter_frontend/core/services/session_service.dart';
import 'package:flutter_frontend/core/services/websocket_manager.dart';
import 'package:flutter_frontend/core/error/api_error_mapper.dart';
import 'package:flutter_frontend/core/presentation/widgets/state_visuals.dart';
import 'package:flutter_frontend/features/patient/presentation/pages/triage_history_screen.dart';
import 'package:flutter_frontend/features/patient/presentation/pages/timeline_screen.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, this.refreshTrigger = 0});

  /// Increment this from the parent to force a data reload.
  final int refreshTrigger;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class StatusData {
  final TriageItem triage;
  final WaitingAnalytics? analytics;
  StatusData({required this.triage, this.analytics});
}

class _StatusScreenState extends State<StatusScreen> {
  final SessionService _sessionService = SessionService();
  final BackendService _backend = BackendService.instance;

  // Hold the future so we can re-create it when we need to refresh
  late Future<StatusData?> _future;
  StreamSubscription<TriageItem>? _wsSub;

  @override
  void initState() {
    super.initState();
    _future = _loadLatest();
    _wsSub = WebSocketManager.instance.updates.listen((_) {
      if (mounted) {
        _refresh();
      }
    });
  }

  @override
  void didUpdateWidget(StatusScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild the future whenever the parent bumps refreshTrigger
    if (oldWidget.refreshTrigger != widget.refreshTrigger) {
      setState(() => _future = _loadLatest());
    }
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    super.dispose();
  }

  Future<StatusData?> _loadLatest() async {
    final email = await _sessionService.getEmail();
    if (email == null || email.isEmpty) return null;

    final latest = await _backend.getCurrentPatientSubmission();
    if (latest == null) return null;

    WaitingAnalytics? analytics;
    if (latest.status == 'waiting') {
      try {
        analytics = await _backend.getWaitingAnalytics(latest.id);
      } catch (_) {}
    }

    return StatusData(triage: latest, analytics: analytics);
  }

  void _refresh() => setState(() => _future = _loadLatest());

  String _waitEstimate(int priority) {
    switch (priority) {
      case 1:
        return 'Immediate';
      case 2:
        return '10-15 min';
      case 3:
        return '20-35 min';
      case 4:
        return '35-50 min';
      default:
        return '45-60 min';
    }
  }

  Color _priorityColor(int priority) {
    if (priority <= 1) return const Color(0xFFBA1A1A);
    if (priority == 2) return const Color(0xFFF57C00);
    if (priority == 3) return const Color(0xFF005EB8);
    return const Color(0xFF146C2E);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'waiting':
        return const Color(0xFFBA1A1A);
      case 'in_progress':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFF146C2E);
    }
  }

  String _priorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'Critical';
      case 2:
        return 'Urgent';
      case 3:
        return 'Semi-urgent';
      case 4:
        return 'Non-urgent';
      default:
        return 'Routine';
    }
  }

  String _confidenceText(double? confidence) {
    if (confidence == null || !confidence.isFinite) {
      return 'Pending';
    }
    return '${(confidence.clamp(0.0, 1.0) * 100).toStringAsFixed(0)}%';
  }

  Widget _summaryTile({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    String? note,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EBF0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF73777F),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1C1E),
                  ),
                ),
                if (note != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    note,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSnapshot(TriageItem result, WaitingAnalytics? analytics) {
    final confidence = result.confidence ?? analytics?.aiConfidence;
    final queuePosition = analytics?.position;
    final patientsAhead = analytics?.totalWaiting;
    final estimatedWait = analytics?.estimatedWaitMins ?? _waitEstimate(result.priority);
    final assignedStaff = result.assignedStaffName;
    final recommendedAction = result.recommendedAction;
    final reason = result.reasoning ?? result.reason;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'YOUR STATUS AT A GLANCE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Color(0xFF73777F),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width > 420
                  ? (MediaQuery.of(context).size.width - 56) / 2
                  : double.infinity,
              child: _summaryTile(
                icon: Icons.local_fire_department_outlined,
                color: _priorityColor(result.priority),
                label: 'Priority',
                value: '${result.priority} - ${_priorityLabel(result.priority)}',
                note: 'Assigned by the triage engine',
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width > 420
                  ? (MediaQuery.of(context).size.width - 56) / 2
                  : double.infinity,
              child: _summaryTile(
                icon: Icons.queue_outlined,
                color: const Color(0xFF005EB8),
                label: 'Queue Position',
                value: queuePosition != null ? '#$queuePosition' : 'Waiting',
                note: patientsAhead != null
                    ? '$patientsAhead patient(s) ahead'
                    : 'Queue position is updating',
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width > 420
                  ? (MediaQuery.of(context).size.width - 56) / 2
                  : double.infinity,
              child: _summaryTile(
                icon: Icons.access_time_outlined,
                color: const Color(0xFFF57C00),
                label: 'Estimated Wait',
                value: analytics != null
                  ? '$estimatedWait min'
                    : _waitEstimate(result.priority),
                note: result.status == 'waiting'
                    ? 'Based on your priority and live queue load'
                    : 'This is the latest treatment estimate',
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width > 420
                  ? (MediaQuery.of(context).size.width - 56) / 2
                  : double.infinity,
              child: _summaryTile(
                icon: Icons.verified_outlined,
                color: const Color(0xFF00897B),
                label: 'AI Confidence',
                value: _confidenceText(confidence),
                note: 'How sure the system is about your triage result',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (assignedStaff != null && assignedStaff.isNotEmpty)
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline, color: Color(0xFF005EB8)),
              title: const Text(
                'Assigned Staff',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(assignedStaff),
            ),
          ),
        if (recommendedAction != null && recommendedAction.isNotEmpty)
          Card(
            child: ListTile(
              leading: const Icon(Icons.medical_services_outlined, color: Color(0xFF005EB8)),
              title: const Text(
                'Recommended Next Step',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(recommendedAction),
            ),
          ),
        if (reason != null && reason.isNotEmpty)
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF005EB8)),
              title: const Text(
                'Why this priority?',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(reason),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StatusData?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          final message = ApiErrorMapper.toUserMessage(
            snapshot.error!,
            fallbackMessage: 'Cannot connect to clinical server.',
          );
          return StateVisual(
            icon: Icons.wifi_off_rounded,
            iconColor: const Color(0xFFBA1A1A),
            title: 'Connection Issue',
            message: message,
            actions: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('RETRY CONNECTION'),
                ),
              ),
            ],
          );
        }

        final data = snapshot.data;
        if (data == null) {
          return EmptyState(
            icon: Icons.assignment_outlined,
            title: 'No Pending Triage',
            message:
                'You have no active triage sessions. Submit your symptoms in the Triage tab to get a priority assessment from our clinical engine.',
            actionLabel: 'OPEN HISTORY',
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TriageHistoryScreen()),
              );
            },
          );
        }

        final result = data.triage;
        final analytics = data.analytics;
        final priorityColor = _priorityColor(result.priority);
        final statusColor = _statusColor(result.status);

        return RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // AI Live Forecast Card (The "Wow" Factor)
              if (result.status == 'waiting' && analytics != null)
                _buildAIForecast(analytics),

              const SizedBox(height: 12),

              // Priority Hero Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: priorityColor.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority accent bar
                    Container(height: 5, color: priorityColor),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'TRIAGE PRIORITY',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      color: Color(0xFF73777F),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Priority ${result.priority}',
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: priorityColor,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  result.status
                                      .replaceAll('_', ' ')
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            result.condition,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1C1E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF44474E),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Urgency score bar
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'URGENCY SCORE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Color(0xFF73777F),
                                    ),
                                  ),
                                  Text(
                                    '${result.urgencyScore}/100',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: priorityColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: result.urgencyScore / 100,
                                  minHeight: 8,
                                  backgroundColor: const Color(0xFFF2F4F6),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    priorityColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PatientTimelineScreen(item: result),
                                ),
                              ),
                              icon: const Icon(
                                Icons.timeline_outlined,
                                size: 16,
                              ),
                              label: const Text(
                                'VIEW LIVE CARE TIMELINE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: priorityColor,
                                backgroundColor: priorityColor.withValues(
                                  alpha: 0.1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusSnapshot(result, analytics),
              const SizedBox(height: 24),

              // Wait time
              Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F0FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.access_time_outlined,
                      color: Color(0xFF005EB8),
                    ),
                  ),
                  title: const Text(
                    'Estimated Wait',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(_waitEstimate(result.priority)),
                ),
              ),

              // Submitted at
              Card(
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F0FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF005EB8),
                    ),
                  ),
                  title: const Text(
                    'Submitted At',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    result.createdAt.toLocal().toString().substring(0, 16),
                  ),
                ),
              ),

              // Photo attachment
              if (result.photoName != null && result.photoName!.isNotEmpty)
                Card(
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F0FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.photo_outlined,
                        color: Color(0xFF005EB8),
                      ),
                    ),
                    title: const Text(
                      'Attached Photo',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(result.photoName!),
                  ),
                ),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TriageHistoryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history_outlined),
                  label: const Text('View Full Triage History'),
                ),
              ),
              const SizedBox(height: 4),
              // Refresh hint
              Center(
                child: TextButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Pull to refresh or tap here'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF73777F),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAIForecast(WaitingAnalytics analytics) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003366), Color(0xFF005EB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003366).withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LIVE AI FORECAST',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(analytics.aiConfidence * 100).toInt()}% SURE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Queue Position',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${analytics.position}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Est. Wait Time',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${analytics.estimatedWaitMins}m',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white70, size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    analytics.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
