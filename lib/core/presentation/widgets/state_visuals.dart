import 'package:flutter/material.dart';

class StateVisual extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final List<Widget>? actions;
  final Color? iconColor;

  const StateVisual({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actions,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF005EB8)).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: iconColor ?? const Color(0xFF005EB8),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1C1E),
                fontFamily: 'Manrope',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 40),
              ...actions!.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: a,
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;
  final IconData? icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.onAction,
    this.actionLabel,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return StateVisual(
      icon: icon ?? Icons.folder_open_outlined,
      title: title,
      message: message,
      actions: onAction != null ? [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onAction,
            child: Text(actionLabel ?? 'Get Started'),
          ),
        )
      ] : null,
    );
  }
}

class OfflineVisual extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineVisual({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return StateVisual(
      icon: Icons.wifi_off_rounded,
      iconColor: const Color(0xFFBA1A1A),
      title: 'Connection Lost',
      message: 'TriageSync requires a secure connection to process your medical data. Please check your network and try again.',
      actions: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('RETRY CONNECTION'),
          ),
        ),
        TextButton(
          onPressed: () {}, // Hypothetical Offline Mode
          child: const Text('USE OFFLINE EMERGENCY GUIDES'),
        ),
      ],
    );
  }
}
