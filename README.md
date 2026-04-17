# TriageSync Frontend

**Flutter · Cross-Platform · Real-Time Clinical Triage**

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?style=flat&logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.5+-06B6D4?style=flat&logo=riverpod)](https://riverpod.dev)
[![WebSocket](https://img.shields.io/badge/WebSocket-Live-010101?style=flat&logo=socket.io)](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API)

---

## 1. Project Overview

TriageSync Frontend is a **production-grade Flutter application** serving two distinct user experiences within a single codebase:

- **Patient Interface** – Symptom submission via natural language or voice, real‑time triage status tracking, and care journey visibility.
- **Staff Dashboard** – Live patient queue with AI‑driven urgency scoring, WebSocket‑powered updates, detailed clinical views, and explainable AI reasoning.

**Target Users:** Patients in waiting areas (mobile) and clinical staff (tablet/desktop web).

**Key Features:**
- ⚡ Real‑time WebSocket synchronization (< 1s latency)
- 🧠 Explainable AI triage with confidence scores and clinical reasoning
- 🌍 Native multilingual symptom input (any language → English triage)
- 🎨 "Clinical Sanctuary" design system – tonal layering, no hard borders
- 📱 Fully responsive (mobile, tablet, desktop web)
- 🔐 Role‑based navigation and secure JWT authentication

**Screens Summary:**
- Onboarding & Login
- Symptom Input (text/voice)
- Submission Success / Confirmation
- Patient Status (priority, vitals, queue position, journey timeline)
- Staff Queue Dashboard (sorted patient list)
- Patient Detail (clinical view with AI reasoning)
- Admin Control Panel (system health, triage logs)

---

## 2. Tech Stack

| Technology | Version | Purpose | Justification |
|------------|---------|---------|---------------|
| **Flutter** | 3.24+ | Cross‑platform UI | Single codebase for iOS, Android, and Web. Mature ecosystem, excellent performance. |
| **Dart** | 3.5+ | Language | Strong typing, sound null safety, and ahead‑of‑time compilation. |
| **Riverpod** | 2.5+ | State Management | Compile‑safe, testable, and eliminates nesting. Provides granular reactivity for WebSocket streams and form state. |
| **GoRouter** | 14.0+ | Navigation | Declarative routing with deep linking support. Enables role‑based redirects (patient vs. staff). |
| **Dio** | 5.4+ | HTTP Client | Interceptors for JWT refresh, logging, and error handling. Cancellation support for search/autocomplete. |
| **web_socket_channel** | 2.4+ | WebSocket | Lightweight, reliable WebSocket implementation with built‑in reconnection patterns. |
| **Flutter Secure Storage** | 9.2+ | Secure Storage | Encrypted storage for JWT tokens (iOS Keychain / Android Keystore). |
| **SharedPreferences** | 2.2+ | Local Cache | Lightweight persistence for user preferences and app state. |
| **Freezed** | 2.5+ | Immutable Models | Union types and JSON serialization with zero boilerplate. |
| **json_serializable** | 6.8+ | JSON Parsing | Code generation for safe, performant serialization. |
| **Google Fonts** | 6.2+ | Typography | Manrope (display) and Inter (body) fonts with fallback. |
| **flutter_animate** | 4.5+ | Animations | Declarative micro‑interactions (pulse, scale, fade). |
---

## 3. Architecture & Folder Structure

The codebase follows **feature‑first modular architecture** with clear separation of concerns, designed for scalability and team collaboration.

```
lib/
├── app.dart                      # App widget, MaterialApp configuration
├── main.dart                     # Entry point (runApp)
├── core/                         # Cross‑cutting concerns
│   ├── constants/                # App constants, enums
│   ├── exceptions/               # Custom exceptions
│   ├── extensions/               # Dart extension methods
│   ├── router/                   # GoRouter configuration, routes, guards
│   ├── theme/                    # AppTheme, colors, text styles, gradients
│   └── utils/                    # Helper functions, validators
├── features/                     # Feature modules (vertical slices)
│   ├── auth/                     # Login, biometrics, token management
│   │   ├── data/                 # Repositories, data sources
│   │   ├── domain/               # Models, use cases
│   │   ├── presentation/         # Screens, widgets, providers
│   │   └── providers/            # Riverpod providers
│   ├── patient/                  # Patient‑facing features
│   │   ├── symptom_input/
│   │   ├── status_tracking/
│   │   ├── onboarding/
│   │   └── success/
│   ├── staff/                    # Staff‑facing features
│   │   ├── queue_dashboard/
│   │   ├── patient_detail/
│   │   └── admin_panel/
│   └── shared/                   # Shared across features
│       ├── widgets/              # Reusable UI components
│       ├── providers/            # Cross‑feature providers
│       └── models/               # Shared data models
├── services/                     # External service integrations
│   ├── api/                      # Dio client, interceptors, API endpoints
│   ├── websocket/                # WebSocket manager, reconnection logic
│   ├── secure_storage/           # Token storage abstraction
│   └── speech/                   # Speech‑to‑text service wrapper
└── l10n/                         # Localization files (ARB)
```

**Responsibility Breakdown:**
- **core/** – Pure Dart code with no Flutter dependencies. Reusable across any Flutter app.
- **features/** – Each feature is self‑contained, following Clean Architecture principles (data/domain/presentation). This enables parallel development and easy removal/replacement.
- **services/** – Wrappers around third‑party libraries and platform channels. Decouples business logic from implementation details.
- **shared/** – Components used by multiple features, avoiding duplication.

**Scalability Reasoning:**
- Feature folders can be extracted into separate packages if the team grows.
- Clear boundaries between UI, business logic, and data enable independent testing.
- Riverpod providers colocated with features reduce cognitive load.

---

## 4. State Management Strategy

We use **Riverpod** with a **provider‑first** approach. All business logic resides in providers; UI widgets observe only what they need.

**State Flow:**
```
User Action → Provider Method → State Update → UI Rebuild (selective)
```

**Where Business Logic Lives:**
- **AsyncNotifier / FutureProvider** for API calls and WebSocket streams.
- **StateNotifier** for complex local UI state (form validation, animations).
- **StreamProvider** for real‑time WebSocket events.

**UI Decoupling:**
- Widgets consume providers via `ref.watch` (reactive) or `ref.read` (one‑time actions).
- No `setState` used; all rebuilds are controlled by provider updates.
- UI models are immutable (`@freezed`).

**Example: Symptom Input Feature**
```dart
// Provider (business logic)
@riverpod
class SymptomController extends _$SymptomController {
  @override
  SymptomState build() => const SymptomState.initial();

  Future<void> submit(String symptoms) async {
    state = const SymptomState.loading();
    try {
      final result = await ref.read(triageRepositoryProvider).submitSymptoms(symptoms);
      state = SymptomState.success(result);
    } catch (e) {
      state = SymptomState.error(e.toString());
    }
  }
}

// UI (presentation)
class SymptomInputScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(symptomControllerProvider);
    // Render based on state (initial/loading/success/error)
  }
}
```

---

## 5. API Integration

**HTTP Client:** `Dio` with custom interceptors.

**Base URL Configuration:**
```dart
// config/environment.dart
enum Environment { dev, staging, prod }

String get baseUrl {
  switch (currentEnvironment) {
    case Environment.dev: return 'http://10.0.2.2:8000/api';
    case Environment.staging: return 'https://staging-api.triagesync.com/api';
    case Environment.prod: return 'https://api.triagesync.com/api';
  }
}
```

**Interceptors (executed in order):**
1. **AuthInterceptor** – Attaches JWT from `FlutterSecureStorage` to `Authorization: Bearer <token>`.
2. **LoggingInterceptor** – Logs request/response in debug mode.
3. **ErrorInterceptor** – Maps HTTP status codes to domain exceptions (e.g., `401 Unauthorized → AuthException`).

**Token Refresh Flow:**
- On `401` response, `AuthInterceptor` attempts to refresh the token using the refresh token stored securely.
- If refresh succeeds, the original request is retried automatically.
- If refresh fails, user is logged out and redirected to login.

**Error Handling Strategy:**
- All API errors are caught and transformed into typed exceptions (`NetworkException`, `AuthException`, `ValidationException`).
- UI displays user‑friendly messages via a global `SnackbarService` or inline error widgets.

---

## 6. WebSocket Integration

**Why WebSockets:**
- The staff dashboard requires **instant updates** when new patients submit symptoms.
- Manual polling would introduce unacceptable latency and server load.

**Implementation:** `WebSocketManager` service that maintains a singleton connection.

**Connection Lifecycle:**
1. **Connect** – On staff login, establish authenticated WebSocket (JWT in query param or via `Sec-WebSocket-Protocol`).
2. **Heartbeat** – Send ping every 30s; expect pong within 10s.
3. **Disconnect** – On logout or app background (configurable).

**Reconnection Strategy:**
- Exponential backoff with jitter (1s → 2s → 4s → max 30s).
- Automatic reconnection on network recovery (using `connectivity_plus`).
- Re‑subscribe to channels after successful reconnection.

**Event Handling Pattern:**
```dart
// Provider that exposes a stream of triage updates
@riverpod
Stream<TriageUpdate> triageUpdates(TriageUpdatesRef ref) {
  final websocket = ref.watch(webSocketManagerProvider);
  return websocket.channel.stream
      .where((event) => event.type == 'triage_update')
      .map((event) => TriageUpdate.fromJson(event.data));
}

// UI listens
final updatesAsync = ref.watch(triageUpdatesProvider);
```

**Where Implemented:**
- `services/websocket/` contains `WebSocketManager`, reconnection logic, and event transformers.
- Staff dashboard providers subscribe to the stream and update the patient list state.

---

## 7. Environment Configuration

We use **compile‑time environment variables** via `--dart-define` to avoid exposing secrets in the binary.

**Setup:**
```bash
flutter run --dart-define=ENVIRONMENT=dev --dart-define=API_URL=http://10.0.2.2:8000
```

**In Code:**
```dart
class EnvironmentConfig {
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
  static const String apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000');
}
```

**For Production Builds:**
```bash
flutter build web --dart-define=ENVIRONMENT=prod --dart-define=API_URL=https://api.triagesync.com
```

**.env files are NOT used in production** to prevent accidental inclusion of secrets.

---

## 8. Getting Started

### Prerequisites
- Flutter SDK **3.24.0** or higher ([Installation Guide](https://docs.flutter.dev/get-started/install))
- Android Studio / Xcode (for mobile emulation)
- Chrome (for web development)

### Step‑by‑Step Setup

```bash
# 1. Clone the repository
git clone https://github.com/your-org/triagesync-frontend.git
cd triagesync-frontend

# 2. Install dependencies
flutter pub get

# 3. Generate code (Freezed, JSON serializable, Riverpod)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app (choose target)
# For web (development):
flutter run -d chrome --dart-define=ENVIRONMENT=dev

# For Android emulator:
flutter run -d android

# For iOS simulator:
flutter run -d ios
```

### Running with Local Backend
Ensure the backend is running at `http://127.0.0.1:8000` (or `10.0.2.2:8000` for Android emulator). The app will automatically use the dev configuration.

---

## 9. Build & Deployment

### Web Build (Production)
```bash
flutter build web --release \
  --dart-define=ENVIRONMENT=prod \
  --dart-define=API_URL=https://api.triagesync.com
```
Output: `build/web/` – deploy to any static hosting (Firebase Hosting, Vercel, AWS S3).

### Android APK / AAB
```bash
# APK (for testing)
flutter build apk --release --dart-define=ENVIRONMENT=prod

# App Bundle (for Play Store)
flutter build appbundle --release --dart-define=ENVIRONMENT=prod
```

### iOS Build
```bash
flutter build ios --release --dart-define=ENVIRONMENT=prod
```
Then archive and distribute via Xcode.

### Environment Switching at Build Time
The `ENVIRONMENT` flag controls:
- API base URL
- Logging verbosity
- Feature flags (e.g., debug panels)

---

## 10. UI & Theming

**Design System: "The Clinical Sanctuary"**
- **No‑line rule:** Sections are defined by background tonal shifts, never borders.
- **Gradients:** Primary CTAs use `primary → primaryContainer` linear gradient.
- **Ghost borders:** For inputs, use `outlineVariant` at 15% opacity.

**Theme Configuration:**
```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF00478D)),
  fontFamily: 'Inter',
  textTheme: GoogleFonts.interTextTheme(),
  // Custom headline font
  primaryTextTheme: GoogleFonts.manropeTextTheme(),
)
```

**Reusable Widgets (in `shared/widgets/`):**
- `GradientButton` – Primary action button with scale animation.
- `UrgencyIndicator` – 4px vertical status bar for patient cards.
- `PriorityCard` – Card with tonal elevation and urgency stripe.
- `GhostDivider` – 1px container with `outlineVariant.withOpacity(0.15)`.
- `AppTopBar` – Blurred header with avatar and notifications.
- `BottomNavBar` – Mobile navigation with active state indicator.

**Responsiveness Strategy:**
- `LayoutBuilder` with breakpoints:
  - `width < 640` → Mobile (single column, bottom nav)
  - `640 ≤ width < 1024` → Tablet (two‑column where applicable)
  - `width ≥ 1024` → Desktop (NavigationRail/Drawer visible)
- `MediaQuery` for adaptive padding and font scaling.

---

## 11. Performance Considerations

- **Lazy Loading:** `ListView.builder` for patient queues; pagination for archives.
- **Efficient Rebuilds:** Riverpod `select` to listen only to specific properties (e.g., `ref.watch(patientProvider.select((p) => p.urgencyScore))`).
- **Image Caching:** `CachedNetworkImage` with disk cache for avatars and map placeholders.
- **WebSocket Stream:** `BehaviorSubject` to avoid redundant UI rebuilds.
- **Shimmer Effects:** Used during loading to reduce perceived latency.

---

## 12. Testing Strategy

| Test Type | Tool | Coverage Target |
|-----------|------|-----------------|
| **Unit Tests** | `flutter_test`, `mockito` | Business logic (providers, models, services) |
| **Widget Tests** | `flutter_test` | Critical UI components and interactions |
| **Integration Tests** | `integration_test` | End‑to‑end flows (login → symptom submission → status update) |
| **Golden Tests** | `flutter_test` + `alchemist` | Visual regression for key screens |

**Example Unit Test:**
```dart
test('SymptomController emits loading and success states', () async {
  final container = createContainer();
  final controller = container.read(symptomControllerProvider.notifier);
  
  await controller.submit('Chest pain');
  
  expect(controller.debugState, isA<SymptomStateSuccess>());
});
```

**Run Tests:**
```bash
flutter test                    # Unit + Widget
flutter test integration_test   # Integration
```

---

## 13. Error Handling & Logging

**Global Error Handling:**
- `FlutterError.onError` catches framework errors and logs to remote service in production.
- `PlatformDispatcher.instance.onError` catches asynchronous errors outside Flutter zone.

**Logging Strategy:**
- **Debug:** Console output via `print` (wrapped in `kDebugMode` check).
- **Production:** Sentry integration for crash reporting and performance monitoring.

**User‑Facing Errors:**
- `SnackbarService` displays non‑blocking messages.
- Inline error widgets for form validation failures.

---

## 14. Security Practices

- **Secure Storage:** `FlutterSecureStorage` for JWT tokens (uses Keychain/Keystore).
- **API Protection:** All requests go through HTTPS in staging/production.
- **Token Handling:** Short‑lived access tokens (15 min) + refresh tokens (7 days) stored separately.
- **Certificate Pinning:** (Planned) To prevent MITM attacks.
- **No Sensitive Logs:** Logging interceptor redacts authorization headers in production.

---

## 15. Contribution Guidelines

**Code Style:**
- Follow official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- Use `flutter analyze` and `dart format .` before committing.
- Prefer composition over inheritance.

**Naming Conventions:**
- Files: `snake_case.dart`
- Classes/Enums: `PascalCase`
- Variables/Methods: `camelCase`
- Constants: `camelCase` (not SCREAMING_SNAKE)

**PR Process:**
1. Create feature branch from `main` (`feature/XYZ-description`).
2. Write/update tests.
3. Ensure CI passes (analysis, tests, build).
4. Request review from at least one maintainer.
5. Squash merge after approval.

---

## 16. Future Improvements

- [ ] **Offline Mode:** Cache patient status for offline viewing.
- [ ] **Push Notifications:** Alert staff when critical patient arrives.
- [ ] **Accessibility Audit:** Ensure full WCAG 2.1 AA compliance.
- [ ] **End‑to‑End Encryption:** For WebSocket messages in transit.
- [ ] **Advanced Analytics:** Dashboard for hospital administrators.
- [ ] **macOS/Windows Desktop Support:** Expand to desktop platforms.

---

<p align="center">
  <sub>Built with precision by the TriageSync Team · Improving emergency care, one queue at a time.</sub>
</p>
