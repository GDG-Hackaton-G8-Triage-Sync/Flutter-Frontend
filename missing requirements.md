# Missing Backend Requirements for Flutter Integration

Date: 2026-04-30

This file lists frontend expectations that are not fully supported by the current Django backend code or are inconsistent between the backend code and the supplied documentation.

## Essential integration blockers

1. Email login is not supported by the actual backend login serializer.
   - Frontend expectation: users sign in with email and password.
   - Backend reality: `POST /api/v1/auth/login/` requires `username` and `password`.
   - Current frontend mitigation: the login field now submits the entered identifier as `username`.
   - Required backend fix: support email-based authentication or document that users must sign in with the registered `name`/username.

2. `staff` is not a real authorized backend role.
   - Frontend expectation: staff users may have role `staff`.
   - Backend reality: `User.Roles` only supports `patient`, `nurse`, `doctor`, and `admin`; `IsMedicalStaff` only authorizes `nurse` and `doctor`.
   - Current frontend mitigation: nurse and doctor users route to the staff dashboard; `staff` submissions are mapped to `nurse` during frontend registration.
   - Required backend fix: either add and authorize a real `staff` role or keep the frontend/docs strictly on `nurse` and `doctor`.

3. Admin users cannot access dashboard metrics endpoints.
   - Frontend expectation: admin portal loads system overview and analytics.
   - Backend reality: `/api/v1/dashboard/admin/overview/` and `/api/v1/dashboard/admin/analytics/` use `IsMedicalStaff`, which excludes `admin`.
   - Current frontend mitigation: a 403 returns empty metrics instead of crashing the admin portal.
   - Required backend fix: allow `admin` through those endpoints or provide admin-owned equivalents.

4. Triage submissions history route is mounted differently from the docs.
   - Frontend expectation/docs: `GET /api/v1/triage-submissions/`.
   - Backend reality: the route is mounted as `GET /api/v1/patients/triage-submissions/`.
   - Current frontend mitigation: the frontend uses the actual mounted route.
   - Required backend fix: add the documented top-level route or update docs/Postman.

5. Staff mutation endpoints do not return the updated triage item.
   - Frontend expectation: status, priority, and verification mutations return the updated `TriageItem`.
   - Backend reality: those endpoints return only `{ "message": "..." }`.
   - Current frontend mitigation: the frontend re-fetches the staff queue after each mutation and finds the changed item.
   - Required backend fix: return the updated serialized patient/submission object.

6. Registration contract must stay aligned around `password2`.
   - Frontend expectation: signup sends `password2` with the same value as `password`.
   - Backend colleague update: `password2` is required and validated.
   - Local backend code observed on 2026-04-30: `RegisterSerializer` still did not expose `password2` in `fields`.
   - Current frontend mitigation: `password2` is sent so the updated backend works; older backend builds should ignore the extra field.
   - Required backend fix: ensure the deployed serializer accepts and validates `password2`.

7. Main authenticated triage should accept and use `blood_type`.
   - Frontend/backend expectation: blood type improves severe bleeding/transfusion triage.
   - Backend reality observed locally: `/api/v1/triage/ai/` and PDF extraction read `blood_type`, but `POST /api/v1/triage/` still only reads `description` and `photo_name`.
   - Current frontend mitigation: the frontend can send `blood_type` when available, and registration/profile stores it.
   - Required backend fix: read `blood_type` in `TriageSubmissionView` or guarantee `evaluate_triage()` uses the patient profile blood type.

## Feature gaps

1. Vitals logging is not implemented.
   - Frontend expectation: `POST /api/v1/dashboard/staff/patient/{id}/vitals/`.
   - Backend reality: no vitals endpoint, model, serializer field, or response data.
   - Current frontend mitigation: no network request is made; the UI shows that vitals logging is unavailable.

2. Patient waiting analytics is not implemented.
   - Frontend expectation: `GET /api/v1/triage/{id}/waiting-analytics/`.
   - Backend reality: no matching route.
   - Current frontend mitigation: the live forecast card stays hidden.

3. Admin user deletion is not implemented.
   - Frontend expectation: delete or wipe a user/patient record from the admin directory.
   - Backend reality: `DELETE /api/v1/admin/patient/{id}/` deletes a triage submission by submission id, not a user by user id.
   - Current frontend mitigation: the frontend does not call this endpoint for user deletion.

4. Staff queue items do not include the full clinical profile.
   - Frontend expectation: staff detail can display `gender`, `age`, `blood_type`, `health_history`, `allergies`, `current_medications`, `bad_habits`, `reasoning`, `confidence`, and `vitals`.
   - Backend reality: `DashboardPatientSerializer` returns only queue fields such as `id`, `patient_name`, `description`, `priority`, `urgency_score`, `condition`, `status`, `photo_name`, verification fields, and `created_at`.
   - Current frontend mitigation: missing fields render as fallback text.

5. AI transparency fields are not persisted on queue submissions.
   - Frontend expectation: staff views can show `explanation`, `recommended_action`, and `reason` for clinical decision support and AI transparency.
   - Backend reality: AI endpoints return these fields, but `PatientSubmission` and `DashboardPatientSerializer` do not expose them for staff queue/detail workflows.
   - Current frontend mitigation: staff detail falls back to a generic AI reasoning sentence.
   - Required backend fix: persist these fields, ideally on an AI audit/triage result model linked to `PatientSubmission`, then include them in staff detail/queue responses.

6. Admin analytics response is much thinner than the frontend dashboard expects.
   - Frontend expectation: `peak_hour`, `wait_time_trend`, `sla_breach_trend`, and condition summaries.
   - Backend reality: current code returns `avg_urgency_score` and `common_conditions` only.
   - Current frontend mitigation: parsers accept missing fields and charts render empty.

7. WebSocket events only include partial payloads.
   - Frontend expectation: a complete triage item can be consumed directly or used to update a row.
   - Backend reality: events include `submission_id`, priority/status metadata, and timestamps, but not the complete queue row.
   - Current frontend mitigation: WebSocket events trigger a queue refresh.

8. Binary photo upload is not implemented.
   - Frontend expectation: the user can attach a photo during symptom submission.
   - Backend reality: the triage endpoint accepts only `photo_name`; no upload/storage endpoint is documented for images.
   - Current frontend mitigation: the frontend sends the selected filename only.

9. Notification preferences are modeled but not exposed in frontend-facing docs.
   - Frontend expectation: notification inbox can read notifications from `/api/v1/notifications/notifications/`.
   - Backend reality: inbox endpoints exist; preference update endpoints are not clearly mounted in the current `notifications/urls.py`.
   - Current frontend mitigation: settings toggles remain local preferences.

## Documentation mismatches to clean up

1. Auth token naming differs across docs and tooling.
   - API docs/code use `access_token` and `refresh_token` for login/register.
   - SimpleJWT refresh returns `access`.
   - Postman checks for `access` and `refresh` on login, which does not match current auth views.

2. Admin endpoint paths differ across files.
   - API docs list `/api/v1/admin/overview/` and `/api/v1/admin/analytics/`.
   - Actual code mounts those under `/api/v1/dashboard/admin/overview/` and `/api/v1/dashboard/admin/analytics/`.

3. Patient history response shape differs across docs/Postman/code.
   - API docs/code use paginated `{ count, next, previous, results }`.
   - Postman expects `{ submissions, count }`.
