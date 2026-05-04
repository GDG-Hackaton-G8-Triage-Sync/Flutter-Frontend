class ApiEndpoints {
  // Auth
  static const String authRefresh = '/api/v1/auth/refresh/';
  static const String authLogin = '/api/v1/auth/login/';
  static const String authLogout = '/api/v1/auth/logout/';
  static const String authProfile = '/api/v1/auth/profile/';
  static const String authRegister = '/api/v1/auth/register/';

  // Generic profile (some endpoints expose both /auth/profile/ and /profile/)
  static const String profile = '/api/v1/profile/';

  // Triage
  static const String triage = '/api/v1/triage/';
  static const String triageAi = '/api/v1/triage/ai/';
  static const String triageEvaluate = '/api/v1/triage/evaluate/';
  static String triageById(int id) => '/api/v1/triage/$id/';
  static String triageAssign(int id) => '/api/v1/triage/$id/assign/';
  static String triageNotes(int id) => '/api/v1/triage/$id/notes/';
  static String triageVerify(int id) => '/api/v1/triage/$id/verify/';
  static String triageVitals(int id) => '/api/v1/triage/$id/vitals/';
    static String triageWaitingAnalytics(int id) => '/api/v1/triage/$id/waiting-analytics/';
  static String triageVitalsHistory(int id) => '/api/v1/triage/$id/vitals/history/';

  static const String triagePdfExtract = '/api/v1/triage/pdf-extract/';

  // Dashboard (staff)
  static const String dashboardStaffPatients = '/api/v1/dashboard/staff/patients/';
  static String dashboardStaffPatientStatus(int id) =>
      '/api/v1/dashboard/staff/patient/$id/status/';
  static String dashboardStaffPatientPriority(int id) =>
      '/api/v1/dashboard/staff/patient/$id/priority/';
  static String dashboardStaffPatientVerify(int id) =>
      '/api/v1/dashboard/staff/patient/$id/verify/';

  // Dashboard (admin)
  static const String dashboardAdminOverview = '/api/v1/dashboard/admin/overview/';
  static const String dashboardAdminAnalytics = '/api/v1/dashboard/admin/analytics/';

  // Admin
  static const String adminUsers = '/api/v1/admin/users/';
  static String adminUserRole(int id) => '/api/v1/admin/users/$id/role/';
  static String adminUser(int id) => '/api/v1/admin/users/$id/';
  static String adminUserSuspend(int id) => '/api/v1/admin/users/$id/suspend/';
  static const String adminReportsExport = '/api/v1/admin/reports/export/';
  static const String adminAuditLogs = '/api/v1/admin/audit-logs/';
  static const String adminConfigSla = '/api/v1/admin/config/sla/';

  // Patients
  static const String patientCurrent = '/api/v1/patients/current/';
  static const String patientHistory = '/api/v1/patients/history/';
  static const String patientProfile = '/api/v1/patients/profile/';
  static const String patientProfilePhoto = '/api/v1/patients/profile/photo/';
  static const String patientQueue = '/api/v1/patients/queue/';
  static const String patientTriageSubmissions = '/api/v1/patients/triage-submissions/';
  static String patientSubmissionById(int id) => '/api/v1/patients/submissions/$id/';

  // Notifications
  static const String notifications = '/api/v1/notifications/';
  static const String notificationsUnreadCount = '/api/v1/notifications/unread-count/';
  static const String notificationsReadAll = '/api/v1/notifications/read-all/';
  static String notificationById(String id) => '/api/v1/notifications/$id/';
  static String notificationRead(String id) => '/api/v1/notifications/$id/read/';
}