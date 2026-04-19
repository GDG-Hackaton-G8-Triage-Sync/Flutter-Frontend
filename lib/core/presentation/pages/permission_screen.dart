import 'package:flutter/material.dart';

class PermissionRationaleScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String rationale;
  final String permissionType;
  final VoidCallback onGrant;
  final VoidCallback onCancel;

  const PermissionRationaleScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.rationale,
    required this.permissionType,
    required this.onGrant,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF005EB8).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 72, color: const Color(0xFF005EB8)),
              ),
              const SizedBox(height: 48),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                rationale,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.6),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onGrant,
                  child: Text('ALLOW ACCESS TO $permissionType'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: onCancel,
                child: const Text('NOT NOW', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
