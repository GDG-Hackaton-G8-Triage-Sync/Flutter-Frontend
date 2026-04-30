# Updated Backend Requirements Gap Analysis

Date: 2026-04-30

This document tracks features requested in `BACKEND_IMPROVEMENT.md` that are still not reflected in the `backend.md` API specification or current implementation reality.

## 1. High-Priority Documentation/Implementation Mismatches

1. **Email Login vs Username Requirement**
   - Requirement: `POST /auth/login/` should support email.
   - Docs (`backend.md`): Mentions `identifier` which *can* be email.
   - Status: Needs confirmation if the backend is strictly `username` or actually accepts emails as `identifier`.

2. **`staff` Role Authorization**
   - Requirement: `staff` role.
   - Backend Reality (`backend.md`): Documentation specifies `patient`, `nurse`, `doctor`, `admin`. No mention of a generic `staff` role in the auth documentation.

3. **Return Object in Mutations**
   - Requirement: Mutation endpoints should return the updated `TriageItem` object.
   - Current State: `backend.md` documentation for `PATCH` endpoints is vague regarding response bodies. If they return only a message, it remains a blocker for frontend efficiency.

## 2. Unresolved Feature Gaps

1. **Audit Logs**
   - Requirement: `GET /api/admin/audit-log/?limit=50` (Section 3B of `BACKEND_IMPROVEMENT.md`).
   - Status: Completely missing from `backend.md`.

2. **AI Copilot Contract**
   - Requirement: `POST /api/triage/ai-draft/` and nurse confirmation endpoint (Section 4 of `BACKEND_IMPROVEMENT.md`).
   - Status: Missing from `backend.md` (only `POST /triage/` exists, which performs analysis internally, but does not offer the explicit "draft/confirm" flow).

3. **FHIR-style Patient Export**
   - Requirement: `GET /fhir/Patient/{id}` (Section 5 of `BACKEND_IMPROVEMENT.md`).
   - Status: Missing from `backend.md`.

4. **WebSocket Payload Normalization**
   - Requirement: Fixed payload structure with all fields (Section 2C of `BACKEND_IMPROVEMENT.md`).
   - Status: `backend.md` (Section 9) only specifies `patient_created` with minimal fields.

## 3. Previously Reported "Missing" Items that appear resolved in `backend.md`

- [x] Vitals logging endpoint: Added (`POST /dashboard/staff/patient/{id}/vitals/`).
- [x] Patient waiting analytics: Added (`GET /triage/{id}/waiting-analytics/`).
- [x] Admin overview/analytics endpoints: Added (`GET /dashboard/admin/overview/` and `GET /dashboard/admin/analytics/`).
- [x] Triage submission history: `GET /patients/history/` and `GET /triage-submissions/` documented.
