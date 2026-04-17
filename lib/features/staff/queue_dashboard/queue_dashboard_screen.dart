import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/staff/queue_dashboard/widgets/queue_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/queue_provider.dart';
import 'widgets/patient_queue_card.dart';

class QueueDashboardScreen extends ConsumerWidget {
  const QueueDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(queueProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              /// Header
              const QueueHeader(),
              /// Queue List
              Expanded(
                child: ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    return PatientQueueCard(
                      patient: patients[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
