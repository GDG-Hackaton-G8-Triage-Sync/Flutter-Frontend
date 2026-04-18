import 'dart:ui';
import 'package:flutter/material.dart';

import '../../models/api_models.dart';
import '../../services/backend_service.dart';

class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen({super.key, required this.patient});

  final TriageItem patient;

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  final BackendService _backend = BackendService.instance;
  bool _isUpdating = false;
  late TriageItem _patient;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
  }

  Color get _priorityColor {
    final p = _patient.priority;
    if (p <= 1) return const Color(0xFFBA1A1A);
    if (p == 2) return const Color(0xFFF57C00);
    if (p == 3) return const Color(0xFF005EB8);
    return const Color(0xFF146C2E);
  }

  String get _priorityLabel {
    switch (_patient.priority) {
      case 1:
        return 'Level 1: Critical';
      case 2:
        return 'Level 2: Urgent';
      case 3:
        return 'Level 3: Semi-Urgent';
      case 4:
        return 'Level 4: Non-Urgent';
      default:
        return 'Level 5: Routine';
    }
  }

  String get _waitEstimate {
    switch (_patient.priority) {
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

  Future<void> _updateStatus(String status) async {
    setState(() => _isUpdating = true);
    try {
      final updated = await _backend.updatePatientStatus(
        id: _patient.id,
        status: status,
      );
      if (!mounted) return;
      setState(() => _patient = updated);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Status updated to $status.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status.')),
      );
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  void _showOverridePriorityDialog() {
    showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Override Priority'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [1, 2, 3, 4, 5].map((p) {
                return ListTile(
                  title: Text('Priority $p'),
                  leading: Radio<int>(
                    value: p,
                    groupValue: _patient.priority,
                    onChanged: (_) => Navigator.pop(ctx),
                  ),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB).withValues(alpha: 0.8),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF005EB8)),
          onPressed: () => Navigator.pop(context, _patient),
        ),
        title: ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [Color(0xFF00478D), Color(0xFF005EB8)],
              ).createShader(bounds),
          child: const Text(
            'Patient Detail',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientHeader(),
            const SizedBox(height: 24),
            _buildPrioritySentinelCard(),
            const SizedBox(height: 24),
            _buildSymptomDescription(),
            const SizedBox(height: 32),
            // Status action buttons
            if (_isUpdating)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (_patient.status != 'in_progress')
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _updateStatus('in_progress'),
                    icon: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Start Treatment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005EB8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              if (_patient.status != 'in_progress')
                const SizedBox(height: 16),
              if (_patient.status != 'completed')
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _updateStatus('completed'),
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Mark as Attended',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF146C2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              if (_patient.status != 'completed') const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _showOverridePriorityDialog,
                  icon: const Icon(
                    Icons.edit_note,
                    color: Color(0xFF00478D),
                  ),
                  label: const Text(
                    'Override Priority',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00478D),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0E0E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _patient.status == 'waiting'
                    ? const Color(0xFF006D44).withValues(alpha: 0.15)
                    : _patient.status == 'in_progress'
                    ? const Color(0xFFF57C00).withValues(alpha: 0.15)
                    : const Color(0xFF005EB8).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _patient.status.toUpperCase().replaceAll('_', ' '),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _patient.status == 'waiting'
                      ? const Color(0xFF006D44)
                      : _patient.status == 'in_progress'
                      ? const Color(0xFFF57C00)
                      : const Color(0xFF005EB8),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'ID: #TS-${_patient.id}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF44474E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _patient.condition,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Submitted: ${_patient.createdAt.toLocal().toString().substring(0, 16)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF44474E),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySentinelCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00478D).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 6,
              child: Container(color: _priorityColor),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
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
                            'CURRENT URGENCY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _priorityLabel,
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1C1E),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_patient.urgencyScore}',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: _priorityColor,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            'SCORE /100',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _priorityColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Color(0xFF44474E),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Estimated wait: $_waitEstimate',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF44474E),
                        ),
                      ),
                    ],
                  ),
                  if (_patient.photoName != null &&
                      _patient.photoName!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.photo, size: 16, color: Color(0xFF44474E)),
                        const SizedBox(width: 8),
                        Text(
                          'Photo: ${_patient.photoName}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF44474E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.file_present, color: Color(0xFF005EB8), size: 20),
              SizedBox(width: 8),
              Text(
                'Symptom Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005EB8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _patient.description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1C1E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
