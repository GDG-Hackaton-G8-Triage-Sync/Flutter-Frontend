import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/staff/queue_dashboard/widgets/queue_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/queue_provider.dart';
import 'widgets/patient_queue_card.dart';

class QueueDashboardScreen extends ConsumerWidget {
  const QueueDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(queueProvider);

    final list = patients;


    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: QueueHeader(),
            ),


        

          

            const SizedBox(height: 12),

            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final patient = list[index];

                  return GestureDetector(
                    onTap: () {
                      context.push('/staff/patient/${patient.id}');
                    },
                    child: PatientQueueCard(
                      key: ValueKey(patient.id),
                      patient: patient,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


