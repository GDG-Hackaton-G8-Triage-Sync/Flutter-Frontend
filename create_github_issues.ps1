$repo = "GDG-Hackaton-G8-Triage-Sync/Flutter-Frontend"

Write-Host "Creating Milestone 'MVP Sprint 1' (will ignore error if it already exists)..."
gh api repos/$repo/milestones -f title="MVP Sprint 1" --silent 2>$null

Write-Host "Creating labels (ignoring errors if they already exist)..."
$labels = @("core", "blocking", "ui", "navigation", "services", "security", "api", "websocket", "models", "patient", "feature", "staff", "state", "admin", "integration", "deployment")
foreach ($label in $labels) {
    gh label create $label --repo $repo --force 2>$null
}

Write-Host "Creating Issue 1..."
$body1 = @'
**Dependencies:** None
**Description:** Initialize Flutter project, configure --dart-define for dev/staging/prod, setup main.dart and app.dart with error handling.
**Acceptance Criteria:**
- [ ] `flutter create` with correct package name
- [ ] `--dart-define` works for API_URL and ENVIRONMENT
- [ ] `main.dart` loads environment and runs app
'@
gh issue create --repo $repo --title "[Leader] Project setup and environment configuration" -l "core" -l "blocking" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body1

Write-Host "Creating Issue 2..."
$body2 = @'
**Dependencies:** #1
**Description:** Implement AppTheme (color scheme, typography with Manrope/Inter), create shared widgets: GradientButton, UrgencyIndicator, PriorityCard, GhostDivider, AppTopBar, BottomNavBar.
**Acceptance Criteria:**
- [ ] ThemeData configured with seed color #00478D
- [ ] All widgets are reusable and located in widgets
'@
gh issue create --repo $repo --title "[Leader] Core theme and shared widgets" -l "core" -l "ui" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body2

Write-Host "Creating Issue 3..."
$body3 = @'
**Dependencies:** #1
**Description:** Setup GoRouter with role-based routes: `/login`, `/patient/*`, `/staff/*`. Implement auth guard that redirects based on user role.
**Acceptance Criteria:**
- [ ] Routes defined for all screens (placeholders)
- [ ] Unauthenticated users cannot access protected routes
'@
gh issue create --repo $repo --title "[Leader] Router and guards" -l "core" -l "navigation" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body3

Write-Host "Creating Issue 4..."
$body4 = @'
**Dependencies:** #1
**Description:** Implement FlutterSecureStorage wrapper for JWT and refresh token storage.
**Acceptance Criteria:**
- [ ] Save, read, delete tokens
- [ ] Uses iOS Keychain / Android Keystore
'@
gh issue create --repo $repo --title "[Leader] Secure storage service" -l "services" -l "security" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body4

Write-Host "Creating Issue 5..."
$body5 = @'
**Dependencies:** #4
**Description:** Setup Dio client with AuthInterceptor (JWT attachment), LoggingInterceptor, ErrorInterceptor, and token refresh flow on 401.
**Acceptance Criteria:**
- [ ] Automatic token refresh on 401
- [ ] Retry original request after refresh
- [ ] All API calls go through this client
'@
gh issue create --repo $repo --title "[Leader] API client with interceptors" -l "services" -l "api" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body5

Write-Host "Creating Issue 6..."
$body6 = @'
**Dependencies:** #5
**Description:** Implement WebSocketManager singleton with connection, heartbeat (ping/pong), exponential backoff reconnection, and expose StreamProvider for triage updates.
**Acceptance Criteria:**
- [ ] Connects with JWT in query param
- [ ] Reconnects on disconnect with backoff (1s, 2s, 4s, max 30s)
- [ ] Exposes triageUpdatesProvider (`Stream<TriageUpdate>`)
'@
gh issue create --repo $repo --title "[Leader] WebSocket manager with reconnection" -l "services" -l "websocket" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body6

Write-Host "Creating Issue 7..."
$body7 = @'
**Dependencies:** #1
**Description:** Define Freezed models: User, TriageResult, PatientJourney, TriageUpdate, PatientDetail. Create provider stubs for triageRepositoryProvider, patientStatusProvider, adminApiProvider.
**Acceptance Criteria:**
- [ ] All models have JSON serialization
- [ ] Stubs return fake data so other members can work in parallel
'@
gh issue create --repo $repo --title "[Leader] Shared models and provider stubs" -l "core" -l "models" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body7

Write-Host "Creating Issue 8..."
$body8 = @'
**Dependencies:** #7
**Description:** Build SymptomInputScreen with text field, submit button. Create symptomControllerProvider (AsyncNotifier) that calls triageRepositoryProvider.submit().
**Acceptance Criteria:**
- [ ] Text input for symptoms (multi-line)
- [ ] Submit button shows loading/error/success states
- [ ] On success, navigates to submission success screen
'@
gh issue create --repo $repo --title "[Member 1] Symptom input screen and controller" -l "patient" -l "feature" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body8

Write-Host "Creating Issue 9..."
$body9 = @'
**Dependencies:** #8
**Description:** Create SubmissionSuccessScreen showing confirmation message and patient ID.
**Acceptance Criteria:**
- [ ] Displays "Patient ID: xxx" from navigation arguments
- [ ] Button to view status or go home
'@
gh issue create --repo $repo --title "[Member 1] Submission success screen" -l "patient" -l "ui" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body9

Write-Host "Creating Issue 10..."
$body10 = @'
**Dependencies:** #7
**Description:** Build PatientStatusScreen that watches patientStatusProvider and shows queue position, urgency level, journey timeline.
**Acceptance Criteria:**
- [ ] Shows current queue position
- [ ] Displays urgency indicator (color-coded)
- [ ] Timeline of care steps
'@
gh issue create --repo $repo --title "[Member 1] Patient status tracking screen" -l "patient" -l "feature" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body10

Write-Host "Creating Issue 11..."
$body11 = @'
**Dependencies:** #3
**Description:** Simple WelcomeScreen (no permissions needed after speech removal). Just intro and login/continue button.
**Acceptance Criteria:**
- [ ] Displays app name and tagline
- [ ] Button navigates to login or symptom input
'@
gh issue create --repo $repo --title "[Member 1] Onboarding welcome screen" -l "patient" -l "ui" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body11

Write-Host "Creating Issue 12..."
$body12 = @'
**Dependencies:** #6, #7
**Description:** Create queueProvider that listens to triageUpdatesProvider, maintains sorted list of patients (by urgency descending), and supports filtering.
**Acceptance Criteria:**
- [ ] List updates in real-time when WebSocket event arrives
- [ ] Sort by urgency score
- [ ] Filter by status (waiting, in-triage, etc.)
'@
gh issue create --repo $repo --title "[Member 2] Queue provider with WebSocket listener" -l "staff" -l "state" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body12

Write-Host "Creating Issue 13..."
$body13 = @'
**Dependencies:** #12, #2
**Description:** Build QueueDashboardScreen with ListView.builder of PatientQueueCard widgets. Include urgency filter dropdown and queue stats header.
**Acceptance Criteria:**
- [ ] Cards show patient name, urgency score, reason, wait time
- [ ] Tap card navigates to patient detail
- [ ] Filter works
'@
gh issue create --repo $repo --title "[Member 2] Queue dashboard UI" -l "staff" -l "ui" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body13

Write-Host "Creating Issue 14..."
$body14 = @'
**Dependencies:** #5, #7
**Description:** Create patientDetailProvider that fetches full patient data by ID using patientApiProvider.getPatientDetail(id).
**Acceptance Criteria:**
- [ ] AsyncNotifier that loads data on demand
- [ ] Handles loading/error states
'@
gh issue create --repo $repo --title "[Member 2] Patient detail provider" -l "staff" -l "state" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body14

Write-Host "Creating Issue 15..."
$body15 = @'
**Dependencies:** #14, #2
**Description:** Build PatientDetailScreen showing AI reasoning, confidence score, vitals, journey timeline, and triage notes.
**Acceptance Criteria:**
- [ ] Displays all clinical fields from PatientDetail model
- [ ] Shows explainable AI reasoning with confidence percentage
'@
gh issue create --repo $repo --title "[Member 2] Patient detail screen" -l "staff" -l "ui" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body15

Write-Host "Creating Issue 16..."
$body16 = @'
**Dependencies:** #7
**Description:** Create AdminRepository with methods fetchLogs(page, filters) and fetchSystemHealth(). Implement adminLogsProvider (paginated) and systemHealthProvider.
**Acceptance Criteria:**
- [ ] Uses adminApiProvider from Leader's stubs
- [ ] Logs support pagination and filtering by date/urgency
'@
gh issue create --repo $repo --title "[Member 3] Admin repository and providers" -l "admin" -l "state" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body16

Write-Host "Creating Issue 17..."
$body17 = @'
**Dependencies:** #16, #6
**Description:** Build widget showing WebSocket status, API latency, queue backlog. Integrate into AdminControlPanelScreen.
**Acceptance Criteria:**
- [ ] Real-time or refreshable metrics
- [ ] Visual indicators (green/yellow/red)
'@
gh issue create --repo $repo --title "[Member 3] System health dashboard" -l "admin" -l "ui" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body17

Write-Host "Creating Issue 18..."
$body18 = @'
**Dependencies:** #16
**Description:** Build TriageLogsScreen with DataTable, filters (date range, urgency, patient search), pagination, and CSV export button.
**Acceptance Criteria:**
- [ ] Logs load with infinite scroll or pagination controls
- [ ] CSV export uses share_plus package
'@
gh issue create --repo $repo --title "[Member 3] Triage logs viewer with export" -l "admin" -l "ui" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body18

Write-Host "Creating Issue 19..."
$body19 = @'
**Dependencies:** #1, #2, #3, #4, #5, #6, #7, #8, #9, #10, #11, #12, #13, #14, #15, #16, #17, #18
**Description:** Merge all feature branches, connect real WebSocket to Member 2's queue, ensure all providers use real endpoints instead of stubs. Build web production and deploy.
**Acceptance Criteria:**
- [ ] All features work together end-to-end
- [ ] `flutter build web --release` succeeds
- [ ] Deployed to staging environment
'@
gh issue create --repo $repo --title "[Leader] Integration and deployment" -l "integration" -l "deployment" --assignee "bella-247" --milestone "MVP Sprint 1" --body $body19

Write-Host "All issues created successfully!"
