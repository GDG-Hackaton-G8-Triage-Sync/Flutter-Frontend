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
- json-server backend simulator

## Run Frontend

```bash
flutter pub get
flutter run -d chrome --dart-define=API_URL=http://localhost:3001
```

For Android emulator, use:

```bash
flutter run -d emulator --dart-define=API_URL=http://10.0.2.2:3001
```

## Run Mock Backend (json-server)

```bash
npm install
npm run mock:server
```

Backend runs at:

- `http://localhost:3001`

## Demo Accounts

- patient: `patient@triagesync.com` / `123456`
- staff: `staff@triagesync.com` / `123456`
- admin: `admin@triagesync.com` / `123456`

## Implemented API Contract (Mocked)

- `POST /api/auth/login/`
- `POST /api/auth/register/`
- `POST /api/triage/`
- `GET /api/triage-submissions/?email=`
- `GET /api/dashboard/staff/patients/`
- `PATCH /api/dashboard/staff/patient/{id}/status/`
- `GET /api/dashboard/admin/overview/`
- `GET /api/dashboard/admin/analytics/`
- `GET /api/admin/users/`
- `PATCH /api/admin/users/{id}/role/`
- `DELETE /api/admin/patient/{id}/`

## Notes

- No deprecated input modes are enabled in the current app flow.
- If backend is offline, UI shows error snackbars/messages instead of silent failures.
