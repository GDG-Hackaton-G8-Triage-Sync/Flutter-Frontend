import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/patient/status_tracking/patient_status_screen.dart';
import '../../features/patient/symptom_input/symptom_input_screen.dart';
import '../../features/staff/admin_panel/admin_control_panel_screen.dart';
import '../../features/staff/patient_detail/patient_detail_screen.dart';
import '../../features/staff/queue_dashboard/queue_dashboard_screen.dart';

class AppRouter {
  static GoRouter create(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        // TODO: Replace with real auth state from Riverpod auth provider.
        final isLoggedIn = _isLoggedInStub(ref);
        final userRole = _userRoleStub(ref);
        final location = state.matchedLocation;

        if (!isLoggedIn && location != '/login') {
          return '/login';
        }

        if (isLoggedIn && location == '/login') {
          if (userRole == 'patient') return '/patient/submit';
          if (userRole == 'staff') return '/staff/queue';
          if (userRole == 'admin') return '/admin/overview';
          return '/login';
        }

        if (location.startsWith('/staff') &&
            userRole != 'staff' &&
            userRole != 'admin') {
          return '/unauthorized';
        }

        if (location.startsWith('/admin') && userRole != 'admin') {
          return '/unauthorized';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/patient/submit',
          name: 'patient_submit',
          builder: (context, state) => const SymptomInputScreen(),
        ),
        GoRoute(
          path: '/patient/status',
          name: 'patient_status',
          builder: (context, state) => const PatientStatusScreen(),
        ),
        GoRoute(
          path: '/staff/queue',
          name: 'staff_queue',
          builder: (context, state) => const QueueDashboardScreen(),
        ),
        GoRoute(
          path: '/staff/patient/:id',
          name: 'patient_detail',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return PatientDetailScreen(patientId: id);
          },
        ),
        GoRoute(
          path: '/admin/overview',
          name: 'admin_overview',
          builder: (context, state) => const AdminControlPanelScreen(),
        ),
        GoRoute(
          path: '/unauthorized',
          name: 'unauthorized',
          builder: (context, state) {
            return const Scaffold(body: Center(child: Text('Unauthorized')));
          },
        ),
      ],
    );
  }

  static bool _isLoggedInStub(WidgetRef ref) {
    ref;
    return false;
  }

  static String _userRoleStub(WidgetRef ref) {
    ref;
    return 'patient';
  }
}
