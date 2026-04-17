import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'core/router/app_router.dart';
import 'core/utils/env_loader.dart';

class TriageSyncApp extends ConsumerStatefulWidget {
  const TriageSyncApp({super.key});

  @override
  ConsumerState<TriageSyncApp> createState() => _TriageSyncAppState();
}

class _TriageSyncAppState extends ConsumerState<TriageSyncApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.create(ref);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TriageSync',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00478D)),
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: EnvLoader.isDev,
    );
  }
}
