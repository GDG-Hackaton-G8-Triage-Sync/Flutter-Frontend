# TriageSync Frontend

Flutter application for patient triage with role-based flows: patient, staff, and admin.

## What Is Implemented

- Role-based login (patient/staff/admin)
- Patient workflow:
  - Submit symptoms to backend
  - Attach photo from gallery
  - View latest triage status
  - Settings and Profile pages
- Staff workflow:
  - View prioritized queue
  - Filter by status
  - Update patient status (`waiting`, `in_progress`, `completed`)
- Admin workflow:
  - View system overview KPIs
  - View analytics
  - Manage user roles

## Stack

- Flutter + Dart
- Dio for HTTP
- SharedPreferences for session storage
- image_picker for photo attachments
- Django REST backend

## Run Frontend

```bash
flutter pub get
flutter run -d chrome --dart-define=API_URL=http://localhost:8000
```

For Android emulator, use:

```bash
flutter run -d emulator --dart-define=API_URL=http://10.0.2.2:8000
```

For production or hosted testing, point `API_URL` at the Django host root:

```bash
flutter run --dart-define=API_URL=https://django-backend-4r5p.onrender.com
```

WebSocket URLs are derived from `API_URL`. Override with `--dart-define=WS_URL=...` only if the backend WebSocket host is different.

## Demo Accounts

- Sign in with the Django username, not email, unless the backend adds email login.
- Patient usernames are currently created from the signup `Full Name` field.
- Staff roles are `nurse` or `doctor`; `staff` is not currently a Django role.

## Implemented Django API Contract

- `POST /api/v1/auth/login/`
- `POST /api/v1/auth/register/`
- `POST /api/v1/auth/refresh/`
- `PATCH /api/v1/profile/`
- `POST /api/v1/triage/`
- `GET /api/v1/patients/triage-submissions/?email=`
- `GET /api/v1/dashboard/staff/patients/`
- `PATCH /api/v1/dashboard/staff/patient/{id}/status/`
- `PATCH /api/v1/dashboard/staff/patient/{id}/priority/`
- `PATCH /api/v1/dashboard/staff/patient/{id}/verify/`
- `GET /api/v1/dashboard/admin/overview/`
- `GET /api/v1/dashboard/admin/analytics/`
- `GET /api/v1/admin/users/`
- `PATCH /api/v1/admin/users/{id}/role/`
- `ws://host/ws/triage/events/?token=<access_token>`

## Notes

- No deprecated input modes are enabled in the current app flow.
- If backend is offline, UI shows error snackbars/messages instead of silent failures.
- Backend gaps that are still required for full parity are tracked in `missing requirements.md`.
