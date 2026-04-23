
import 'package:flutter/material.dart';
import 'package:flutter_frontend/features/shared/models/queue_models.dart';
import 'package:flutter_frontend/providers/queue_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientDetailScreen extends ConsumerWidget {
final String patientId;

   const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(queueProvider);

  patients.firstWhere(
    (p) => p.id.toString() == patientId,
  );
  
    return Scaffold(
      bottomNavigationBar: const _BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _HeaderSection(patientId as QueuePatient),
              _UrgencyCard(patientId as QueuePatient),
              _SymptomCard(patientId as QueuePatient),
              _AiReasoningCard(),
              _PriorityBreakdown(),
              _ActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final QueuePatient  patient;
  const _HeaderSection(this.patient);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "TriageSync",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Icon(Icons.notifications_none),
            ],
          ),

          const SizedBox(height: 16),

          /// Active session badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "ACTIVE SESSION",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Text("ID:tS-20240612-001",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),

          const SizedBox(height: 12),

          /// Name
          Text(
            patient.name ?? "Unknown Patient",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 4),

          /// Info
          Text(
            "${patient.gender}, ${patient.age} years old • Blood Type ${patient.bloodType}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
class _UrgencyCard extends StatelessWidget {
  final QueuePatient patient;
  const _UrgencyCard(this.patient);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// RED SIDE BAR
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 12),

          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CURRENT URGENCY",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),

                Text(
                  "Level ${patient.priority} (${patient.urgencyScore})",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                      "Heart Rate\n112 bpm",         
                      style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "SpO2\n91%",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Immediate physician review required",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
          ),

          /// RIGHT WAIT TIME
          Column(
            children: const [
              Text(
                "04",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              Text("MIN WAITS", style: TextStyle(color: Colors.red)),
            ],
          )
        ],
      ),
    );
  }
}
class _SymptomCard extends StatelessWidget {
  final QueuePatient patient;
  const _SymptomCard(this.patient);

  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      title: "Symptom Description",
      child: Text(
        patient.description,
      ),
    );
  }
}
class _AiReasoningCard extends StatelessWidget {
  const _AiReasoningCard();

  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      title: "AI Reasoning & Triangulation",
      borderColor: Colors.blue,
      child: const Column(
        children: [
          _BulletText("Symptoms match ACS (94% confidence)."),
          _BulletText("Hypoxia detected (SpO2 91%)."),
          _BulletText("Risk factors: age, HR, pain radiation."),
        ],
      ),
    );
  }
}
class _BulletText extends StatelessWidget {
  final String text;

  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• "),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
class _PriorityBreakdown extends StatelessWidget {
  const _PriorityBreakdown();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Triage Priority Breakdown",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            _PriorityBar(label: "Circulation", value: 0.8),
            _PriorityBar(label: "Respiration", value: 0.7),
            _PriorityBar(label: "Neurological", value: 0.2),
          ],
        ),
      ),
    );
  }
}
class _PriorityBar extends StatelessWidget {
  final String label;
  final double value;

  const _PriorityBar({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value,
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue.shade800,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onPressed: () {},
  child: const Text("Mark as Attended", style: TextStyle(color: Colors.white)),
),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue.shade800,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onPressed: () {},
  child: const Text("Override Priority", style: TextStyle(color: Colors.white)),
),
          ),
        ],
      ),
    );
  }
}
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "Status",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mic),
          label: "Symptoms",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}
class _CardContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? borderColor;

  const _CardContainer({
    required this.title,
    required this.child,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: borderColor != null
            ? Border(left: BorderSide(color: borderColor!, width: 4))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
