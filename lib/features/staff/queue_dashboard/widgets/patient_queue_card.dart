import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/theme/app_typography.dart';
import 'package:flutter_frontend/features/shared/models/queue_models.dart';

class PatientQueueCard extends StatelessWidget {
  final QueuePatient patient;

  const PatientQueueCard({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(patient.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          /// LEFT COLOR BAR
          Container(
            width: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// MAIN CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP ROW (ID + TAG)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "#TS-${patient.id}",
                          style: AppTypography.textTheme.labelMedium
                              ?.copyWith(color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      const SizedBox(width: 8),

                      _priorityBadge(),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// NAME (using condition as name fallback)
                  Text(
                    patient.condition,
                    style: AppTypography.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  /// DESCRIPTION
                  Text(
                    patient.description,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          /// RIGHT SIDE SCORE
          
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  patient.urgencyScore.toString(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "URGENCY",
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// COLOR MAPPING
  Color _priorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  /// BADGE (mapped from priority)
  Widget _priorityBadge() {
    final label = _priorityLabel(patient.priority);
    final color = _priorityColor(patient.priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  /// LABEL MAPPING (UI ONLY)
  String _priorityLabel(int priority) {
    switch (priority) {
      case 1:
        return "IMMEDIATE";
      case 2:
        return "HIGH RISK";
      case 3:
        return "STANDARD";
      default:
        return "STABLE";
    }
  }
}