import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_frontend/core/models/api_models.dart';
import 'package:flutter_frontend/core/services/backend_service.dart';
import 'package:flutter_frontend/core/services/session_service.dart';
import 'package:flutter_frontend/core/services/websocket_manager.dart';
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

  List<AuditLogEntry> _auditLogs = <AuditLogEntry>[];

  bool _isLoading = true;
  String? _error;
  StreamSubscription<Map<String, dynamic>>? _wsEventSub;
  Timer? _silentRefreshDebounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAll();

    _wsEventSub = WebSocketManager.instance.events.listen((event) {
      if (!mounted) return;

      final type = (event['type'] ?? event['event_type'] ?? '')
          .toString()
          .toLowerCase();
      final shouldRefresh = type.contains('triage') ||
          type.contains('status') ||
          type.contains('audit') ||
          type.contains('critical') ||
          type.contains('sla');
      if (!shouldRefresh) return;

      _silentRefreshDebounce?.cancel();
      _silentRefreshDebounce = Timer(const Duration(milliseconds: 600), () {
        if (mounted) {
          _loadAll(silent: true);
        }
      });
    });
  }

  Future<void> _loadAll({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final results = await Future.wait([
        _backend.getAdminOverview(),
        _backend.getAdminAnalytics(),
        _backend.getUsers(),
        _backend.getAuditLogs(),
      ]);

      if (!mounted) return;
      setState(() {
        _overview = results[0] as AdminOverview;
        _analytics = results[1] as AdminAnalytics;
        _allUsers = results[2] as List<AppUser>;
        _auditLogs = results[3] as List<AuditLogEntry>;
        _applySearch();
        if (!silent) {
          _isLoading = false;
        }
      });
    } catch (_) {
      if (!mounted) return;
      if (silent) return;
      setState(() {
        _error = 'Failed to load enterprise dashboard data (HIPAA Timeout).';
        _isLoading = false;
      });
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
      await _backend.deleteUser(user.id);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deletion failed.')),
      );
    }
  }

  Future<void> _suspendUser(AppUser user) async {
    final justification = await _askForJustification('Suspend User');
    if (justification == null) return;
    try {
      await _backend.suspendUser(user.id);
      await _loadAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.name} suspended.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to suspend user.')),
      );
    }
  }

  Future<void> _exportReport() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating HIPAA Compliant Report...')),
    );
    try {
      final report = await _backend.getReportSummary();
      if (!mounted) return;
      final total = report['total_submissions'] ?? report['total'] ?? '—';
      final critical = report['critical_cases'] ?? '—';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report ready: $total submissions, $critical critical cases.'),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate report.')),
      );
    }
  }

  Future<void> _showRegisterDialog() async {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();
    final TextEditingController ageCtrl = TextEditingController();
    String selectedRole = 'nurse';
    String? gender;
    String? bloodType;

    return showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Register Internal Member'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  decoration: const InputDecoration(labelText: 'System Role'),
                  items: const [
                    DropdownMenuItem(value: 'nurse', child: Text('Nurse')),
                    DropdownMenuItem(value: 'doctor', child: Text('Doctor')),
                    DropdownMenuItem(value: 'admin', child: Text('Administrator')),
                    DropdownMenuItem(value: 'patient', child: Text('Patient')),
                  ],
                  onChanged: (v) => setDialogState(() => selectedRole = v!),
                ),
                if (selectedRole == 'patient') ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: gender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.people),
                    ),
                    items: ['Male', 'Female', 'Other']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => gender = v),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: bloodType,
                    decoration: const InputDecoration(
                      labelText: 'Blood Type',
                      prefixIcon: Icon(Icons.bloodtype),
                    ),
                    items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => bloodType = v),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty ||
                    emailCtrl.text.isEmpty ||
                    passCtrl.text.isEmpty ||
                    ageCtrl.text.isEmpty) {
                  return;
                }
                try {
                  await _backend.register(
                    name: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    password: passCtrl.text.trim(),
                    role: selectedRole,
                    age: int.tryParse(ageCtrl.text),
                    gender: gender,
                    bloodType: bloodType,
                  );
                  if (!ctx.mounted || !mounted) return;
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Registered $selectedRole: ${nameCtrl.text}'),
                    ),
                  );
                  _loadAll(); // Refresh directory
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration failed.')),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await _backend.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _silentRefreshDebounce?.cancel();
    _wsEventSub?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _switchToTab(int index) {
    _tabController.animateTo(index);
  }

  String _humanizeAuditAction(String action) {
    final normalized = action.trim().toLowerCase();
    const map = <String, String>{
      'user_role_updated': 'User Role Updated',
      'role_override': 'Role Override',
      'user_deleted': 'User Deleted',
      'patient_deleted': 'Patient Deleted',
      'user_suspended': 'User Suspended',
      'triage_created': 'Triage Submission Created',
      'triage_updated': 'Triage Updated',
      'status_changed': 'Patient Status Changed',
      'priority_update': 'Triage Priority Updated',
      'critical_alert': 'Critical Alert Triggered',
      'login': 'User Logged In',
      'logout': 'User Logged Out',
      'report_exported': 'Report Exported',
    };
    if (map.containsKey(normalized)) {
      return map[normalized]!;
    }

    if (normalized.isEmpty) {
      return 'System Event';
    }

    return normalized
        .split('_')
        .map((part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  String _formatActor(String? actorEmail) {
    final actor = (actorEmail ?? '').trim();
    if (actor.isEmpty) {
      return 'System';
    }
    return actor;
  }

  String _formatAuditTimestamp(DateTime timestamp) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${timestamp.year}-${two(timestamp.month)}-${two(timestamp.day)} '
        '${two(timestamp.hour)}:${two(timestamp.minute)}';
  }

  String _buildAuditNarrative(AuditLogEntry log) {
    final actor = _formatActor(log.actorEmail);
    final target = (log.targetEmail ?? '').trim();
    final details = log.details.trim();

    if (target.isNotEmpty && details.isNotEmpty) {
      return '$actor acted on $target. Details: $details';
    }
    if (target.isNotEmpty) {
      return '$actor acted on $target.';
    }
    if (details.isNotEmpty) {
      return '$actor: $details';
    }
    return '$actor triggered this event.';
  }

  Widget _buildQuickNavigationCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE4F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Navigation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF00478D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use these shortcuts during peak traffic to jump directly to the right panel.',
            style: TextStyle(fontSize: 12, color: Color(0xFF4A4F57)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _switchToTab(0),
                icon: const Icon(Icons.dashboard_outlined, size: 18),
                label: const Text('Operations Dashboard'),
              ),
              OutlinedButton.icon(
                onPressed: () => _switchToTab(1),
                icon: const Icon(Icons.manage_accounts_outlined, size: 18),
                label: const Text('User Directory'),
              ),
              OutlinedButton.icon(
                onPressed: () => _switchToTab(2),
                icon: const Icon(Icons.policy_outlined, size: 18),
                label: const Text('Audit Trail'),
              ),
            ],
          ),
        ],
      ),
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
            onPressed: _loadAll,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF005EB8)),
            tooltip: 'Refresh Data',
          ),
          IconButton(
            onPressed: _showRegisterDialog,
            icon: const Icon(Icons.person_add),
            tooltip: 'Register Member',
          ),
          IconButton(
            onPressed: _exportReport,
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
          _buildQuickNavigationCard(),
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
                    'View Live Patient Queue',
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
                          : user.role == 'nurse' || user.role == 'doctor'
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
                            value: 'nurse',
                            child: Text('Assign Nurse ACL'),
                          ),
                          PopupMenuItem(
                            value: 'doctor',
                            child: Text('Assign Doctor ACL'),
                          ),
                          PopupMenuItem(
                            value: 'admin',
                            child: Text('Grant Global Admin'),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _suspendUser(user),
                        icon: const Icon(Icons.block, color: Color(0xFFF57C00)),
                        tooltip: 'Suspend User',
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

  Widget _buildAuditTab() {
    return _auditLogs.isEmpty
        ? const Center(child: Text('No audit entries yet.', style: TextStyle(color: Colors.grey)))
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _auditLogs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final log = _auditLogs[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE6ECF5)),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBA1A1A).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.policy_outlined, color: Color(0xFFBA1A1A)),
                  ),
                  title: Text(
                    _humanizeAuditAction(log.action),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _buildAuditNarrative(log),
                      style: const TextStyle(height: 1.35),
                    ),
                  ),
                  trailing: Text(
                    _formatAuditTimestamp(log.timestamp),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
              );
            },
          );
  }
}
