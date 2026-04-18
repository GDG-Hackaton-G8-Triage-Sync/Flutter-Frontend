import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/backend_service.dart';
import '../screens/patient/hospital_info_screen.dart';

class PatientHomeTab extends StatefulWidget {
  final String name;
  final String email;
  final VoidCallback onStartTriage;

  const PatientHomeTab({
    super.key,
    required this.name,
    required this.email,
    required this.onStartTriage,
  });

  @override
  State<PatientHomeTab> createState() => _PatientHomeTabState();
}

class _PatientHomeTabState extends State<PatientHomeTab> {
  TriageItem? _latestTriage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLatest();
  }

  Future<void> _loadLatest() async {
    try {
      final items = await BackendService.instance.getPatientSubmissionsByEmail(widget.email);
      if (items.isNotEmpty) {
        // Sort by date to get the absolute latest if the backend doesn't
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (mounted) {
          setState(() {
            _latestTriage = items.first;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildLatestStatusCard(),
        const SizedBox(height: 24),
        _buildActionGrid(),
        const SizedBox(height: 24),
        _buildHealthInsight(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning,',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              widget.name.isNotEmpty ? widget.name : 'Patient',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF002D57),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Badge(
            label: Text('2'),
            child: Icon(Icons.notifications_none_outlined, color: Color(0xFF005EB8)),
          ),
        ),
      ],
    );
  }

  Widget _buildLatestStatusCard() {
    if (_isLoading) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_latestTriage == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF005EB8), Color(0xFF00478D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF005EB8).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(Icons.medical_services_outlined, color: Colors.white, size: 32),
            const SizedBox(height: 12),
            const Text(
              'No Active Triage Session',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Start a session if you feel unwell',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.onStartTriage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF005EB8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Start Triage Now'),
            ),
          ],
        ),
      );
    }

    final status = _latestTriage!.status;
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Current Triage Status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              _statusBadge(status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.assignment_ind, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _latestTriage!.condition,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      'Priority ${_latestTriage!.priority} • Triage #${_latestTriage!.id}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: status == 'waiting' ? 0.3 : (status == 'in_progress' ? 0.7 : 1.0),
            backgroundColor: Colors.grey[100],
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 12),
          Text(
            _getStatusMessage(status),
            style: TextStyle(fontSize: 12, color: Colors.grey[700], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _actionTile(
              'New Triage',
              Icons.add_moderator,
              const Color(0xFF005EB8),
              widget.onStartTriage,
            ),
            _actionTile(
              'Hospital Info',
              Icons.location_on_outlined,
              const Color(0xFF146C2E),
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HospitalInfoScreen()),
              ),
            ),
            _actionTile(
              'Emergency',
              Icons.emergency_outlined,
              const Color(0xFFBA1A1A),
              () => _showEmergencyDialog(context),
            ),
            _actionTile(
              'Lab Results',
              Icons.biotech_outlined,
              const Color(0xFFFF8F00),
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new lab results available at this time.')),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('EMERGENCY HOTLINE', style: TextStyle(color: Color(0xFFBA1A1A), fontWeight: FontWeight.bold)),
        content: const Text('Do you want to dial the Hospital Emergency Dispatch (911)?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBA1A1A)),
            child: const Text('DIAL NOW', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthInsight() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F0FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Color(0xFF005EB8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Health Tip: Hydration',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF002D57)),
                ),
                Text(
                  'Drinking 8 glasses of water daily keeps your immune system ready.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'waiting': return const Color(0xFFF57C00);
      case 'in_progress': return const Color(0xFF005EB8);
      case 'completed': return const Color(0xFF146C2E);
      default: return Colors.grey;
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'waiting': return 'Physician has received your data and is reviewing.';
      case 'in_progress': return 'A nurse is currently preparing your clinical plan.';
      case 'completed': return 'Session complete. Take-home notes available.';
      default: return '';
    }
  }

  Widget _statusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
