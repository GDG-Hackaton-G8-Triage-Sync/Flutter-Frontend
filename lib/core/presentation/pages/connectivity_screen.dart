import 'package:flutter/material.dart';
import 'package:flutter_frontend/core/presentation/widgets/state_visuals.dart';

class ConnectivityScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const ConnectivityScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: OfflineVisual(onRetry: onRetry),
      ),
    );
  }
}
