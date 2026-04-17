import 'package:flutter/material.dart';

class PatientDetailScreen extends StatelessWidget {
  final int patientId;
  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Patient Detail $patientId')));
}
