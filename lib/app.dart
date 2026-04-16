import 'package:flutter/material.dart';

import 'config/app_theme.dart';
import 'config/theme/app_colors.dart';
import 'config/theme/app_iconography.dart';
import 'config/theme/app_radii.dart';

class FrontendApp extends StatelessWidget {
  const FrontendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Frontend',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _ThemePreviewScreen(),
    );
  }
}

class _ThemePreviewScreen extends StatelessWidget {
  const _ThemePreviewScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Ready'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: AppIconography.filledIcon(Icons.notifications),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme tokens applied.', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Primary, surfaces, typography, radii, and icon defaults are configured.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadii.x2l),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Sample card using configured surface tokens'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
