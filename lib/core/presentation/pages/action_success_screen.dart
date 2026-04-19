import 'package:flutter/material.dart';

class ActionSuccessScreen extends StatelessWidget {
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const ActionSuccessScreen({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF146C2E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 64, color: Colors.white),
              ),
              const SizedBox(height: 48),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 56),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(actionLabel.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
