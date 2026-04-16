import 'package:flutter/material.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({super.key, required this.patientId});

  final int patientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Patient Detail Screen: $patientId')),
    );
  }
}
