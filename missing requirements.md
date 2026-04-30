# Critical Integration Blockers (Frontend-Backend)

Date: 2026-04-30

This document tracks the **minimum** changes required for the frontend to successfully integrate with the current production Django backend.

## 1. Authentication Integration
- **Identifier Handling**: The frontend `AuthProvider` must be configured to send the user's email/username as `identifier` to `POST /auth/login/`.
- **Role Alignment**: The frontend needs to ensure its internal `Role` definitions match the updated backend schema (`patient`, `staff`, `nurse`, `doctor`, `admin`). The `staff` role is now officially supported.

## 2. Triage & Workflow Data
- **Payload Consumption**: The frontend services must be updated to handle the new return structure from mutation endpoints (which now return the full `TriageItem` object), removing the need for post-mutation re-fetches.
- **WebSocket Synchronization**: The frontend notification/event listeners must be updated to parse the new `triage_item` object embedded within event data instead of triggering full queue reloads.

## 3. Deployment Parity (Urgent Action Items)
- **Roadmap Features**: The frontend should currently **disable or hide** calls to the following features, as they are not yet implemented in the live backend (planned for future release):
  - Audit Logs (`/admin/audit-log/`)
  - AI Copilot Draft flow (`/triage/ai-draft/`)
  - FHIR Export (`/fhir/Patient/{id}`)

## 4. Environment Configuration
- Update the frontend base URL to point to the production environment: `https://django-backend-4r5p.onrender.com/api/v1` for the live demo.
