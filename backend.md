# Updated Backend Requirements Gap Analysis

Date: 2026-05-02 (updated)

This document tracks features requested in `BACKEND_IMPROVEMENT.md` that are still not reflected in the API specification or current implementation reality.

## 1. High-Priority Documentation/Implementation Mismatches

1. **Email Login vs Username Requirement**
   - Requirement: `POST /auth/login/` should support email.
   - Docs: Mentions `identifier` which *can* be email.
   - Status: Needs confirmation if the backend is strictly `username` or actually accepts emails as `identifier`.

2. **Role Authorization**
   - Requirement: Roles.
   - Backend Reality: Documentation specifies `patient`, `nurse`, `doctor`, `admin`. `staff` role is handled by the frontend by mapping to `nurse` or `doctor` when calling role update endpoints.

3. **Return Object in Mutations**
   - Requirement: Mutation endpoints should return the updated `HealthCheckItem` object.
   - Current State: `PATCH` endpoints for status/priority return `{"message": "..."}`. Frontend re-fetches the full queue after mutations.

## 2. Resolved Items (May 2026)

- [x] **Staff Health Workflow Endpoints** — All four staff endpoints are now implemented and routed under `/api/v1/staff/patient/{id}/`:
  - `GET/POST /api/v1/staff/patient/{id}/notes/`
  - `PATCH /api/v1/staff/patient/{id}/assign/`
  - `GET /api/v1/staff/patient/{id}/vitals/history/`
  - `PATCH /api/v1/staff/patient/{id}/verify/`
- [x] **Audit Logs** — `GET /api/v1/admin/audit-logs/` is implemented and returns paginated `AuditLog` objects.
- [x] **Notification Endpoints** — All notification paths are correctly routed at `/api/v1/notifications/`.
- [x] **Local Dev URL** — Frontend `.env` correctly points to the configured backend API URL.
- [x] Vitals logging endpoint: `POST /api/v1/health-check/{id}/vitals/`
- [x] Patient waiting analytics: `GET /api/v1/health-check/{id}/waiting-analytics/`
- [x] Admin overview/analytics: `GET /api/v1/dashboard/admin/overview/` and `analytics/`
- [x] Health Check submission history: `GET /api/v1/patients/history/` and `GET /api/v1/patients/health-check-submissions/`

## 3. Remaining Feature Gaps (Not Yet Implemented)

1. **Smart Helper Draft/Confirm Flow**
   - Requirement: `POST /api/v1/health-check/ai-draft/` and nurse confirmation endpoint.
   - Status: Not implemented. Only `POST /api/v1/health-check/` exists (performs analysis internally).

2. **FHIR-style Patient Export**
   - Requirement: `GET /fhir/Patient/{id}`
   - Status: Not implemented.

3. **WebSocket Payload Normalization**
   - Requirement: Full `health-check_item` object in WebSocket event payloads.
   - Status: Backend sends minimal fields only (`patient_id`, `priority`, `urgency_score`). Frontend compensates by reloading the full queue on each event.
