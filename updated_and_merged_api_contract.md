# TriageSync: Updated & Merged API Contract (Current Project-Aligned)

Status: Active source of truth for this repository snapshot
Last updated: 2026-04-20
Scope: Frontend expectations + currently implemented mock server behavior + legacy/deprecation map from v1.0/v1.1/v1.2/v1.3

---

## 1. Why This Document Exists

This file merges all previous API contract versions into one practical contract that backend can implement against without guesswork.

It explicitly separates:

- Required now: What frontend actively calls today.
- Supported for compatibility: Transitional/legacy paths still accepted.
- Not yet implemented but previously proposed: retained as planned/optional with rationale.

This prevents drift between documents and running code.

---

## 2. Runtime Standards (Current)

### 2.1 Base URLs

- API base (local mock): `http://localhost:3001`
- Versioned API root: `/api/v1/`
- WebSocket local: `ws://localhost:3002/ws/v1/updates/`

### 2.2 Trailing Slash

- Preferred and expected by frontend: trailing slash on endpoint paths.
- Current frontend calls are trailing-slash compliant.

### 2.3 Response Strategy

- Success (2xx): direct JSON resources (object/array), no success envelope.
- Error (4xx/5xx): standardized object:
    - `code` (string)
    - `message` (string)

Example:

```json
{ "code": "INVALID_CREDENTIALS", "message": "Email or password is incorrect" }
```

Note: `details` is not consistently emitted yet by current mock routes.

### 2.4 Authentication

- Bearer JWT in `Authorization` header for protected routes.
- Access token: 1h (mock-server implementation).
- Refresh token: 7d (mock-server implementation).

---

## 3. Frontend-Required API Contract (Must Match)

This section reflects active calls from frontend service layer (`lib/core/services/backend_service.dart`) and role-based screens.

## 3.1 Auth

### POST `/api/v1/auth/register/`

Purpose: Register account (patient by default, but role may be supplied).

Request:

```json
{
    "name": "string",
    "email": "string",
    "password": "string",
    "role": "patient|staff|admin",
    "gender": "string?",
    "age": 30,
    "blood_type": "string?",
    "health_history": "string?",
    "allergies": "string?",
    "current_medications": "string?",
    "bad_habits": "string?"
}
```

Success:

- `201` with message body

Error:

- `400 VALIDATION_ERROR`
- `409 CONFLICT`

### POST `/api/v1/auth/login/`

Request:

```json
{ "email": "string", "password": "string" }
```

Success response shape (required by frontend model):

```json
{
    "access_token": "string",
    "refresh_token": "string",
    "role": "patient|staff|admin",
    "user_id": 123,
    "name": "string",
    "email": "string"
}
```

Error:

- `401 INVALID_CREDENTIALS`

### POST `/api/v1/auth/refresh/`

Request:

```json
{ "refresh_token": "string" }
```

Success:

```json
{
    "access_token": "string",
    "refresh_token": "string"
}
```

Error:

- `400 BAD_REQUEST`
- `401 TOKEN_INVALID`
- `401 USER_NOT_FOUND`

Why needed:

- Frontend interceptor retries any non-refresh `401` once using this endpoint.

---

## 3.2 Profile

### PATCH `/api/v1/profile/`

Purpose: Update profile (currently frontend sends only name/email in edit-profile flow, but server supports more fields).

Accepted fields:

```json
{
    "name": "string?",
    "email": "string?",
    "gender": "string?",
    "age": 30,
    "blood_type": "string?",
    "health_history": "string?",
    "allergies": "string?",
    "current_medications": "string?",
    "bad_habits": "string?"
}
```

Success:

- Updated sanitized user object (without password).

Error:

- `404 NOT_FOUND`

---

## 3.3 Triage (Patient)

### POST `/api/v1/triage/`

Purpose: Submit symptom assessment.

Request:

```json
{
    "description": "string",
    "photo_name": "string?"
}
```

Success:

- `201` returns full `TriageItem`.
- Server also broadcasts `TRIAGE_CREATED` via WebSocket.

Error:

- `400 VALIDATION_ERROR`
- `403 PERMISSION_DENIED` (if non-patient)

### GET `/api/v1/triage-submissions/`

Purpose: fetch historical submissions.

Query:

- `email` (optional)

Behavior:

- Patient role: always scoped to self email regardless of query.
- Staff/admin: can filter by `email`.

Success:

- Array of `TriageItem` sorted by newest `created_at` first.

---

## 3.4 Staff Queue & Actions

### GET `/api/v1/staff/patients/`

Query:

- `status` (optional)
- `priority` (optional)

Success:

- Array of `TriageItem`, sorted by `urgency_score` descending.

Error:

- `403 PERMISSION_DENIED`

### PATCH `/api/v1/staff/patient/{id}/status/`

Request:

```json
{ "status": "waiting|in_progress|completed" }
```

Success:

- Updated `TriageItem`
- Broadcast `TRIAGE_UPDATED`

Error:

- `400 VALIDATION_ERROR`
- `404 NOT_FOUND`
- `403 PERMISSION_DENIED`

### PATCH `/api/v1/staff/patient/{id}/priority/`

Request:

```json
{ "priority": 1 }
```

Success:

- Updated `TriageItem`
- Broadcast `TRIAGE_UPDATED`

Error:

- `400 VALIDATION_ERROR`
- `404 NOT_FOUND`
- `403 PERMISSION_DENIED`

### PATCH `/api/v1/staff/patient/{id}/verify/`

Request:

```json
{ "verified_by": "Nurse/Doctor Name" }
```

Success:

- Updated `TriageItem` with `verified_by` and `verified_at`
- Broadcast `TRIAGE_UPDATED`

Error:

- `400 VALIDATION_ERROR`
- `404 NOT_FOUND`
- `409 CONFLICT` (already verified)
- `403 PERMISSION_DENIED`

---

## 3.5 Admin

### GET `/api/v1/admin/overview/`

Success:

```json
{
    "total_patients": 0,
    "waiting": 0,
    "in_progress": 0,
    "completed": 0,
    "critical_cases": 0
}
```

### GET `/api/v1/admin/analytics/`

Success:

```json
{
    "avg_urgency_score": 0,
    "peak_hour": "14:00 - 16:00",
    "common_conditions": ["..."]
}
```

### GET `/api/v1/admin/users/`

Success:

- Array of `AppUser` records.

### PATCH `/api/v1/admin/users/{id}/role/`

Request:

```json
{ "role": "patient|staff|admin" }
```

Success:

- Updated user directory record.

Error:

- `400 VALIDATION_ERROR`
- `404 NOT_FOUND`

### DELETE `/api/v1/admin/patient/{id}/`

Current implementation behavior:

- Removes triage submission by triage `id` from `triageSubmissions`.

Important note:

- Despite name `patient`, this currently acts on triage-entry id, not account-level anonymization.
- Keep as-is only if frontend expects this behavior. If true patient anonymization is desired, version this behavior change.

---

## 3.6 WebSocket Contract (Frontend-Synced)

URI:

- `ws://localhost:3002/ws/v1/updates/` (local)

Handshake:

1. Client connects.
2. Client sends first auth frame:

```json
{ "type": "AUTH", "token": "JWT" }
```

3. Server responds:

```json
{ "type": "AUTH_SUCCESS" }
```

4. If auth not completed in 5s: server sends `ERROR/AUTH_REQUIRED` then terminates.

Heartbeat:

- Client sends `{"type":"PING"}`
- Server responds `{"type":"PONG"}`

Push events consumed by frontend:

- `TRIAGE_CREATED`
- `TRIAGE_UPDATED`
- `SLA_BREACH` (defined/handled client-side, currently not emitted by mock routes)

Event frame shape:

```json
{
    "type": "TRIAGE_UPDATED",
    "timestamp": "2026-04-20T12:00:00.000Z",
    "data": {}
}
```

---

## 4. Data Models Required By Frontend

## 4.1 AuthResponse

Required fields:

- `access_token` string
- `refresh_token` string
- `role` string
- `user_id` int
- `name` string
- `email` string

Optional profile extensions currently supported:

- `gender`, `age`, `blood_type`, `health_history`, `allergies`, `current_medications`, `bad_habits`

## 4.2 TriageItem

Required for parsing/UX:

- `id` int
- `description` string
- `priority` int
- `urgency_score` int
- `condition` string
- `status` string
- `created_at` ISO date-time

Optional but actively used in some screens:

- `patient_name`
- `photo_name`
- `verified_by`
- `verified_at`
- `gender`, `age`, `blood_type`, `health_history`, `allergies`, `current_medications`, `bad_habits`

## 4.3 AdminOverview

- `total_patients`, `waiting`, `in_progress`, `completed`, `critical_cases`

## 4.4 AdminAnalytics

- `avg_urgency_score`, `peak_hour`, `common_conditions` array

## 4.5 AppUser

- `id`, `name`, `email`, `role`
- optional profile extensions same as above

---

## 5. Merged Compatibility & Legacy Policy

This section preserves old contract content so backend teams migrating from v1.0/v1.1/v1.2 can align safely.

### 5.1 Auth Legacy Compatibility (Currently Supported)

- `/api/auth/login/`
- `/api/auth/register/`
- `/api/auth/refresh/`

These are mounted for compatibility in current mock app composition.

### 5.2 Legacy Endpoints From Earlier Contracts (Deprecated)

Deprecated (do not use for new frontend code):

- `/api/dashboard/staff/patients/`
- `/api/dashboard/staff/patient/{id}/status/`
- `/api/staff/queue/{id}/priority/`
- `/api/dashboard/admin/overview/`
- `/api/dashboard/admin/analytics/`
- `/api/admin/users/`

Reason:

- Current frontend core service has moved fully to `/api/v1/...` routes.

### 5.3 Response Envelope Decision (Merged)

- Success envelope from v1.2 is superseded.
- Current project expectation is direct success payloads.
- Error envelope remains standardized (`code`, `message`; `details` optional).

---

## 6. Not Yet Implemented But Previously Requested (Retained as Planned)

The following appeared in prior contracts but are not currently implemented in the modular mock routes and are not required by active frontend API calls yet.

- `POST /api/v1/triage/upload-url/`
- `GET /api/v1/admin/audit-logs/`
- `GET /api/v1/profile/notifications/`
- `PATCH /api/v1/profile/notifications/{id}/read/`
- `PATCH /api/v1/profile/notifications/read-all/`

Optional implementation note (why):

- These endpoints become necessary when frontend migrates from UI-only placeholders/local state to backend-backed persistence for uploads, notifications, and immutable audit streams.

Optional implementation note (how):

- Add dedicated route modules under `mock-server/src/routes/` and keep direct-success + error-envelope behavior consistent with this contract.

---

## 7. Role Matrix (Current Effective Behavior)

| Endpoint Group                    |         patient | staff | admin |
| --------------------------------- | --------------: | ----: | ----: |
| `/api/v1/auth/*`                  |             yes |   yes |   yes |
| `POST /api/v1/triage/`            |             yes |    no |    no |
| `GET /api/v1/triage-submissions/` | yes (self only) |   yes |   yes |
| `/api/v1/staff/*`                 |              no |   yes |   yes |
| `/api/v1/admin/*`                 |              no |    no |   yes |
| `PATCH /api/v1/profile/`          |             yes |   yes |   yes |

---

## 8. Error Codes In Active Use

Common emitted codes in current server:

- `VALIDATION_ERROR`
- `CONFLICT`
- `INVALID_CREDENTIALS`
- `BAD_REQUEST`
- `TOKEN_INVALID`
- `USER_NOT_FOUND`
- `AUTH_HEADER_MISSING`
- `AUTH_TOKEN_INVALID`
- `AUTH_USER_NOT_FOUND`
- `PERMISSION_DENIED`
- `NOT_FOUND`
- `INTERNAL_SERVER_ERROR`

---

## 9. Practical Backend Guidance

For backend to fully match frontend expectations now:

1. Treat this file as implementation contract over previous versions.
2. Keep `/api/v1/*` stable and slash-consistent.
3. Preserve direct-success payload shapes exactly for model parsing.
4. Keep auth refresh response returning both tokens.
5. Maintain WebSocket AUTH + PING/PONG protocol and event casing.

Optional hardening (recommended):

1. Add `details` object consistently on all errors.
2. Add trace/request id for observability.
3. Introduce pagination only with coordinated frontend parser updates.
4. Clarify and version the current delete semantics (`/admin/patient/{id}/`) before changing behavior.

---

## 10. Decision Summary (Merged From v1.0-v1.3)

Final merged decisions for this codebase state:

- Versioned API is the primary contract: yes.
- Legacy auth paths: temporarily supported.
- Legacy non-v1 dashboard/staff/admin paths: deprecated.
- Success envelopes: no.
- Error envelopes: yes (`code`, `message`; `details` optional).
- WebSocket handshake with AUTH frame: required.
- WS heartbeat PING/PONG: required.
- Event names: uppercase (`TRIAGE_CREATED`, `TRIAGE_UPDATED`, `SLA_BREACH`).

This file supersedes earlier standalone contract docs for day-to-day integration in this repository.
