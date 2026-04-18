import 'package:flutter/material.dart';

import '../../models/api_models.dart';
import '../../services/backend_service.dart';
import '../../services/session_service.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, this.refreshTrigger = 0});

  /// Increment this from the parent to force a data reload.
  final int refreshTrigger;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final SessionService _sessionService = SessionService();
  final BackendService _backend = BackendService.instance;

  // Hold the future so we can re-create it when we need to refresh
  late Future<TriageItem?> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadLatest();
  }

  @override
  void didUpdateWidget(StatusScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild the future whenever the parent bumps refreshTrigger
    if (oldWidget.refreshTrigger != widget.refreshTrigger) {
      setState(() => _future = _loadLatest());
    }
  }

  Future<TriageItem?> _loadLatest() async {
    final email = await _sessionService.getEmail();
    if (email == null || email.isEmpty) return null;

    final submissions = await _backend.getPatientSubmissionsByEmail(email);
    if (submissions.isEmpty) return null;

    submissions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return submissions.first;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TriageItem?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: 48,
                    color: Color(0xFF44474E),
                  ),
                  const SizedBox(height: 12),
                  const Text('Failed to load your status. Is the backend running?'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final result = snapshot.data;
        if (result == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F0FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      size: 40,
                      color: Color(0xFF005EB8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No triage submissions yet.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF00478D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Submit your symptoms to get your priority status.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF44474E)),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          );
        }

        final priorityColor = _priorityColor(result.priority);
        final statusColor = _statusColor(result.status);

        return RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

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
