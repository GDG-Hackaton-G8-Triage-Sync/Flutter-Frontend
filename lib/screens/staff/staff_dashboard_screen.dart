import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/api_models.dart';
import '../../services/backend_service.dart';
import '../../services/session_service.dart';
import '../../services/websocket/websocket_manager.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status update failed.')),
      );
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

  String _priorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'P1 • Critical';
      case 2:
        return 'P2 • Urgent';
      case 3:
        return 'P3 • Semi-Urgent';
      case 4:
        return 'P4 • Low';
      default:
        return 'P5 • Routine';
    }
  }

  void _navigateToDetail(TriageItem patient) async {
    final updated = await Navigator.push<TriageItem>(
      context,
      MaterialPageRoute(
        builder: (_) => PatientDetailScreen(patient: patient),
      ),
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
    final critical = _patients.where((p) => p.priority == 1).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Staff Queue',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _fetchPatients(),
            icon: const Icon(Icons.refresh, color: Color(0xFF005EB8)),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Color(0xFF005EB8)),
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats summary bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                _statChip('Waiting', waiting, const Color(0xFFBA1A1A)),
                const SizedBox(width: 8),
                _statChip('Active', inProgress, const Color(0xFFF57C00)),
                const SizedBox(width: 8),
                _statChip('Critical', critical, const Color(0xFF8B1A1A)),
                const Spacer(),
                Text(
                  '${_patients.length} total',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF44474E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _statusFilterController,
                    decoration: InputDecoration(
                      labelText: 'Filter by status',
                      hintText: 'waiting / in_progress / completed',
                      prefixIcon: const Icon(Icons.filter_list),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _fetchPatients,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005EB8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Priority filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _priorityFilterChip(null, 'All'),
                const SizedBox(width: 8),
                _priorityFilterChip(1, 'P1 Critical'),
                const SizedBox(width: 8),
                _priorityFilterChip(2, 'P2 Urgent'),
                const SizedBox(width: 8),
                _priorityFilterChip(3, 'P3 Semi-Urgent'),
                const SizedBox(width: 8),
                _priorityFilterChip(4, 'P4 Low'),
                const SizedBox(width: 8),
                _priorityFilterChip(5, 'P5 Routine'),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _fetchPatients,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _patients.isEmpty
                ? const Center(
                    child: Text(
                      'No patients match the current filter.',
                      style: TextStyle(color: Color(0xFF44474E)),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchPatients,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _patients.length,
                      itemBuilder: (context, index) {
                        final patient = _patients[index];
                        return _buildPatientCard(patient);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(TriageItem patient) {
    final color = _priorityColor(patient.priority);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        onTap: () => _navigateToDetail(patient),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Patient #${patient.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C1E),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _priorityLabel(patient.priority),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                patient.condition,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00478D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                patient.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF44474E),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _statusChip(patient.status),
                  const Spacer(),
                  // Quick-action status buttons
                  _quickActionButton(
                    patient,
                    'waiting',
                    Icons.pause_circle_outline,
                    const Color(0xFF44474E),
                  ),
                  const SizedBox(width: 6),
                  _quickActionButton(
                    patient,
                    'in_progress',
                    Icons.play_circle_outline,
                    const Color(0xFFF57C00),
                  ),
                  const SizedBox(width: 6),
                  _quickActionButton(
                    patient,
                    'completed',
                    Icons.check_circle_outline,
                    const Color(0xFF146C2E),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickActionButton(
    TriageItem patient,
    String status,
    IconData icon,
    Color color,
  ) {
    final isActive = patient.status == status;
    return InkWell(
      onTap: isActive ? null : () => _updateStatus(patient, status),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? color : color.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'waiting':
        bg = const Color(0xFFFFDAD6);
        fg = const Color(0xFFBA1A1A);
        break;
      case 'in_progress':
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFF57C00);
        break;
      default:
        bg = const Color(0xFFD8F3DC);
        fg = const Color(0xFF146C2E);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _statChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
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
