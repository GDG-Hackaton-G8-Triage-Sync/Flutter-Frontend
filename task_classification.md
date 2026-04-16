## Final Task Classification (No Speech, No Frontend Localization)

**Removed:** All UI localization (`l10n/`, ARB files, `AppLocalizations`, multi-language support).  
**Added:** Clear **task dependencies** so members know who must finish first.

---

## 👑 Leader (You) – Core Infrastructure + Auth + API/WebSocket Services

**⏱️ Must finish FIRST (Days 1–2)** – Everyone depends on you.

| Order | Area | Files / Tasks | Deliverable for Others |
|-------|------|---------------|------------------------|
| 1 | Project setup | `pubspec.yaml`, `main.dart`, `app.dart`, `--dart-define` | Run `flutter create` with correct package name |
| 2 | Core theme & widgets | `lib/core/theme/`, `lib/features/shared/widgets/` | `GradientButton`, `UrgencyIndicator`, `PriorityCard`, etc. |
| 3 | Router & guards | `lib/core/router/` | GoRouter with role-based routes: `/login`, `/patient/...`, `/staff/...` |
| 4 | Secure storage | `lib/services/secure_storage/` | `SecureStorageService` (JWT + refresh token) |
| 5 | API client + interceptors | `lib/services/api/` | Dio client with auth, logging, error, token refresh |
| 6 | Auth feature (full) | `lib/features/auth/` | Login screen, onboarding, `authProvider`, `tokenProvider` |
| 7 | WebSocket manager | `lib/services/websocket/` | `WebSocketManager` with reconnection, heartbeat, `triageUpdatesProvider` (StreamProvider) |
| 8 | Shared models & provider stubs | `lib/features/shared/models/`, `lib/features/shared/providers/` | Freezed models: `User`, `TriageResult`, `PatientJourney`, `TriageUpdate`, `PatientDetail`<br>Provider stubs: `triageRepositoryProvider`, `patientStatusProvider`, `adminApiProvider` |
| 9 | API endpoint implementations | `lib/services/api/endpoints/` | Real implementations of all providers (not stubs) – so others can switch from mocks |

**📌 Dependencies for others:**  
- Member 1 **cannot start** until Leader provides `triageRepositoryProvider` and `patientStatusProvider` (or at least stubs).  
- Member 2 **cannot start** until Leader provides `triageUpdatesProvider` (WebSocket stream) and `patientApiProvider`.  
- Member 3 **cannot start** until Leader provides `adminApiProvider` and `secureStorageService`.

**🔧 Leader’s strategy:**  
Deliver **stubs in first 24 hours** (return fake data). Then replace with real implementations while others work in parallel.

---

## 👨‍💻 Member 1 – Patient Features (Text Symptom Input + Status Tracking)

**⏱️ Can start AFTER Leader delivers stubs (Day 2 morning).**  
**⏱️ Should finish BEFORE Member 2 (no dependency, but Member 2 doesn’t need Member 1).**

| Order | Area | Files / Tasks |
|-------|------|---------------|
| 1 | Patient providers | `lib/features/patient/providers/symptom_controller.dart` – AsyncNotifier that calls `triageRepositoryProvider.submit()` |
| 2 | Symptom Input UI | `lib/features/patient/symptom_input/symptom_input_screen.dart` – Text field, submit button, loading/error/success states |
| 3 | Success screen | `lib/features/patient/success/submission_success_screen.dart` – Confirmation with patient ID |
| 4 | Status tracking UI | `lib/features/patient/status_tracking/patient_status_screen.dart` – Watches `patientStatusProvider`, shows queue position, urgency, timeline |
| 5 | Onboarding (no mic) | `lib/features/patient/onboarding/welcome_screen.dart` – Simple welcome, no permissions |
| 6 | Unit & widget tests | `test/features/patient/` – Mock `triageRepositoryProvider` and `patientStatusProvider` |

**🚫 Do not touch:** Staff, admin, auth, WebSocket internals, localization (removed).  
**✅ Depends on Leader:** `triageRepositoryProvider`, `patientStatusProvider`, `authProvider` (for user info).  
**⏱️ Estimated time:** 1.5 days (Day 2–3).

---

## 👩‍💻 Member 2 – Staff Dashboard (Queue + Patient Detail)

**⏱️ Can start AFTER Leader delivers WebSocket stream (Day 2 afternoon).**  
**⏱️ No dependency on Member 1 or Member 3.**

| Order | Area | Files / Tasks |
|-------|------|---------------|
| 1 | Queue provider | `lib/features/staff/providers/queue_provider.dart` – Listens to `triageUpdatesProvider`, maintains sorted list, filtering logic |
| 2 | Queue UI | `lib/features/staff/queue_dashboard/queue_dashboard_screen.dart` – ListView.builder with `PatientQueueCard`, urgency filter dropdown |
| 3 | Patient detail provider | `lib/features/staff/providers/patient_detail_provider.dart` – Calls `patientApiProvider.getPatientDetail(id)` |
| 4 | Patient detail UI | `lib/features/staff/patient_detail/patient_detail_screen.dart` – Shows AI reasoning, confidence score, vitals, journey timeline |
| 5 | UI state providers | `lib/features/staff/providers/` – `selectedPatientProvider`, `queueFilterProvider` (StateProvider) |
| 6 | Unit & widget tests | `test/features/staff/` – Mock `triageUpdatesProvider` with StreamController, mock `patientApiProvider` |

**🚫 Do not touch:** Patient UI, admin panel, auth, localization.  
**✅ Depends on Leader:** `triageUpdatesProvider` (Stream), `patientApiProvider` (REST), `shared/widgets/UrgencyIndicator`.  
**⏱️ Estimated time:** 1.5 days (Day 2–3).

---

## 👨‍🎨 Member 3 – Admin Panel (No localization, no speech)

**⏱️ Can start AFTER Leader delivers admin API stubs (Day 2 morning).**  
**⏱️ No dependency on Member 1 or Member 2.**

| Order | Area | Files / Tasks |
|-------|------|---------------|
| 1 | Admin repository | `lib/features/staff/admin_panel/data/admin_repository.dart` – Uses `adminApiProvider` to fetch logs and health |
| 2 | Admin providers | `lib/features/staff/admin_panel/providers/admin_providers.dart` – `adminLogsProvider` (paginated), `systemHealthProvider` |
| 3 | System health UI | `lib/features/staff/admin_panel/widgets/system_health_card.dart` – WebSocket status, API latency, queue backlog |
| 4 | Triage logs viewer | `lib/features/staff/admin_panel/triage_logs_screen.dart` – DataTable with filters (date, urgency, patient), pagination |
| 5 | Export CSV | Add `share_plus` package, export logs from `adminLogsProvider` |
| 6 | Admin main screen | `lib/features/staff/admin_panel/admin_control_panel_screen.dart` – Tabs or sections combining health + logs |
| 7 | Unit & widget tests | `test/features/staff/admin_panel/` – Mock `adminApiProvider` |

**🚫 Do not touch:** Patient UI, staff queue/detail, auth, WebSocket internals, localization (removed entirely).  
**✅ Depends on Leader:** `adminApiProvider`, `secureStorageService` (for admin token), shared widgets.  
**⏱️ Estimated time:** 1.5 days (Day 2–3).

---

## 📊 Task Dependency Graph (Critical Path)

```
Leader (Day 1–2)
├── Deliver stubs (Day 1 end)
│   ├── Member 1 starts (Day 2 morning)
│   ├── Member 2 waits for WebSocket stream (Day 2 afternoon)
│   └── Member 3 starts (Day 2 morning)
│
├── Deliver real WebSocket (Day 2 afternoon)
│   └── Member 2 can now test with real stream
│
└── Deliver real API endpoints (Day 2 end)
    └── All members switch from mocks to real data
```

**No cross-member dependencies** – Member 1, 2, 3 work in **parallel** after Day 2 morning.

---

## ✅ Final Folder Ownership (No overlaps)

| Member | Owned Folders |
|--------|---------------|
| Leader | `lib/core/`, `lib/services/`, `lib/features/auth/`, `lib/features/shared/` |
| Member 1 | `lib/features/patient/` (all subfolders) |
| Member 2 | `lib/features/staff/queue_dashboard/`, `lib/features/staff/patient_detail/`, `lib/features/staff/providers/` (queue-related) |
| Member 3 | `lib/features/staff/admin_panel/` (all) |

**Shared folder** `lib/features/shared/` is **read-only** for Members 1–3 (they import, never modify). Only Leader modifies it.

---

## 🚀 Fastest Execution Plan

1. **Day 1 (Leader only):** Setup, core, auth, stubs. Deliver to others by EOD.
2. **Day 2 morning:** Leader starts WebSocket real implementation. Members 1 & 3 start building UI with mocks. Member 2 waits for WebSocket stream.
3. **Day 2 afternoon:** Leader delivers WebSocket stream → Member 2 starts. Leader finishes real API endpoints.
4. **Day 3:** All members integrate real endpoints, write tests, polish UI.
5. **Day 4 (buffer):** Bug fixes, Leader handles final deployment (web build).

**Total:** 4 days with minimal communication. Members only talk to Leader, never to each other.