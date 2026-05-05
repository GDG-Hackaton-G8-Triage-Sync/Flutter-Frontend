import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';
import 'package:flutter_frontend/core/services/session_service.dart';
import 'package:flutter_frontend/core/services/websocket_manager.dart';
import 'package:flutter_frontend/core/error/api_error_mapper.dart';
import 'package:flutter_frontend/core/presentation/widgets/state_visuals.dart';
import 'package:flutter_frontend/features/patient/presentation/pages/triage_history_screen.dart';

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
  final PatientQueueSnapshot? queue;
  StatusData({required this.triage, this.analytics, this.queue});
}

class _StatusScreenState extends State<StatusScreen> {
  final SessionService _sessionService = SessionService();
  final BackendService _backend = BackendService.instance;

  // Hold the future so we can re-create it when we need to refresh
  late Future<StatusData?> _future;
  StreamSubscription<TriageItem>? _wsSub;
  StreamSubscription<Map<String, dynamic>>? _eventSub;

  @override
  void initState() {
    super.initState();
    _future = _loadLatest();
    _wsSub = WebSocketManager.instance.updates.listen((_) {
      if (mounted) {
        _refresh();
      }
    });
    _eventSub = WebSocketManager.instance.events.listen((event) {
      if (mounted && _shouldRefreshForEvent(event)) {
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
    _eventSub?.cancel();
    super.dispose();
  }

  Future<StatusData?> _loadLatest() async {
    final email = await _sessionService.getEmail();
    if (email == null || email.isEmpty) return null;

    final current = await _backend.getCurrentPatientSubmission();
    final history = await _backend.getPatientHistory();

    TriageItem? historyLatest;
    if (history.isNotEmpty) {
      history.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      historyLatest = history.first;
    }

    final latest = _selectBestTriage(
      current: current,
      historyLatest: historyLatest,
    );
    if (latest == null) return null;

    final queue = await _backend.getPatientQueue();

    WaitingAnalytics? analytics;
    if (latest.status == 'waiting' && queue == null) {
      try {
        analytics = await _backend.getWaitingAnalytics(latest.id);
      } catch (_) {}
    }

    return StatusData(triage: latest, analytics: analytics, queue: queue);
  }

  void _refresh() => setState(() => _future = _loadLatest());

  bool _shouldRefreshForEvent(Map<String, dynamic> event) {
    final type = (event['type'] ?? event['event_type'] ?? '')
        .toString()
        .toLowerCase();
    final relevantTypes = <String>{
      'triage_created',
      'patient_created',
      'triage_updated',
      'status_changed',
      'priority_update',
      'critical_alert',
      'sla_breach',
      'triage_event',
      'queue_snapshot',
      'queue_updated',
      'queue_changed',
      'waitlist_updated',
      'patient_updated',
    };

    if (relevantTypes.contains(type)) {
      return true;
    }

    final data = event['data'];
    if (data is Map<String, dynamic>) {
      return data.containsKey('triage_item') ||
          data.containsKey('queue_position') ||
          data.containsKey('estimated_wait_minutes') ||
          data.containsKey('status') ||
          data.containsKey('priority');
    }

    return false;
  }

  bool _looksPlaceholder(TriageItem item) {
    final condition = item.condition.trim().toLowerCase();
    final description = item.description.trim().toLowerCase();
    return item.id <= 0 ||
        item.priority >= 5 &&
            (condition == 'unknown' ||
                condition.isEmpty ||
                description.isEmpty);
  }

  TriageItem? _selectBestTriage({
    TriageItem? current,
    TriageItem? historyLatest,
  }) {
    if (historyLatest == null) return current;
    if (current == null) return historyLatest;
    if (_looksPlaceholder(current) && !_looksPlaceholder(historyLatest)) {
      return historyLatest;
    }
    if (historyLatest.createdAt.isAfter(current.createdAt)) {
      return historyLatest;
    }
    return current;
  }

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
      case 'completed':
        return const Color(0xFF146C2E);
      case 'canceled':
        return const Color(0xFF73777F);
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

  String _queueStatusLabel(String status) {
    switch (status) {
      case 'waiting':
        return 'Waiting';
      case 'in_progress':
        return 'Being Seen';
      case 'completed':
        return 'Completed';
      case 'canceled':
        return 'Canceled';
      default:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }

  Color _slaColor(String slaStatus) {
    switch (slaStatus) {
      case 'critical':
        return const Color(0xFFBA1A1A);
      case 'warning':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFF146C2E);
    }
  }

  Widget _buildQueueHero({
    required TriageItem triage,
    required PatientQueueSnapshot? queue,
    required WaitingAnalytics? analytics,
  }) {
    final liveQueue = queue != null;
    final queueSnapshot = queue;
    final queuePosition = queue?.position ?? analytics?.position ?? 1;
    final patientsAhead = queue?.aheadOfYou ?? analytics?.totalWaiting ?? 1;
    final patientsBehind = queue?.behindYou ?? 0;
    final etaLabel = queue?.etaLabel ?? _waitEstimate(triage.priority);
    final statusLabel = liveQueue
        ? _queueStatusLabel(queueSnapshot?.status ?? triage.status)
        : triage.status == 'waiting'
        ? 'Waiting'
        : triage.status.replaceAll('_', ' ').toUpperCase();
    final progress = (queue?.progressPercent ?? 0).clamp(0, 100) / 100;
    final slaColor = liveQueue
        ? _slaColor(queueSnapshot?.slaStatus ?? 'normal')
        : _priorityColor(triage.priority);
    final currentStep = queue?.currentStep ?? 'Waiting for live queue data';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF003366),
            const Color(0xFF005EB8).withValues(alpha: 0.92),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003366).withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  liveQueue ? 'LIVE QUEUE SNAPSHOT' : 'LIVE ESTIMATE',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: slaColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  liveQueue ? queue.slaStatus.toUpperCase() : 'ESTIMATED',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR POSITION',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#$queuePosition',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      liveQueue
                          ? 'This is your current position in the live backend queue.'
                          : 'This is a priority-based estimate until live queue data arrives.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'STATUS',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      statusLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Priority ${triage.priority} • ${_priorityLabel(triage.priority)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            triage.condition,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _summaryTile(
                  icon: Icons.people_alt_outlined,
                  color: Colors.white,
                  label: 'Patients ahead',
                  value: '$patientsAhead',
                  note: 'People still waiting before you',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryTile(
                  icon: Icons.hourglass_bottom,
                  color: Colors.white,
                  label: 'ETA',
                  value: etaLabel,
                  note: 'From the live queue engine',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            valueColor: AlwaysStoppedAnimation<Color>(slaColor),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${queue?.progressPercent ?? 0}% through this triage cycle',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$patientsBehind behind you',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currentStep,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (liveQueue) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: queue.steps.map((step) {
                final isCurrent = step == queue.currentStep;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isCurrent
                          ? Colors.white.withValues(alpha: 0.35)
                          : Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    step,
                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: isCurrent ? 1 : 0.8,
                      ),
                      fontSize: 11,
                      fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTerminalHero(TriageItem triage) {
    final completedAt =
        triage.completedAt ?? triage.verifiedAt ?? triage.createdAt;
    final statusColor = _priorityColor(triage.priority);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'CURRENT TRIAGE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: Color(0xFF73777F),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(triage.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  triage.status.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(triage.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            triage.condition,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            triage.description,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF44474E),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _summaryTile(
                  icon: Icons.local_fire_department_outlined,
                  color: statusColor,
                  label: 'Priority',
                  value: 'P${triage.priority}',
                  note: _priorityLabel(triage.priority),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryTile(
                  icon: Icons.event_available_outlined,
                  color: const Color(0xFF005EB8),
                  label: 'Updated',
                  value: completedAt.toLocal().toString().substring(0, 16),
                  note: triage.status == 'completed'
                      ? 'This triage is in history now'
                      : 'Latest lifecycle update',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            triage.status == 'completed'
                ? 'This triage is complete. Check the Triage History screen for the archived result.'
                : 'This triage is not active in the live queue right now.',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF5F6368),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
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
              label: const Text('View Triage History'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelSubmission() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel triage?'),
        content: const Text(
          'This will remove your submission from the active queue. You can still view it in history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep waiting'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel triage'),
          ),
        ],
      ),
    );

    if (shouldCancel != true) return;

    try {
      await _backend.cancelCurrentPatientSubmission();
      _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your triage has been canceled.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to cancel triage right now.')),
      );
    }
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
        final queue = data.queue;

        return RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (result.status == 'waiting' || result.status == 'in_progress') ...[
                _buildQueueHero(
                  triage: result,
                  queue: queue,
                  analytics: analytics,
                ),
                const SizedBox(height: 12),
              ] else ...[
                _buildTerminalHero(result),
                const SizedBox(height: 12),
              ],

              const SizedBox(height: 12),
              if (result.status == 'waiting')
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _cancelSubmission,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancel Triage'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFBA1A1A),
                      side: const BorderSide(color: Color(0xFFBA1A1A)),
                    ),
                  ),
                ),
              const SizedBox(height: 24),

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
}
