import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/api_models.dart';
import '../../services/backend_service.dart';
import '../../services/session_service.dart';
import '../../services/websocket/websocket_manager.dart';
import '../../widgets/state_visuals.dart';
import '../login_screen.dart';
import 'patient_detail_screen.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  final BackendService _backend = BackendService.instance;
  final SessionService _session = SessionService();
  final TextEditingController _statusFilterController = TextEditingController();

  List<TriageItem> _patients = <TriageItem>[];
  bool _isLoading = true;
  String? _error;
  Timer? _poller;
  StreamSubscription<TriageItem>? _wsSub;

  // Priority filter
  int? _selectedPriority;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
    // Poll every 5 seconds as a fallback
    _poller = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _fetchPatients(silent: true),
    );
    // Real-time WebSocket updates
    WebSocketManager.instance.connect();
    _wsSub = WebSocketManager.instance.updates.listen((_) {
      _fetchPatients(silent: true);
    });
  }

  Future<void> _fetchPatients({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final items = await _backend.getStaffPatients(
        priority: _selectedPriority,
        status: _statusFilterController.text.trim().isEmpty
            ? null
            : _statusFilterController.text.trim(),
      );

      items.sort((a, b) => b.urgencyScore.compareTo(a.urgencyScore));

      if (!mounted) return;
      setState(() {
        _patients = items;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load queue from backend.';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(TriageItem item, String status) async {
    try {
      await _backend.updatePatientStatus(id: item.id, status: status);
      await _fetchPatients(silent: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient #${item.id} updated to $status.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Status update failed.')));
    }
  }

  Future<void> _logout() async {
    await _session.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _poller?.cancel();
    _wsSub?.cancel();
    _statusFilterController.dispose();
    super.dispose();
  }

  Color _priorityColor(int priority) {
    if (priority <= 1) return const Color(0xFFBA1A1A);
    if (priority == 2) return const Color(0xFFF57C00);
    if (priority == 3) return const Color(0xFF005EB8);
    return const Color(0xFF146C2E);
  }


  void _navigateToDetail(TriageItem patient) async {
    final updated = await Navigator.push<TriageItem>(
      context,
      MaterialPageRoute(builder: (_) => PatientDetailScreen(patient: patient)),
    );
    // Refresh if the patient was updated in detail view
    if (updated != null || mounted) {
      await _fetchPatients(silent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final waiting = _patients.where((p) => p.status == 'waiting').length;
    final inProgress = _patients.where((p) => p.status == 'in_progress').length;
    final total = _patients.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'INTAKE COMMAND',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Color(0xFF73777F),
                letterSpacing: 1.5,
              ),
            ),
            const Text(
              'Emergency Unit D-4',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF003366),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _fetchPatients(),
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF005EB8)),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF005EB8)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildQuickStatsStrip(waiting, inProgress, total),
          _buildFilterBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? _buildErrorView()
                : _patients.isEmpty
                ? _buildEmptyView()
                : RefreshIndicator(
                    onRefresh: _fetchPatients,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _patients.length,
                      itemBuilder: (context, index) => _buildPatientRow(_patients[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsStrip(int waiting, int inProgress, int critical) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('WAITING', waiting, const Color(0xFFBA1A1A)),
          _statItem('ACTIVE', inProgress, const Color(0xFF005EB8)),
          _statItem('CRITICAL', critical, const Color(0xFF8B1A1A)),
        ],
      ),
    );
  }

  Widget _statItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.0),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _priorityFilterChip(null, 'All Priorities'),
            const SizedBox(width: 8),
            _priorityFilterChip(1, 'Critical (P1)'),
            const SizedBox(width: 8),
            _priorityFilterChip(2, 'Urgent (P2)'),
            const SizedBox(width: 8),
            _priorityFilterChip(3, 'Routine'),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientRow(TriageItem patient) {
    final color = _priorityColor(patient.priority);
    final waitingTime = DateTime.now().difference(patient.createdAt).inMinutes;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(patient),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'P${patient.priority}',
                        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.condition.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Color(0xFF003366),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          patient.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${waitingTime}m',
                        style: TextStyle(
                          color: waitingTime > 20 ? const Color(0xFFBA1A1A) : const Color(0xFF44474E),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const Text('WAIT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _statusIndicator(patient.status),
                  const Spacer(),
                  if (patient.status == 'waiting')
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () => _updateStatus(patient, 'in_progress'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.withValues(alpha: 0.1),
                          foregroundColor: color,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('BEGIN CARE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusIndicator(String status) {
    final isWaiting = status == 'waiting';
    final isInProgress = status == 'in_progress';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isWaiting ? Colors.red[50] : (isInProgress ? Colors.blue[50] : Colors.green[50]),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: isWaiting ? Colors.red[700] : (isInProgress ? Colors.blue[700] : Colors.green[700]),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(_error!),
          TextButton(onPressed: _fetchPatients, child: const Text('RETRY CONNECTION')),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return EmptyState(
      icon: Icons.done_all_rounded,
      title: 'Current Queue Clear',
      message: 'Excellent work! All patients in this unit have been processed. New intake assessments will appear here automatically.',
      actionLabel: 'REFRESH FEED',
      onAction: _fetchPatients,
    );
  }

  Widget _priorityFilterChip(int? priority, String label) {
    final isSelected = _selectedPriority == priority;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : const Color(0xFF44474E),
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _selectedPriority = priority);
        _fetchPatients();
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF005EB8),
      checkmarkColor: Colors.white,
      side: const BorderSide(color: Color(0xFFDDE4F0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      showCheckmark: false,
    );
  }
}
