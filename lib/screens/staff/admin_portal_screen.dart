import 'package:flutter/material.dart';

import '../../models/api_models.dart';
import '../../services/backend_service.dart';
import '../../services/session_service.dart';
import '../login_screen.dart';

class AdminPortalScreen extends StatefulWidget {
  const AdminPortalScreen({super.key});

  @override
  State<AdminPortalScreen> createState() => _AdminPortalScreenState();
}

class _AdminPortalScreenState extends State<AdminPortalScreen> {
  final BackendService _backend = BackendService.instance;
  final SessionService _session = SessionService();

  AdminOverview? _overview;
  AdminAnalytics? _analytics;
  List<AppUser> _users = <AppUser>[];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _backend.getAdminOverview(),
        _backend.getAdminAnalytics(),
        _backend.getUsers(),
      ]);

      if (!mounted) return;
      setState(() {
        _overview = results[0] as AdminOverview;
        _analytics = results[1] as AdminAnalytics;
        _users = results[2] as List<AppUser>;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load admin dashboard data.';
        _isLoading = false;
      });
    }
  }

  Future<void> _changeRole(AppUser user, String role) async {
    try {
      await _backend.updateUserRole(id: user.id, role: role);
      await _loadAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.name} role changed to $role.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Role update failed.')));
    }
  }

  Future<void> _deletePatient(AppUser user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
          'Are you sure you want to remove ${user.name} from the system?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await _backend.deletePatient(user.id);
      await _loadAll();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${user.name} removed.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Delete failed.')));
    }
  }

  Future<void> _logout() async {
    await _session.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Admin Control Panel',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadAll,
            icon: const Icon(Icons.refresh, color: Color(0xFF005EB8)),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Color(0xFF005EB8)),
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadAll,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadAll,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // --- Overview KPI Grid ---
                  if (_overview != null) ...[
                    const _SectionHeader(title: 'Overview'),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _kpiTile(
                          'Total Patients',
                          _overview!.totalPatients,
                          Icons.people_outline,
                          const Color(0xFF005EB8),
                        ),
                        _kpiTile(
                          'Waiting',
                          _overview!.waiting,
                          Icons.hourglass_empty,
                          const Color(0xFFBA1A1A),
                        ),
                        _kpiTile(
                          'In Progress',
                          _overview!.inProgress,
                          Icons.play_circle_outline,
                          const Color(0xFFF57C00),
                        ),
                        _kpiTile(
                          'Completed',
                          _overview!.completed,
                          Icons.check_circle_outline,
                          const Color(0xFF146C2E),
                        ),
                        _kpiTile(
                          'Critical Cases',
                          _overview!.criticalCases,
                          Icons.emergency,
                          const Color(0xFF8B1A1A),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // --- Analytics ---
                  if (_analytics != null) ...[
                    const _SectionHeader(title: 'Analytics'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _analyticsRow(
                            Icons.speed,
                            'Avg Urgency Score',
                            '${_analytics!.avgUrgencyScore}/100',
                          ),
                          const Divider(height: 20),
                          _analyticsRow(
                            Icons.schedule,
                            'Peak Hour',
                            _analytics!.peakHour,
                          ),
                          if (_analytics!.commonConditions.isNotEmpty) ...[
                            const Divider(height: 20),
                            _analyticsRow(
                              Icons.local_hospital_outlined,
                              'Common Conditions',
                              _analytics!.commonConditions.join(', '),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // --- User Management ---
                  const _SectionHeader(title: 'User Management'),
                  const SizedBox(height: 12),
                  ..._users.map(
                    (user) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFE0F0FF),
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF005EB8),
                            ),
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${user.email} • ${user.role}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Role change
                            PopupMenuButton<String>(
                              onSelected: (role) => _changeRole(user, role),
                              icon: const Icon(
                                Icons.swap_horiz,
                                color: Color(0xFF005EB8),
                              ),
                              tooltip: 'Change Role',
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'patient',
                                  child: Text('patient'),
                                ),
                                PopupMenuItem(
                                  value: 'staff',
                                  child: Text('staff'),
                                ),
                                PopupMenuItem(
                                  value: 'admin',
                                  child: Text('admin'),
                                ),
                              ],
                            ),
                            // Delete
                            IconButton(
                              onPressed: () => _deletePatient(user),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFBA1A1A),
                              ),
                              tooltip: 'Remove User',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _kpiTile(String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF44474E)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _analyticsRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF005EB8)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF44474E)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1C1E),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF00478D),
      ),
    );
  }
}
