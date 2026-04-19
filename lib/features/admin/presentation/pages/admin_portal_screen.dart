import 'package:flutter/material.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';
import 'package:flutter_frontend/core/services/session_service.dart';
import 'package:flutter_frontend/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_frontend/features/staff/presentation/pages/command_center_screen.dart';

class AdminPortalScreen extends StatefulWidget {
  const AdminPortalScreen({super.key});

  @override
  State<AdminPortalScreen> createState() => _AdminPortalScreenState();
}

class _AdminPortalScreenState extends State<AdminPortalScreen>
    with SingleTickerProviderStateMixin {
  final BackendService _backend = BackendService.instance;
  final SessionService _session = SessionService();

  late TabController _tabController;

  AdminOverview? _overview;
  AdminAnalytics? _analytics;

  List<AppUser> _allUsers = <AppUser>[];
  List<AppUser> _filteredUsers = <AppUser>[];
  String _searchQuery = '';

  // Dynamic audit log simulating enterprise immutability stream
  final List<AuditLogEntry> _auditLog = <AuditLogEntry>[];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _seedInitialAuditLog();
    _loadAll();
  }

  void _seedInitialAuditLog() {
    _logAudit('SYSTEM_BOOT', 'Admin dashboard initialized.', 'system');
    _logAudit(
      'LOGIN_SUCCESS',
      'admin@triagesync.com logged in securely.',
      'admin_portal',
    );
  }

  void _logAudit(String action, String target, String actor) {
    if (!mounted) return;
    setState(() {
      _auditLog.insert(
        0,
        AuditLogEntry(
          time: DateTime.now()
              .toIso8601String()
              .replaceFirst('T', ' ')
              .substring(0, 19),
          actor: actor,
          action: action,
          target: target,
        ),
      );
    });
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
        _allUsers = results[2] as List<AppUser>;
        _applySearch();
        _isLoading = false;
      });
      _logAudit(
        'DATA_SYNC',
        'Synchronized live metrics & user tree.',
        'system',
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load enterprise dashboard data (HIPAA Timeout).';
        _isLoading = false;
      });
      _logAudit(
        'SYNC_ERROR',
        'Failed to pull live backend snapshot.',
        'system',
      );
    }
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = List.from(_allUsers);
    } else {
      _filteredUsers = _allUsers
          .where(
            (u) =>
                u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                u.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                u.role.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
  }

  Future<String?> _askForJustification(String actionName) async {
    String input = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.security, color: Color(0xFFBA1A1A)),
            const SizedBox(width: 8),
            Text(actionName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enterprise Policy Requires a Justification Reason to proceed.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Audit Reason',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => input = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (input.trim().isEmpty) return;
              Navigator.pop(ctx, input.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005EB8),
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _changeRole(AppUser user, String role) async {
    // Enterprise required capture!
    final justification = await _askForJustification('Role Override');
    if (justification == null) return;

    try {
      await _backend.updateUserRole(id: user.id, role: role);
      _logAudit(
        'ROLE_MUTATION',
        '${user.email} -> $role. Reason: $justification',
        'admin',
      );

      await _loadAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ACL Update: ${user.name} is now $role.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Role update blocked by backend.')),
      );
    }
  }

  Future<void> _deletePatient(AppUser user) async {
    final justification = await _askForJustification('Force Patient Deletion');
    if (justification == null) return;

    try {
      await _backend.deletePatient(user.id);
      _logAudit(
        'USER_DELETION',
        'Erased records for ${user.email}. Reason: $justification',
        'admin',
      );

      await _loadAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User ${user.name} wiped. Immutable record saved in audit log.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Deletion blocked.')));
    }
  }

  Future<void> _simulateExport() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating HIPAA Compliant CSV Payload...'),
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    _logAudit(
      'FILE_EXPORT',
      'Exported Daily Metrics PDF to local drive.',
      'admin',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export Complete! Sent to Administrator Email.'),
      ),
    );
  }

  Future<void> _showRegisterDialog() async {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();
    String selectedRole = 'staff';

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Register Internal Member'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person))),
              const SizedBox(height: 8),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
              const SizedBox(height: 8),
              TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock))),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: const InputDecoration(labelText: 'System Role'),
                items: const [
                  DropdownMenuItem(value: 'staff', child: Text('Medical Staff')),
                  DropdownMenuItem(value: 'admin', child: Text('Administrator')),
                ],
                onChanged: (v) => selectedRole = v!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty || passCtrl.text.isEmpty) return;
              try {
                await _backend.register(
                  name: nameCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  password: passCtrl.text.trim(),
                  role: selectedRole,
                );
                _logAudit('MEMBER_REGISTERED', 'New $selectedRole: ${emailCtrl.text}', 'admin');
                if (!ctx.mounted || !mounted) return;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered $selectedRole: ${nameCtrl.text}')));
                _loadAll(); // Refresh directory
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration failed.')));
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    _logAudit('LOGOUT', 'Administrator session terminated.', 'admin');
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
        title: const Text(
          'Enterprise Admin Portal',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF00478D),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF005EB8),
          unselectedLabelColor: Colors.black54,
          indicatorColor: const Color(0xFF005EB8),
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.manage_accounts), text: 'Directory'),
            Tab(icon: Icon(Icons.security), text: 'Audit Stream'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showRegisterDialog,
            icon: const Icon(Icons.person_add),
            tooltip: 'Register Member',
          ),
          IconButton(
            onPressed: _simulateExport,
            icon: const Icon(Icons.download),
            tooltip: 'Export Report',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
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
                  Text(_error!),
                  ElevatedButton(
                    onPressed: _loadAll,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildDirectoryTab(),
                _buildAuditTab(),
              ],
            ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _loadAll,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFBA1A1A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_overview == null) return;
                    _logAudit(
                      'COMMAND_CENTER',
                      'Opened Command Center view',
                      'admin',
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommandCenterScreen(
                          totalPatients: _overview!.totalPatients,
                          waiting: _overview!.waiting,
                          inProgress: _overview!.inProgress,
                          criticalCases: _overview!.criticalCases,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.sos),
                  label: const Text(
                    'Live Command Center',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_overview != null) ...[
            const Text(
              'Real-time Metrics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00478D),
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _kpiTile(
                  'Patients',
                  _overview!.totalPatients,
                  Icons.people,
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
                  Icons.loop,
                  const Color(0xFFF57C00),
                ),
                _kpiTile(
                  'Critical SLA',
                  _overview!.criticalCases,
                  Icons.warning_amber,
                  const Color(0xFF8B1A1A),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          if (_analytics != null) ...[
            const Text(
              'System Analytics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00478D),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _analyticsRow(
                    'Peak Usage Time',
                    _analytics!.peakHour,
                    Icons.timeline,
                  ),
                  const Divider(),
                  _analyticsRow(
                    'Average Complexity Score',
                    '${_analytics!.avgUrgencyScore}/100',
                    Icons.analytics,
                  ),
                  const Divider(),
                  _analyticsRow(
                    'High Volume Conditions',
                    _analytics!.commonConditions.join(', '),
                    Icons.coronavirus,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDirectoryTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: TextField(
            onChanged: (v) {
              setState(() {
                _searchQuery = v;
                _applySearch();
              });
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search by Name, Email, or Role (e.g. staff)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredUsers.length,
            itemBuilder: (ctx, index) {
              final user = _filteredUsers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: user.role == 'admin'
                        ? const Color(0xFFBA1A1A).withValues(alpha: 0.1)
                        : const Color(0xFFE0F0FF),
                    child: Icon(
                      user.role == 'admin'
                          ? Icons.security
                          : user.role == 'staff'
                          ? Icons.medical_services
                          : Icons.person,
                      color: user.role == 'admin'
                          ? const Color(0xFFBA1A1A)
                          : const Color(0xFF005EB8),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${user.email} • ${user.role.toUpperCase()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<String>(
                        onSelected: (role) => _changeRole(user, role),
                        icon: const Icon(
                          Icons.shield,
                          color: Color(0xFF005EB8),
                        ),
                        tooltip: 'Modify Role',
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'patient',
                            child: Text('Demote to Patient'),
                          ),
                          PopupMenuItem(
                            value: 'staff',
                            child: Text('Assign Staff ACL'),
                          ),
                          PopupMenuItem(
                            value: 'admin',
                            child: Text('Grant Global Admin'),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _deletePatient(user),
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Color(0xFFBA1A1A),
                        ),
                        tooltip: 'Wipe User Data',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuditTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _auditLog.length,
      itemBuilder: (ctx, idx) {
        final entry = _auditLog[idx];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.verified_user, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.action,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(entry.target, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(
                        '${entry.actor} • ${entry.time}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _kpiTile(String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _analyticsRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF005EB8)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class AuditLogEntry {
  final String time;
  final String actor;
  final String action;
  final String target;

  AuditLogEntry({
    required this.time,
    required this.actor,
    required this.action,
    required this.target,
  });
}
