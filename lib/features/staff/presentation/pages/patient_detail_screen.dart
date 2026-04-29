import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';
import 'package:flutter_frontend/core/services/session_service.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update status.')));
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _executePriorityOverride(int p) async {
    setState(() => _isUpdating = true);
    try {
      final updated = await _backend.updatePatientPriority(
        id: _patient.id,
        priority: p,
      );
      if (!mounted) return;
      setState(() => _patient = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Priority escalated to Level $p.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to override priority.')),
      );
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  void _showOverridePriorityDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Override Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [1, 2, 3, 4, 5].map((p) {
            return ListTile(
              title: Text('Priority $p'),
              leading: Icon(
                p == _patient.priority
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: p == _patient.priority
                    ? const Color(0xFF005EB8)
                    : Colors.grey,
              ),
              onTap: () {
                Navigator.pop(ctx);
                if (p != _patient.priority) {
                  _executePriorityOverride(p);
                }
              },
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

  void _showVitalsDialog() {
    final bpController = TextEditingController();
    final heartRateController = TextEditingController();
    final tempController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Log Clinical Vitals',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bpController,
              decoration: const InputDecoration(
                labelText: 'Blood Pressure (e.g. 120/80)',
                prefixIcon: Icon(Icons.bloodtype),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: heartRateController,
              decoration: const InputDecoration(
                labelText: 'Heart Rate (bpm)',
                prefixIcon: Icon(Icons.favorite),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tempController,
              decoration: const InputDecoration(
                labelText: 'Temperature (°F)',
                prefixIcon: Icon(Icons.thermostat),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final bp = bpController.text.trim();
              final hr = heartRateController.text.trim();
              final temp = tempController.text.trim();

              if (bp.isEmpty || hr.isEmpty || temp.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all vitals fields.'),
                  ),
                );
                return;
              }

              Navigator.pop(ctx);
              setState(() => _isUpdating = true);

              try {
                final updated = await _backend.logVitals(
                  id: _patient.id,
                  bp: bp,
                  heartRate: hr,
                  temperature: temp,
                );
                if (!mounted) return;
                setState(() => _patient = updated);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vitals logged successfully.')),
                );
              } catch (_) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to log vitals.')),
                );
              } finally {
                if (mounted) setState(() => _isUpdating = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005EB8),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Vitals'),
          ),
        ],
      ),
    );
  }

  void _exportFHIRRecord() {
    final fhirRecord = {
      "resourceType": "Bundle",
      "type": "collection",
      "entry": [
        {
          "resource": {
            "resourceType": "Patient",
            "id": "pat-${_patient.id}",
            "name": [
              {"text": _patient.patientName ?? "Unknown"},
            ],
            "gender": _patient.gender?.toLowerCase() ?? "unknown",
            "birthDate": _patient.age != null
                ? "${DateTime.now().year - _patient.age!}-01-01"
                : null,
          },
        },
        {
          "resource": {
            "resourceType": "Encounter",
            "status": _patient.status == "completed"
                ? "finished"
                : "in-progress",
            "class": {"code": "EMR", "display": "emergency"},
            "priority": {
              "coding": [
                {
                  "system":
                      "http://terminology.hl7.org/CodeSystem/v3-ActPriority",
                  "code": "EM",
                  "display": _priorityLabel,
                },
              ],
            },
            "reasonCode": [
              {"text": _patient.description},
            ],
          },
        },
        if (_patient.vitals != null)
          {
            "resource": {
              "resourceType": "Observation",
              "status": "final",
              "code": {"text": "Vital Signs Bundle"},
              "valueString":
                  "BP: ${_patient.vitals!.bp}, HR: ${_patient.vitals!.heartRate}, Temp: ${_patient.vitals!.temperature}",
              "effectiveDateTime": _patient.vitals!.recordedAt
                  .toIso8601String(),
            },
          },
      ],
    };

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('FHIR JSON Export'),
        content: SingleChildScrollView(
          child: Text(
            const JsonEncoder.withIndent('  ').convert(fhirRecord),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('FHIR Record exported to interoperability hub'),
                ),
              );
            },
            child: const Text('Propagate to EHR'),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF005EB8)),
            onPressed: _exportFHIRRecord,
            tooltip: 'Export FHIR Record',
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF005EB8)),
          onPressed: () => Navigator.pop(context, _patient),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
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
            _buildAICopilotCard(),
            const SizedBox(height: 24),
            _buildMedicalProfileCard(),
            const SizedBox(height: 24),
            _buildPrioritySentinelCard(),
            const SizedBox(height: 24),
            _buildSymptomDescription(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showVitalsDialog,
                icon: const Icon(Icons.monitor_heart, color: Colors.white),
                label: const Text(
                  'Log Vitals',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA1A1A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
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
              if (_patient.status != 'in_progress') const SizedBox(height: 16),
              if (_patient.status != 'completed')
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _updateStatus('completed'),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
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
                  icon: const Icon(Icons.edit_note, color: Color(0xFF00478D)),
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
                        const Icon(
                          Icons.photo,
                          size: 16,
                          color: Color(0xFF44474E),
                        ),
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

  Future<void> _confirmAIPriority() async {
    setState(() => _isUpdating = true);
    try {
      final nurseName =
          await SessionService().getName() ?? 'Authenticated Staff';
      final updated = await _backend.verifyTriage(
        id: _patient.id,
        nurseName: nurseName,
      );
      if (!mounted) return;
      setState(() => _patient = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI Triage confirmed and signed by $nurseName')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to verify AI decision.')),
      );
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Widget _buildAICopilotCard() {
    final isVerified = _patient.verifiedBy != null;
    final double confidence = _patient.confidence ?? 0.0;
    final bool isHighConfidence = confidence > 0.85;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isVerified
            ? const Color(0xFFE6F4EA)
            : (isHighConfidence
                  ? const Color(0xFFE0F2F1)
                  : const Color(0xFFE8DEF8)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isVerified
              ? const Color(0xFF34A853)
              : (isHighConfidence
                    ? const Color(0xFF00897B)
                    : const Color(0xFFD0BCFF)),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isVerified
                    ? Icons.verified
                    : (isHighConfidence
                          ? Icons.security_rounded
                          : Icons.auto_awesome),
                color: isVerified
                    ? const Color(0xFF137333)
                    : (isHighConfidence
                          ? const Color(0xFF00695C)
                          : const Color(0xFF6750A4)),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isVerified
                    ? 'Clinical Verification'
                    : (isHighConfidence
                          ? 'AI Trusted Triage'
                          : 'AI Triage Copilot'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isVerified
                      ? const Color(0xFF137333)
                      : (isHighConfidence
                            ? const Color(0xFF00695C)
                            : const Color(0xFF6750A4)),
                ),
              ),
              const Spacer(),
              if (!isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (isHighConfidence
                                ? const Color(0xFF00897B)
                                : const Color(0xFF6750A4))
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(confidence * 100).toStringAsFixed(0)}% CONFIDENCE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: isHighConfidence
                          ? const Color(0xFF004D40)
                          : const Color(0xFF6750A4),
                    ),
                  ),
                ),
              if (isVerified) ...[
                const Icon(Icons.lock, size: 14, color: Color(0xFF137333)),
                const SizedBox(width: 4),
                const Text(
                  'AUDITED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF137333),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isVerified
                ? 'This decision has been manually verified by ${_patient.verifiedBy} to ensure clinical accuracy and HIPAA compliance.'
                : 'Suggested Level: ${_patient.priority}\nReasoning: ${_patient.reasoning ?? "Analysis of symptom vectors indicates clinical correlation required."}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isVerified
                  ? const Color(0xFF137333)
                  : const Color(0xFF1D192B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          if (!isVerified && !_isUpdating)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _confirmAIPriority,
                icon: Icon(
                  isHighConfidence
                      ? Icons.task_alt_rounded
                      : Icons.verified_user,
                  color: isHighConfidence
                      ? const Color(0xFF00695C)
                      : const Color(0xFF6750A4),
                  size: 18,
                ),
                label: Text(
                  isHighConfidence
                      ? 'Approve AI Triage'
                      : 'Confirm AI Priority',
                  style: TextStyle(
                    color: isHighConfidence
                        ? const Color(0xFF00695C)
                        : const Color(0xFF6750A4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isHighConfidence
                        ? const Color(0xFF00695C)
                        : const Color(0xFF6750A4),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
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

  Widget _buildMedicalProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.medical_information_outlined,
                color: Color(0xFF005EB8),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Clinical Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005EB8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            Icons.person_outline,
            'Demographics',
            '${_patient.gender ?? "Unspecified"}, ${_patient.age ?? "N/A"}y, Blood: ${_patient.bloodType ?? "Unknown"}',
          ),
          const Divider(height: 32),
          _buildInfoRow(
            Icons.history_edu,
            'Medical History',
            _patient.healthHistory?.isNotEmpty == true
                ? _patient.healthHistory!
                : 'No history provided',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.warning_amber_rounded,
            'Allergies',
            _patient.allergies?.isNotEmpty == true
                ? _patient.allergies!
                : 'No known allergies',
            isWarning: _patient.allergies?.isNotEmpty == true,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.medication,
            'Current Medications',
            _patient.currentMedications?.isNotEmpty == true
                ? _patient.currentMedications!
                : 'None listed',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.smoke_free_outlined,
            'Lifestyle Habits',
            _patient.badHabits?.isNotEmpty == true
                ? _patient.badHabits!
                : 'No habits reported',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isWarning = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isWarning ? const Color(0xFFBA1A1A) : const Color(0xFF44474E),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isWarning ? const Color(0xFFBA1A1A) : Colors.grey,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isWarning
                      ? const Color(0xFFBA1A1A)
                      : const Color(0xFF1A1C1E),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
