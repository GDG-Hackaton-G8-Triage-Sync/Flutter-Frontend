class ApiEndpoints {
  static const String authRefresh = '/api/v1/auth/refresh/';
  static const String authLogin = '/api/v1/auth/login/';
  static const String authRegister = '/api/v1/auth/register/';
  static const String profile = '/api/v1/profile/';

  static const String triageAi = '/api/v1/triage/ai/';
  static const String triagePdfExtract = '/api/v1/triage/pdf-extract/';
  static String triageVitals(int id) => '/api/v1/triage/$id/vitals/';
  static String triageWaitingAnalytics(int id) => '/api/v1/triage/$id/waiting-analytics/';

  static const String dashboardStaffPatients = '/api/v1/dashboard/staff/patients/';
  static String dashboardStaffPatientStatus(int id) =>
      '/api/v1/dashboard/staff/patient/$id/status/';
  static String dashboardStaffPatientPriority(int id) =>
      '/api/v1/dashboard/staff/patient/$id/priority/';

  static const String dashboardAdminOverview = '/api/v1/dashboard/admin/overview/';
  static const String dashboardAdminAnalytics = '/api/v1/dashboard/admin/analytics/';

  static const String adminUsers = '/api/v1/admin/users/';
  static String adminUserRole(int id) => '/api/v1/admin/users/$id/role/';
  static String adminUser(int id) => '/api/v1/admin/users/$id/';
  static String adminUserSuspend(int id) => '/api/v1/admin/users/$id/suspend/';
  static const String adminReportSummary = '/api/v1/admin/reports/summary/';
  static const String adminAuditLogs = '/api/v1/admin/audit-logs/';

  static const String patientTriageSubmissions = '/api/v1/patients/triage-submissions/';

  static const String notifications = '/api/v1/notifications/';
  static const String notificationsUnreadCount = '/api/v1/notifications/unread-count/';
  static const String notificationsReadAll = '/api/v1/notifications/read-all/';

  static String staffPatientVerify(int id) => '/api/v1/staff/patient/$id/verify/';
  static String staffPatientNotes(int id) => '/api/v1/staff/patient/$id/notes/';
  static String staffPatientAssign(int id) => '/api/v1/staff/patient/$id/assign/';
  static String staffPatientVitalsHistory(int id) =>
      '/api/v1/staff/patient/$id/vitals/history/';
}